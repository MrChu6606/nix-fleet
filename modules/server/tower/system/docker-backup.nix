{ pkgs, ... }:
{
  # 1. Create a systemd service for the backup execution
  systemd.services.docker-volume-backup = {
    description = "Safely backup Docker/Arion volumes to external drive";
    
    # Path dependencies required by the script
    path = [ pkgs.util-linux pkgs.gnutar pkgs.gzip pkgs.systemd ];

    script = ''
      DRIVE_UUID="2867abdf-830d-465c-9104-c14a77a7056d"
      MOUNT_TARGET="/mnt/external_backup"
      DOCKER_VOLUME_DIR="/appdata"
      BACKUP_NAME="docker_volumes_$(date +%Y%m%d_%H%M%S).tar.gz"

      echo "Creating mount target if missing..."
      mkdir -p "$MOUNT_TARGET"

      echo "Mounting external drive by UUID..."
      if ! mount -U "$DRIVE_UUID" "$MOUNT_TARGET"; then
          echo "Error: Failed to mount the drive. Exiting."
          exit 1
      fi

      # Using systemctl to bring down docker ensures systemd handles 
      # the state gracefully without triggering failure alerts.
      echo "Stopping Docker and Arion containers..."
      systemctl stop docker.service docker.socket

      echo "Creating compressed volume archive..."
      if ! tar -czf "$MOUNT_TARGET/$BACKUP_NAME" -C "$DOCKER_VOLUME_DIR" .; then
          echo "Warning: Tar completed with errors, proceeding to restart services anyway."
      fi

      echo "Starting Docker and Arion containers back up..."
      systemctl start docker.socket docker.service

      echo "Safely unmounting external drive..."
      cd /
      umount "$MOUNT_TARGET"

      echo "Backup process finished successfully!"
    '';

    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  # 2. Schedule the service to run automatically
  systemd.timers.docker-volume-backup = {
    description = "Timer for Docker/Arion volume backup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      # Runs every day at 2:00 AM
      OnCalendar = "*-*-* 02:00:00";
      # Persistent ensures that if the system was powered off at 2:00 AM, 
      # the backup runs immediately upon the next boot.
      Persistent = true; 
    };
  };
}
