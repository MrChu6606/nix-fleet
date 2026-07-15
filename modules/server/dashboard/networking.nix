{ lib, ... }: {
  # Force-disable the settings attribute so the older nixpkgs doesn't panic
  services.resolved.settings = lib.mkForce {};
              
  services.resolved.extraConfig = ''
    MultiCastDNS=yes
  '';
}
