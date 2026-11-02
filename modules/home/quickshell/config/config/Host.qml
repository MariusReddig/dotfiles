pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// ─────────────────────────────────────────────────────────────────────
//  Per-machine profiles.
//
//  The profile is chosen by, in order:
//    1. the PILLBAR_PROFILE environment variable   (e.g. PILLBAR_PROFILE=laptop qs -c pillbar)
//    2. this machine's hostname, looked up in `hosts`
//    3. "default"
//
//  A profile only lists what differs from `defaults`. Battery and brightness
//  also hide themselves automatically when the hardware isn't there.
// ─────────────────────────────────────────────────────────────────────
Singleton {
    id: root

    // ── edit: hostname → profile (run `hostname` on each machine) ──
    readonly property var hosts: ({
        "marius-laptop": "laptop",
        "workstation": "workstation"     // ← put the workstation's hostname here
    })

    // ── edit: what each profile shows ──
    readonly property var profiles: ({
        laptop: {},
        workstation: {
            battery: false,
            brightness: false,
            wifi: false            // wired only: hide the Wi-Fi section
        }
    })

    // Every cyclable state, in default order. A profile can set `states` to a
    // subset / different order; states left out are skipped by cycling but
    // still open with their own shortcut.
    readonly property var allStates: ["workspaces", "status", "calendar", "media", "tray", "notifications"]

    readonly property var defaults: ({
        battery: true,         // battery in the status view
        brightness: true,      // brightness slider in the tray view
        volume: true,          // volume slider in the tray view
        network: true,         // network icon + panel in the tray view
        wifi: true,            // Wi-Fi section in the network panel
        vpn: true,             // VPN section in the network panel
        bluetooth: true,       // bluetooth icon + panel in the tray view
        appTray: true          // app tray icons (SystemTray) in the tray view
    })

    // ─────────────────────────────────────────────────────────────
    property string hostname: ""
    readonly property string profileName: Quickshell.env("PILLBAR_PROFILE")
        || (hosts[hostname] ?? "default")
    readonly property var profile: Object.assign({}, defaults, profiles[profileName] ?? {})

    // Cycle order for this machine: the profile's `states`, keeping only known names.
    readonly property var cycleStates: {
        const wanted = profiles[profileName]?.states;
        if (!wanted) return allStates;
        const out = [];
        for (let i = 0; i < wanted.length; i++)
            if (allStates.indexOf(wanted[i]) >= 0) out.push(wanted[i]);
        return out.length > 0 ? out : allStates;
    }

    function has(feature) { return profile[feature] !== false; }

    FileView {
        id: hostFile
        path: "/etc/hostname"
        blockLoading: true
        onLoaded: root.hostname = text().trim()
    }

    Component.onCompleted: {
        if (hostname === "") hostname = hostFile.text().trim();
        console.warn(`pillbar: host "${hostname}" → profile "${profileName}", cycle: ${cycleStates.join(" ")}`);
    }
}
