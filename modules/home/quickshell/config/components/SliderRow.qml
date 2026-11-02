import QtQuick
import "../config"

// [round icon button] [slider ……………] [42%]
// The button usually mutes; leave `onIconClicked` unconnected for a plain icon.
Row {
    id: root

    property string glyph: ""
    property real value: 0              // 0 … max
    property real max: 1.0
    property bool dimmed: false         // e.g. muted
    property int fullWidth: 320
    signal moved(real value)
    signal iconClicked()

    spacing: 10

    Rectangle {
        width: 30
        height: 30
        radius: 15
        anchors.verticalCenter: parent.verticalCenter
        color: iconHover.hovered ? Config.overlay : Config.surface
        HoverHandler { id: iconHover }
        Text {
            anchors.centerIn: parent
            text: root.glyph
            color: root.dimmed ? Config.subtext : Config.text
            font.family: Config.iconFont
            font.pixelSize: 15
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.iconClicked()
        }
    }

    ValueSlider {
        width: root.fullWidth - 30 - 44 - 2 * root.spacing
        anchors.verticalCenter: parent.verticalCenter
        value: root.value
        max: root.max
        muted: root.dimmed
        onMoved: v => root.moved(v)
    }

    Text {
        width: 44
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignRight
        text: Math.round(root.value / root.max * 100) + "%"
        color: Config.subtext
        font.family: Config.font
        font.pixelSize: 12
    }
}
