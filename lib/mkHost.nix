{ 
  system, 
  overlays ? [], 
  modules, 
  extraSpecialArgs ? {},
  pkgsInput
}:

pkgsInput.lib.nixosSystem {
  inherit system modules;

  pkgs = import pkgsInput {
      inherit system overlays;
      config = { allowUnfree = true; };
  };

  specialArgs = {
      loadModules = 
          import ./load-modules.nix {inherit (pkgsInput) lib; };
  } // extraSpecialArgs;
}
