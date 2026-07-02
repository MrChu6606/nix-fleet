{ pkgs, ... }: {
  # Enables direnv
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Sets kernel to zen kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Configure boot menu
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # enable binfmt with qemu for building aarch64 images
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  swapDevices = [
  {
      device = "/swapfile";
      size = 8 * 1024;
  }
  ];

}
