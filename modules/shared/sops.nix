{ config, lib, ... }: let
  adminList = [ "lotus" "cedar" ];
in {
  sops = {

    # Extract the tailscale key
    secrets = {
      tailscale_key = {
        sopsFile = ../../secrets/global.yaml;
      };
    };

    age = {
      keyFile = if builtins.elem config.networking.hostName adminList
        then "/home/nic/.config/sops/age/keys.txt"
        else "/var/lib/sops-nix/key.txt";
      sshKeyPaths = lib.optionals (!(builtins.elem config.networking.hostName adminList)) [ 
        "/etc/ssh/ssh_host_ed25519_key" 
      ];

      generateKey = !(builtins.elem config.networking.hostName adminList);
    };
  };
}
