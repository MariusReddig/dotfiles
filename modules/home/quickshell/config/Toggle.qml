import QtQuick

// Small on/off switch.
Rectangle {
    id: root
    property bool checked: false
    signal toggled(bool value)

    implicitWidth: 38
    implicitHeight: 22
    radius: height / 2
    color: checked ? Config.accent : Config.overlay
    Behavior on color { ColorAnimation { duration: 120 } }

    Rectangle {
        width: parent.height - 6
        height: width
        radius: width / 2
        y: 3
        x: root.checked ? root.width - width - 3 : 3
        color: root.checked ? Config.bg : Config.text
        Behavior on x { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggled(!root.checked)
    }
}
