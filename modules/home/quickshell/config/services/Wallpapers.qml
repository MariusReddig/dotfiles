pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../config"
import "../state"

// Finds images in Config.wallpaperDir (recursively) and applies them with
// Config.wallpaperCommand.
//
// The chosen wallpaper is saved to ~/.local/state/pillbar/wallpaper and
// restored when pillbar starts, so a restart (or a crashed wallpaper daemon)
// never leaves you without your background.
Singleton {
    id: root

    property var files: []
    property string current: ""
    readonly property bool loading: scan.running

    readonly property string stateDir: (Quickshell.env("XDG_STATE_HOME") || Quickshell.env("HOME") + "/.local/state") + "/pillbar"
    readonly property string stateFile: stateDir + "/wallpaper"

    function rescan() {
        scan.running = false;
        scan.running = true;
    }

    function apply(path) {
        if (!path) return;
        run(path, Config.wallpaperCommand);
        current = path;
        save.command = ["sh", "-c", 'mkdir -p "$1" && printf "%s" "$2" > "$3"', "sh", stateDir, path, stateFile];
        save.running = true;
    }

    function run(path, template) {
        const cmd = template.map(a => a.split("%f").join(path));
        console.info("pillbar: wallpaper →", cmd.join(" "));
        Quickshell.execDetached(cmd);
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

    Process { id: save }

    // ── restore on startup ──────────────────────────────────────
    // 1. read the saved path
    // 2. ask the daemon what it is showing (retry while it isn't up yet)
    // 3. re-apply only if it isn't already showing that image (no needless transition)
    property int restoreTries: 0

    Process {
        id: load
        running: Config.restoreWallpaper
        command: ["cat", root.stateFile]
        stdout: StdioCollector {
            onStreamFinished: {
                const path = text.trim();
                if (path === "") return;
                root.current = path;
                query.running = true;
            }
        }
    }

    Process {
        id: query
        command: Config.wallpaperQueryCommand
        stdout: StdioCollector { id: queryOut }
        onExited: code => {
            if (code !== 0) {
                // daemon not running yet (pillbar started before it) → try again
                if (++root.restoreTries <= 15) retry.start();
                else console.warn("pillbar: wallpaper daemon not reachable, giving up on restore");
                return;
            }
            if (!queryOut.text.includes(root.current)) {
                console.info("pillbar: restoring wallpaper", root.current);
                root.run(root.current, Config.wallpaperRestoreCommand);
            }
        }
    }
    Timer { id: retry; interval: 2000; onTriggered: query.running = true }
}
