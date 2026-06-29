{
  pkgs,
  nvfFN,
  zenPkg,
  ...
}: let
  stable = with pkgs; [

  ];

  unstable = with pkgs.unstable; [

  ];
  
  nvfPkg = nvfFN pkgs.unstable;
in {
  environment.systemPackages = stable ++ unstable ++ [ nvfPkg zenPkg ];

  services.flatpak = {
    enable = true;

    remotes = [
      {
        name = "flathub";
        location = "https://f;athub.org/repo/flathub.flatpakrepo";
      }
    ];
  };
}
