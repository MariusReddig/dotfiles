pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

// Notification daemon. Make sure mako / dunst / swaync are NOT running.
Singleton {
    id: root

    readonly property var list: server.trackedNotifications.values
    readonly property int count: list.length
    readonly property var latest: count > 0 ? list[count - 1] : null

    function clearAll() {
        for (const n of list.slice()) n.dismiss();
    }

    onLatestChanged: if (!latest && BarState.mode === "toast") BarState.close()

    NotificationServer {
        id: server
        keepOnReload: true
        actionsSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        imageSupported: true

        onNotification: n => {
            n.tracked = true;
            if (!Config.toastOnNotification) return;
            // Only pop a toast when nothing else is on screen (or a toast already is).
            if (!BarState.shown || BarState.target === "toast") BarState.request("toast", true);
        }
    }
}
