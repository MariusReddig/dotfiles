import QtQuick
import Quickshell

// The single shape everything forms out of.
//   hidden     → 0×0, transparent, slightly above the edge
//   forming    → small dot drops in
//   open       → grows to the size of the current view, content fades in
//   morphing   → content fades out, shape keeps its size, then grows/shrinks to the next view
//   dissolving → content fades, shape collapses back to the dot, then vanishes
Rectangle {
    id: pill

    required property var panel
    property bool active: true

    readonly property string phase: active ? BarState.phase : "hidden"
    readonly property bool expanded: (phase === "open" || phase === "morphing") && view !== null
    readonly property Item view: loader.item

    // Views that draw the state icon themselves (launcher, wallpapers) set ownsIcon.
    readonly property string stateIcon: view?.ownsIcon ? "" : (Config.stateIcons[BarState.mode] ?? "")

    width: phase === "hidden" ? 0 : expanded ? body.implicitWidth + Config.padding * 2 : Config.dotSize
    height: phase === "hidden" ? 0 : expanded ? body.implicitHeight + Config.padding * 2 : Config.dotSize
    y: phase === "hidden" ? -Config.dotSize : Config.margin
    radius: Math.min(width / 2, height / 2, Config.maxRadius)
    opacity: phase === "hidden" ? 0 : 1
    color: Config.bg
    border.color: Config.border
    border.width: 1
    clip: true

    Behavior on width { NumberAnimation { duration: Config.morphMs; easing.type: Easing.OutBack; easing.overshoot: 0.7 } }
    Behavior on height { NumberAnimation { duration: Config.morphMs; easing.type: Easing.OutBack; easing.overshoot: 0.7 } }
    Behavior on y { NumberAnimation { duration: Config.formMs; easing.type: Easing.OutCubic } }
    Behavior on opacity { NumberAnimation { duration: Config.formMs } }

    // Esc closes, Tab / Shift+Tab cycle (when the pill has keyboard focus).
    focus: true
    Keys.onEscapePressed: BarState.close()
    Keys.onTabPressed: BarState.cycle(1)
    Keys.onBacktabPressed: BarState.cycle(-1)

    readonly property bool hovered: pillHover.hovered
    HoverHandler { id: pillHover }

    // Wheel on the pill cycles states (views with their own scrolling take precedence).
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        enabled: Config.scrollCycles
        property real acc: 0
        onWheel: w => {
            acc += w.angleDelta.y;
            if (Math.abs(acc) < 120) return;
            // Launcher / wallpapers are only reachable directly; don't scroll away from them.
            if (BarState.phase === "open" && !BarState.directModes.includes(BarState.mode)) BarState.cycle(acc > 0 ? -1 : 1);
            acc = 0;
        }
    }

    // [state icon] [view]  — fades as one unit while the shape morphs.
    Row {
        id: body
        anchors.centerIn: parent
        spacing: 10
        focus: true

        opacity: pill.phase === "open" ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: Config.fadeMs; easing.type: Easing.OutCubic } }

        Rectangle {
            id: iconBadge
            visible: pill.stateIcon !== ""
            width: 30
            height: 30
            radius: 15
            color: Config.surface
            // Centre on short views, sit at the top next to the first row on tall ones.
            y: loader.height <= 40 ? (body.height - height) / 2 : 0

            Text {
                anchors.centerIn: parent
                text: pill.stateIcon
                color: Config.accent
                font.family: Config.iconFont
                font.pixelSize: 16
            }
        }

        Loader {
            id: loader
            focus: true
            y: height <= 40 ? (body.height - height) / 2 : 0
            active: pill.active && BarState.mode !== ""
            sourceComponent: ({
                workspaces: workspacesView,
                clock: clockView,
                calendar: calendarView,
                launcher: launcherView,
                wallpapers: wallpapersView,
                media: mediaView,
                tray: trayView,
                notifications: notificationsView,
                toast: toastView
            })[BarState.mode] ?? null

            onStatusChanged: if (status === Loader.Error)
                console.warn("pillbar: view", BarState.mode, "failed to load — see the QML error above")
        }
    }

    Component { id: workspacesView; ViewWorkspaces {} }
    Component { id: clockView; ViewClock {} }
    Component { id: calendarView; ViewCalendar {} }
    Component { id: launcherView; ViewLauncher {} }
    Component { id: wallpapersView; ViewWallpapers {} }
    Component { id: mediaView; ViewMedia {} }
    Component { id: trayView; ViewTray { panel: pill.panel } }
    Component { id: notificationsView; ViewNotifications {} }
    Component { id: toastView; ViewToast {} }
}
