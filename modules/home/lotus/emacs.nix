{ pkgs, ... }: {

  # Install Emacs using unstable overlay
  programs.emacs = {
    enable = true;
    package = pkgs.unstable.emacs; 
  };

  # Dependencies that Doom Emacs needs to function/compile packages
  home.packages = with pkgs; [
    git
    ripgrep
    fd
    coreutils
    clang 
  ];

  # Add Doom's binary folder to PATH automatically
  home.sessionPath = [ "$HOME/.config/emacs/bin" ];

  # Declaratively generate Doom configuration files
  home.file.".config/doom/init.el".text = ''
    (doom! :input
           :completion
           ivy               ; a search engine for love and life

           :ui
           doom              ; what makes it look like doom
           doom-dashboard    ; a nifty welcome screen
           modeline          ; a snazzy status bar

           :editor
           (evil +everywhere); enable evil mode everywhere!

           :emacs
           dired             ; making dired pretty

           :lang
           emacs-lisp        ; drown in parentheses
           org               ; organize plain text life

           :config
           default)
  '';

  home.file.".config/doom/config.el".text = ''
    ;; Place private configuration here!
    (setq display-line-numbers-type t)
  '';

  home.file.".config/doom/packages.el".text = ''
    ;; -*- no-byte-compile: t; -*-
    ;; Place custom packages here!
  '';
}
