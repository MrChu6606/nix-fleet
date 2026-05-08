{ ... }: {
  fileSystems."/mnt/appdata" = {
    device = "/dev/disk/by-label/addpata";
    fsType = "ext4";
  };

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-label/storage";
    fsType = "ext4";
  };

  # Trick libvirt into putting vms in appdata
  fileSystems."/var/lib/libvirt/images" = {
    device = "/mnt/appdata/vms";
    options = [ "bind" ];
  };
}
