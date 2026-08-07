{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    
    # Base extensions you want across ALL projects
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      mkhl.direnv
    ];

    # Global Vim & Editor Preferences
    userSettings = {
      "vim.enable" = true;
      "vim.useSystemClipboard" = true;
      "vim.leader" = "<space>";
      "workbench.colorTheme" = "Default Dark Modern";
      "direnv.status.show" = "warning";
    };
  };
}
