{
  description = "My NixOS system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    silentSDDM = {
      url="github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    monique = {
      url = "github:ToRvaLDz/monique";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nvf,
    home-manager,
    zen-browser,
    nix-flatpak,
    silentSDDM,
    niri,
    monique,
    sops-nix,
    disko,
    arion,
    ...
  }: let

    # a function for creating nvf
    nvfFN = systemPkgs: 
      (nvf.lib.neovimConfiguration {
        pkgs = systemPkgs;
        modules = [./nvf/nvf-configuration.nix];
      }).neovim;

    mkHost = import ./lib/mkHost.nix { inherit nixpkgs; };

    fleetSettings = import ./fleet-seetings.nix;

  in {
    nixosConfigurations = {

      lotus = mkHost {
        system = "x86_64-linux";
        overlays = [
            (import ./overlays/flameshot.nix)
            (import ./overlays/qutebrowser.nix)
            (import ./overlays/steam.nix)
            (import ./overlays/unstable.nix { inherit nixpkgs-unstable; } )
        ];
        modules = [
          ./modules/pc/laptop
          ./modules/pc/shared
          ./modules/shared
          nix-flatpak.nixosModules.nix-flatpak
          silentSDDM.nixosModules.default
          sops-nix.nixosModules.default
          monique.nixosModules.default
        ];
        extraSpecialArgs = { 
          inherit nvfFN;
          zenPkg = zen-browser.packages."x86_64-linux".default;
        };
      };

      cedar = mkHost {
        system = "x86_64-linux";
        overlays = [
          (import ./overlays/steam.nix)
          (import ./overlays/unstable.nix { inherit nixpkgs-unstable; } )
        ];
        modules = [
          ./modules/shared
          ./modules/pc/shared
          ./modules/pc/desktop
          nix-flatpak.nixosModules.nix-flatpak
          sops-nix.nixosModules.default
          monique.nixosModules.default
        ];
        extraSpecialArgs = { 
          inherit nvfFN;
          zenPkg = zen-browser.packages."x86_64-linux".default;
        };
      };

      sequoia = mkHost {
        system = "x86_64-linux";
        modules = [
          ./modules/shared
          ./modules/server/tower
          ./modules/server/shared
          sops-nix.nixosModules.default
          disko.nixosModules.default
          arion.nixosModules.arion
        ];
        overlays = [
          (import ./overlays/unstable.nix { inherit nixpkgs-unstable; } )
        ];
        extraSpecialArgs = { inherit fleetSettings; };
      };

      juniper = mkHost {
        system = "aarch64-linux";
        modules = [
          ./modules/shared
          ./modules/server/pi
          ./modules/server/shared
          disko.nixosModules.default
          sops-nix.nixosModules.default

          # makes it so can build sd images
          ({ modulesPath, ... }: {
            imports = [
              "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
            ];
          })
        ];
        extraSpecialArgs = { inherit fleetSettings; };
      };

      
    };

    homeConfigurations = {
      "nic@lotus" = home-manager.lib.homeManagerConfiguration {
        pkgs = self.nixosConfigurations.lotus.pkgs;
        modules = [
          # Point this directly to your user's home manager profile
          ./modules/home/lotus
          ./modules/home/shared
          niri.homeModules.niri
        ];

        extraSpecialArgs = {
          inherit nvfFN;
          zenPkg = zen-browser.packages."x86_64-linux".default;
        };
      };
      "nic@cedar" = home-manager.lib.homeManagerConfiguration {
        pkgs = self.nixosConfigurations.lotus.pkgs;
        modules = [
          ./modules/home/shared
        ];

        extraSpecialArgs = {
          inherit nvfFN;
          zenPkg = zen-browser.packages."x86_64-linux".default;
        };
      };
    };
  };
}
