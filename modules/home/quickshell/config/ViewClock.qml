import QtQuick
import Quickshell

Row {
    spacing: 10

    SystemClock { id: clock; precision: SystemClock.Seconds }

    Text {
        id: time
        anchors.verticalCenter: parent.verticalCenter
        text: Qt.formatTime(clock.date, "HH:mm")
        color: Config.text
        font.family: Config.font
        font.pixelSize: 20
        font.weight: Font.DemiBold
    }

    Text {
        anchors.baseline: time.baseline
        text: Qt.formatTime(clock.date, "ss")
        color: Config.subtext
        font.family: Config.font
        font.pixelSize: 12
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: 1
        height: 16
        color: Config.overlay
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        rightPadding: 4
        text: clock.date.toLocaleDateString(Qt.locale(), "dddd, d. MMMM")
        color: Config.subtext
        font.family: Config.font
        font.pixelSize: 13
    }
}
