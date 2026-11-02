//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import "config"
import "state"
import "services"
import "bar"

ShellRoot {
    // One layer surface per monitor; only the focused monitor's pill comes alive.
    Variants {
        model: Quickshell.screens
        Bar {
            required property var modelData
            screen: modelData
        }
    }

    // Start the notification daemon, network monitor and wallpaper restore at startup.
    Component.onCompleted: { Notifs.count; Network.online; Wallpapers.current; }

    // ── Hyprland global shortcuts ───────────────────────────────
    //   bind = SUPER, C, global, quickshell:bar-status   (see README)
    GlobalShortcut { name: "bar-workspaces";    description: "Pill: workspaces";    onPressed: BarState.toggle("workspaces") }
    GlobalShortcut { name: "bar-status";        description: "Pill: system status"; onPressed: BarState.toggle("status") }
    GlobalShortcut { name: "bar-clock";         description: "Pill: system status (old name)"; onPressed: BarState.toggle("status") }
    GlobalShortcut { name: "bar-calendar";      description: "Pill: calendar";      onPressed: BarState.toggle("calendar") }
    GlobalShortcut { name: "bar-launcher";      description: "Pill: app launcher";  onPressed: BarState.toggle("launcher") }
    GlobalShortcut { name: "bar-wallpapers";    description: "Pill: wallpapers";    onPressed: BarState.toggle("wallpapers") }
    GlobalShortcut { name: "bar-media";         description: "Pill: media controls"; onPressed: BarState.toggle("media") }
    GlobalShortcut { name: "bar-tray";          description: "Pill: system tray";   onPressed: BarState.toggle("tray") }
    GlobalShortcut { name: "bar-notifications"; description: "Pill: notifications"; onPressed: BarState.toggle("notifications") }
    GlobalShortcut { name: "bar-next";          description: "Pill: next state";    onPressed: BarState.cycle(1) }
    GlobalShortcut { name: "bar-prev";          description: "Pill: previous state"; onPressed: BarState.cycle(-1) }
    GlobalShortcut { name: "bar-close";         description: "Pill: hide";          onPressed: BarState.close() }

    // ── IPC:  qs ipc call bar toggle launcher ───────────────────
    IpcHandler {
        target: "bar"
        function toggle(mode: string): void { BarState.toggle(mode); }
        function open(mode: string): void { BarState.request(mode); }
        function close(): void { BarState.close(); }
        function next(): void { BarState.cycle(1); }
        function prev(): void { BarState.cycle(-1); }
        function state(): string { return BarState.phase + ":" + BarState.mode; }
        // Troubleshooting: which monitor pillbar thinks is focused, and the profile.
        function debug(): string {
            return JSON.stringify({
                phase: BarState.phase,
                mode: BarState.mode,
                automatic: BarState.automatic,
                focusedMonitor: Hyprland.focusedMonitor?.name ?? null,
                screens: Quickshell.screens.map(s => s.name),
                host: Host.hostname,
                profile: Host.profileName
            }, null, 2);
        }
    }
}
