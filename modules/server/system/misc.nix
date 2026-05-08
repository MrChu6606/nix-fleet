{ ... }: {
  # Enable flakes and nix shell
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Configure boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/New_York";

  # Set automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-generations +5";
  };

  # Setup automatic optimization for de duplication
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "weekly" ];

  # Set neovim as default editor
  environment.variables.EDITOR = "nvim";

  # Enable docker
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      data-root = "/mnt/appdata/docker";
    };
  };

  system.stateVersion = "25.11";
}
