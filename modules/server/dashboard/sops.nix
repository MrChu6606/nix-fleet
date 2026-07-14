{ pkgs, ... }: {
  sops = {
    package = pkgs.sops;
    sops.validationPackage = pkgs.sops;
  };
}
