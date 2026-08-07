{
  description = "Java Coursework Dev Environment (assumes vscode)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv";
  };

  outputs = { self, nixpkgs, devenv, ... } @ inputs:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSystem = f: nixpkgs.lib.genAttrs systems (system: f {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      });
    in
    {
      devShells = forEachSystem ({ pkgs }: {
        default = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [
            ./devenv.nix
          ];
        };
      });
    };
}
