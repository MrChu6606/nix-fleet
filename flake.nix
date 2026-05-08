{
  description = "My NixOS system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    silentSDDM = {
      url="github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixpkgs-unstable,
    nvf,
    zen-browser,
    nix-flatpak,
    ...
  }: let
    system = "x86_64-linux";

    # pkgs nixosSystem uses
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };

      overlays = [
        (import ./overlays/flameshot.nix)
        (import ./overlays/qutebrowser.nix)
        (import ./overlays/steam.nix)
      ];
    };

    # unstable nixpkgs
    unstablePkgs = import nixpkgs-unstable {
      inherit system;
    };

    # pass nvf as part of the system packages
    nvfPkg =
      (nvf.lib.neovimConfiguration {
        pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
        modules = [./nvf/nvf-configuration.nix];
      }).neovim;

    # Here I extract the package and pass that as an input to packages.nix
    zenPkg = zen-browser.packages.${system}.default;

    # Here instead of doing that i import sddm from inputs directly in greeter.nix
    #silentSDDM = silentSDDMFlake.packages.${system}.default;

    # Search modules directory and add .nix files to a list called mods
    lib = nixpkgs.lib;
    loadModules = import ./.lib/load-modules.nix { inherit lib; };
    sharedMods = loadModules ./modules/shared;


  in {
    # I think this line adds the packages to my system
    packages.${system} = {
      nvf = nvfPkg;
      zen = zenPkg;
    };

    # both profiles have sharedMods concatinated to modules list
    nixosConfigurations = {
      #laptop profile loads zen and calls loadModules on laptop directory
      lotus = nixpkgs.lib.nixosSystem {
        inherit system pkgs;

        specialArgs = { inherit inputs; };

        modules = sharedMods ++ loadModules ./modules/laptop ++
          [
          nix-flatpak.nixosModules.nix-flatpak
          {
            _module.args = {inherit unstablePkgs nvfPkg zenPkg;};
          }
        ];
      };

      sequoia = nixpkgs.lib.nixosSystem {
        inherit system pkgs;

        modules = sharedMods ++ loadModules ./modules/server ++
          [
          {
            _module.args = {inherit unstablePkgs nvfPkg;};
          }
        ];
      };
    };
  };
}
