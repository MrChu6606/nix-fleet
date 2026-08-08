{ config, lib, modulesPath, ... }: {
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "nvme" "usb_storage" "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Supermicro ASPEED BMC framebuffer fixes to prevent display crashes
  boot.kernelParams = [
    "console=tty0"
    "panic=10"
    "nomodeset"
    "video=efifb:off"
    "initcall_blacklist=sysfb_init"
  ];

  # Root mapped to RAM (tmpfs)
  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "defaults" "size=16G" "mode=755" ];
  };

  # Ext4 root drive mapped to /persist using label
  fileSystems."/persist" = {
    device = "/dev/disk/by-label/persist";
    fsType = "ext4";
    neededForBoot = true; # CRITICAL: ensures /persist mounts in stage 1
  };

  # Persistent Nix Store bind-mounted from /persist
  fileSystems."/nix" = {
    device = "/persist/nix";
    fsType = "none";
    options = [ "bind" ];
    neededForBoot = true;
  };

  # EFI Boot Partition using label
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
