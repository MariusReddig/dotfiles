import QtQuick
import Quickshell

Column {
    id: root
    spacing: 6
    padding: 4

    SystemClock { id: clock; precision: SystemClock.Minutes }

    readonly property date today: clock.date
    property int year: today.getFullYear()
    property int month: today.getMonth()

    readonly property int cell: 34
    readonly property date firstCell: {
        const first = new Date(year, month, 1);
        const offset = (first.getDay() + 6) % 7;   // Monday-first
        return new Date(year, month, 1 - offset);
    }

    function shift(delta) {
        const m = month + delta;
        year += Math.floor(m / 12);
        month = ((m % 12) + 12) % 12;
    }

    function resetToToday() {
        year = today.getFullYear();
        month = today.getMonth();
    }

    // Wheel flips months instead of cycling the bar.
    WheelHandler {
        property real acc: 0
        onWheel: e => {
            acc += e.angleDelta.y;
            if (Math.abs(acc) < 120) return;
            root.shift(acc > 0 ? -1 : 1);
            acc = 0;
        }
    }

    // ── header ──
    Item {
        width: grid.width
        height: 28

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 6
            anchors.verticalCenter: parent.verticalCenter
            text: Qt.locale().standaloneMonthName(root.month) + " " + root.year
            color: Config.text
            font.family: Config.font
            font.pixelSize: 15
            font.weight: Font.DemiBold
        }

        Row {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4
            PillButton { text: "‹"; fontSize: 15; onClicked: root.shift(-1) }
            PillButton { text: "•"; onClicked: root.resetToToday() }
            PillButton { text: "›"; fontSize: 15; onClicked: root.shift(1) }
        }
    }

    // ── weekday labels ──
    Row {
        spacing: grid.spacing
        Repeater {
            model: 7
            delegate: Text {
                required property int index
                width: root.cell
                horizontalAlignment: Text.AlignHCenter
                text: Qt.locale().dayName((index + 1) % 7, Locale.ShortFormat)
                color: Config.subtext
                font.family: Config.font
                font.pixelSize: 11
            }
        }
    }

    // ── days ──
    Grid {
        id: grid
        columns: 7
        spacing: 2

        Repeater {
            model: 42
            delegate: Rectangle {
                id: day
                required property int index
                readonly property date date: new Date(root.firstCell.getFullYear(),
                                                      root.firstCell.getMonth(),
                                                      root.firstCell.getDate() + index)
                readonly property bool inMonth: date.getMonth() === root.month
                readonly property bool isToday: date.toDateString() === root.today.toDateString()

                width: root.cell
                height: 28
                radius: height / 2
                color: isToday ? Config.accent : hover.hovered ? Config.surface : "transparent"

                HoverHandler { id: hover }

                Text {
                    anchors.centerIn: parent
                    text: day.date.getDate()
                    color: day.isToday ? Config.bg : Config.text
                    opacity: day.inMonth ? 1 : 0.35
                    font.family: Config.font
                    font.pixelSize: 13
                    font.weight: day.isToday ? Font.Bold : Font.Normal
                }
            }
        }
    }
}
