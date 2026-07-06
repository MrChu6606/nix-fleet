{ pkgs, ... }: {
  programs = {
    gamescope.enable = true;
    monique.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];
}
