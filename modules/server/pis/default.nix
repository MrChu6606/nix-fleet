{ lib, loadModules, modulesPath, ...}: {
  imports = (loadModules ./.) ++ [ (modulesPath + "/installer/scan/not-detected.nix")] ++ [ ../shared ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  boot.initrd.availableKernelModules = [ "xhci_pci" "uas" ];

  mySystem.networking = {
    enable = true;
    enableStaticInterfaces = true;
  };
}
