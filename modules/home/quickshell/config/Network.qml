pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// NetworkManager backend (via nmcli): connection status, Wi-Fi list, VPNs.
// Live-updates from `nmcli monitor`.
Singleton {
    id: root

    // ── status ──────────────────────────────────────────────────
    property string primaryType: ""        // "ethernet" | "wifi" | ""
    property string primaryName: ""        // connection name / SSID
    property int signal: 0                 // Wi-Fi strength of the active network, 0–100
    property bool wifiEnabled: true
    property var networks: []              // [{ ssid, signal, secure, active, known }]
    property var vpns: []                  // [{ name, uuid, type, active }]
    property var knownWifi: []             // saved Wi-Fi connection names
    readonly property bool vpnActive: vpns.some(v => v.active)
    readonly property bool online: primaryType !== ""
    property bool scanning: false
    property bool busy: action.running
    property string lastError: ""

    // ── public API ──────────────────────────────────────────────
    function refresh() {
        restart(devProc);
        restart(conProc);
        restart(radioProc);
        scan(false);
    }

    function scan(rescan) {
        wifiProc.command = ["nmcli", "-t", "-f", "IN-USE,SIGNAL,SECURITY,SSID",
                            "device", "wifi", "list", "--rescan", rescan ? "yes" : "no"];
        if (rescan) scanning = true;
        restart(wifiProc);
    }

    function setWifi(on) { run(["nmcli", "radio", "wifi", on ? "on" : "off"]); }

    // password is only needed for a secured network that has no saved connection
    function connectWifi(ssid, password) {
        if (knownWifi.includes(ssid)) run(["nmcli", "connection", "up", "id", ssid]);
        else if (password) run(["nmcli", "device", "wifi", "connect", ssid, "password", password]);
        else run(["nmcli", "device", "wifi", "connect", ssid]);
    }

    function disconnect(name) { run(["nmcli", "connection", "down", "id", name]); }

    function toggleVpn(vpn) {
        run(["nmcli", "connection", vpn.active ? "down" : "up", "uuid", vpn.uuid]);
    }

    // ── internals ───────────────────────────────────────────────
    // nmcli -t escapes ":" as "\:" and "\" as "\\".
    function fields(line) {
        const out = [];
        let cur = "";
        for (let i = 0; i < line.length; i++) {
            const c = line[i];
            if (c === "\\" && i + 1 < line.length) { cur += line[++i]; continue; }
            if (c === ":") { out.push(cur); cur = ""; continue; }
            cur += c;
        }
        out.push(cur);
        return out;
    }

    function lines(text) { return text.split("\n").filter(l => l.trim() !== ""); }

    function restart(proc) {
        if (proc.running) proc.again = true;
        else proc.running = true;
    }

    property var queue: []
    function run(cmd) {
        lastError = "";
        if (action.running) { queue = queue.concat([cmd]); return; }
        action.command = cmd;
        action.running = true;
    }

    component NmProc: Process {
        property bool again: false
        onRunningChanged: if (!running && again) { again = false; running = true; }
    }

    NmProc {
        id: devProc
        command: ["nmcli", "-t", "-f", "TYPE,STATE,CONNECTION", "device"]
        stdout: StdioCollector {
            onStreamFinished: {
                let type = "", name = "";
                for (const l of root.lines(text)) {
                    const [t, state, conn] = root.fields(l);
                    if (state !== "connected") continue;
                    if (t === "ethernet") { type = "ethernet"; name = conn; break; }
                    if (t === "wifi" && type === "") { type = "wifi"; name = conn; }
                }
                root.primaryType = type;
                root.primaryName = name;
            }
        }
    }

    NmProc {
        id: conProc
        command: ["nmcli", "-t", "-f", "NAME,UUID,TYPE,ACTIVE", "connection", "show"]
        stdout: StdioCollector {
            onStreamFinished: {
                const vpns = [], wifi = [];
                for (const l of root.lines(text)) {
                    const [name, uuid, type, active] = root.fields(l);
                    if (type === "vpn" || type === "wireguard")
                        vpns.push({ name, uuid, type, active: active === "yes" });
                    else if (type === "802-11-wireless")
                        wifi.push(name);
                }
                root.vpns = vpns.sort((a, b) => a.name.localeCompare(b.name));
                root.knownWifi = wifi;
            }
        }
    }

    NmProc {
        id: radioProc
        command: ["nmcli", "-t", "radio", "wifi"]
        stdout: StdioCollector { onStreamFinished: root.wifiEnabled = text.trim() === "enabled" }
    }

    NmProc {
        id: wifiProc
        onRunningChanged: if (!running) root.scanning = false
        stdout: StdioCollector {
            onStreamFinished: {
                const best = {};
                for (const l of root.lines(text)) {
                    const [inUse, sig, security, ssid] = root.fields(l);
                    if (!ssid) continue;
                    const n = { ssid, signal: parseInt(sig) || 0, secure: security !== "" && security !== "--",
                                active: inUse === "*", known: root.knownWifi.includes(ssid) };
                    const prev = best[ssid];
                    if (!prev || n.active || (!prev.active && n.signal > prev.signal)) best[ssid] = n;
                }
                const list = Object.values(best).sort((a, b) => (b.active - a.active) || (b.known - a.known) || (b.signal - a.signal));
                root.networks = list;
                root.signal = list.find(n => n.active)?.signal ?? 0;
            }
        }
    }

    Process {
        id: action
        stderr: StdioCollector { id: actionErr }
        onExited: code => {
            if (code !== 0) {
                root.lastError = actionErr.text.trim().replace(/^Error:\s*/, "") || `nmcli exited with ${code}`;
                console.warn("pillbar: nmcli:", root.lastError);
            }
            root.refresh();
            if (root.queue.length > 0) {
                const next = root.queue[0];
                root.queue = root.queue.slice(1);
                root.run(next);
            }
        }
    }

    // ── live updates ────────────────────────────────────────────
    Process {
        id: monitor
        running: true
        command: ["nmcli", "monitor"]
        stdout: SplitParser { onRead: debounce.restart() }
        onRunningChanged: if (!running) relaunch.start()   // nmcli not ready yet / NM restarted
    }
    Timer { id: relaunch; interval: 5000; onTriggered: monitor.running = true }
    Timer { id: debounce; interval: 400; onTriggered: root.refresh() }

    // Wi-Fi signal drifts without events; poll gently.
    Timer { running: true; repeat: true; interval: 30000; onTriggered: root.scan(false) }

    Component.onCompleted: refresh()
}
