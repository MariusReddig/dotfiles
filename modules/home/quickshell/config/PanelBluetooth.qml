import QtQuick
import Quickshell
import Quickshell.Bluetooth

// Bluetooth power, scanning and devices (BlueZ).
Column {
    id: root
    width: 340
    spacing: 4

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool powered: adapter?.enabled ?? false
    property bool startedScan: false

    readonly property var devices: (adapter?.devices.values ?? [])
        .filter(d => d.paired || d.connected || (adapter.discovering && (d.name || d.deviceName)))
        .sort((a, b) => (b.connected - a.connected) || (b.paired - a.paired)
                        || (a.name || a.address).localeCompare(b.name || b.address))

    Component.onDestruction: if (startedScan && adapter) adapter.discovering = false

    // ── header ──
    Item {
        width: root.width
        height: 30

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 6
            anchors.verticalCenter: parent.verticalCenter
            text: "Bluetooth"
            color: Config.text
            font.family: Config.font
            font.pixelSize: 13
            font.weight: Font.DemiBold
        }

        Row {
            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            QuickIcon {
                visible: root.powered
                width: 28
                height: 28
                glyph: Config.glyphs.radar
                selected: root.adapter?.discovering ?? false
                onClicked: {
                    root.adapter.discovering = !root.adapter.discovering;
                    root.startedScan = root.adapter.discovering;
                }
            }
            Toggle {
                anchors.verticalCenter: parent.verticalCenter
                visible: !!root.adapter
                checked: root.powered
                onToggled: v => root.adapter.enabled = v
            }
        }
    }

    Text {
        visible: !root.adapter || !root.powered || root.devices.length === 0
        width: root.width
        leftPadding: 6
        topPadding: 4
        bottomPadding: 4
        wrapMode: Text.Wrap
        text: !root.adapter ? "No Bluetooth adapter found"
            : !root.powered ? "Bluetooth is off"
            : root.adapter.discovering ? "Searching…"
            : "No paired devices — tap the radar to search"
        color: Config.subtext
        font.family: Config.font
        font.pixelSize: 12
    }

    ListView {
        visible: root.powered && root.devices.length > 0
        width: root.width
        height: Math.min(root.devices.length, 6) * 46
        clip: true
        spacing: 2
        boundsBehavior: Flickable.StopAtBounds
        model: root.powered ? root.devices : []

        delegate: ListRow {
            required property var modelData
            readonly property var dev: modelData
            width: root.width
            glyph: dev.connected ? Config.glyphs.btConnected : Config.glyphs.bt
            title: dev.name || dev.deviceName || dev.address
            subtitle: dev.connected ? "Connected" : dev.paired ? "Paired" : "Available — click to pair"
            trailing: dev.batteryAvailable ? Math.round(dev.battery * 100) + "%" : ""
            active: dev.connected
            onClicked: {
                if (dev.connected) dev.disconnect();
                else if (dev.paired) dev.connect();
                else dev.pair();
            }
        }
    }
}
