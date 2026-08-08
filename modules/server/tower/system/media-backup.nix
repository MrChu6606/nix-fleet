{ pkgs, config, ... }: {
  # Daily Timer
  systemd.timers."restic-backups-media-external" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Persistent = true;
      Unit = "restic-backups-media-external.service";
    };
  };

  # Direct Systemd Service Definition (No broken NixOS wrapper layer)
  systemd.services."restic-backups-media-external" = {
    description = "Restic Media External Backup Service";
    
    path = [
      pkgs.coreutils
      pkgs.util-linux
      pkgs.restic
    ];

    environment = {
      TMPDIR = "/mnt/external_backup/.restic-tmp";
      RESTIC_REPOSITORY = "/mnt/external_backup/restic_media";
      RESTIC_PASSWORD_FILE = config.sops.secrets.restic_media_password.path;
    };

    script = ''
      set -euo pipefail

      DRIVE_UUID="2867abdf-830d-465c-9104-c14a77a7056d"
      MOUNT_TARGET="/mnt/external_backup"

      mkdir -p "$MOUNT_TARGET"

      # Ensure drive is mounted
      if ! mountpoint -q "$MOUNT_TARGET"; then
        echo "Mounting backup drive (UUID=$DRIVE_UUID)..."
        mount -U "$DRIVE_UUID" "$MOUNT_TARGET"
      fi

      if ! mountpoint -q "$MOUNT_TARGET"; then
        echo "ERROR: Mount failed! Aborting to prevent writing to tmpfs." >&2
        exit 1
      fi

      mkdir -p "$MOUNT_TARGET/restic_media"
      mkdir -p "$MOUNT_TARGET/.restic-tmp"

      # Initialize repository if missing
      if [ ! -f "$MOUNT_TARGET/restic_media/config" ]; then
        echo "Initializing new Restic repository..."
        restic init
      fi

      # Run Backup
      echo "Starting backup execution..."
      restic backup /media/music \
        --exclude="**/.Trash-*" \
        --exclude="**/.DS_Store" \
        --exclude="**/*.tmp"

      # Prune Old Snapshots
      echo "Pruning old snapshots..."
      restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune
    '';

    postStop = ''
      MOUNT_TARGET="/mnt/external_backup"
      
      if mountpoint -q "$MOUNT_TARGET"; then
        rm -rf "$MOUNT_TARGET/.restic-tmp" || true
        echo "Unmounting backup drive..."
        umount "$MOUNT_TARGET" || true
      fi
    '';

    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
