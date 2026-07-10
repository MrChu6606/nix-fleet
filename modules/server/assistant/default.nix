{ loadModules, ... }:
{
  imports = loadModules ./. + [ ../tower/services/adguard.nix];
  networking.hostname = "juniper";
}
