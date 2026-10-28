import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

// Full-screen, transparent overlay per monitor. The input mask decides what
// actually receives the mouse:
//   • the pill itself
//   • a thin strip along the top edge (hover → reveal)
//   • the whole screen, but only while a deliberately opened state is up
//     (click anywhere outside the pill → close)
// Everything else passes straight through to the windows below.
PanelWindow {
    id: win

    readonly property bool focusedScreen: Hyprland.focusedMonitor !== null
        && Hyprland.monitorFor(screen) === Hyprland.focusedMonitor

    // The state we are in or heading to — known while the pill is still forming,
    // so keyboard focus is set up before the view needs it.
    readonly property string wanted: BarState.shown ? BarState.target : ""
    readonly property bool wantsKeyboard: focusedScreen && !BarState.automatic
        && Config.interactiveModes.includes(wanted)

    readonly property bool catchClicks: Config.closeOnOutsideClick
        && BarState.shown && !BarState.automatic

    anchors { top: true; bottom: true; left: true; right: true }
    exclusionMode: ExclusionMode.Ignore   // invisible bar → reserves no space
    color: "transparent"

    WlrLayershell.namespace: "pillbar"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: !wantsKeyboard ? WlrKeyboardFocus.None
        : (wanted === "launcher" || wanted === "wallpapers") ? WlrKeyboardFocus.Exclusive
        : WlrKeyboardFocus.OnDemand

    mask: Region {
        item: pill
        regions: [
            Region { item: edge },
            Region { item: backdrop }
        ]
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
