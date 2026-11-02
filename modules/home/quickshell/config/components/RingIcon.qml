import QtQuick
import "../config"

// A glyph inside a circular progress ring.
//   value 0 … 1 fills the ring clockwise from the top.
Item {
    id: root

    property string glyph: ""
    property real value: 0
    property color color: Config.accent           // filled part + glyph
    property color trackColor: Config.surface     // empty part
    property int size: 30
    property int thickness: 3
    property int glyphSize: 14

    implicitWidth: size
    implicitHeight: size

    // animate the ring when the value changes
    property real shown: value
    Behavior on shown { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }

    onShownChanged: ring.requestPaint()
    onColorChanged: ring.requestPaint()
    onTrackColorChanged: ring.requestPaint()

    Canvas {
        id: ring
        anchors.fill: parent
        antialiasing: true

        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();
            const r = (Math.min(width, height) - root.thickness) / 2;
            const cx = width / 2, cy = height / 2;
            const start = -Math.PI / 2;
            ctx.lineWidth = root.thickness;
            ctx.lineCap = "round";

            ctx.strokeStyle = root.trackColor;
            ctx.beginPath();
            ctx.arc(cx, cy, r, 0, 2 * Math.PI);
            ctx.stroke();

            const v = Math.max(0, Math.min(1, root.shown));
            if (v > 0) {
                ctx.strokeStyle = root.color;
                ctx.beginPath();
                ctx.arc(cx, cy, r, start, start + v * 2 * Math.PI);
                ctx.stroke();
            }
        }
    }

    Text {
        anchors.centerIn: parent
        text: root.glyph
        color: root.color
        font.family: Config.iconFont
        font.pixelSize: root.glyphSize
    }
}
