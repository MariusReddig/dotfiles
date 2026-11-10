pragma Singleton
import QtQuick
import Quickshell

// Manual "stay awake" toggle for the status bar. `active` is read by the bar
// windows (see Bar.qml), which each hold a Quickshell.Wayland.IdleInhibitor
// bound to this — engaging it tells the compositor directly (wlr-idle-inhibit
// protocol), so hypridle's own ext-idle-notify-v1 listeners back off too.
Singleton {
    id: root

    property bool active: false

    function toggle() { active = !active; }
}
