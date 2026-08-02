pragma Singleton
import QtQuick

QtObject {
    readonly property color background: "{{colors.surface.default.hex}}"
    readonly property color surfaceContainer: "{{colors.surface_container.default.hex}}"
    readonly property color primary: "{{colors.primary.default.hex}}"
    readonly property color onPrimary: "{{colors.on_primary.default.hex}}"
    readonly property color text: "{{colors.on_surface.default.hex}}"
    readonly property color border: "{{colors.outline.default.hex}}"
}
'';
