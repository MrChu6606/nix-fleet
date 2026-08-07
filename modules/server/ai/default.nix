{ loadModules, ... }: {
  imports = loadModules ./. ++ [../shared];
  
  mySystem.networking = {
    enable = true;
    enableStaticInterfaces = true;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

}
