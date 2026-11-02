pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../config"

// Screen backlight via brightnessctl.
// `available` stays false on machines without a backlight (most desktops).
Singleton {
    id: root

    property bool available: false
    property string device: ""
    property real value: 0            // 0 … 1

    readonly property var deviceArgs: Config.backlightDevice !== ""
        ? ["-d", Config.backlightDevice] : ["-c", "backlight"]

    function refresh() {
        if (!get.running) get.running = true;
    }

    // Dragging a slider fires many updates; only the latest pending value is sent.
    property real pending: -1
    function set(v) {
        v = Math.max(0.01, Math.min(1, v));   // never fully black
        value = v;
        pending = v;
        if (!setter.running) flush();
    }
    function flush() {
        if (pending < 0) return;
        setter.command = ["brightnessctl", "-q"].concat(deviceArgs, ["set", Math.round(pending * 100) + "%"]);
        pending = -1;
        setter.running = true;
    }

    Process {
        id: get
        // machine-readable: device,class,current,percent%,max
        command: ["brightnessctl", "-m"].concat(root.deviceArgs, ["info"])
        stdout: StdioCollector {
            onStreamFinished: {
                const f = text.trim().split("\n")[0]?.split(",") ?? [];
                const cur = parseInt(f[2]), max = parseInt(f[4]);
                if (f.length >= 5 && max > 0) {
                    root.available = true;
                    root.device = f[0];
                    if (!setter.running && root.pending < 0) root.value = cur / max;
                } else {
                    root.available = false;
                }
            }
        }
        onExited: code => { if (code !== 0) root.available = false; }
    }

    Process {
        id: setter
        onExited: root.pending >= 0 ? root.flush() : root.refresh()
    }

    Component.onCompleted: refresh()
}
