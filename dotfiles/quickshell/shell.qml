import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications

ShellRoot {
    id: root

    // USER CONFIGURATION
    property string terminal: "alacritty"
    readonly property real s: 1.25      // Global UI scale factor

    // State
    property bool showControlCenter: false
    property real dynamicPillWidth: 300 // Updates dynamically based on content

    // System Monitoring State
    property int cpuUsage: 0
    property int ramUsage: 0
    property int brightnessVal: 100
    property int volumeVal: 100
    property bool volumeMuted: false
    property bool wifiEnabled: false
    property bool bluetoothEnabled: false
    property bool dndEnabled: false

    property var niriWorkspaces: []
    readonly property color colorDanger: "#f38ba8"
    readonly property color colorWarn: "#f9c74f"

    // Safe notification model fallback (handles API variations across Quickshell builds)
    readonly property var notifList: (typeof NotificationServer !== "undefined" && NotificationServer.notifications) 
        ? NotificationServer.notifications 
        : (typeof NotificationServer !== "undefined" ? NotificationServer.tracked : null)
    readonly property int notifCount: root.notifList ? (root.notifList.count !== undefined ? root.notifList.count : (root.notifList.length || 0)) : 0

    Component.onCompleted: NotificationServer.active = true

    // =========================================================================
    // COMMAND EXECUTION QUEUE (Fixes silent button/slider failures)
    // =========================================================================
    Process {
        id: shellExec
        property var cmdQueue: []

        function runCmd(commandArray) {
            if (running) {
                cmdQueue.push(commandArray);
            } else {
                command = commandArray;
                running = true;
            }
        }

        onRunningChanged: {
            if (!running && cmdQueue.length > 0) {
                command = cmdQueue.shift();
                running = true;
            }
        }
    }

    // Command Helpers
    function toggleMute() {
        shellExec.runCmd(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]);
        root.volumeMuted = !root.volumeMuted;
    }
    function toggleWifi() {
        var next = !root.wifiEnabled;
        root.wifiEnabled = next;
        shellExec.runCmd(["bash", "-c", "nmcli radio wifi " + (next ? "on" : "off")]);
    }
    function toggleBluetooth() {
        var next = !root.bluetoothEnabled;
        root.bluetoothEnabled = next;
        shellExec.runCmd(["bash", "-c", "bluetoothctl power " + (next ? "on" : "off")]);
    }
    function lockSession() { shellExec.runCmd(["swaylock", "-f"]); }
    function logoutSession() { shellExec.runCmd(["niri", "msg", "action", "quit", "--skip-confirmation"]); }
    function rebootSystem() { shellExec.runCmd(["systemctl", "reboot"]); }
    function shutdownSystem() { shellExec.runCmd(["systemctl", "poweroff"]); }
    
    function clearAllNotifications() {
        if (!root.notifList) return;
        var count = root.notifCount;
        for (var i = count - 1; i >= 0; i--) {
            var notif = root.notifList.get ? root.notifList.get(i) : root.notifList[i];
            if (notif && typeof notif.dismiss === "function") notif.dismiss();
        }
    }

    IpcHandler {
        target: "bar"
        function toggleControlCenter() { root.showControlCenter = !root.showControlCenter; }
    }

    // =========================================================================
    // BACKGROUND PROCESSES
    // =========================================================================
    function workspacesForOutput(outputName) {
        var result = [];
        var list = root.niriWorkspaces || [];
        for (var i = 0; i < list.length; i++) {
            if (list[i].output === outputName) result.push(list[i]);
        }
        result.sort(function (a, b) { return a.idx - b.idx; });
        return result;
    }

    function switchWorkspace(ws) {
        shellExec.runCmd(["bash", "-c",
            "niri msg action focus-monitor '" + ws.output + "' >/dev/null 2>&1; niri msg action focus-workspace " + ws.idx]);
    }

    Process {
        id: niriEventProc
        command: ["niri", "msg", "-j", "event-stream"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                try {
                    var evt = JSON.parse(data.trim());
                    if (evt.WorkspacesChanged) root.niriWorkspaces = evt.WorkspacesChanged.workspaces;
                    else if (evt.WorkspaceActivated || evt.WorkspaceUrgencyChanged || evt.WorkspaceActiveWindowChanged) {
                        niriInitProc.running = false; niriInitProc.running = true;
                    }
                } catch (e) {}
            }
        }
    }
    Process {
        id: niriInitProc
        command: ["bash", "-c", "niri msg -j workspaces | tr -d '\\n'"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                try { var parsed = JSON.parse(data); if (Array.isArray(parsed)) root.niriWorkspaces = parsed; } catch (e) {}
            }
        }
    }

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
    Timer { interval: 2000; running: true; repeat: true; onTriggered: statsProc.running = true }

    Process {
        id: getVolProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                var trimmed = data.trim();
                root.volumeMuted = trimmed.indexOf("MUTED") !== -1;
                var parts = trimmed.split(" ");
                if (parts.length >= 2) root.volumeVal = Math.round(parseFloat(parts[1]) * 100);
            }
        }
    }

    Process {
        id: getBrightnessProc
        command: ["brightnessctl", "-m"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                var parts = data.split(",");
                if (parts.length >= 4) root.brightnessVal = parseInt(parts[3].replace("%", "")) || 100;
            }
        }
    }

    Process { id: wifiStatusProc; command: ["bash", "-c", "nmcli -t -f WIFI g 2>/dev/null"]; stdout: SplitParser { onRead: data => { root.wifiEnabled = data.trim() === "enabled"; } } }
    Process { id: btStatusProc; command: ["bash", "-c", "bluetoothctl show 2>/dev/null | grep -q 'Powered: yes' && echo on || echo off"]; stdout: SplitParser { onRead: data => { root.bluetoothEnabled = data.trim() === "on"; } } }

    // =========================================================================
    // UI LAYOUT (Tide Island Dynamic Movement & Shapes)
    // =========================================================================
    Variants {
        model: Quickshell.screens

        Scope {
            required property var modelData

            // The persistent Top Bar window
            PanelWindow {
                id: barWindow
                screen: modelData
                WlrLayershell.exclusiveZone: Math.round(30 * root.s)
                anchors { top: true; left: true; right: true }
                implicitHeight: 40 * root.s
                color: "transparent"

                Rectangle {
                    id: topIsland
                    anchors.top: parent.top
                    anchors.topMargin: 4 * root.s
                    anchors.horizontalCenter: parent.horizontalCenter
                    implicitWidth: root.dynamicPillWidth
                    implicitHeight: 34 * root.s
                    
                    // Perfect pill shape
                    radius: 17 * root.s
                    
                    color: ThemeColors.background
                    border.color: ThemeColors.border
                    border.width: 1
                    
                    // Hide this island instantly when the CC morph overlay activates
                    opacity: root.showControlCenter ? 0 : 1

                    // TIDE PHYSICS: OutExpo gives that fluid, rapid-start but smooth-settling Dynamic Island feel
                    Behavior on implicitWidth { NumberAnimation { duration: 450; easing.type: Easing.OutExpo } }

                    RowLayout {
                        id: pillLayout
                        anchors.centerIn: parent
                        spacing: 14 * root.s
                        onImplicitWidthChanged: root.dynamicPillWidth = implicitWidth + (32 * root.s)

                        RowLayout {
                            spacing: 6 * root.s
                            Repeater {
                                model: root.workspacesForOutput(modelData.name)
                                delegate: Rectangle {
                                    id: wsDot
                                    required property var modelData
                                    property bool wsActive: modelData.is_active === true
                                    property bool wsFocused: modelData.is_focused === true
                                    
                                    implicitWidth: wsActive ? (wsLabel.implicitWidth + 16 * root.s) : 8 * root.s
                                    implicitHeight: 16 * root.s
                                    radius: 8 * root.s
                                    
                                    color: wsActive ? ThemeColors.primary : ThemeColors.surfaceContainer
                                    border.width: (wsFocused && !wsActive) ? 1 : 0
                                    border.color: ThemeColors.primary
                                    
                                    // TIDE PHYSICS: Workspace pills also slide/expand fluidly
                                    Behavior on implicitWidth { NumberAnimation { duration: 400; easing.type: Easing.OutExpo } }
                                    Behavior on color { ColorAnimation { duration: 200 } }

                                    Text {
                                        id: wsLabel
                                        anchors.centerIn: parent
                                        visible: wsDot.wsActive
                                        text: wsDot.modelData.idx
                                        color: ThemeColors.textOnPrimary
                                        font.pixelSize: Math.round(9 * root.s)
                                        font.bold: true
                                        opacity: wsDot.wsActive ? 1 : 0
                                        Behavior on opacity { NumberAnimation { duration: 250 } }
                                    }
                                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.switchWorkspace(wsDot.modelData) }
                                }
                            }
                        }

                        Rectangle { implicitWidth: 1; implicitHeight: 14 * root.s; color: ThemeColors.border }

                        RowLayout {
                            spacing: 10 * root.s
                            RowLayout {
                                spacing: 4 * root.s
                                IconGlyph { name: "cpu"; tint: ThemeColors.primary; implicitWidth: 12 * root.s; implicitHeight: 12 * root.s }
                                Text { text: root.cpuUsage + "%"; color: ThemeColors.primary; font.pixelSize: Math.round(11 * root.s); font.bold: true }
                            }
                            RowLayout {
                                spacing: 4 * root.s
                                IconGlyph { name: "memory"; tint: ThemeColors.text; implicitWidth: 12 * root.s; implicitHeight: 12 * root.s }
                                Text { text: root.ramUsage + "%"; color: ThemeColors.text; font.pixelSize: Math.round(11 * root.s); font.bold: true; opacity: 0.8 }
                            }
                        }

                        Rectangle { implicitWidth: 1; implicitHeight: 14 * root.s; color: ThemeColors.border }

                        Text {
                            id: clockText
                            color: ThemeColors.text
                            font.pixelSize: Math.round(12 * root.s)
                            font.bold: true
                            Timer { interval: 1000; running: true; repeat: true; triggeredOnStart: true; onTriggered: clockText.text = Qt.formatDateTime(new Date(), "hh:mm AP") }
                        }

                        Rectangle { implicitWidth: 1; implicitHeight: 14 * root.s; color: ThemeColors.border }

                        Rectangle {
                            implicitWidth: 26 * root.s; implicitHeight: 26 * root.s; radius: 13 * root.s
                            color: ThemeColors.surfaceContainer
                            IconGlyph { anchors.centerIn: parent; name: "sliders"; tint: ThemeColors.text; implicitWidth: 14 * root.s; implicitHeight: 14 * root.s }
                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.showControlCenter = true }
                        }
                    }
                }
            }
        }
    }

    // =========================================================================
    // THE MORPHING OVERLAY (Dynamic Island Expansion)
    // =========================================================================
    PanelWindow {
        id: overlayWindow
        visible: overlayRoot.opacity > 0
        color: "transparent"
        
        anchors { top: true; right: true; bottom: true; left: true }

        onVisibleChanged: {
            if (visible) { getVolProc.running = true; wifiStatusProc.running = true; btStatusProc.running = true; }
        }

        Item {
            id: overlayRoot
            anchors.fill: parent
            opacity: root.showControlCenter ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.InOutQuad } }

            // Dim background
            Rectangle {
                anchors.fill: parent
                color: "#40000000"
                opacity: root.showControlCenter ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 350; easing.type: Easing.OutExpo } }
                MouseArea { anchors.fill: parent; onClicked: root.showControlCenter = false }
            }

            // The Morph Card anchored directly to the top bar position
            Rectangle {
                id: morphCard
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 4 * root.s // Anchored to top bar position for smooth morphing

                // TIDE SHAPES: Morphs from Pill to a deeply rounded "Squircle"
                width: root.showControlCenter ? (360 * root.s) : root.dynamicPillWidth
                height: root.showControlCenter ? (560 * root.s) : (34 * root.s)
                radius: root.showControlCenter ? (32 * root.s) : (17 * root.s)
                
                // TIDE PHYSICS: Easing.OutExpo mimics spring physics smoothly
                Behavior on width { NumberAnimation { duration: 450; easing.type: Easing.OutExpo } }
                Behavior on height { NumberAnimation { duration: 450; easing.type: Easing.OutExpo } }
                Behavior on radius { NumberAnimation { duration: 450; easing.type: Easing.OutExpo } }

                color: ThemeColors.background
                border.color: ThemeColors.border
                border.width: 1
                clip: true

                MouseArea { anchors.fill: parent; onClicked: {} } // Prevent background click from closing

                // Control Center Content
                Item {
                    anchors.fill: parent
                    anchors.margins: 20 * root.s
                    
                    // Slightly slower fade in to allow the shape to expand *before* content fully appears
                    opacity: root.showControlCenter ? 1 : 0
                    Behavior on opacity { NumberAnimation { duration: 350; easing.type: Easing.InOutQuad } }

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 14 * root.s

                        RowLayout {
                            Layout.fillWidth: true
                            Text { text: "Control Center"; color: ThemeColors.text; font.bold: true; font.pixelSize: Math.round(16 * root.s); Layout.fillWidth: true }
                            IconGlyph {
                                name: "close"; tint: ThemeColors.text; implicitWidth: 13 * root.s; implicitHeight: 13 * root.s
                                MouseArea { anchors.fill: parent; anchors.margins: -6 * root.s; cursorShape: Qt.PointingHandCursor; onClicked: root.showControlCenter = false }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10 * root.s
                            ToggleChip { iconName: "wifi"; label: "Wi-Fi"; enabled_: root.wifiEnabled; uiScale: root.s; toggleAction: root.toggleWifi }
                            ToggleChip { iconName: "bluetooth"; label: "Bluetooth"; enabled_: root.bluetoothEnabled; uiScale: root.s; toggleAction: root.toggleBluetooth }
                            ToggleChip { iconName: "bell"; label: "Do Not Disturb"; enabled_: root.dndEnabled; uiScale: root.s; toggleAction: function () { root.dndEnabled = !root.dndEnabled; } }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: 36 * root.s
                            radius: 8 * root.s
                            color: ThemeColors.surfaceContainer
                            RowLayout {
                                anchors.centerIn: parent
                                spacing: 6 * root.s
                                IconGlyph { name: "wifi"; tint: ThemeColors.text; implicitWidth: 12 * root.s; implicitHeight: 12 * root.s }
                                Text { text: "Network Settings"; color: ThemeColors.text; font.bold: true; font.pixelSize: Math.round(11 * root.s) }
                            }
                            MouseArea { 
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: { 
                                    shellExec.runCmd([root.terminal, "-e", "nmtui"]); 
                                    root.showControlCenter = false; 
                                } 
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4 * root.s
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 8 * root.s
                                IconGlyph {
                                    name: root.volumeMuted ? "speaker-mute" : "speaker"; tint: ThemeColors.text; implicitWidth: 15 * root.s; implicitHeight: 15 * root.s
                                    MouseArea { anchors.fill: parent; anchors.margins: -4 * root.s; cursorShape: Qt.PointingHandCursor; onClicked: root.toggleMute() }
                                }
                                Text { text: "Volume  " + root.volumeVal + "%"; color: ThemeColors.text; font.pixelSize: Math.round(11 * root.s); Layout.fillWidth: true }
                            }
                            Slider {
                                Layout.fillWidth: true
                                from: 0; to: 100; stepSize: 1
                                value: root.volumeVal
                                onMoved: { root.volumeVal = Math.round(value); shellExec.runCmd(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", (value / 100.0).toFixed(2)]); }
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4 * root.s
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 8 * root.s
                                IconGlyph { name: "sun"; tint: ThemeColors.text; implicitWidth: 15 * root.s; implicitHeight: 15 * root.s }
                                Text { text: "Brightness  " + root.brightnessVal + "%"; color: ThemeColors.text; font.pixelSize: Math.round(11 * root.s); Layout.fillWidth: true }
                            }
                            Slider {
                                Layout.fillWidth: true
                                from: 5; to: 100; stepSize: 1
                                value: root.brightnessVal
                                onMoved: { root.brightnessVal = Math.round(value); shellExec.runCmd(["brightnessctl", "set", Math.round(value) + "%"]); }
                            }
                        }

                        Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: ThemeColors.border }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10 * root.s
                            PowerButton { Layout.fillWidth: true; iconName: "lock"; tint: ThemeColors.primary; uiScale: root.s; confirmAction: root.lockSession }
                            PowerButton { Layout.fillWidth: true; iconName: "logout"; tint: root.colorWarn; uiScale: root.s; confirmAction: root.logoutSession }
                            PowerButton { Layout.fillWidth: true; iconName: "restart"; tint: root.colorWarn; uiScale: root.s; confirmAction: root.rebootSystem }
                            PowerButton { Layout.fillWidth: true; iconName: "power"; tint: root.colorDanger; uiScale: root.s; confirmAction: root.shutdownSystem }
                        }

                        Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: ThemeColors.border }

                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: "Notifications" + (root.notifCount > 0 ? " (" + root.notifCount + ")" : "")
                                color: ThemeColors.text; font.bold: true; font.pixelSize: Math.round(14 * root.s); Layout.fillWidth: true
                            }
                            Text {
                                visible: root.notifCount > 0
                                text: "Clear all"; color: ThemeColors.primary; font.pixelSize: Math.round(10 * root.s); font.bold: true
                                MouseArea { anchors.fill: parent; anchors.margins: -6 * root.s; cursorShape: Qt.PointingHandCursor; onClicked: root.clearAllNotifications() }
                            }
                        }

                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 8 * root.s
                            model: root.notifList
                            delegate: Rectangle {
                                required property var modelData
                                width: ListView.view.width
                                implicitHeight: 54 * root.s
                                radius: 10 * root.s
                                color: ThemeColors.surfaceContainer
                                RowLayout {
                                    anchors.fill: parent; anchors.margins: 10 * root.s; spacing: 8 * root.s
                                    ColumnLayout {
                                        Layout.fillWidth: true; spacing: 2 * root.s
                                        Text { text: modelData ? (modelData.summary || "Notification") : ""; color: ThemeColors.text; font.bold: true; font.pixelSize: Math.round(12 * root.s); elide: Text.ElideRight; Layout.fillWidth: true }
                                        Text { text: modelData ? (modelData.body || "") : ""; color: ThemeColors.text; opacity: 0.7; font.pixelSize: Math.round(10 * root.s); elide: Text.ElideRight; Layout.fillWidth: true }
                                    }
                                    IconGlyph {
                                        name: "close"; tint: ThemeColors.text; implicitWidth: 11 * root.s; implicitHeight: 11 * root.s
                                        MouseArea { anchors.fill: parent; anchors.margins: -6 * root.s; cursorShape: Qt.PointingHandCursor; onClicked: if (modelData) modelData.dismiss() }
                                    }
                                }
                            }
                        }
                        Text {
                            visible: root.notifCount === 0
                            text: "No notifications"; color: ThemeColors.text; opacity: 0.5; font.pixelSize: Math.round(11 * root.s)
                            Layout.alignment: Qt.AlignHCenter; Layout.topMargin: 12 * root.s
                        }
                    }
                }
            }
        }
    }
}
