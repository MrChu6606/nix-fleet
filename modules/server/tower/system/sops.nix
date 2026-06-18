{ config, lib, ... }: {
  sops = {
    # Point to tower secrets file relative to this module
    defaultSopsFile = ../../../../secrets/tower.yaml;
    defaultSopsFormat = "yaml";

    # extract the secrets
    secrets = {
      grafana_env = {
        owner = "grafana";
        group = "grafana";
      };
    };

    age = {
      keyFile = if config.networking.hostName == "lotus"
                  then "/home/nic/.config/sops/age/keys.txt"
                  else "/var/lib/sops-nix/key.txt";
      sshKeyPaths = lib.optionals (config.networking.hostName != "lotus") [ 
        "/etc/ssh/ssh_host_ed25519_key" 
      ];

      generateKey = if config.networking.hostName == "lotus" then false else true;
    };

    
  };
}
