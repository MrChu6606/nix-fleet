import QtQuick

Canvas {
    id: icon
    property string name: "circle"
    property color tint: "white"
    property real strokeW: 1.8
    implicitWidth: 16
    implicitHeight: 16

    onPaint: {
        var ctx = getContext("2d");
        ctx.setTransform(1, 0, 0, 1, 0, 0);
        ctx.clearRect(0, 0, width, height);
        ctx.save();
        ctx.scale(width / 24, height / 24);
        ctx.strokeStyle = tint;
        ctx.fillStyle = tint;
        ctx.lineWidth = strokeW;
        ctx.lineCap = "round";
        ctx.lineJoin = "round";

        switch (name) {
        case "sliders":
            ctx.beginPath(); ctx.moveTo(4, 8); ctx.lineTo(20, 8); ctx.stroke();
            ctx.beginPath(); ctx.arc(14, 8, 2.4, 0, Math.PI * 2); ctx.fill();
            ctx.beginPath(); ctx.moveTo(4, 16); ctx.lineTo(20, 16); ctx.stroke();
            ctx.beginPath(); ctx.arc(9, 16, 2.4, 0, Math.PI * 2); ctx.fill();
            break;
        case "cpu":
            ctx.strokeRect(7, 7, 10, 10);
            [9, 12, 15].forEach(function (p) {
                ctx.beginPath(); ctx.moveTo(p, 3.5); ctx.lineTo(p, 7); ctx.stroke();
                ctx.beginPath(); ctx.moveTo(p, 17); ctx.lineTo(p, 20.5); ctx.stroke();
                ctx.beginPath(); ctx.moveTo(3.5, p); ctx.lineTo(7, p); ctx.stroke();
                ctx.beginPath(); ctx.moveTo(17, p); ctx.lineTo(20.5, p); ctx.stroke();
            });
            break;
        case "memory":
            ctx.strokeRect(4, 6, 16, 12);
            [8, 12, 16].forEach(function (p) {
                ctx.beginPath(); ctx.moveTo(p, 18); ctx.lineTo(p, 21); ctx.stroke();
            });
            ctx.beginPath(); ctx.moveTo(7, 10); ctx.lineTo(7, 14); ctx.stroke();
            ctx.beginPath(); ctx.moveTo(11, 10); ctx.lineTo(11, 14); ctx.stroke();
            break;
        case "sun":
            ctx.beginPath(); ctx.arc(12, 12, 3.6, 0, Math.PI * 2); ctx.stroke();
            for (var i = 0; i < 8; i++) {
                var a = i * Math.PI / 4;
                var x1 = 12 + Math.cos(a) * 6.5, y1 = 12 + Math.sin(a) * 6.5;
                var x2 = 12 + Math.cos(a) * 9, y2 = 12 + Math.sin(a) * 9;
                ctx.beginPath(); ctx.moveTo(x1, y1); ctx.lineTo(x2, y2); ctx.stroke();
            }
            break;
        case "speaker":
            ctx.beginPath();
            ctx.moveTo(4, 10); ctx.lineTo(8, 10); ctx.lineTo(13, 5.5);
            ctx.lineTo(13, 18.5); ctx.lineTo(8, 14); ctx.lineTo(4, 14);
            ctx.closePath(); ctx.fill();
            ctx.beginPath(); ctx.arc(12, 12, 4.2, -0.6, 0.6, false); ctx.stroke();
            ctx.beginPath(); ctx.arc(12, 12, 7, -0.5, 0.5, false); ctx.stroke();
            break;
        case "speaker-mute":
            ctx.beginPath();
            ctx.moveTo(4, 10); ctx.lineTo(8, 10); ctx.lineTo(13, 5.5);
            ctx.lineTo(13, 18.5); ctx.lineTo(8, 14); ctx.lineTo(4, 14);
            ctx.closePath(); ctx.fill();
            ctx.beginPath(); ctx.moveTo(16, 8); ctx.lineTo(21, 13); ctx.moveTo(21, 8); ctx.lineTo(16, 13); ctx.stroke();
            break;
        case "bell":
            ctx.beginPath();
            ctx.moveTo(6.5, 17);
            ctx.lineTo(6.5, 12);
            ctx.quadraticCurveTo(6.5, 6.5, 12, 6.5);
            ctx.quadraticCurveTo(17.5, 6.5, 17.5, 12);
            ctx.lineTo(17.5, 17);
            ctx.stroke();
            ctx.beginPath(); ctx.moveTo(4.5, 17); ctx.lineTo(19.5, 17); ctx.stroke();
            ctx.beginPath(); ctx.arc(12, 20, 1.6, 0, Math.PI * 2); ctx.fill();
            break;
        case "wifi":
            ctx.beginPath(); ctx.arc(12, 18, 1.4, 0, Math.PI * 2); ctx.fill();
            for (var r = 0; r < 3; r++) {
                var rad = 4.5 + r * 4.2;
                ctx.beginPath();
                ctx.arc(12, 18, rad, Math.PI * 1.18, Math.PI * 1.82, false);
                ctx.stroke();
            }
            break;
        case "bluetooth":
            ctx.beginPath();
            ctx.moveTo(12, 4); ctx.lineTo(12, 20);
            ctx.moveTo(8, 8); ctx.lineTo(16, 15); ctx.lineTo(12, 19);
            ctx.moveTo(16, 8); ctx.lineTo(8, 15); ctx.lineTo(12, 19);
            ctx.moveTo(12, 4); ctx.lineTo(16, 8);
            ctx.moveTo(12, 4); ctx.lineTo(8, 8);
            ctx.stroke();
            break;
        case "power":
            ctx.beginPath();
            ctx.arc(12, 12, 7, -0.96, 4.10, false);
            ctx.stroke();
            ctx.beginPath(); ctx.moveTo(12, 4.5); ctx.lineTo(12, 11); ctx.stroke();
            break;
        case "lock":
            ctx.beginPath(); ctx.arc(12, 10, 4, Math.PI, Math.PI * 2, false); ctx.stroke();
            ctx.strokeRect(6, 10, 12, 9);
            ctx.beginPath(); ctx.arc(12, 14.3, 1.3, 0, Math.PI * 2); ctx.fill();
            break;
        case "restart":
            ctx.beginPath();
            ctx.arc(12, 12, 7.5, -0.6, 4.9, false);
            ctx.stroke();
            ctx.beginPath();
            ctx.moveTo(17.6, 5.4); ctx.lineTo(18.4, 9.4); ctx.lineTo(14.4, 9.0);
            ctx.closePath(); ctx.fill();
            break;
        case "logout":
            ctx.beginPath();
            ctx.moveTo(13, 4); ctx.lineTo(6, 4); ctx.lineTo(6, 20); ctx.lineTo(13, 20);
            ctx.stroke();
            ctx.beginPath(); ctx.moveTo(10, 12); ctx.lineTo(20, 12); ctx.stroke();
            ctx.beginPath(); ctx.moveTo(16.5, 8); ctx.lineTo(20.5, 12); ctx.lineTo(16.5, 16); ctx.stroke();
            break;
        case "close":
            ctx.beginPath(); ctx.moveTo(6.5, 6.5); ctx.lineTo(17.5, 17.5); ctx.stroke();
            ctx.beginPath(); ctx.moveTo(17.5, 6.5); ctx.lineTo(6.5, 17.5); ctx.stroke();
            break;
        default:
            ctx.beginPath(); ctx.arc(12, 12, 7, 0, Math.PI * 2); ctx.stroke();
        }
        ctx.restore();
    }

    onTintChanged: requestPaint()
    onNameChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
    Component.onCompleted: requestPaint()
}
