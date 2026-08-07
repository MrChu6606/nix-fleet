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

  # Enable Podman
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    dockerCompat = true;
  };

  # Configure storage graphroot (where Podman stores images/layers)
  virtualisation.containers.storage.settings = {
    storage = {
      driver = "overlay";
      graphroot = "/appdata/podman/storage";
      runroot = "/run/containers/storage";
    };
  };

  security.sudo.wheelNeedsPassword = false;
}
