{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      papirus-icon-theme
      adwaita-icon-theme
      corefonts
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {

        monospace = [ "FiraCode Nerd Font" ];

        sansSerif = [ "FiraCode Nerd Font" "Noto Sans CJK JP" ];

        serif = [ "FiraCode Nerd Font" "Noto Serif" ];

        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
