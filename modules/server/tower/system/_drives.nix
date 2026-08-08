{ ... }: {
  disko.devices.disk = {

    # APPDATA + VMS (1TB)
    appdata = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_with_Heatsink_1TB_S6WSNS0RC14674J";

      content = {
        type = "gpt";

        partitions = {
          data = {
            size = "100%";

            content = {
              type = "filesystem";
              format = "ext4";
            };
          };
        };
      };
    };

    # MEDIA (2TB)
    media = {
      type = "disk";
      device = "/dev/disk/by-id/ata-Inland_SATA_SSD_IB24IL0002S00060";

      content = {
        type = "gpt";

        partitions = {
          data = {
            size = "100%";

            content = {
              type = "filesystem";
              format = "ext4";
            };
          };
        };
      };
    };
  };
}
