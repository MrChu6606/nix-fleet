{ pkgs, ... }:

let

  buildGoModule = pkgs.buildGoModule.override {
    # Specify the go package needed for this project
    go = pkgs.go_1_26;
  };

  kairo = buildGoModule {
    pname = "kairo";
    version = "unstable-2026-05-05";


    src = pkgs.fetchFromGitHub {
      owner = "programmersd21";
      repo = "kairo";
      rev = "main";
      hash = "sha256-1ojhSonWu6AdX+Tj8wO6vGFOzjld3Vp5cW8RS0iwbWc=";
    };

    # Force Nix to ignore repos vendor folder
    proxyVendor = true;
    vendorHash = "sha256-yEgPXAWkSgLCPhvAfZ7PkT9G7rJzeIXJIWVfdQ+Di5g=";
  };
in
{
  # Add Kairo to system packages
  environment.systemPackages = [ kairo ];
}
