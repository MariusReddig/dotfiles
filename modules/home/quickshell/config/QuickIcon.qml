import QtQuick

// Round quick-settings button in the tray state.
Rectangle {
    id: root

    property string glyph: ""
    property string badge: ""          // small glyph in the corner (e.g. VPN shield)
    property bool on: true             // dimmed when off
    property bool selected: false      // its panel is expanded
    property string tooltip: ""
    signal clicked()
    signal scrolled(int steps)

    width: 34
    height: 34
    radius: 17
    color: selected ? Config.accent : hover.hovered ? Config.surface : "transparent"
    Behavior on color { ColorAnimation { duration: 120 } }

    HoverHandler { id: hover }

    Text {
        anchors.centerIn: parent
        text: root.glyph
        color: root.selected ? Config.bg : root.on ? Config.text : Config.subtext
        opacity: root.on || root.selected ? 1 : 0.6
        font.family: Config.iconFont
        font.pixelSize: 18
    }

    Rectangle {
        visible: root.badge !== ""
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: 15
        height: 15
        radius: 8
        color: Config.bg
        Text {
            anchors.centerIn: parent
            text: root.badge
            color: Config.accent
            font.family: Config.iconFont
            font.pixelSize: 11
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        property real acc: 0
        onClicked: root.clicked()
        onWheel: w => {
            acc += w.angleDelta.y;
            const steps = Math.trunc(acc / 120);
            if (steps !== 0) { root.scrolled(steps); acc -= steps * 120; }
        }
    }
}
