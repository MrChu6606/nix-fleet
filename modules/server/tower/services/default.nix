{ loadModules, ... }:
{
    imports = [
      ./hypermind.nix
      ./minecraft.nix
      ./monitoring.nix
      ./nginx.nix
      ./searxng-box.nix
      ./music.nix
    ];
}
