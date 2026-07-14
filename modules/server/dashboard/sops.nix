{ pkgs, sops-nix, ... }: {
  # Pull the correct architectures straight out of the modern sops-nix flake output
  sops.package = sops-nix.packages.${pkgs.stdenv.hostPlatform.system}.sops-install-secrets;
  sops.validationPackage = sops-nix.packages.${pkgs.stdenv.buildPlatform.system}.sops-install-secrets;
}
