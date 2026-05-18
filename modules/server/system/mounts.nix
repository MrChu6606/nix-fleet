_: {
  fileSystems."/appdata" = {
    device = "/dev/disk/by-partlabel/appdata";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  fileSystems."/media" = {
    device = "/dev/disk/by-partlabel/media";
    fsType = "ext4";
    options = [ "noatime" ];
  };
}
