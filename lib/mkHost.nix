{
  hostname,
  routing ? false,
  system,
  overlays ? [],
  modules,
  extraSpecialArgs ? {},
  pkgsInput
}: let
  fleetSettings = import ../fleet-settings.nix;
in
pkgsInput.lib.nixosSystem {
  inherit system modules;

  pkgs = import pkgsInput {
    inherit system overlays;
    config = {
      allowUnfree = true;
    };
  };

  specialArgs = {
    inherit hostname;

    fleetSettings =
      if routing == true
      then fleetSettings
      else fleetSettings.${hostname} or {};

    networkSettings = fleetSettings.network;

    loadModules =
      import ./load-modules.nix { inherit (pkgsInput) lib; };
  } // extraSpecialArgs;
}
