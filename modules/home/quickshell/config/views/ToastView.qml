import QtQuick
import "../config"
import "../state"
import "../services"
import "../utils"
import "../components"
import "tray"

// Compact notification shown when the bar was hidden and something arrived.
// Clicking it morphs the pill into the full notification viewer.
NotificationCard {
    notif: Notifs.latest
    cardWidth: 380
    color: "transparent"
}
