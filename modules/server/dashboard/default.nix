{ loadModules, ... }:
{
  imports = loadModules ./.;
  networking.hostName = "rowan";
}
