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
      hash = "sha256-sciSMgaz+XHO2b+PN+cC5Z43ugdZO1fv+/mzH/3HBGM=";
    };

    # Force Nix to ignore repos vendor folder
    proxyVendor = true;
    vendorHash = "sha256-KKvov6jGRfKkvPUk/CZ49XaGQ1ariN6NPiR3kKxOCxM=";
  };
in
{
  # Add Kairo to system packages
  environment.systemPackages = [ kairo ];
}
