{ pkgs, ... }: let
  # this is the HM module, it still has some quirks
  tide-island = pkgs.callPackage ../../../pkgs/tide-island.nix { };
in {
  # Add it to your installed packages
  home.packages = [
    tide-island
    pkgs.awww
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

  xdg.desktopEntries.tide-island-config-app = {
    name = "Tide Island Settings";
    comment = "Configuration for Tide Island Shell";
    exec = "tide-island-config-app";
    icon = "preferences-system";
    terminal = false;
    categories = [ "Settings" "DesktopSettings" ];
  };
}
