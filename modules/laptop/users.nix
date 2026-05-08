{
  config,
  pkgs,
  lib,
  ...
}: {
  users.users.nic = {
    isNormalUser = true;
    description = "nic";
    extraGroups = ["networkmanager" "wheel" "libvirtd" "kvm" "cdrom" "optical" "wireshark"];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };
}
