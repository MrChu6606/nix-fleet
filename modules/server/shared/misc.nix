{ pkgs, ... }: {

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

  # wake on lan
  networking = {
    interfaces = {
      eno1.wakeOnLan.enable = true;
    };
    firewall.allowedUDPPorts = [ 9 ];
  };

  environment.systemPackages = with pkgs; [
    wakeonlan
  ];
}
