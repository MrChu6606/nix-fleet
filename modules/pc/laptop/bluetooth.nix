_: {
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = {
    General.Experimental = true;
    Policy.AutoEnable = true;
  };

  services.blueman.enable = true;
}
