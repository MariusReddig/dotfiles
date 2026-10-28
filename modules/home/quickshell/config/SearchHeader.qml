import QtQuick

// [ search field ………………………… ] (icon)
// Search field and state icon together span the full width of the view.
Row {
    id: root

    property int fullWidth: 460
    property string placeholder: "Search…"
    property string icon: ""
    property alias text: field.text
    readonly property alias field: field

    signal keyPressed(var event)

    function grabFocus() { field.forceActiveFocus(); }

    spacing: 6

    Rectangle {
        width: root.fullWidth - badge.width - root.spacing
        height: 40
        radius: 20
        color: Config.surface

        TextInput {
            id: field
            anchors.fill: parent
            anchors.leftMargin: 18
            anchors.rightMargin: 18
            verticalAlignment: TextInput.AlignVCenter
            focus: true
            clip: true
            color: Config.text
            selectionColor: Config.accent
            selectedTextColor: Config.bg
            font.family: Config.font
            font.pixelSize: 14

            Keys.onPressed: e => root.keyPressed(e)

            Text {
                anchors.verticalCenter: parent.verticalCenter
                visible: field.text === ""
                text: root.placeholder
                color: Config.subtext
                font: field.font
            }
        }
    }

    Rectangle {
        id: badge
        width: 40
        height: 40
        radius: 20
        color: Config.accent

        Text {
            anchors.centerIn: parent
            text: root.icon
            color: Config.bg
            font.family: Config.iconFont
            font.pixelSize: 18
        }
    }
}
