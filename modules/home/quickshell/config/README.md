# pillbar — a Quickshell bar that forms out of a pill

Invisible until you call it. A dot drops in at the top-centre, then grows into
whichever view you asked for; switching views morphs the same shape; closing
collapses it back into the dot and it vanishes.

## Install

    ~/.config/quickshell/pillbar/   ← these files
    qs -c pillbar                   ← run (or put the files directly in ~/.config/quickshell/ and run `qs`)

Stop any other notification daemon (mako, dunst, swaync) — pillbar is the daemon.

## Hyprland

```ini
exec-once = qs -c pillbar

bind = SUPER, W,            global, quickshell:bar-workspaces
bind = SUPER, C,            global, quickshell:bar-clock
bind = SUPER SHIFT, C,      global, quickshell:bar-calendar
bind = SUPER, SPACE,        global, quickshell:bar-launcher
bind = SUPER SHIFT, SPACE,  global, quickshell:bar-wallpapers
bind = SUPER, M,            global, quickshell:bar-media
bind = SUPER, T,            global, quickshell:bar-tray
bind = SUPER, N,            global, quickshell:bar-notifications
bind = SUPER, TAB,          global, quickshell:bar-next
bind = SUPER SHIFT, TAB,    global, quickshell:bar-prev
bind = SUPER, ESCAPE,       global, quickshell:bar-close

# optional: blur behind the pill
layerrule = blur, pillbar
layerrule = ignorezero, pillbar
```

Same thing over IPC (scripts, other tools):

    qs -c pillbar ipc call bar toggle calendar
    qs -c pillbar ipc call bar next
    qs -c pillbar ipc call bar state      # → "open:calendar"

## State machine (`BarState.qml`)

```
            request(m)              formTimer
  hidden ─────────────▶ forming ─────────────▶ open(m)
    ▲                     ▲                    │   │ request(n≠m)
    │ dissolveTimer       │ request            │   ▼
  dissolving ◀────────────┴──── close() ───────┤ morphing ── morphTimer ─▶ open(n)
```

* Pressing the key of the view that's open closes it (toggle).
* Tab / Shift+Tab (when focused) or the mouse wheel on the pill cycle views.
* Esc, a click anywhere outside the pill, or 5 s without hovering close it
  (`Config.visibleMs`; launcher and wallpaper picker stay until you're done).
* Automatic pop-ups: touching the top screen edge, switching workspace (always
  morphs to the workspaces state) and incoming notifications. These never take
  the keyboard and never swallow clicks outside the pill.

## States

| state | reachable by | notes |
|---|---|---|
| workspaces, clock, calendar, media, tray, notifications | direct request **and** cycling | cycle order as listed |
| launcher | direct request only | `toggle launcher`; scrollable, fuzzy search |
| wallpapers | direct request, or "Wallpapers" entry in the launcher | `toggle wallpapers` |
| toast | automatic | incoming notification while hidden |

**Launcher:** fuzzy search (fzf-style, matched letters highlighted), wheel or
↑↓ / PgUp PgDn to scroll, Enter launches. "Wallpapers" is listed like an app.

**Wallpapers:** images from `Config.wallpaperDir`, applied with
`Config.wallpaperCommand` (default `awww img`; needs `awww-daemon` running).

**Tray:** quick-settings icons for network, Bluetooth and volume, then the
app tray icons. Click a quick icon to expand its panel (the bar stays open
while a panel is expanded):
* *Network* (NetworkManager / `nmcli`): wired status, Wi-Fi on/off, scan,
  connect (password prompt for new secured networks), disconnect, and all VPN
  / WireGuard connections NetworkManager knows — click to connect/disconnect.
  A shield badge on the icon means a VPN is up.
* *Bluetooth* (BlueZ): power, scan, connect/disconnect/pair, battery level.
* *Volume* (PipeWire): output and mic sliders, mute, output device switch.
  Scrolling on the volume icon changes the volume directly.

**Media:** any MPRIS player. Space play/pause, ←→ previous/next, ↑↓ switch
player, click the progress bar to seek.

## Files

| file | role |
|---|---|
| `shell.qml` | entry: one surface per monitor, shortcuts, IPC |
| `Config.qml` | sizes, timings, colours, behaviour toggles |
| `BarState.qml` | the state machine |
| `Notifs.qml` | notification server |
| `Bar.qml` | layer-shell window, input mask, focus grab |
| `Pill.qml` | the morphing shape + view loader |
| `View*.qml` | workspaces, clock, calendar, launcher, media, tray, notifications, toast |
| `Fuzzy.qml` | fuzzy matcher used by the launcher |
| `Wallpapers.qml` | wallpaper scan + apply |
| `Network.qml` | NetworkManager backend (status, Wi-Fi, VPN) |
| `Panel*.qml` | network / Bluetooth / volume panels in the tray state |
| `QuickIcon.qml`, `ListRow.qml`, `Toggle.qml`, `VolumeSlider.qml` | small UI pieces |
| `SearchHeader.qml` | search field + state icon row used by launcher and wallpapers |

## Adding a view

1. `ViewFoo.qml` with an implicit size.
2. Add `"foo"` to `BarState.modes` (cycle order) or `BarState.directModes` (direct only) and a `Component` + map entry in `Pill.qml`.
3. Optional: `Config.autoHide.foo`, `Config.interactiveModes`, a `GlobalShortcut` in `shell.qml`.

## Notes

* State icons use Nerd Font glyphs: install `pkgs.nerd-fonts.symbols-only`
  (or any Nerd Font and set `Config.iconFont`). Change glyphs in `Config.stateIcons`.
* Workspace clicks use the Lua dispatcher (`hl.dsp.focus`). On an older
  Hyprland without Lua dispatch, set `Config.hyprlandLua: false`.

* Only the focused monitor's pill reacts; the others stay hidden.
* The window is click-through everywhere except the pill (`mask: Region { item: pill }`),
  so while hidden it doesn't block anything and reserves no space.
* If right-click tray menus close the bar on your setup, remove `"tray"` from
  `Config.interactiveModes` (that disables click-outside-to-close for the tray view).
