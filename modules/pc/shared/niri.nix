{ pkgs, ... }: {
  programs = {
    gamescope.enable = true;
    monique.enable = true;
  };

  xdg.portal = {
    enable = true;
    configPackages = [ pkgs.niri ];

    config = {
      niri = {
        "org.freedesktop.impl.portal.FileChooser" = [
          "termfilechooser"
          "gnome"
          "gtk"
        ];
      };
    };

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-termfilechooser
      xdg-desktop-portal-gnome # Handles Nautilus file picker delegation
    ];
  };
  
  environment.systemPackages = with pkgs; [
    xwayland-satellite
    nautilus # Required for xdg-desktop-portal-gnome to launch the file chooser
  ];
}
