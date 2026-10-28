import QtQuick
import Quickshell

Column {
    id: root
    spacing: 8

    readonly property int w: 400

    Item {
        width: root.w
        height: 28

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 6
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Text {
                text: "Notifications"
                color: Config.text
                font.family: Config.font
                font.pixelSize: 14
                font.weight: Font.DemiBold
            }
            Rectangle {
                visible: Notifs.count > 0
                anchors.verticalCenter: parent.verticalCenter
                width: Math.max(20, countLabel.implicitWidth + 10)
                height: 20
                radius: 10
                color: Config.accent
                Text {
                    id: countLabel
                    anchors.centerIn: parent
                    text: Notifs.count
                    color: Config.bg
                    font.family: Config.font
                    font.pixelSize: 11
                    font.weight: Font.Bold
                }
            }
        }

        PillButton {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            visible: Notifs.count > 0
            text: "Clear all"
            onClicked: Notifs.clearAll()
        }
    }

    Text {
        visible: Notifs.count === 0
        width: root.w
        horizontalAlignment: Text.AlignHCenter
        topPadding: 12
        bottomPadding: 12
        text: "All caught up"
        color: Config.subtext
        font.family: Config.font
        font.pixelSize: 13
    }

    ListView {
        visible: Notifs.count > 0
        width: root.w
        height: Math.min(contentHeight, 440)
        spacing: 6
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        model: Notifs.list.slice().reverse()   // newest first

        delegate: NotificationCard {
            required property var modelData
            notif: modelData
            cardWidth: root.w
        }
    }
}
