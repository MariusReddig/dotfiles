import QtQuick
import Quickshell
import Quickshell.Hyprland

Row {
    id: root
    spacing: 6

    readonly property var workspaces: Hyprland.workspaces.values
        .filter(w => w.id > 0)               // skip special workspaces
        .sort((a, b) => a.id - b.id)

    Repeater {
        model: root.workspaces

        delegate: Rectangle {
            id: ws
            required property var modelData
            readonly property bool focused: Hyprland.focusedWorkspace === modelData
            readonly property bool occupied: (modelData.toplevels?.values?.length ?? 0) > 0

            width: focused ? 44 : 24
            height: 24
            radius: 12
            color: focused ? Config.accent
                : modelData.urgent ? Config.urgent
                : occupied ? Config.surface
                : "transparent"
            border.width: focused || occupied ? 0 : 1
            border.color: Config.overlay

            Behavior on width { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
            Behavior on color { ColorAnimation { duration: 150 } }

            Text {
                anchors.centerIn: parent
                text: ws.modelData.name
                color: ws.focused ? Config.bg : ws.occupied ? Config.text : Config.subtext
                font.family: Config.font
                font.pixelSize: 12
                font.weight: ws.focused ? Font.Bold : Font.Normal
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch(Config.hyprlandLua
                    ? `hl.dsp.focus({ workspace = ${ws.modelData.id} })`
                    : `workspace ${ws.modelData.id}`)
            }
        }
    }
}
