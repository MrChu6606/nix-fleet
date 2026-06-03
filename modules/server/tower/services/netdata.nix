_: {
  services.netdata = {
    enable = true;
    # retention duration in seconds
    config.global = { "history" = "86400"; };
  };
}
