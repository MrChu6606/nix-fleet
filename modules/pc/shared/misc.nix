{ pkgs, ... }: {
  # Sets kernel to zen kernel
  boot.kernelPackages = pkgs.linuxPackagaes_zen;

}
