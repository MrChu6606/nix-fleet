_: {
  users.users.nic = {
    extraGroups = [ "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKwVDpKO0Stfm4abOjFjSBT0LbVJdwJJsqp7iOc9mzMI"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHu4MMLoTG4QET3RbY5tvJrtWDO0tN+58NH/OVZ5b3mo"
    ];
  };

  nix.settings.trusted-users = [ "root" "nic" ];
}
