_: {

  # Set automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-generations +5";
  };

  # Setup automatic optimization for de duplication
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "weekly" ];

  # Enable docker
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      data-root = "/appdata/docker";
    };
  };

  security.sudo.wheelNeedsPassword = false;
}
