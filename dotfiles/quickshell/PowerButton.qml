import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: btn
    property string iconName: "power"
    property color tint: "#f38ba8"
    property real uiScale: 1.0
    property var confirmAction: function () {}
    property bool confirming: false

    implicitWidth: 56 * uiScale
    implicitHeight: 46 * uiScale
    radius: 12 * uiScale
    color: confirming ? tint : ThemeColors.surfaceContainer
    border.width: confirming ? 0 : 1
    border.color: ThemeColors.border
    Behavior on color { ColorAnimation { duration: 150 } }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 2 * btn.uiScale

        IconGlyph {
            Layout.alignment: Qt.AlignHCenter
            name: btn.iconName
            tint: btn.confirming ? ThemeColors.background : ThemeColors.text
            implicitWidth: 15 * btn.uiScale
            implicitHeight: 15 * btn.uiScale
        }
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Confirm?"
            visible: btn.confirming
            color: ThemeColors.background
            font.pixelSize: Math.round(8 * btn.uiScale)
            font.bold: true
        }
    }

    Timer {
        id: resetTimer
        interval: 2500
        onTriggered: btn.confirming = false
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (btn.confirming) {
                btn.confirming = false;
                resetTimer.stop();
                btn.confirmAction();
            } else {
                btn.confirming = true;
                resetTimer.restart();
            }
        }
    }
}
