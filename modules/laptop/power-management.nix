{
  config,
  pkgs,
  lib,
  ...
}: {
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
    HandlePowerKey = "ignore";
  };

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.thermald.enable = true;
}
