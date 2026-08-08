{ pkgs, config, ... }: {
  # 1. Environment variable for the repository password file (SOPS or local file)
  # Restic encrypts all snapshots, so a password file is required even for local drives.
  sops.secrets.restic_media_password = {
    # If using sops-nix, declare the secret here. 
    # Alternatively, point `passwordFile` below directly to a path like `/persist/etc/restic-password`.
  };

  # 2. Native NixOS Restic Backup Configuration
  services.restic.backups.media-external = {
    # Run daily at 03:00 AM
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Persistent = true;
    };

    # Restic repository path on your mounted external drive
    repository = "/mnt/external_backup/restic_media";
    
    # Path to the password file used to encrypt/decrypt the repository
    passwordFile = config.sops.secrets.restic_media_password.path;

    # Targets to back up
    paths = [
      "/media/music"
    ];

    # Pre-exec script: Mount the drive before starting the backup
    initialize = true; # Automatically run 'restic init' if repository doesn't exist yet
    
    # Prune policy to automatically clean up old snapshots
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];
  };

  # 3. Systemd Service Overrides for Dynamic Mounting & Unmounting
  systemd.services."restic-backups-media-external" = {
    path = [ pkgs.util-linux ];
    
    # Mount the external drive by UUID before Restic runs
    preStart = ''
      DRIVE_UUID="2867abdf-830d-465c-9104-c14a77a7056d"
      MOUNT_TARGET="/mnt/external_backup"
      
      mkdir -p "$MOUNT_TARGET"
      if ! mountpoint -q "$MOUNT_TARGET"; then
        echo "Mounting backup drive ($DRIVE_UUID)..."
        mount -U "$DRIVE_UUID" "$MOUNT_TARGET"
      fi
    '';

    # Ensure the drive unmounts when the service completes or fails
    postStop = ''
      MOUNT_TARGET="/mnt/external_backup"
      if mountpoint -q "$MOUNT_TARGET"; then
        echo "Unmounting backup drive..."
        umount "$MOUNT_TARGET" || true
      fi
    '';
  };
}
