{ config, lib, ... }: {
  sops = {

    # Extract the tailscale key
    secrets = {
      tailscale_key = {
        sopsFile = ../../secrets/global.yaml;
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
