import QtQuick
import Quickshell

// Wi-Fi, wired status and VPN connections (NetworkManager).
Column {
    id: root
    width: 340
    spacing: 4

    property string passwordFor: ""   // SSID waiting for a password

    function level(sig) { return Math.max(0, Math.min(4, Math.round(sig / 25))); }

    Component.onCompleted: Network.scan(true)
    Timer { running: true; repeat: true; interval: 15000; onTriggered: Network.scan(true) }

    component SectionHeader: Item {
        property string title: ""
        default property alias trailing: tail.data
        width: parent ? parent.width : 340   // inline components can't see the file's ids
        height: 30
        Text {
            anchors.left: parent.left
            anchors.leftMargin: 6
            anchors.verticalCenter: parent.verticalCenter
            text: parent.title
            color: Config.text
            font.family: Config.font
            font.pixelSize: 13
            font.weight: Font.DemiBold
        }
        Row {
            id: tail
            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8
        }
    }

    // ── wired ──
    ListRow {
        visible: Network.primaryType === "ethernet"
        width: root.width
        glyph: Config.glyphs.ethernet
        title: Network.primaryName
        subtitle: "Wired · connected"
        active: true
        onClicked: Network.disconnect(Network.primaryName)
    }

    // ── Wi-Fi ──
    SectionHeader {
        title: "Wi-Fi"
        QuickIcon {
            visible: Network.wifiEnabled
            width: 28
            height: 28
            glyph: Config.glyphs.refresh
            selected: Network.scanning
            onClicked: Network.scan(true)
        }
        Toggle {
            anchors.verticalCenter: parent.verticalCenter
            checked: Network.wifiEnabled
            onToggled: v => Network.setWifi(v)
        }
    }

    Text {
        visible: !Network.wifiEnabled || Network.networks.length === 0
        leftPadding: 6
        text: !Network.wifiEnabled ? "Wi-Fi is off" : Network.scanning ? "Scanning…" : "No networks found"
        color: Config.subtext
        font.family: Config.font
        font.pixelSize: 12
    }

    ListView {
        visible: Network.wifiEnabled && Network.networks.length > 0
        width: root.width
        height: Math.min(Network.networks.length, 5) * 46
        clip: true
        spacing: 2
        boundsBehavior: Flickable.StopAtBounds
        model: Network.wifiEnabled ? Network.networks : []

        delegate: ListRow {
            required property var modelData
            readonly property var net: modelData
            width: root.width
            glyph: Config.glyphs.wifi[root.level(net.signal)]
            title: net.ssid
            subtitle: net.active ? "Connected" : net.known ? "Saved" : net.secure ? "Secured" : "Open"
            trailing: net.active ? Config.glyphs.check : net.secure && !net.known ? Config.glyphs.lock : ""
            trailingIsGlyph: true
            active: net.active
            onClicked: {
                if (net.active) Network.disconnect(net.ssid);
                else if (net.secure && !net.known) { root.passwordFor = net.ssid; pw.text = ""; pw.forceActiveFocus(); }
                else Network.connectWifi(net.ssid);
            }
        }
    }

    // ── password prompt ──
    Rectangle {
        visible: root.passwordFor !== ""
        width: root.width
        height: 38
        radius: 19
        color: Config.surface

        TextInput {
            id: pw
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            verticalAlignment: TextInput.AlignVCenter
            echoMode: TextInput.Password
            clip: true
            color: Config.text
            font.family: Config.font
            font.pixelSize: 13

            Keys.onReturnPressed: { Network.connectWifi(root.passwordFor, text); root.passwordFor = ""; text = ""; }
            Keys.onEnterPressed: { Network.connectWifi(root.passwordFor, text); root.passwordFor = ""; text = ""; }
            Keys.onEscapePressed: { root.passwordFor = ""; text = ""; }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                visible: pw.text === ""
                text: `Password for ${root.passwordFor} — Enter to connect`
                color: Config.subtext
                font: pw.font
            }
        }
    }

    Text {
        visible: Network.lastError !== ""
        width: root.width
        leftPadding: 6
        wrapMode: Text.Wrap
        text: Network.lastError
        color: Config.urgent
        font.family: Config.font
        font.pixelSize: 11
    }

    // ── VPN ──
    SectionHeader { title: "VPN" }

    Text {
        visible: Network.vpns.length === 0
        width: root.width
        leftPadding: 6
        wrapMode: Text.Wrap
        text: "No VPN connections. Import one with nmcli or nm-connection-editor."
        color: Config.subtext
        font.family: Config.font
        font.pixelSize: 12
    }

    Repeater {
        model: Network.vpns
        delegate: ListRow {
            required property var modelData
            width: root.width
            glyph: Config.glyphs.vpn
            title: modelData.name
            subtitle: (modelData.type === "wireguard" ? "WireGuard" : "VPN") + (modelData.active ? " · connected" : "")
            active: modelData.active
            trailing: modelData.active ? Config.glyphs.check : ""
            trailingIsGlyph: true
            onClicked: Network.toggleVpn(modelData)
        }
    }
}
