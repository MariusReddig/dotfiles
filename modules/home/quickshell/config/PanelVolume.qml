import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

// Output / input volume and output device selection (PipeWire).
Column {
    id: root
    width: 340
    spacing: 6

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource
    readonly property var sinks: Pipewire.nodes.values
        .filter(n => n.isSink && !n.isStream && n.audio)
    readonly property real maxVolume: 1.0

    function label(n) { return n?.description || n?.nickname || n?.name || "Unknown"; }

    PwObjectTracker { objects: [root.sink, root.source].concat(root.sinks).filter(n => n) }

    component Channel: Row {
        id: ch
        property var node: null
        property string onGlyph: ""
        property string offGlyph: ""
        property real maxVolume: 1.0
        // inline components can't see the file's ids, so size from the parent
        readonly property real fullWidth: parent ? parent.width : 340
        spacing: 10
        visible: !!node?.audio

        Rectangle {
            width: 30
            height: 30
            radius: 15
            anchors.verticalCenter: parent.verticalCenter
            color: muteHover.hovered ? Config.overlay : Config.surface
            HoverHandler { id: muteHover }
            Text {
                anchors.centerIn: parent
                text: ch.node?.audio?.muted ? ch.offGlyph : ch.onGlyph
                color: ch.node?.audio?.muted ? Config.subtext : Config.text
                font.family: Config.iconFont
                font.pixelSize: 15
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: ch.node.audio.muted = !ch.node.audio.muted
            }
        }

        VolumeSlider {
            width: ch.fullWidth - 30 - 44 - 2 * ch.spacing
            anchors.verticalCenter: parent.verticalCenter
            value: ch.node?.audio?.volume ?? 0
            max: ch.maxVolume
            muted: ch.node?.audio?.muted ?? false
            onMoved: v => { ch.node.audio.volume = v; if (v > 0 && ch.node.audio.muted) ch.node.audio.muted = false; }
        }

        Text {
            width: 44
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignRight
            text: Math.round((ch.node?.audio?.volume ?? 0) * 100) + "%"
            color: Config.subtext
            font.family: Config.font
            font.pixelSize: 12
        }
    }

    Text {
        text: "Volume"
        leftPadding: 6
        color: Config.text
        font.family: Config.font
        font.pixelSize: 13
        font.weight: Font.DemiBold
    }

    Channel { maxVolume: root.maxVolume; node: root.sink; onGlyph: Config.glyphs.volHigh; offGlyph: Config.glyphs.volMute }
    Channel { maxVolume: root.maxVolume; node: root.source; onGlyph: Config.glyphs.mic; offGlyph: Config.glyphs.micOff }

    Text {
        visible: root.sinks.length > 1
        text: "Output"
        leftPadding: 6
        topPadding: 4
        color: Config.subtext
        font.family: Config.font
        font.pixelSize: 11
    }

    Repeater {
        model: root.sinks.length > 1 ? root.sinks : []
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
