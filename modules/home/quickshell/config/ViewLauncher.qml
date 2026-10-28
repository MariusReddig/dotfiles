import QtQuick
import Quickshell
import Quickshell.Widgets

// App launcher with fuzzy search. The list scrolls (wheel or keyboard).
//   ↑ ↓ / PgUp PgDn   move     Enter   launch     Esc   close
// "Wallpapers" is listed like an app and opens the wallpaper picker.
FocusScope {
    id: root
    focus: true

    readonly property bool ownsIcon: true     // icon sits in the search row, not beside the pill
    readonly property int w: 460
    readonly property int rowH: 46

    implicitWidth: column.implicitWidth
    implicitHeight: column.implicitHeight

    property int current: 0

    // Built-in entries that behave like apps.
    readonly property var builtins: [{
        name: "Wallpapers",
        genericName: "Choose a desktop background",
        keywords: ["background", "wallpaper", "awww"],
        glyph: Config.stateIcons.wallpapers,
        run: () => BarState.request("wallpapers")
    }]

    readonly property var results: {
        const q = header.text.trim();
        const items = DesktopEntries.applications.values
            .filter(e => !e.noDisplay)
            .map(e => ({ name: e.name, genericName: e.genericName || e.comment || "",
                         keywords: e.keywords ?? [], id: e.id, entry: e }))
            .concat(root.builtins);

        if (q === "")
            return items
                .sort((a, b) => a.name.localeCompare(b.name))
                .map(it => ({ item: it, positions: [] }));

        const out = [];
        for (const it of items) {
            const byName = Fuzzy.match(it.name, q);
            let score = byName ? byName.score : -Infinity;
            for (const [field, weight] of [[it.genericName, 0.6], [(it.keywords ?? []).join(" "), 0.5], [it.id ?? "", 0.4]]) {
                const m = Fuzzy.match(field, q);
                if (m) score = Math.max(score, m.score * weight);
            }
            if (score > -Infinity) out.push({ item: it, score, positions: byName ? byName.positions : [] });
        }
        return out.sort((a, b) => b.score - a.score);
    }

    function move(delta) {
        if (results.length === 0) return;
        current = Math.max(0, Math.min(results.length - 1, current + delta));
        list.positionViewAtIndex(current, ListView.Contain);
    }

    function launch(it) {
        if (!it) return;
        if (it.run) { it.run(); return; }        // builtin: morphs to its own state
        console.info("pillbar: launching", it.id, "→", it.entry.command);
        try {
            it.entry.execute();
        } catch (err) {
            console.warn("pillbar: execute() failed, falling back:", err);
            Quickshell.execDetached(it.entry.command);
        }
        BarState.close();
    }

    function icon(name) {
        return Quickshell.iconPath(name ?? "", true) || Quickshell.iconPath("application-x-executable", true);
    }

    function grabFocus() { header.grabFocus(); }

    Component.onCompleted: { grabFocus(); Qt.callLater(grabFocus); }
    Connections {
        target: BarState
        function onPhaseChanged() { if (BarState.phase === "open") Qt.callLater(root.grabFocus); }
    }
    Timer { running: true; interval: 80; onTriggered: root.grabFocus() }

    Column {
        id: column
        spacing: 6

        SearchHeader {
            id: header
            fullWidth: root.w
            placeholder: "Search applications…"
            icon: Config.stateIcons.launcher

            onTextChanged: { root.current = 0; list.positionViewAtBeginning(); }
            onKeyPressed: e => {
                switch (e.key) {
                case Qt.Key_Escape: BarState.close(); break;
                case Qt.Key_Down: root.move(1); break;
                case Qt.Key_Up: root.move(-1); break;
                case Qt.Key_PageDown: root.move(Config.launcherRows); break;
                case Qt.Key_PageUp: root.move(-Config.launcherRows); break;
                case Qt.Key_Return:
                case Qt.Key_Enter: root.launch(root.results[root.current]?.item); break;
                case Qt.Key_Tab: break;   // swallow: launcher is not part of the cycle
                default: return;
                }
                e.accepted = true;
            }
        }

        Text {
            visible: root.results.length === 0
            width: root.w
            horizontalAlignment: Text.AlignHCenter
            topPadding: 10
            bottomPadding: 10
            text: "No matches"
            color: Config.subtext
            font.family: Config.font
            font.pixelSize: 13
        }

        Item {
            visible: root.results.length > 0
            width: root.w
            height: list.height

        ListView {
            id: list
            width: root.w
            height: Math.min(root.results.length, Config.launcherRows) * root.rowH
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            model: root.results
            currentIndex: root.current
            highlightFollowsCurrentItem: false

            delegate: Rectangle {
                id: row
                required property var modelData
                required property int index
                readonly property var it: modelData.item

                width: list.width - (scrollbar.visible ? 8 : 0)
                height: root.rowH
                radius: 16
                color: index === root.current ? Config.surface : "transparent"

                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 12

                    Item {
                        width: 28
                        height: 28
                        anchors.verticalCenter: parent.verticalCenter
                        IconImage {
                            anchors.centerIn: parent
                            visible: !row.it.glyph
                            implicitSize: 26
                            source: row.it.glyph ? "" : root.icon(row.it.entry.icon)
                        }
                        Text {
                            anchors.centerIn: parent
                            visible: !!row.it.glyph
                            text: row.it.glyph ?? ""
                            color: Config.accent
                            font.family: Config.iconFont
                            font.pixelSize: 22
                        }
                    }

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            textFormat: Text.StyledText
                            text: Fuzzy.highlight(row.it.name, row.modelData.positions, Config.accent)
                            color: Config.text
                            font.family: Config.font
                            font.pixelSize: 13
                        }
                        Text {
                            visible: text !== ""
                            width: root.w - 90
                            elide: Text.ElideRight
                            text: row.it.genericName
                            color: Config.subtext
                            font.family: Config.font
                            font.pixelSize: 11
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: root.current = row.index
                    onClicked: root.launch(row.it)
                }
            }

        }

        // thin scroll indicator
        Rectangle {
            id: scrollbar
            visible: list.contentHeight > list.height
            anchors.right: parent.right
            width: 4
            radius: 2
            color: Config.overlay
            y: list.visibleArea.yPosition * list.height
            height: list.visibleArea.heightRatio * list.height
        }
        }
    }
}
