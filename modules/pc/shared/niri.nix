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
        default = [ "gnome gtk "]; # fallbacks
        "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
      };
    };

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-termfilechooser
    ];
  };
  
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];
}
