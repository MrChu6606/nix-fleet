{ lib, loadModules, modulesPath, ...}: {
  imports = loadModules ./. + [ (modulesPath + "/installer/scan/not-detected.nix")];

  # configure pi bootloader
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.loader.grub.enable = lib.mkForce false;

  # configure pi hardware settings

  boot.initrd.availableKernelModules = [ "xhci_pci" "uas" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
