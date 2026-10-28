import QtQuick

Rectangle {
    id: btn

    property alias text: label.text
    property real fontSize: 12
    signal clicked()

    implicitWidth: Math.max(implicitHeight, label.implicitWidth + 20)
    implicitHeight: 26
    radius: height / 2
    color: area.containsMouse ? Config.overlayHi : Config.overlay
    Behavior on color { ColorAnimation { duration: 100 } }

    Text {
        id: label
        anchors.centerIn: parent
        color: Config.text
        font.family: Config.font
        font.pixelSize: btn.fontSize
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: btn.clicked()
    }
}
