import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications

ShellRoot {
    id: root

    // Global Scale Factor (1.0 = normal, 1.25 = +25% size)
    readonly property real s: 1.25

    // Toggle States for Control Center / Notification Panel
    property bool showControlCenter: false

    // System Monitoring & State Tracking
    property int cpuUsage: 0
    property int ramUsage: 0
    property int brightnessVal: 100

    // Enable Quickshell as the system-wide Notification Daemon
    Component.onCompleted: {
        NotificationServer.active = true;
    }

    // -------------------------------------------------------------------------
    // QuickShell IPC - Trigger this via command line or keybinding
    // Shell command: quickshell ipc call bar toggleControlCenter
    // -------------------------------------------------------------------------
    IpcHandler {
        target: "bar"

        function toggleControlCenter() {
            root.showControlCenter = !root.showControlCenter;
        }
    }

    // Process to Fetch CPU & RAM Usage
    Process {
        id: statsProc
        command: ["bash", "-c", "echo $(top -bn1 | grep 'Cpu(s)' | awk '{print $2}') $(free -m | awk '/Mem:/ { printf(\"%d\", $3/$2*100) }')"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split(" ");
                if (parts.length >= 2) {
                    root.cpuUsage = Math.round(parseFloat(parts[0]) || 0);
                    root.ramUsage = parseInt(parts[1]) || 0;
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: statsProc.running = true
    }

    // Process to Fetch Default Volume Level
    Process {
        id: getVolProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split(" ");
                if (parts.length >= 2) {
                    var vol = parseFloat(parts[1]) * 100;
                    volSlider.value = Math.round(vol);
                }
            }
        }
    }

    // Process to Fetch Brightness Level via brightnessctl
    Process {
        id: getBrightnessProc
        command: ["brightnessctl", "-m"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                var parts = data.split(",");
                if (parts.length >= 4) {
                    root.brightnessVal = parseInt(parts[3].replace("%", "")) || 100;
                }
            }
        }
    }

    // -------------------------------------------------------------------------
    // 1. Top Bar - Rendered on EVERY connected monitor
    // -------------------------------------------------------------------------
    Variants {
        model: Quickshell.screens

        Scope {
            required property var modelData

            PanelWindow {
                id: barWindow
                screen: modelData

                // Reduced space reservation for Niri windows
                WlrLayershell.exclusiveZone: Math.round(30 * root.s)

                anchors {
                    top: true
                    left: true
                    right: true
                }
                height: 40 * root.s
                color: "transparent"

                // Dynamic Island Pill
                Rectangle {
                    anchors.centerIn: parent
                    implicitWidth: pillLayout.implicitWidth + (32 * root.s)
                    implicitHeight: 34 * root.s
                    radius: 17 * root.s
                    color: ThemeColors.background
                    border.color: ThemeColors.border
                    border.width: 1

                    Behavior on implicitWidth {
                        NumberAnimation { duration: 220; easing.type: Easing.OutBack }
                    }

                    RowLayout {
                        id: pillLayout
                        anchors.centerIn: parent
                        spacing: 14 * root.s

                        // System Stats (CPU & RAM)
                        RowLayout {
                            spacing: 8 * root.s

                            Text {
                                text: " " + root.cpuUsage + "%"
                                color: ThemeColors.primary
                                font.pixelSize: Math.round(11 * root.s)
                                font.bold: true
                            }

                            Text {
                                text: " " + root.ramUsage + "%"
                                color: ThemeColors.text
                                font.pixelSize: Math.round(11 * root.s)
                                font.bold: true
                                opacity: 0.8
                            }
                        }

                        // Divider
                        Rectangle {
                            implicitWidth: 1
                            implicitHeight: 14 * root.s
                            color: ThemeColors.border
                        }

                        // Clock Widget
                        Text {
                            id: clockText
                            color: ThemeColors.text
                            font.pixelSize: Math.round(12 * root.s)
                            font.bold: true

                            Timer {
                                interval: 1000
                                running: true
                                repeat: true
                                triggeredOnStart: true
                                onTriggered: clockText.text = Qt.formatDateTime(new Date(), "hh:mm AP")
                            }
                        }

                        // Divider
                        Rectangle {
                            implicitWidth: 1
                            implicitHeight: 14 * root.s
                            color: ThemeColors.border
                        }

                        // Control Center Toggle Button
                        Rectangle {
                            implicitWidth: 26 * root.s
                            implicitHeight: 26 * root.s
                            radius: 13 * root.s
                            color: root.showControlCenter ? ThemeColors.primary : ThemeColors.surfaceContainer

                            Text {
                                anchors.centerIn: parent
                                text: "⚙"
                                font.pixelSize: Math.round(12 * root.s)
                                color: root.showControlCenter ? ThemeColors.textOnPrimary : ThemeColors.text
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: root.showControlCenter = !root.showControlCenter
                            }
                        }
                    }
                }
            }
        }
    }

    // -------------------------------------------------------------------------
    // 2. Control Center Panel (Settings, Controls & Notifications)
    // -------------------------------------------------------------------------
    PanelWindow {
        id: controlPanel
        visible: root.showControlCenter

        // Refresh volume slider state when opened
        onVisibleChanged: {
            if (visible) {
                getVolProc.running = true;
            }
        }

        anchors {
            top: true
            right: true
        }
        margins {
            top: 48 * root.s
            right: 16 * root.s
        }
        implicitWidth: 340 * root.s
        implicitHeight: 460 * root.s
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            radius: 16 * root.s
            color: ThemeColors.background
            border.color: ThemeColors.border
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16 * root.s
                spacing: 12 * root.s

                Text {
                    text: "Control Center"
                    color: ThemeColors.text
                    font.bold: true
                    font.pixelSize: Math.round(16 * root.s)
                }

                // WiFi Quick Toggle Button
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10 * root.s

                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 40 * root.s
                        radius: 8 * root.s
                        color: ThemeColors.surfaceContainer

                        RowLayout {
                            anchors.centerIn: parent
                            Text {
                                text: "📶 Network Menu"
                                color: ThemeColors.text
                                font.bold: true
                                font.pixelSize: Math.round(12 * root.s)
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                Process.run(["ghostty", "-e", "nmtui"]);
                            }
                        }
                    }
                }

                // Volume Slider
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4 * root.s

                    Text {
                        text: "🔊 Volume (" + Math.round(volSlider.value) + "%)"
                        color: ThemeColors.text
                        font.pixelSize: Math.round(11 * root.s)
                    }

                    Slider {
                        id: volSlider
                        Layout.fillWidth: true
                        from: 0
                        to: 100
                        stepSize: 1

                        onMoved: {
                            var volFormatted = (value / 100.0).toFixed(2);
                            Process.run(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", volFormatted]);
                        }
                    }
                }

                // Brightness Slider
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4 * root.s

                    Text {
                        text: "☀️ Brightness (" + root.brightnessVal + "%)"
                        color: ThemeColors.text
                        font.pixelSize: Math.round(11 * root.s)
                    }

                    Slider {
                        Layout.fillWidth: true
                        from: 5
                        to: 100
                        value: root.brightnessVal
                        stepSize: 1

                        onMoved: {
                            root.brightnessVal = Math.round(value);
                            Process.run(["brightnessctl", "set", Math.round(value) + "%"]);
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 1
                    color: ThemeColors.border
                }

                // Notifications Header
                Text {
                    text: "Notifications (" + NotificationServer.notifications.values.length + ")"
                    color: ThemeColors.text
                    font.bold: true
                    font.pixelSize: Math.round(14 * root.s)
                }

                // Notifications List
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: 8 * root.s
                    model: NotificationServer.notifications.values

                    delegate: Rectangle {
                        required property var modelData

                        width: ListView.view.width
                        implicitHeight: 54 * root.s
                        radius: 8 * root.s
                        color: ThemeColors.surfaceContainer

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 8 * root.s

                            Text {
                                text: modelData.summary || "Notification"
                                color: ThemeColors.text
                                font.bold: true
                                font.pixelSize: Math.round(12 * root.s)
                                elide: Text.ElideRight
                            }
                            Text {
                                text: modelData.body || ""
                                color: ThemeColors.text
                                opacity: 0.7
                                font.pixelSize: Math.round(10 * root.s)
                                elide: Text.ElideRight
                            }
                        }
                    }
                }
            }
        }
    }
}
