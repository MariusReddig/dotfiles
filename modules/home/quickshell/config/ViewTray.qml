import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Bluetooth
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray

// [ network  bluetooth  volume ] | [ app tray icons ]
// Clicking a quick-settings icon expands its panel below; the pill morphs to fit.
Column {
    id: root
    required property var panel
    spacing: 8

    property string expanded: ""      // "" | "network" | "bluetooth" | "volume"

    function toggle(name) { expanded = expanded === name ? "" : name; }

    // Keep the bar open while a panel is expanded (no 5 s auto-hide mid-typing).
    Binding { target: BarState; property: "hold"; value: root.expanded !== "" }

    // ── live state for the icons ────────────────────────────────
    readonly property var sink: Pipewire.defaultAudioSink
    PwObjectTracker { objects: root.sink ? [root.sink] : [] }
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool btOn: adapter?.enabled ?? false
    readonly property bool btConnected: (adapter?.devices.values ?? []).some(d => d.connected)

    readonly property string netGlyph:
        Network.primaryType === "ethernet" ? Config.glyphs.ethernet
        : Network.primaryType === "wifi" ? Config.glyphs.wifi[Math.max(0, Math.min(4, Math.round(Network.signal / 25)))]
        : Network.wifiEnabled ? Config.glyphs.offline
        : Config.glyphs.wifiOff

    // ── icon row ────────────────────────────────────────────────
    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 4

        QuickIcon {
            glyph: root.netGlyph
            badge: Network.vpnActive ? Config.glyphs.vpn : ""
            on: Network.online
            selected: root.expanded === "network"
            onClicked: root.toggle("network")
        }

        QuickIcon {
            glyph: !root.btOn ? Config.glyphs.btOff : root.btConnected ? Config.glyphs.btConnected : Config.glyphs.bt
            on: root.btOn
            selected: root.expanded === "bluetooth"
            onClicked: root.toggle("bluetooth")
        }

        QuickIcon {
            glyph: root.muted || root.volume === 0 ? Config.glyphs.volMute
                 : root.volume < 0.34 ? Config.glyphs.volLow
                 : root.volume < 0.67 ? Config.glyphs.volMid
                 : Config.glyphs.volHigh
            on: !root.muted
            selected: root.expanded === "volume"
            onClicked: root.toggle("volume")
            // scroll on the icon changes volume without opening the panel
            onScrolled: steps => {
                if (root.sink?.audio)
                    root.sink.audio.volume = Math.max(0, Math.min(1, root.volume + steps * 0.05));
            }
        }

        Rectangle {
            visible: SystemTray.items.values.length > 0
            width: 1
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            color: Config.overlay
        }

        Repeater {
            model: SystemTray.items

            delegate: Rectangle {
                id: slot
                required property SystemTrayItem modelData

                width: 34
                height: 34
                radius: 17
                color: area.containsMouse ? Config.surface : "transparent"

                IconImage {
                    anchors.centerIn: parent
                    implicitSize: 20
                    source: slot.modelData.icon
                }

                MouseArea {
                    id: area
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                    onClicked: m => {
                        const item = slot.modelData;
                        if (m.button === Qt.MiddleButton) {
                            item.secondaryActivate();
                        } else if (m.button === Qt.RightButton || item.onlyMenu) {
                            if (!item.hasMenu) return;
                            const p = slot.mapToItem(null, 0, slot.height + 6);
                            item.display(root.panel, p.x, p.y);
                        } else {
                            item.activate();
                        }
                    }
                }
            }
        }
    }

    // ── expanded panel ──────────────────────────────────────────
    Loader {
        active: root.expanded !== ""
        visible: active
        sourceComponent: ({ network: networkPanel, bluetooth: bluetoothPanel, volume: volumePanel })[root.expanded] ?? null
    }

    Component { id: networkPanel; PanelNetwork {} }
    Component { id: bluetoothPanel; PanelBluetooth {} }
    Component { id: volumePanel; PanelVolume {} }
}
