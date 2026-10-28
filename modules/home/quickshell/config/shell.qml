//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

ShellRoot {
    // One layer surface per monitor; only the focused monitor's pill comes alive.
    Variants {
        model: Quickshell.screens
        Bar {
            required property var modelData
            screen: modelData
        }
    }

    // Start the notification daemon and the network monitor at startup.
    Component.onCompleted: { Notifs.count; Network.online; }

    // ── Hyprland global shortcuts ───────────────────────────────
    //   bind = SUPER, C, global, quickshell:bar-clock   (see README)
    GlobalShortcut { name: "bar-workspaces";    description: "Pill: workspaces";    onPressed: BarState.toggle("workspaces") }
    GlobalShortcut { name: "bar-clock";         description: "Pill: clock";         onPressed: BarState.toggle("clock") }
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
    }
}
