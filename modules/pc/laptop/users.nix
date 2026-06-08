{ lib, ... }: {
  users.users.nic.extraGroups = lib.mkMerge [
    [ "networkmanager"  "wireshark" ]
  ];
}
