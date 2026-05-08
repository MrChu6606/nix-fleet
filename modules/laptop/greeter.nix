{ inputs, ... }:
{
    imports = [inputs.silentSDDM.nixosModules.default];

    services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
    };

    programs.silentSDDM = {
        enable = true;
        theme = "default";
        settings = {
            Background = { Mode = "cover"; };
            General = { GreeterEnvironment = "QT_SCALE_FACTOR=1"; };
            Wayland = {
                PrimaryDisplay = "eDP-1";
                EnabledHiDPI = true;
            };
        };
    };
}
