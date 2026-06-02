{ pkgs, ... }: {
  users.users.nic = {
    isNormalUser = true;
    description = "nic";
    extraGroups = ["wheel" "docker" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKwVDpKO0Stfm4abOjFjSBT0LbVJdwJJsqp7iOc9mzMI"
    ];
  };

  nix.settings.trusted-users = [ "root" "nic" ];
}
