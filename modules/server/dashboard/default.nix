{ loadModules, ... }:
{
  imports = loadModules ./.;
  networking.hostname = "rowan";
}
