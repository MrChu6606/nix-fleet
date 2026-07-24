{ pkgs, hostname, ... }: {
  # Enables flakes and nix shell
  nix.settings.experimental-features = ["nix-command" "flakes"];

  time.timeZone = "America/New_York";

  # Sets default editor
  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = [ pkgs.neovim ];
  };

  networking.hostName = hostname;

  system.stateVersion = "25.05";
}
