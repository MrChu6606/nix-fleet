{ config, pkgs, lib, ... }:

{
  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
    noto-fonts-color-emoji
    papirus-icon-theme
    adwaita-icon-theme
    noto-fonts-cjk-sans
    corefonts
  ];
}
