{
  hostname,
  routing ? false,
  system,
  overlays ? [],
  cudaSupport ? false,
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
    # does this work? no
    # stdenv.hostPlatform.system = system;
    config = {
      inherit cudaSupport;
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
