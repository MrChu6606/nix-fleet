import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: chip
    property string iconName: "wifi"
    property string label: "Wi-Fi"
    property bool enabled_: false
    property real uiScale: 1.0
    property var toggleAction: function () {}

    Layout.fillWidth: true
    implicitHeight: 56 * uiScale
    radius: 12 * uiScale
    color: enabled_ ? ThemeColors.primary : ThemeColors.surfaceContainer
    Behavior on color { ColorAnimation { duration: 150 } }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 4 * chip.uiScale

        IconGlyph {
            Layout.alignment: Qt.AlignHCenter
            name: chip.iconName
            tint: chip.enabled_ ? ThemeColors.textOnPrimary : ThemeColors.text
            implicitWidth: 18 * chip.uiScale
            implicitHeight: 18 * chip.uiScale
        }
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: chip.label
            color: chip.enabled_ ? ThemeColors.textOnPrimary : ThemeColors.text
            font.pixelSize: Math.round(10 * chip.uiScale)
            font.bold: true
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: chip.toggleAction()
    }
}
