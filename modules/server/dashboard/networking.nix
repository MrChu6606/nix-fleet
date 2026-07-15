{ lib, ... }: {
  # Force-disable the settings attribute so the older nixpkgs doesn't panic
  options.services.resolved.settings = lib.mkOption {
    type = lib.types.anything;
    default = {};
    description = "Dummy option to prevent older nixpkgs from crashing on shared config";
  };           

  services.resolved.extraConfig = ''
    MultiCastDNS=yes
  '';
}
