{ config, lib, ... }: let
  adminList = [ "lotus" "cedar" ];
in {
  sops = {

    defaultSopsFile = ../../secrets/global.yaml;

    # Extract the tailscale key
    secrets = {
      tailscale_key = { };
    };

    age = {
      keyFile = if builtins.elem config.networking.hostName adminList
        then "/home/nic/.config/sops/age/keys.txt"
        else "/var/lib/sops-nix/key.txt";

      sshKeyPaths = lib.optionals (!(builtins.elem config.networking.hostName adminList)) (
        # Use the persistent path on impermanent hosts like sequoia
        if config.networking.hostName == "sequoia" then [
          "/persist/etc/ssh/ssh_host_ed25519_key"
        ] else [
          "/etc/ssh/ssh_host_ed25519_key"
        ]
      );

      generateKey = !(builtins.elem config.networking.hostName adminList);
    };
  };
}
