import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications

Rectangle {
    id: card

    property var notif: null
    property int cardWidth: 400

    readonly property string imageSource: notif ? (notif.image || Quickshell.iconPath(notif.appIcon, true)) : ""

    implicitWidth: cardWidth
    implicitHeight: Math.max(body.implicitHeight, 36) + 20
    radius: 16
    color: Config.surface
    border.width: notif && notif.urgency === NotificationUrgency.Critical ? 1 : 0
    border.color: Config.urgent

    // Click on the card body → default action, if the app offers one.
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            const def = Array.from(card.notif?.actions ?? []).find(a => a.identifier === "default");
            if (def) def.invoke();
            else BarState.request("notifications");
        }
    }

    IconImage {
        id: icon
        x: 10
        y: 10
        visible: card.imageSource !== ""
        implicitSize: 36
        source: card.imageSource
    }

    Column {
        id: body
        x: icon.visible ? 56 : 12
        y: 10
        width: card.width - x - 36
        spacing: 2

        Text {
            width: parent.width
            elide: Text.ElideRight
            text: card.notif?.appName ?? ""
            visible: text !== ""
            color: Config.subtext
            font.family: Config.font
            font.pixelSize: 11
        }
        Text {
            width: parent.width
            elide: Text.ElideRight
            text: card.notif?.summary ?? ""
            color: Config.text
            font.family: Config.font
            font.pixelSize: 13
            font.weight: Font.DemiBold
        }
        Text {
            width: parent.width
            visible: text !== ""
            wrapMode: Text.Wrap
            maximumLineCount: 4
            elide: Text.ElideRight
            textFormat: Text.StyledText
            text: card.notif?.body ?? ""
            color: Config.subtext
            font.family: Config.font
            font.pixelSize: 12
        }

        Flow {
            width: parent.width
            spacing: 6
            topPadding: visible ? 6 : 0
            visible: actionRepeater.count > 0

            Repeater {
                id: actionRepeater
                model: Array.from(card.notif?.actions ?? []).filter(a => a.identifier !== "default")
                delegate: PillButton {
                    required property var modelData
                    text: modelData.text
                    onClicked: modelData.invoke()
                }
            }
        }
    }

    PillButton {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 8
        implicitHeight: 22
        text: "✕"
        fontSize: 10
        onClicked: card.notif?.dismiss()
    }
}
