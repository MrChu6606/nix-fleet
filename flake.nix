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

    nixflix = {
            url = "github:kiriwalawren/nixflix";
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
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    nvf,
    zen-browser,
    nix-flatpak,
    silentSDDM,
    nixflix,
    sops-nix,
    disko,
    ...
  }: let

    # a function for creating nvf
    nvfFN = systemPkgs: 
      (nvf.lib.neovimConfiguration {
        pkgs = systemPkgs;
        modules = [./nvf/nvf-configuration.nix];
      }).neovim;


    mkHost = import ./lib/mkHost.nix { inherit nixpkgs; };

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
          ./modules/server
          nixflix.nixosModules.default
          sops-nix.nixosModules.default
          disko.nixosModules.default
        ];
        overlays = [
          (import ./overlays/unstable.nix { inherit nixpkgs-unstable; } )
        ];
        extraSpecialArgs = { inherit nvfFN; };
      };

      juniper = mkHost {
        system = "aarch64-linux";
        modules = [
          ./modules/shared
          ./modules/pi
        ];
        extraSpecialArgs = { inherit nvfFN; };
      };
    };
  };
}
