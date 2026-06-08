{ pkgs, ... }: {
  users.users.nic = {
    isNormalUser = true;
    description = "nic";
    extraGroups = [ "wheel" "dialout" ];
    shell = pkgs.zsh;
  };
}
