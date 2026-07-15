{ lib, loadModules, modulesPath, ...}: {
  imports = (loadModules ./.) ++ [ (modulesPath + "/installer/scan/not-detected.nix")];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  boot.initrd.availableKernelModules = [ "xhci_pci" "uas" ];
}
