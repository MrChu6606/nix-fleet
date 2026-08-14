{ loadModules, ... }:
{
  imports = loadModules ./. ++ [../pis/default.nix];
}
