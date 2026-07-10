{ loadModules, ... }:
{
  imports = loadModules ./. + [ ../tower/services/adguard.nix];
  networking.hostName = "juniper";
}
