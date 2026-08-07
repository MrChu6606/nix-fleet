{ config, lib, modulesPath, ... }: {
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "nvme" "usb_storage" "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # 1. Root mapped to 16GB of RAM (adjust size as needed)
  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=16G" "mode=755" ];
  };

  # 2. Existing ext4 root drive reassigned to /persist
  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/d0555a94-cf8f-4d6d-8cff-45ec4ee57abf";
    fsType = "ext4";
    neededForBoot = true; # CRITICAL: ensures /persist mounts in stage 1 before bind mounts
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B41B-EF9A";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
