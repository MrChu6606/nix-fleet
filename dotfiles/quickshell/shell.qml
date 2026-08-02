import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications

ShellRoot {
    id: root

    // Notification Center Toggle State
    property bool showNotifs: false

    // QuickShell IPC to toggle Notification Center via keybinding
    IpcHandler {
        target: "bar"
        function toggleNotifications() {
            root.showNotifs = !root.showNotifs;
        }
    }

    // Top Bar Panel Window
    PanelWindow {
        id: barWindow
        anchors {
            top: true
            left: true
            right: true
        }
        height: 52
        color: "transparent"

        // Floating Dynamic Island Pill
        Rectangle {
            anchors.centerIn: parent
            implicitWidth: pillLayout.implicitWidth + 32
            implicitHeight: 38
            radius: 19
            color: ThemeColors.background
            border.color: ThemeColors.border
            border.width: 1

            // Fluid animation for dynamic island width expanding/shrinking
            Behavior on implicitWidth {
                NumberAnimation { duration: 220; easing.type: Easing.OutBack }
            }

            RowLayout {
                id: pillLayout
                anchors.centerIn: parent
                spacing: 16

                // Workspaces Indicator / Desktop Label
                Rectangle {
                    implicitWidth: 28
                    implicitHeight: 28
                    radius: 14
                    color: ThemeColors.primary

                    Text {
                        anchors.centerIn: parent
                        text: "N"
                        font.bold: true
                        color: ThemeColors.onPrimary
                    }
                }

                // Clock Widget
                Text {
                    id: clockText
                    color: ThemeColors.text
                    font.pixelSize: 13
                    font.bold: true

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        triggeredOnStart: true
                        onTriggered: clockText.text = Qt.formatDateTime(new Date(), "hh:mm AP")
                    }
                }

                // Notification Center Toggle Button
                Rectangle {
                    implicitWidth: 28
                    implicitHeight: 28
                    radius: 14
                    color: root.showNotifs ? ThemeColors.primary : ThemeColors.surfaceContainer

                    Text {
                        anchors.centerIn: parent
                        text: "🔔"
                        font.pixelSize: 12
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.showNotifs = !root.showNotifs
                    }
                }
            }
        }
    }

    // Notification Center Popup Panel
    PanelWindow {
        id: notifWindow
        visible: root.showNotifs
        anchors {
            top: true
            right: true
        }
        margins {
            top: 56
            right: 16
        }
        implicitWidth: 320
        implicitHeight: 400
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            radius: 16
            color: ThemeColors.background
            border.color: ThemeColors.border
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16

                Text {
                    text: "Notifications"
                    color: ThemeColors.text
                    font.bold: true
                    font.pixelSize: 16
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: NotificationServer.notifications

                    delegate: Rectangle {
                        required property string summary
                        required property string body

                        width: ListView.view.width
                        implicitHeight: 60
                        radius: 8
                        color: ThemeColors.surfaceContainer

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 8

                            Text {
                                text: summary
                                color: ThemeColors.text
                                font.bold: true
                                elide: Text.ElideRight
                            }
                            Text {
                                text: body
                                color: ThemeColors.text
                                opacity: 0.7
                                font.pixelSize: 11
                                elide: Text.ElideRight
                            }
                        }
                    }
                }
            }
        }
    }
}
