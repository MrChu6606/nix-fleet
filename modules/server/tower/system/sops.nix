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
    };
  };
}
