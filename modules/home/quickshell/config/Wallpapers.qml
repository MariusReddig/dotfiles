pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Finds images in Config.wallpaperDir (recursively) and applies them with
// Config.wallpaperCommand.
Singleton {
    id: root

    property var files: []
    property string current: ""
    readonly property bool loading: scan.running

    function rescan() {
        scan.running = false;
        scan.running = true;
    }

    function apply(path) {
        if (!path) return;
        const cmd = Config.wallpaperCommand.map(a => a.split("%f").join(path));
        console.info("pillbar: wallpaper →", cmd.join(" "));
        Quickshell.execDetached(cmd);
        current = path;
    }

    function baseName(path) {
        return path.slice(path.lastIndexOf("/") + 1);
    }

    Process {
        id: scan
        command: ["find", "-L", Config.wallpaperDir, "-maxdepth", "4", "-type", "f",
                  "(", "-iname", "*.jpg", "-o", "-iname", "*.jpeg", "-o", "-iname", "*.png",
                  "-o", "-iname", "*.webp", "-o", "-iname", "*.gif", "-o", "-iname", "*.bmp", ")"]
        stdout: StdioCollector {
            onStreamFinished: root.files = text.split("\n")
                .filter(l => l !== "")
                .sort((a, b) => a.localeCompare(b))
        }
    }
}
