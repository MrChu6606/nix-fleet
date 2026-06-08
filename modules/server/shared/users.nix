_: {
  users.users.nic = {
    isNormalUser = true;
    description = "nic";
    extraGroups = [ "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKwVDpKO0Stfm4abOjFjSBT0LbVJdwJJsqp7iOc9mzMI"
    ];
  };

  nix.settings.trusted-users = [ "root" "nic" ];
}
