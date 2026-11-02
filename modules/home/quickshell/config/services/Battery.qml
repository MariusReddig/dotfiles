pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.UPower
import "../config"

// Laptop battery via UPower. `available` is false on desktops.
Singleton {
    id: root

    readonly property var device: UPower.displayDevice
    readonly property bool available: !!device && device.isLaptopBattery

    // Quickshell reports 0–1 on newer versions and 0–100 on older ones.
    readonly property real percent: {
        const p = device?.percentage ?? 0;
        return Math.round(p <= 1 ? p * 100 : p);
    }

    readonly property bool charging: device?.state === UPowerDeviceState.Charging
    readonly property bool full: device?.state === UPowerDeviceState.FullyCharged
    readonly property bool pluggedIn: !UPower.onBattery
    readonly property bool low: available && !pluggedIn && percent <= Config.batteryLow

    readonly property string glyph: {
        if (!available) return "";
        const i = Math.max(0, Math.min(10, Math.round(percent / 10)));
        return charging || (pluggedIn && !full) ? Config.glyphs.batteryCharging[i]
             : low ? Config.glyphs.batteryAlert
             : Config.glyphs.battery[i];
    }

    // "1 h 20 min left" / "35 min until full" / "Fully charged" / "Plugged in"
    readonly property string statusText: {
        if (!available) return "";
        if (full) return "Fully charged";
        const fmt = s => {
            const h = Math.floor(s / 3600), m = Math.round(s % 3600 / 60);
            return h > 0 ? `${h} h ${m} min` : `${m} min`;
        };
        if (charging) return device.timeToFull > 0 ? `${fmt(device.timeToFull)} until full` : "Charging";
        if (pluggedIn) return "Plugged in";
        return device.timeToEmpty > 0 ? `${fmt(device.timeToEmpty)} left` : "On battery";
    }
}
