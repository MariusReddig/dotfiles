# pillbar — a Quickshell bar that forms out of a pill

Invisible until you call it. A dot drops in at the top-centre, then grows into
whichever view you asked for; switching views morphs the same shape; closing
collapses it back into the dot and it vanishes.

## Layout

```
pillbar/
├── shell.qml               entry: one bar per monitor, shortcuts, IPC
├── hyprland-pillbar.lua    keybinds for Hyprland's Lua config
├── config/
│   ├── Config.qml          every tunable: sizes, timings, colours, glyphs, paths
│   └── Host.qml            per-machine profiles (laptop / workstation)
├── state/
│   └── BarState.qml        the state machine
├── bar/
│   ├── Bar.qml             layer-shell window, input mask, edge reveal, click-outside
│   └── Pill.qml            the morphing shape + view loader
├── views/                  one file per state
│   ├── WorkspacesView.qml
│   ├── StatusView.qml      time, date, network + battery rings
│   ├── CalendarView.qml
│   ├── MediaView.qml
│   ├── TrayView.qml        quick icons, volume + brightness sliders, app tray
│   ├── NotificationsView.qml
│   ├── ToastView.qml
│   ├── LauncherView.qml
│   ├── WallpapersView.qml
│   └── tray/               panels that expand inside the tray view
│       ├── NetworkPanel.qml
│       ├── BluetoothPanel.qml
│       └── AudioPanel.qml
├── services/               system backends (singletons)
│   ├── Battery.qml         UPower
│   ├── Brightness.qml      brightnessctl
│   ├── Network.qml         NetworkManager / nmcli (Wi-Fi, VPN)
│   ├── Notifs.qml          notification daemon
│   └── Wallpapers.qml      scan, apply, save + restore (awww)
├── components/             reusable UI pieces
│   ├── ListRow.qml  NotificationCard.qml  PillButton.qml  QuickIcon.qml
│   ├── RingIcon.qml  SearchHeader.qml  SliderRow.qml  Toggle.qml  ValueSlider.qml
└── utils/
    └── Fuzzy.qml           fuzzy matcher
```

Imports between folders are relative (`import "../services"`), so the folder
works wherever it lives.

## Install

    ~/.config/quickshell/pillbar/   ← this folder      → qs -c pillbar
    ~/.config/quickshell/           ← or its contents  → quickshell

Needed on NixOS:

```nix
services.upower.enable = true;                 # battery
networking.networkmanager.enable = true;       # network + VPN
hardware.bluetooth.enable = true;              # bluetooth
services.pipewire.enable = true;               # volume
environment.systemPackages = [ pkgs.brightnessctl pkgs.libnotify ];
fonts.packages = [ pkgs.nerd-fonts.symbols-only ];
```

Stop any other notification daemon (mako, dunst, swaync) — pillbar is the daemon.
For brightnessctl without root, your user needs to be in the `video` group.

## Per-machine profiles (`config/Host.qml`)

One folder for every machine; `Host.qml` decides what each one shows.

1. Map each hostname to a profile in `hosts` (run `hostname` to see yours).
2. In `profiles`, list only what differs from `defaults`: `battery`,
   `brightness`, `volume`, `network`, `wifi`, `vpn`, `bluetooth`, `appTray`,
   and `states` (which states are cycled, in which order).
3. `PILLBAR_PROFILE=workstation qs -c pillbar` overrides the hostname lookup.

The chosen profile is logged at start: `pillbar: host "…" → profile "…"`.

## Keybinds (Hyprland Lua)

See `hyprland-pillbar.lua`; load it from `hyprland.lua` with
`require("hyprland-pillbar")`. Over IPC:

    qs -c pillbar ipc call bar toggle status
    qs -c pillbar ipc call bar next
    qs -c pillbar ipc call bar state      # → "open:status"

## State machine (`state/BarState.qml`)

```
            request(m)              formTimer
  hidden ─────────────▶ forming ─────────────▶ open(m)
    ▲                     ▲                    │   │ request(n≠m)
    │ dissolveTimer       │ request            │   ▼
  dissolving ◀────────────┴──── close() ───────┤ morphing ── morphTimer ─▶ open(n)
```

| state | reachable by | shows |
|---|---|---|
| workspaces | cycle, shortcut, workspace switch, top edge | Hyprland workspaces |
| status | cycle, shortcut | time, date, network strength ring, battery ring (laptops) |
| calendar | cycle, shortcut | month grid |
| media | cycle, shortcut | MPRIS player controls |
| tray | cycle, shortcut | network / Bluetooth / audio icons, volume + brightness sliders, app tray |
| notifications | cycle, shortcut | notification list |
| launcher | shortcut only | fuzzy app search, scrollable |
| wallpapers | shortcut or "Wallpapers" in the launcher | wallpaper grid |
| toast | automatic | incoming notification while hidden |

* Pressing the key of the open view closes it. Tab / wheel cycle views.
* Esc, a click outside, or 5 s without hovering close it (`Config.visibleMs`).
* Automatic pop-ups (top edge, workspace switch, toast) never take the keyboard
  and never swallow clicks.

## Notes

* **Status:** the battery block only appears when UPower reports a laptop
  battery. It turns red below `Config.batteryLow` %.
* **Tray:** the brightness slider only appears when brightnessctl finds a
  backlight (built-in laptop screens). Pick a specific one with
  `Config.backlightDevice`. External monitors over DDC aren't supported.
* **Wallpapers:** saved to `~/.local/state/pillbar/wallpaper` and re-applied at
  start unless awww already shows it. Needs `awww-daemon` running.
* Workspace clicks use the Lua dispatcher (`hl.dsp.focus`); on an older
  Hyprland set `Config.hyprlandLua: false`.

## Adding a view

1. `views/FooView.qml` with an implicit size.
2. Add `"foo"` to `BarState.modes` (cycle) or `BarState.directModes` (direct
   only), and a `Component` + map entry in `bar/Pill.qml`.
3. Optional: `Config.autoHide.foo`, `Config.stateIcons.foo`, a `GlobalShortcut`
   in `shell.qml`.
