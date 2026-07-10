{ lib, loadModules, modulesPath, ...}: {
  imports = loadModules ./. ++ [ (modulesPath + "/installer/scan/not-detected.nix")];

  sdImage.compressImage = false;
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  boot.initrd.availableKernelModules = [ "xhci_pci" "uas" ];
}
