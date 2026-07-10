{ config, lib, ... }: {

  fileSystems."/" = lib.mkIf (!config.system.build ? sdImage) {
    device = "/dev/disk/by-uuid/9016-4EF8";
    fsType = "ext4";
  };

}
