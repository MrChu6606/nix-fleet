_: {
  sops = {
    secrets = let
      towerSecrets = ../../../../secrets/tower.yaml;
    in {
      grafana_env = {
        sopsFile = towerSecrets;
        owner = "grafana";
        group = "grafana";
      };

      grafana_key = {
        sopsFile = towerSecrets;
      };

      lidarr_env = {
        sopsFile = towerSecrets;
        owner = "lidarr";
        group = "media";
      };

      prowlarr_env = {
        sopsFile = towerSecrets;
        owner = "root";
        group = "root";
      };

      sabnzbd_secrets = {
        sopsFile = towerSecrets;
        owner = "sabnzbd";
        group = "media";
      };
    };
  };
}
