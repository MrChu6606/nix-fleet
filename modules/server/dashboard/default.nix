{ loadModules, ... }:
{
  imports = loadModules ./.;
  networking.hostName = "rowan";

  raspberry-pi = {
    enable = true;
    board = "bcm2712";
  };
}
