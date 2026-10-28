import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris

// Music / video control for any MPRIS player (Spotify, mpv, Firefox, VLC, …).
//   Space  play/pause     ← →  previous / next     ↑ ↓  switch player
FocusScope {
    id: root
    focus: true

    readonly property int w: 380
    readonly property var players: Mpris.players.values
    property int chosen: -1   // -1 → follow whichever player is playing

    readonly property var player: {
        if (players.length === 0) return null;
        if (chosen >= 0 && chosen < players.length) return players[chosen];
        return players.find(p => p.isPlaying) ?? players[0];
    }

    implicitWidth: column.implicitWidth
    implicitHeight: column.implicitHeight

    function fmt(sec) {
        if (!isFinite(sec) || sec < 0) return "0:00";
        sec = Math.floor(sec);
        const h = Math.floor(sec / 3600), m = Math.floor(sec % 3600 / 60), s = sec % 60;
        const ss = String(s).padStart(2, "0");
        return h > 0 ? `${h}:${String(m).padStart(2, "0")}:${ss}` : `${m}:${ss}`;
    }

    function switchPlayer(step) {
        if (players.length < 2) return;
        const i = players.indexOf(player);
        chosen = ((i + step) % players.length + players.length) % players.length;
    }

    Component.onCompleted: forceActiveFocus()
    Keys.onPressed: e => {
        const p = root.player;
        switch (e.key) {
        case Qt.Key_Space: if (p?.canTogglePlaying) p.togglePlaying(); break;
        case Qt.Key_Left: if (p?.canGoPrevious) p.previous(); break;
        case Qt.Key_Right: if (p?.canGoNext) p.next(); break;
        case Qt.Key_Up: root.switchPlayer(-1); break;
        case Qt.Key_Down: root.switchPlayer(1); break;
        case Qt.Key_Escape: BarState.close(); break;
        case Qt.Key_Tab: BarState.cycle(1); break;
        case Qt.Key_Backtab: BarState.cycle(-1); break;
        default: return;
        }
        e.accepted = true;
    }

    // MPRIS doesn't push position updates; poll while playing.
    Timer {
        running: root.player?.isPlaying ?? false
        interval: 1000
        repeat: true
        onTriggered: root.player.positionChanged()
    }

    Column {
        id: column
        spacing: 8

        Text {
            visible: !root.player
            width: root.w
            horizontalAlignment: Text.AlignHCenter
            topPadding: 6
            bottomPadding: 6
            text: "Nothing is playing"
            color: Config.subtext
            font.family: Config.font
            font.pixelSize: 13
        }

        Row {
            visible: !!root.player
            spacing: 12

            // ── cover art ──
            ClippingRectangle {
                width: 72
                height: 72
                radius: 14
                color: Config.surface

                Image {
                    anchors.fill: parent
                    source: root.player?.trackArtUrl ?? ""
                    fillMode: Image.PreserveAspectCrop
                    sourceSize.width: 144
                    sourceSize.height: 144
                    asynchronous: true
                    visible: status === Image.Ready
                }
                Text {
                    anchors.centerIn: parent
                    visible: !root.player?.trackArtUrl
                    text: Config.stateIcons.media
                    color: Config.subtext
                    font.family: Config.iconFont
                    font.pixelSize: 28
                }
            }

            Column {
                width: root.w - 84
                spacing: 2

                Text {
                    width: parent.width
                    elide: Text.ElideRight
                    text: root.player?.trackTitle || "Unknown title"
                    color: Config.text
                    font.family: Config.font
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                }
                Text {
                    width: parent.width
                    elide: Text.ElideRight
                    text: [root.player?.trackArtist, root.player?.trackAlbum].filter(s => s).join(" · ") || root.player?.identity || ""
                    color: Config.subtext
                    font.family: Config.font
                    font.pixelSize: 12
                }

                // ── controls ──
                Row {
                    spacing: 6
                    topPadding: 6

                    Repeater {
                        model: [
                            { glyph: 0xF04AE, ok: () => root.player?.canGoPrevious, act: () => root.player.previous() },
                            { glyph: 0, ok: () => root.player?.canTogglePlaying, act: () => root.player.togglePlaying() },
                            { glyph: 0xF04AD, ok: () => root.player?.canGoNext, act: () => root.player.next() }
                        ]
                        delegate: Rectangle {
                            id: btn
                            required property var modelData
                            required property int index
                            readonly property bool main: index === 1
                            readonly property bool enabledBtn: !!modelData.ok()

                            width: main ? 40 : 32
                            height: width
                            radius: width / 2
                            anchors.verticalCenter: parent.verticalCenter
                            color: main ? Config.accent : btnHover.hovered ? Config.overlay : Config.surface
                            opacity: enabledBtn ? 1 : 0.4

                            HoverHandler { id: btnHover }
                            Text {
                                anchors.centerIn: parent
                                text: String.fromCodePoint(btn.main
                                    ? (root.player?.isPlaying ? 0xF03E4 : 0xF040A)   // md-pause / md-play
                                    : btn.modelData.glyph)
                                color: btn.main ? Config.bg : Config.text
                                font.family: Config.iconFont
                                font.pixelSize: btn.main ? 20 : 16
                            }
                            MouseArea {
                                anchors.fill: parent
                                enabled: btn.enabledBtn
                                cursorShape: Qt.PointingHandCursor
                                onClicked: btn.modelData.act()
                            }
                        }
                    }
                }
            }
        }

        // ── progress ──
        Column {
            visible: !!root.player && (root.player.lengthSupported ?? false) && root.player.length > 0
            spacing: 2

            Rectangle {
                id: track
                width: root.w
                height: 6
                radius: 3
                color: Config.surface

                Rectangle {
                    width: track.width * Math.min(1, (root.player?.position ?? 0) / Math.max(1, root.player?.length ?? 1))
                    height: parent.height
                    radius: parent.radius
                    color: Config.accent
                    Behavior on width { NumberAnimation { duration: 300 } }
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.topMargin: -6
                    anchors.bottomMargin: -6
                    enabled: root.player?.canSeek ?? false
                    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked: m => root.player.position = root.player.length * Math.max(0, Math.min(1, m.x / track.width))
                }
            }

            Item {
                width: root.w
                height: 14
                Text {
                    text: root.fmt(root.player?.position ?? 0)
                    color: Config.subtext
                    font.family: Config.font
                    font.pixelSize: 10
                }
                Text {
                    anchors.right: parent.right
                    text: root.fmt(root.player?.length ?? 0)
                    color: Config.subtext
                    font.family: Config.font
                    font.pixelSize: 10
                }
            }
        }

        // ── player switcher (only with more than one player) ──
        Flow {
            visible: root.players.length > 1
            width: root.w
            spacing: 4
            Repeater {
                model: root.players
                delegate: PillButton {
                    required property var modelData
                    required property int index
                    text: (modelData === root.player ? "● " : "") + (modelData.identity || "Player")
                    onClicked: root.chosen = index
                }
            }
        }
    }
}
