{
  pkgs,
  ...
}: {
    # Enables flakes and nix shell
    nix.settings.experimental-features = ["nix-command" "flakes"];

    # Enables direnv
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;

    # Sets kernel to zen kernel
    boot.kernelPackages = pkgs.linuxPackages_zen;

    # Enables fwupd to flash update bios
    services.fwupd.enable = true;

    # Configure boot menu
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    time.timeZone = "America/New_York";

    services.tailscale.enable = true;
    programs.steam.enable = true;

    # Setup automatic garbage collection
    nix.gc = {
        automatic = false;
        dates = "weekly";
        options = "--delete-generations +5";
    };

    # Setup automatic optimization for de duplication
    nix.optimise.automatic = false;
    nix.optimise.dates = [ "weekly" ];

# Sets default editor
    environment.variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
    };

    xdg.portal.enable = true;

    swapDevices = [
    {
        device = "/swapfile";
        size = 8 * 1024;
    }
    ];

    system.stateVersion = "25.05";
}
