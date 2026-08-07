{ loadModules, ... }:
{
  imports = loadModules ./. ++ [ ../../shared/default.nix ];
  
  mySystem.networking.enable = true;
}
