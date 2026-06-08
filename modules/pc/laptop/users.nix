_: {
  users.users.nic = {
    isNormalUser = true;
    description = "nic";
    extraGroups = [ "networkmanager"  "wireshark" ];
  };
}
