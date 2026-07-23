{ pkgs, ... }: {
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      hplip
      hplipWithPlugin
    ];
  };
  # gui for printing
  programs.system-config-printer.enable = true;
}
