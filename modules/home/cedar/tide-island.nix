{ pkgs, ... }: let
  tide-island = import ../../../pkgs/tide-island.nix { inherit pkgs; };
in {
  home.packages = with pkgs; [
    tide-island
    awww
  ];

  # awww service (integrates with Tide-island's built-in wallpaper picker)
  systemd.user.services = {
    awww = {
      Unit = {
        Description = "Awww Wallpaper Daemon";
        Documentation = [ "https://github.com/Horus645/awww" ];
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.awww}/bin/awww-daemon";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # tide-island service
    tide-island = {
      Unit = {
        Description = "Tide Island Shell / Dynamic Bar";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${tide-island}/bin/tide-island";
        Restart = "on-failure";
        Environment = [ "TIDE_ISLAND_COMPOSITOR=niri" ];
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
