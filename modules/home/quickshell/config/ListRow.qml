import QtQuick

// One entry in a quick-settings panel: [glyph] title / subtitle … trailing
Rectangle {
    id: root

    property string glyph: ""
    property string title: ""
    property string subtitle: ""
    property string trailing: ""          // text or glyph on the right
    property bool trailingIsGlyph: false
    property bool active: false            // highlighted (connected / current)
    property bool dim: false
    signal clicked()

    implicitWidth: 340
    implicitHeight: subtitle !== "" ? 44 : 36
    radius: 14
    color: active ? Config.surface : hover.hovered ? Qt.rgba(1, 1, 1, 0.04) : "transparent"
    opacity: dim ? 0.6 : 1

    HoverHandler { id: hover }

    Text {
        id: icon
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        width: 22
        horizontalAlignment: Text.AlignHCenter
        text: root.glyph
        color: root.active ? Config.accent : Config.text
        font.family: Config.iconFont
        font.pixelSize: 16
    }

    Column {
        anchors.left: icon.right
        anchors.leftMargin: 10
        anchors.right: tail.left
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        Text {
            width: parent.width
            elide: Text.ElideRight
            text: root.title
            color: Config.text
            font.family: Config.font
            font.pixelSize: 13
            font.weight: root.active ? Font.DemiBold : Font.Normal
        }
        Text {
            visible: root.subtitle !== ""
            width: parent.width
            elide: Text.ElideRight
            text: root.subtitle
            color: Config.subtext
            font.family: Config.font
            font.pixelSize: 11
        }
    }

    Text {
        id: tail
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        text: root.trailing
        color: root.active ? Config.accent : Config.subtext
        font.family: root.trailingIsGlyph ? Config.iconFont : Config.font
        font.pixelSize: root.trailingIsGlyph ? 15 : 11
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
