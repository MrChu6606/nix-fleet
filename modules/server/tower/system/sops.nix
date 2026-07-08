_: {
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

      grafana_key = {};

        lidarr_env = {
          owner = "lidarr";
          group = "media";
        };

        prowlarr_env = {
          owner = "root";
          group = "root";
        };

        sabnzbd_secrets = {
          owner = "sabnzbd";
          group = "media";
        };
    };
  };
}
