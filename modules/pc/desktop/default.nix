{ loadModules, ... }:
{
  imports = loadModules ./.;
  hardware.graphics.enable = true;
  boot.kernelModules = [ "k10temp" "amdgpu" ];
}
