{
  config,
  pkgs,
  lib,
  ...
}: {
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = {
    General.Experimental = true;
    Policy.AutoEnable = true;
  };
  # Enable support for xbox controllers
  # doesnt seem to work on latest linux kernel
  #hardware.xone.enable = true;

  services.blueman.enable = true;
}
