final: prev: {
# Fix sops-nix demanding buildGo125Module on older nixpkgs pins
  buildGo125Module = final.buildGo123Module or final.buildGoModule;
}
