{ pkgs, ... }: {
  # Sets kernel to zen kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

}
