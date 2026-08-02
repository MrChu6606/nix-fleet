{ pkgs, ... }: let
  tide-island = pkgs.callPackage ./pkgs/tide-island.nix { };
in {
  # Add it to your installed packages
  home.packages = [
    tide-island
  ];

  systemd.user.services.tide-island = {
    Unit = {
      Description = "Tide Island Dynamic Island";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${tide-island}/bin/tide-island";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session-pre.target" "graphical-session.target" ];
    };
  };
}
