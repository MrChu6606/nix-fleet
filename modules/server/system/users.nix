{ pkgs, ... }: {
  users.users.nic = {
    isNormalUser = true;
    description = "nic";
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
  };
}
