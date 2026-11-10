import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "../config"
import "../state"
import "../services"
import "../views"

// Full-screen, transparent overlay per monitor. The input mask decides what
// actually receives the mouse:
//   • the pill itself
//   • a thin strip along the top edge (hover → reveal)
//   • the whole screen, but only while a deliberately opened state is up
//     (click anywhere outside the pill → close)
// Everything else passes straight through to the windows below.
PanelWindow {
    id: win

    // Compare by connector name (e.g. "eDP-1"). If Hyprland doesn't report a
    // focused monitor, fall back to the first screen so the pill still shows.
    readonly property string focusedName: Hyprland.focusedMonitor?.name ?? ""
    readonly property bool focusedScreen: focusedName !== ""
        ? focusedName === screen?.name
        : screen === Quickshell.screens[0]

    // The state we are in or heading to — known while the pill is still forming,
    // so keyboard focus is set up before the view needs it.
    readonly property string wanted: BarState.shown ? BarState.target : ""
    readonly property bool wantsKeyboard: focusedScreen && !BarState.automatic
        && Config.interactiveModes.includes(wanted)

    // launcher/wallpapers are the only views you actually type into.
    readonly property bool wantsGrab: wantsKeyboard && (wanted === "launcher" || wanted === "wallpapers")

    readonly property bool catchClicks: Config.closeOnOutsideClick
        && BarState.shown && !BarState.automatic

    anchors { top: true; bottom: true; left: true; right: true }
    exclusionMode: ExclusionMode.Ignore   // invisible bar → reserves no space
    color: "transparent"

    WlrLayershell.namespace: "pillbar"
    WlrLayershell.layer: WlrLayer.Overlay
    // Only ever OnDemand/None here, never Exclusive: this surface is always
    // mapped (it's the permanent invisible overlay), and Hyprland's keyboard-
    // focus restore on release is tied to a layer surface *unmapping* — since
    // this one never does, toggling Exclusive left the seat's real keyboard
    // focus stuck on nothing once released (global keybinds still worked,
    // since those bypass window focus entirely, but typed characters didn't
    // reach any app until you clicked away and back). HyprlandFocusGrab below
    // handles the launcher/wallpapers case properly instead.
    WlrLayershell.keyboardFocus: wantsKeyboard ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    mask: Region {
        item: pill
        regions: [
            Region { item: edge },
            Region { item: backdrop }
        ]
    }

    // Hyprland's own focus-grab extension: acquires keyboard focus for launcher/
    // wallpapers and — unlike WlrKeyboardFocus.Exclusive on this surface —
    // correctly restores it to the previously active window on release.
    HyprlandFocusGrab {
        windows: [win]
        active: win.wantsGrab
        onCleared: if (win.wantsGrab) BarState.close()
    }

    // Toggled from the status view. Bound per-monitor since each Bar is its
    // own layer-shell surface; harmless to engage from more than one.
    IdleInhibitor {
        window: win
        enabled: IdleInhibit.active
    }

    // ── click outside → close ───────────────────────────────────
    MouseArea {
        id: backdrop
        width: win.catchClicks ? parent.width : 0
        height: win.catchClicks ? parent.height : 0
        acceptedButtons: Qt.AllButtons
        onPressed: BarState.close()
    }

    // ── top edge → reveal ───────────────────────────────────────
    Item {
        id: edge
        width: Config.revealOnEdge && !BarState.shown ? parent.width : 0
        height: Config.revealEdge

        HoverHandler {
            id: edgeHover
            onHoveredChanged: hovered ? revealTimer.restart() : revealTimer.stop()
        }
        Timer {
            id: revealTimer
            interval: Config.revealDelay
            // Hyprland moves monitor focus with the cursor, so the pill forms on
            // the monitor whose edge you touched.
            onTriggered: if (edgeHover.hovered) BarState.reveal()
        }
    }

    Pill {
        id: pill
        panel: win
        active: win.focusedScreen
        anchors.horizontalCenter: parent.horizontalCenter
        onHoveredChanged: if (active) BarState.hovered = hovered
    }
}
