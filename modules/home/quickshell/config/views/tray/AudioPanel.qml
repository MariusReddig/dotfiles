import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import "../../config"
import "../../state"
import "../../services"
import "../../components"

// Expanded audio panel: microphone level and output device selection.
// (Output volume itself lives in the tray view's controls.)
Column {
    id: root
    width: 340
    spacing: 6

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource
    readonly property var sinks: Pipewire.nodes.values
        .filter(n => n.isSink && !n.isStream && n.audio)

    function label(n) { return n?.description || n?.nickname || n?.name || "Unknown"; }

    PwObjectTracker { objects: [root.source].concat(root.sinks).filter(n => n) }

    Text {
        text: "Microphone"
        leftPadding: 6
        color: Config.text
        font.family: Config.font
        font.pixelSize: 13
        font.weight: Font.DemiBold
    }

    SliderRow {
        visible: !!root.source?.audio
        fullWidth: root.width
        glyph: root.source?.audio?.muted ? Config.glyphs.micOff : Config.glyphs.mic
        value: root.source?.audio?.volume ?? 0
        dimmed: root.source?.audio?.muted ?? false
        onMoved: v => { root.source.audio.volume = v; if (v > 0) root.source.audio.muted = false; }
        onIconClicked: root.source.audio.muted = !root.source.audio.muted
    }

    Text {
        visible: !root.source?.audio
        leftPadding: 6
        text: "No microphone"
        color: Config.subtext
        font.family: Config.font
        font.pixelSize: 12
    }

    Text {
        text: "Output device"
        leftPadding: 6
        topPadding: 4
        color: Config.text
        font.family: Config.font
        font.pixelSize: 13
        font.weight: Font.DemiBold
    }

    Repeater {
        model: root.sinks
        delegate: ListRow {
            required property var modelData
            width: root.width
            glyph: Config.glyphs.volHigh
            title: root.label(modelData)
            active: modelData === root.sink
            trailing: active ? Config.glyphs.check : ""
            trailingIsGlyph: true
            onClicked: Pipewire.preferredDefaultAudioSink = modelData
        }
    }
}
