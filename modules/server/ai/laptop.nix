_: {
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
  };

  powerManagement.powertop.enable = true;

  services.upower.enable = true;

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };
}
