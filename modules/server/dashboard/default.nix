{ loadModules, lib, ... }:
{
  imports = loadModules ./.;
  networking.hostName = "rowan";

  raspberry-pi-nix = {
    board = "bcm2712";
  };

  boot.loader.generic-extlinux-compatible.enable = lib.mkForce false;
}
