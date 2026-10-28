pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland

// ─────────────────────────────────────────────────────────────────────
//  The bar's state machine.
//
//  phase ∈ hidden | forming | open | morphing | dissolving
//  mode  = the view currently rendered inside the pill
//  target = the view that was requested last
//
//            request(m)              formTimer
//   hidden ─────────────▶ forming ─────────────▶ open(m)
//     ▲                     ▲                    │   │ request(n≠m)
//     │ dissolveTimer       │ request            │   ▼
//   dissolving ◀────────────┴──── close() ───────┤ morphing ── morphTimer ─▶ open(n)
//                                                │
//                          idle timeout / Esc / click outside / same key again
//
//  Requests arriving during forming/morphing only update `target`;
//  the running timer lands on whatever was requested last.
// ─────────────────────────────────────────────────────────────────────
Singleton {
    id: root

    // States reachable by cycling (Tab / wheel / bar-next / bar-prev), in order.
    readonly property var modes: ["workspaces", "clock", "calendar", "media", "tray", "notifications"]
    // States reachable only by a direct request. "toast" is used by the notification agent.
    readonly property var directModes: ["launcher", "wallpapers", "toast"]

    property string phase: "hidden"
    property string mode: ""
    property string target: ""
    property bool hovered: false
    // true when the bar popped up by itself (top-edge reveal, workspace switch,
    // notification toast). Automatic pop-ups don't take the keyboard and don't
    // catch clicks outside the pill. A direct request clears it.
    property bool automatic: false
    // A view can hold the bar open (e.g. while a quick-settings panel is expanded).
    property bool hold: false

    readonly property bool shown: phase !== "hidden" && phase !== "dissolving"

    // ── public API ──────────────────────────────────────────────
    function request(m, auto) {
        if (!modes.includes(m) && !directModes.includes(m)) {
            console.warn("pillbar: unknown mode", m);
            return;
        }
        target = m;
        automatic = auto === true;
        switch (phase) {
        case "hidden":
        case "dissolving":
            enter("forming");
            break;
        case "open":
            if (mode !== m) enter("morphing");
            else armIdle();
            break;
        // forming / morphing: pending timer picks up the new target
        }
    }

    function toggle(m) {
        if (shown && target === m) close();
        else request(m);
    }

    // Mouse reached the top edge of the screen.
    function reveal() {
        if (shown) return;
        request(Config.revealMode, true);
    }

    function cycle(step) {
        const n = modes.length;
        let i = modes.indexOf(target);
        if (target === "toast") i = modes.indexOf("notifications") - step;
        // From a direct-only state (launcher, wallpapers) cycling starts at the ends of the list.
        const next = i < 0 ? (step > 0 ? 0 : n - 1) : ((i + step) % n + n) % n;
        request(modes[next]);
    }

    function close() {
        if (!shown) return;
        enter("dissolving");
    }

    // ── internals ───────────────────────────────────────────────
    function enter(p) {
        formTimer.stop();
        morphTimer.stop();
        dissolveTimer.stop();
        idle.stop();
        phase = p;
        switch (p) {
        case "forming":
            formTimer.start();
            break;
        case "morphing":
            morphTimer.start();
            break;
        case "open":
            mode = target;
            armIdle();
            break;
        case "dissolving":
            dissolveTimer.start();
            break;
        case "hidden":
            automatic = false;
            hold = false;
            mode = "";
            target = "";
            break;
        }
    }

    function armIdle() {
        idle.stop();
        if (hold) return;
        const t = Config.autoHide[mode] ?? 0;
        if (t > 0 && !hovered) {
            idle.interval = t;
            idle.start();
        }
    }

    onHoldChanged: {
        if (phase !== "open") return;
        if (hold) idle.stop();
        else armIdle();
    }

    onHoveredChanged: {
        if (phase !== "open") return;
        if (hovered) idle.stop();
        else armIdle();
    }

    Timer { id: formTimer; interval: Config.formMs; onTriggered: root.enter("open") }
    Timer { id: morphTimer; interval: Config.fadeMs; onTriggered: root.enter("open") }
    Timer { id: dissolveTimer; interval: Config.morphMs; onTriggered: root.enter("hidden") }
    Timer { id: idle; onTriggered: root.close() }

    // Don't flash the workspaces at login when Hyprland reports its initial state.
    property bool ready: false
    Timer { running: true; interval: 1500; onTriggered: root.ready = true }

    Connections {
        target: Hyprland
        function onFocusedWorkspaceChanged() {
            if (!Config.flashWorkspaces || !root.ready) return;
            // Always morph to the workspaces — except out of the launcher / wallpaper
            // picker, which you're typing into.
            if (root.shown && (root.target === "launcher" || root.target === "wallpapers")) return;
            root.request("workspaces", true);
        }
    }
}
