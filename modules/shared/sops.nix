{ config, lib, ... }: {
  sops = {
    # Point to your global secrets file relative to this module
    defaultSopsFile = ../../secrets/global.yaml;
    defaultSopsFormat = "yaml";

    # Extract the tailscale key
    secrets = {
      tailscale_key = { };
    };

    age.keyFile = if config.networking.hostName == "lotus"
                  then "/home/nic/.config/sops/age/keys.txt"
                  else "/var/lib/sops-nix/key.txt";

    # Only look for SSH keys if we are on a headless server node
    gnupg.sshKeyPaths = lib.optionals (config.networking.hostName != "lotus") [ 
      "/etc/ssh/ssh_host_ed25519_key" 
    ];
  };
}
