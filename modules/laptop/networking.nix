{
  config,
  pkgs,
  lib,
  ...
}: {
  networking.hostName = "lotus";
  networking.networkmanager.enable = true;
  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
    usbmon.enable =true;
  };
}
