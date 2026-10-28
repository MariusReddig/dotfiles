pragma Singleton
import QtQuick
import Quickshell

// Every tunable lives here.
Singleton {
    // ── geometry ────────────────────────────────────────────────
    readonly property int margin: 8          // gap between screen edge and pill
    readonly property int padding: 8         // inner padding of the pill
    readonly property int dotSize: 14        // size of the "seed" the bar forms out of
    readonly property int maxRadius: 22      // pill radius cap (big views stay rounded-rect)

    // ── timing (ms) ─────────────────────────────────────────────
    readonly property int formMs: 170        // hidden → dot
    readonly property int fadeMs: 120        // content fade when morphing between views
    readonly property int morphMs: 320       // dot ↔ view, view ↔ view resize

    // How long the pill stays visible when not hovered. Hovering pauses it.
    readonly property int visibleMs: 5000

    // Auto-hide per state. 0 = stays until toggled / Esc / click outside.
    readonly property var autoHide: ({
        workspaces: visibleMs,
        clock: visibleMs,
        toast: visibleMs,
        calendar: visibleMs,
        media: visibleMs,
        tray: visibleMs,
        notifications: visibleMs,
        launcher: 0,
        wallpapers: 0
    })

    // States that take keyboard focus when opened on purpose.
    readonly property var interactiveModes: ["calendar", "launcher", "wallpapers", "media", "tray", "notifications"]

    // Clicking anywhere outside the pill closes it (when it was opened on purpose;
    // automatic pop-ups — edge reveal, workspace switch, toast — never eat clicks).
    readonly property bool closeOnOutsideClick: true

    // ── behaviour ───────────────────────────────────────────────
    readonly property bool flashWorkspaces: true      // switching workspace shows the workspaces state
    readonly property bool toastOnNotification: true  // pop a toast when the bar is hidden
    readonly property bool scrollCycles: true         // mouse wheel on the pill cycles states
    readonly property int launcherRows: 8             // visible rows; the list scrolls beyond that
    readonly property int wallpaperRows: 3            // visible grid rows; the grid scrolls beyond that

    // ── top-edge reveal ─────────────────────────────────────────
    readonly property bool revealOnEdge: true
    readonly property string revealMode: "workspaces" // state shown when the mouse hits the top edge
    readonly property int revealDelay: 150            // ms the mouse must rest at the edge
    readonly property int revealEdge: 2               // height of the trigger strip in px

    // ── wallpapers ──────────────────
    readonly property string wallpaperDir: Quickshell.env("HOME") + "/Pictures/Wallpapers"
    // %f is replaced by the image path. Examples:
    //   swww:      ["swww", "img", "%f", "--transition-type", "grow"]
    //   hyprpaper: ["sh", "-c", "hyprctl hyprpaper reload ,\"%f\""]
    readonly property var wallpaperCommand: ["awww", "img", "%f", "--transition-type", "grow"]
    readonly property bool closeOnWallpaperApply: false

    // Hyprland ≥ 0.54 with the Lua dispatcher needs hl.dsp.* syntax.
    // Set to false on older (hyprlang) builds.
    readonly property bool hyprlandLua: true

    // ── state icons (Nerd Font Material Design glyphs) ──────────
    // Shown on the left of every state that has an entry here.
    // Needs a Nerd Font, e.g. pkgs.nerd-fonts.symbols-only.
    readonly property string iconFont: "Symbols Nerd Font"
    readonly property var stateIcons: ({
        clock: String.fromCodePoint(0xF0150),          // md-clock_outline
        calendar: String.fromCodePoint(0xF0E18),       // md-calendar_month_outline
        launcher: String.fromCodePoint(0xF003B),       // md-apps
        wallpapers: String.fromCodePoint(0xF02EF),     // md-image_multiple_outline
        media: String.fromCodePoint(0xF0387),          // md-music_note
        tray: String.fromCodePoint(0xF1294),           // md-tray
        notifications: String.fromCodePoint(0xF009C),  // md-bell_outline
        toast: String.fromCodePoint(0xF009F)           // md-bell_ring_outline
    })

    // Glyphs for the quick-settings icons in the tray state.
    readonly property var glyphs: ({
        wifi: [0xF092F, 0xF091F, 0xF0922, 0xF0925, 0xF0928].map(c => String.fromCodePoint(c)), // by strength
        wifiOff: String.fromCodePoint(0xF092E),
        ethernet: String.fromCodePoint(0xF0200),
        offline: String.fromCodePoint(0xF0A8E),
        vpn: String.fromCodePoint(0xF099D),
        bt: String.fromCodePoint(0xF00AF),
        btConnected: String.fromCodePoint(0xF00B1),
        btOff: String.fromCodePoint(0xF00B2),
        volHigh: String.fromCodePoint(0xF057E),
        volMid: String.fromCodePoint(0xF0580),
        volLow: String.fromCodePoint(0xF057F),
        volMute: String.fromCodePoint(0xF075F),
        mic: String.fromCodePoint(0xF036C),
        micOff: String.fromCodePoint(0xF036D),
        lock: String.fromCodePoint(0xF033E),
        check: String.fromCodePoint(0xF012C),
        refresh: String.fromCodePoint(0xF0450),
        radar: String.fromCodePoint(0xF0437)
    })

    // ── colours (Catppuccin Mocha) ──────────────────────────────
    readonly property color bg: "#1e1e2e"
    readonly property color border: "#313244"
    readonly property color surface: "#313244"
    readonly property color overlay: "#45475a"
    readonly property color overlayHi: "#585b70"
    readonly property color text: "#cdd6f4"
    readonly property color subtext: "#a6adc8"
    readonly property color accent: "#89b4fa"
    readonly property color urgent: "#f38ba8"

    readonly property string font: "Inter"
}
