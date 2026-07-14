_: {
  programs.bottom = {
    enable = true;
    settings = {
      # Core settings
      flags = {
        # Forces bottom to pull GPU data on startup
        enable_gpu = true; 
      };
      
      # Process widget column configuration
      processes = {
        columns = [ "PID" "Name" "CPU%" "Mem%" "GPU%" "GMem%" ];
      };
    };
  };
  xdg.configFile."bottom/bottom.toml".force = true;
}
