_: {
  security = {
    pam.services.swaylock = {};
    polkit.enable = true;
  };
  services.upower.enable = true;
}
