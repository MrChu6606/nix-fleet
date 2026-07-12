{ pkgs, config, ... }:let
  # grab the xone source from unstable and compile it against systems kernel
  unstableXone = config.boot.kernelPackages.xone.overrideAttrs (oldAttrs: {
    src = pkgs.unstable.linuxPackages.xone.src;
  });
in {
  programs.steam.enable = true;

  boot = {
    # explicitly add the unstable version kernel module to the boot list
    extraModulePackages = [ unstableXone ];
    kernelModules = [ "xone-dongle" ];
    # block the conflicting Wi-Fi drivers from hijacking the device
    blacklistedKernelModules = [ "mt76x2u" "mt76x2" "mt76" ];
  };

  # grab the unstable package and udev rules
  environment.systemPackages = [ unstableXone ];
  services.udev.packages = [ unstableXone ];
}
