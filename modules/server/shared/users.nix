_: {
  users.users.nic = {
    extraGroups = [ "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKwVDpKO0Stfm4abOjFjSBT0LbVJdwJJsqp7iOc9mzMI"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHu4MMLoTG4QET3RbY5tvJrtWDO0tN+58NH/OVZ5b3mo"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMImsuLVN/U9zBaMFNKNqVP5AtMu9UEDM+xxhHk21anNAAAADXNzaDpuaXgtZmxlZXQ="
    ];
  };

  nix.settings.trusted-users = [ "root" "nic" ];
}
