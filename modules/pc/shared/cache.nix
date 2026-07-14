_:{
  nix.settings = {
    # Keep trusted-users restricted to root
    trusted-users = [ "root" ];

    # Globally allow these caches so any user can pull from them safely
    substituters = [
      "https://cache.nixos.org" # Default
      "https://nix-community.cachix.org"
      "https://raspberry-pi-nix.cachix.org"
    ];

    # Explicitly trust the corresponding public keys
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" # Default
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "raspberry-pi-nix.cachix.org-1:WmV2rdSangxW0rZjY/tBvBDSaNFQ3DyEQsVw8EvHn9o="
    ];
  };
}
