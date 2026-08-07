{ loadModules, lib, pkgs, ... }:
{
  imports = loadModules ./. ++ [../pis/default.nix];

  boot = {
    loader.generic-extlinux-compatible.enable = lib.mkForce false;
    initrd.availableKernelModules = pkgs.lib.mkForce [
      # Standard RPi modules needed to boot
      "vfat"
      "ext4"
      "sd_mod"
      "bcm2835_dma"
      "i2c_bcm2835"
      "pcie_brcmstb" # Needed for RPi 4/5 PCIe/USB controllers
    ];    
  };
}
