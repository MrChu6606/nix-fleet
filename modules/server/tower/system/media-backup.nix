{ pkgs, config, ... }: {

  # 2. Native NixOS Restic Backup Configuration
  services.restic.backups.media-external = {
    # Run daily at 03:00 AM
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Persistent = true;
    };

    # Dedicated subdirectory for Restic snapshots
    repository = "/mnt/external_backup/restic_media";
    
    # Decrypted password managed automatically by sops-nix
    passwordFile = config.sops.secrets.restic_media_password.path;

    # Media folder to back up
    paths = [
      "/media/media"
    ];

    # Exclude temporary or OS-generated files
    exclude = [
      "**/.Trash-*"
      "**/.DS_Store"
      "**/*.tmp"
    ];

    # Automatically run 'restic init' on first run if repo doesn't exist
    initialize = true;
    
    # Retention policy: keeps snapshots light and cleans up old ones
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];
  };

  # 3. Automatic Drive Mount & Unmount Hooks
  systemd.services."restic-backups-media-external" = {
    path = [ pkgs.util-linux ];
    
    # Automatically mount the external drive by UUID before Restic runs
    preStart = ''
      DRIVE_UUID="2867abdf-830d-465c-9104-c14a77a7056d"
      MOUNT_TARGET="/mnt/external_backup"
      
      mkdir -p "$MOUNT_TARGET"
      if ! mountpoint -q "$MOUNT_TARGET"; then
        echo "Mounting backup drive ($DRIVE_UUID)..."
        mount -U "$DRIVE_UUID" "$MOUNT_TARGET"
      fi

      # Ensure the restic_media subdirectory exists on the external drive
      mkdir -p "$MOUNT_TARGET/restic_media"
    '';

    # Automatically unmount when finished or if an error occurs
    postStop = ''
      MOUNT_TARGET="/mnt/external_backup"
      if mountpoint -q "$MOUNT_TARGET"; then
        echo "Unmounting backup drive..."
        umount "$MOUNT_TARGET" || true
      fi
    '';
  };
}
