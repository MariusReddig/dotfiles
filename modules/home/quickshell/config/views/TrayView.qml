import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Bluetooth
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray
import "../config"
import "../state"
import "../services"
import "../utils"
import "../components"
import "tray"

// [ network  bluetooth  audio ] | [ app tray icons ]
// [ volume slider     ]
// [ brightness slider ]   (only where a backlight exists)
// [ expanded panel    ]   (click a quick icon)
Column {
    id: root
    required property var panel
    spacing: 8

    property string expanded: ""      // "" | "network" | "bluetooth" | "volume" (audio panel)

    function toggle(name) { expanded = expanded === name ? "" : name; }

    // Keep the bar open while a panel is expanded (no 5 s auto-hide mid-typing).
    Binding { target: BarState; property: "hold"; value: root.expanded !== "" }

    // ── live state for the icons ────────────────────────────────
    readonly property var sink: Pipewire.defaultAudioSink
    PwObjectTracker { objects: root.sink ? [root.sink] : [] }
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property string volGlyph: muted || volume === 0 ? Config.glyphs.volMute
        : volume < 0.34 ? Config.glyphs.volLow
        : volume < 0.67 ? Config.glyphs.volMid
        : Config.glyphs.volHigh

    readonly property int controlsWidth: 340

    // Pick up brightness changes made elsewhere (keyboard keys) while open.
    Component.onCompleted: if (Host.has("brightness")) Brightness.refresh()
    Timer { running: Host.has("brightness"); repeat: true; interval: 2000; onTriggered: Brightness.refresh() }

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
            visible: Host.has("network")
            glyph: root.netGlyph
            badge: Network.vpnActive ? Config.glyphs.vpn : ""
            on: Network.online
            selected: root.expanded === "network"
            onClicked: root.toggle("network")
        }

        QuickIcon {
            visible: Host.has("bluetooth")
            glyph: !root.btOn ? Config.glyphs.btOff : root.btConnected ? Config.glyphs.btConnected : Config.glyphs.bt
            on: root.btOn
            selected: root.expanded === "bluetooth"
            onClicked: root.toggle("bluetooth")
        }

        QuickIcon {
            glyph: root.volGlyph
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
            visible: Host.has("appTray") && SystemTray.items.values.length > 0
            width: 1
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            color: Config.overlay
        }

        Repeater {
            model: Host.has("appTray") ? SystemTray.items : []

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

    // ── controls ────────────────────────────────────────────────
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 4

        SliderRow {
            visible: Host.has("volume") && !!root.sink?.audio
            fullWidth: root.controlsWidth
            glyph: root.volGlyph
            value: root.volume
            dimmed: root.muted
            onMoved: v => { root.sink.audio.volume = v; if (v > 0) root.sink.audio.muted = false; }
            onIconClicked: root.sink.audio.muted = !root.sink.audio.muted
        }

        SliderRow {
            visible: Host.has("brightness") && Brightness.available
            fullWidth: root.controlsWidth
            glyph: Brightness.value < 0.34 ? Config.glyphs.brightnessLow
                 : Brightness.value < 0.67 ? Config.glyphs.brightnessMid
                 : Config.glyphs.brightnessHigh
            value: Brightness.value
            onMoved: v => Brightness.set(v)
        }
    }

    // ── expanded panel ──────────────────────────────────────────
    Loader {
        anchors.horizontalCenter: parent.horizontalCenter
        active: root.expanded !== ""
        visible: active
        sourceComponent: ({ network: networkPanel, bluetooth: bluetoothPanel, volume: volumePanel })[root.expanded] ?? null
    }

    Component { id: networkPanel; NetworkPanel {} }
    Component { id: bluetoothPanel; BluetoothPanel {} }
    Component { id: volumePanel; AudioPanel {} }
}
