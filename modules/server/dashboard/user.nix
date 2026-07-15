_: {
  users.users.nic = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    
    # Plaintext password for TTY login (change this on first login)
    initialPassword = "please";
  };
}
