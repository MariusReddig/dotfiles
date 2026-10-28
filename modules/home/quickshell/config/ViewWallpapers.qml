import QtQuick
import Quickshell
import Quickshell.Widgets

// Wallpaper picker (its own state; also reachable from the launcher).
//   arrows   move     Enter   apply     Esc   close     wheel   scroll
FocusScope {
    id: root
    focus: true

    readonly property bool ownsIcon: true
    readonly property int cellW: 200
    readonly property int cellH: 124
    readonly property int columns: 3
    readonly property int w: cellW * columns

    implicitWidth: column.implicitWidth
    implicitHeight: column.implicitHeight

    property int current: 0

    readonly property var results: {
        const q = header.text.trim();
        const files = Wallpapers.files;
        if (q === "") return files;
        return files
            .map(f => ({ f, m: Fuzzy.match(Wallpapers.baseName(f), q) }))
            .filter(x => x.m)
            .sort((a, b) => b.m.score - a.m.score)
            .map(x => x.f);
    }

    function move(delta) {
        if (results.length === 0) return;
        current = Math.max(0, Math.min(results.length - 1, current + delta));
        grid.positionViewAtIndex(current, GridView.Contain);
    }

    function apply() {
        Wallpapers.apply(results[current]);
        if (Config.closeOnWallpaperApply) BarState.close();
    }

    function grabFocus() { header.grabFocus(); }

    Component.onCompleted: {
        Wallpapers.rescan();
        grabFocus();
        Qt.callLater(grabFocus);
    }
    Connections {
        target: BarState
        function onPhaseChanged() { if (BarState.phase === "open") Qt.callLater(root.grabFocus); }
    }
    // Jump to the current wallpaper once the scan finishes.
    Connections {
        target: Wallpapers
        function onFilesChanged() {
            const i = Wallpapers.files.indexOf(Wallpapers.current);
            if (header.text === "" && i >= 0) { root.current = i; Qt.callLater(() => grid.positionViewAtIndex(i, GridView.Center)); }
        }
    }
    Timer { running: true; interval: 80; onTriggered: root.grabFocus() }

    Column {
        id: column
        spacing: 6

        SearchHeader {
            id: header
            fullWidth: root.w
            placeholder: "Search wallpapers…"
            icon: Config.stateIcons.wallpapers

            onTextChanged: { root.current = 0; grid.positionViewAtBeginning(); }
            onKeyPressed: e => {
                switch (e.key) {
                case Qt.Key_Escape: BarState.close(); break;
                case Qt.Key_Down: root.move(root.columns); break;
                case Qt.Key_Up: root.move(-root.columns); break;
                case Qt.Key_Right: root.move(1); break;
                case Qt.Key_Left: root.move(-1); break;
                case Qt.Key_PageDown: root.move(root.columns * Config.wallpaperRows); break;
                case Qt.Key_PageUp: root.move(-root.columns * Config.wallpaperRows); break;
                case Qt.Key_Return:
                case Qt.Key_Enter: root.apply(); break;
                case Qt.Key_Tab: break;
                default: return;
                }
                e.accepted = true;
            }
        }

        Text {
            visible: root.results.length === 0
            width: root.w
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            topPadding: 10
            bottomPadding: 10
            text: Wallpapers.loading ? "Scanning…"
                : Wallpapers.files.length === 0 ? `No images in ${Config.wallpaperDir}`
                : "No matches"
            color: Config.subtext
            font.family: Config.font
            font.pixelSize: 13
        }

        GridView {
            id: grid
            visible: root.results.length > 0
            width: root.w
            height: Math.min(Math.ceil(root.results.length / root.columns), Config.wallpaperRows) * root.cellH
            cellWidth: root.cellW
            cellHeight: root.cellH
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            model: root.results
            currentIndex: root.current
            highlightFollowsCurrentItem: false

            delegate: Item {
                id: cell
                required property string modelData
                required property int index
                readonly property bool selected: index === root.current
                readonly property bool active: modelData === Wallpapers.current

                width: root.cellW
                height: root.cellH

                ClippingRectangle {
                    id: thumb
                    anchors.fill: parent
                    anchors.margins: 4
                    radius: 16
                    color: Config.surface

                    Image {
                        anchors.fill: parent
                        source: "file://" + cell.modelData
                        sourceSize.width: root.cellW * 1.5
                        sourceSize.height: root.cellH * 1.5
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                        cache: true
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: 22
                        visible: cell.selected || hover.hovered
                        color: "#cc1e1e2e"
                        Text {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideMiddle
                            text: Wallpapers.baseName(cell.modelData)
                            color: Config.text
                            font.family: Config.font
                            font.pixelSize: 11
                        }
                    }

                    Text {
                        visible: cell.active
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.margins: 6
                        text: String.fromCodePoint(0xF05E0)   // md-check_circle
                        color: Config.accent
                        font.family: Config.iconFont
                        font.pixelSize: 18
                    }
                }

                // selection ring
                Rectangle {
                    anchors.fill: thumb
                    radius: thumb.radius
                    color: "transparent"
                    border.width: cell.selected ? 2 : 0
                    border.color: Config.accent
                }

                HoverHandler { id: hover }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.current = cell.index;
                        root.apply();
                        root.grabFocus();
                    }
                }
            }
        }
    }
}
