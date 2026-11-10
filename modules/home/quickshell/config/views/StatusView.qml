import QtQuick
import Quickshell
import "../config"
import "../services"
import "../components"

// System status: time, date and (on laptops) battery.
Row {
    id: root
    spacing: 10

    SystemClock { id: clock; precision: SystemClock.Seconds }

    // Keep the Wi-Fi strength fresh while the status view is open.
    Component.onCompleted: if (root.showNetwork) Network.scan(false)
    Timer { running: root.showNetwork && root.wifi; repeat: true; interval: 5000; onTriggered: Network.scan(false) }

    component Divider: Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: 1
        height: 16
        color: Config.overlay
    }

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

    Divider {}

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: clock.date.toLocaleDateString(Qt.locale(), "dddd, d. MMMM")
        color: Config.subtext
        font.family: Config.font
        font.pixelSize: 13
    }

    // [ring icon] title / subtitle — the text only shows after clicking the icon.
    component StatusItem: Row {
        id: item
        property alias glyph: ring.glyph
        property alias value: ring.value
        property alias color: ring.color
        property string title: ""
        property string subtitle: ""
        property bool expanded: false
        anchors.verticalCenter: parent.verticalCenter
        spacing: item.expanded ? 8 : 0

        RingIcon {
            id: ring
            anchors.verticalCenter: parent.verticalCenter
            scale: ringHover.hovered ? 1.1 : 1
            Behavior on scale { NumberAnimation { duration: 120 } }

            HoverHandler { id: ringHover }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: item.expanded = !item.expanded
            }
        }
        Column {
            visible: item.expanded
            anchors.verticalCenter: parent.verticalCenter
            Text {
                text: item.title
                color: Config.text
                font.family: Config.font
                font.pixelSize: 13
                font.weight: Font.DemiBold
            }
            Text {
                visible: text !== ""
                text: item.subtitle
                color: Config.subtext
                font.family: Config.font
                font.pixelSize: 10
            }
        }
    }

    // ── network ──
    readonly property bool showNetwork: Host.has("network")
    readonly property bool wired: Network.primaryType === "ethernet"
    readonly property bool wifi: Network.primaryType === "wifi"

    Divider { visible: root.showNetwork }

    StatusItem {
        visible: root.showNetwork
        rightPadding: root.showBattery ? 0 : 4
        glyph: root.wired ? Config.glyphs.ethernet
             : root.wifi ? Config.glyphs.wifi[Math.max(0, Math.min(4, Math.round(Network.signal / 25)))]
             : Network.wifiEnabled ? Config.glyphs.offline : Config.glyphs.wifiOff
        value: root.wired ? 1 : root.wifi ? Network.signal / 100 : 0
        color: Network.online ? Config.accent : Config.subtext
        title: Network.online ? Network.primaryName : "Offline"
        subtitle: (root.wired ? "Wired" : root.wifi ? `Wi-Fi · ${Network.signal}%` : "")
                  + (Network.vpnActive ? " · VPN" : "")
    }

    // ── battery ──
    readonly property bool showBattery: Battery.available && Host.has("battery")

    Divider { visible: root.showBattery }

    StatusItem {
        visible: root.showBattery
        rightPadding: 4
        glyph: Battery.charging || (Battery.pluggedIn && !Battery.full)
            ? Config.glyphs.batteryCharging[10] : Config.glyphs.battery[10]
        value: Battery.percent / 100
        color: Battery.low ? Config.urgent : Battery.charging ? Config.accent : Config.text
        title: Battery.percent + "%"
        subtitle: Battery.statusText
    }

    // ── idle inhibit ── (own widget, not StatusItem: clicking performs an
    // action here instead of just revealing the label)
    Divider {}

    Row {
        id: inhibitItem
        property bool expanded: false
        anchors.verticalCenter: parent.verticalCenter
        spacing: inhibitItem.expanded ? 8 : 0

        RingIcon {
            id: inhibitRing
            anchors.verticalCenter: parent.verticalCenter
            scale: inhibitHover.hovered ? 1.1 : 1
            Behavior on scale { NumberAnimation { duration: 120 } }
            glyph: IdleInhibit.active ? Config.glyphs.idleInhibit : Config.glyphs.idleInhibitOff
            value: IdleInhibit.active ? 1 : 0
            color: IdleInhibit.active ? Config.accent : Config.subtext

            HoverHandler { id: inhibitHover }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    IdleInhibit.toggle();
                    inhibitItem.expanded = !inhibitItem.expanded;
                }
            }
        }
        Column {
            visible: inhibitItem.expanded
            anchors.verticalCenter: parent.verticalCenter
            Text {
                text: IdleInhibit.active ? "Staying awake" : "Idle as usual"
                color: Config.text
                font.family: Config.font
                font.pixelSize: 13
                font.weight: Font.DemiBold
            }
            Text {
                text: "Click to toggle"
                color: Config.subtext
                font.family: Config.font
                font.pixelSize: 10
            }
        }
    }
}
