{ home-manager }:
target:
{
  pkgs,
  modules ? [],
  extraSpecialArgs ? {},
}:
let
  parsed = pkgs.lib.splitString "@" target;
  username = builtins.elemAt parsed 0;
  hostname = builtins.elemAt parsed 1;
in
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = modules ++ [
    {
      home.username = username;
      home.homeDirectory = "/home/${username}";
    }
  ];
  extraSpecialArgs = {
    inherit hostname username;

    loadModules = import ./load-modules.nix { inherit (pkgs) lib; };
  } // extraSpecialArgs;
}
