_: {
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ]; # Applies across all input devices
        extraArgs = [ ];
        settings = {
          main = {
            # Map the raw Gesture Button event to toggle the "workspace_layer"
            mouseforward = "toggle(workspace_layer)";
          };

          "workspace_layer" = {
            # While in workspace_layer, scrolling sends Super + J / Super + K
            mousewheelup = "M-k";
            mousewheeldown = "M-j";
          };
        };
      };
    };
  };
}
