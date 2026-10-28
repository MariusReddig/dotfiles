import QtQuick

// Horizontal slider 0…max. Drag, click or scroll (±5 %).
Item {
    id: root

    property real value: 0
    property real max: 1.0
    property bool muted: false
    signal moved(real value)

    implicitWidth: 220
    implicitHeight: 22

    function set(v) { moved(Math.max(0, Math.min(max, v))); }

    Rectangle {
        id: track
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 6
        radius: 3
        color: Config.surface

        Rectangle {
            width: track.width * Math.min(1, root.value / root.max)
            height: parent.height
            radius: parent.radius
            color: root.muted ? Config.overlayHi : Config.accent
        }
    }

    Rectangle {
        width: 14
        height: 14
        radius: 7
        anchors.verticalCenter: parent.verticalCenter
        x: (root.width - width) * Math.min(1, root.value / root.max)
        color: Config.text
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        property real acc: 0
        onPressed: m => root.set(m.x / width * root.max)
        onPositionChanged: m => { if (pressed) root.set(m.x / width * root.max); }
        onWheel: w => {
            acc += w.angleDelta.y;
            const steps = Math.trunc(acc / 120);
            if (steps !== 0) { root.set(root.value + steps * 0.05); acc -= steps * 120; }
        }
    }
}
