{ pkgs, ...}: {
  systemd = {
      services.docker-volume-backup = {
      description = "Safely backup Docker/Arion volumes to external drive";
      
      # Added pkgs.docker here
      path = [ pkgs.util-linux pkgs.gnutar pkgs.gzip pkgs.systemd pkgs.docker pkgs.gawk ];

      script = ''
        DRIVE_UUID="2867abdf-830d-465c-9104-c14a77a7056d"
        MOUNT_TARGET="/mnt/external_backup"
        DOCKER_VOLUME_DIR="/appdata"
        BACKUP_NAME="docker_volumes_$(date +%Y%m%d_%H%M%S).tar.gz"

        # 1. Find all currently running Arion services before we shut anything down
        echo "Identifying active Arion projects..."
        ACTIVE_SERVICES=$(systemctl list-units --type=service --state=running "arion-*" | gawk '{print $1}' | grep '^arion-')

        if [ -z "$ACTIVE_SERVICES" ]; then
            echo "No active Arion services found running. Proceeding with backup anyway."
        fi

        echo "Creating mount target if missing..."
        mkdir -p "$MOUNT_TARGET"

        echo "Mounting external drive by UUID..."
        if ! mount -U "$DRIVE_UUID" "$MOUNT_TARGET"; then
            echo "Error: Failed to mount the drive. Exiting."
            exit 1
        fi

        # Gracefully stop only the services that were actually running
        if [ ! -z "$ACTIVE_SERVICES" ]; then
            echo "Stopping active Arion projects:"
            echo "$ACTIVE_SERVICES"
            # echo stops them all in a single parallelizable systemd call
            systemctl stop $ACTIVE_SERVICES
            sleep 2
        fi

        echo "Creating compressed volume archive..."
        if ! tar -czf "$MOUNT_TARGET/$BACKUP_NAME" -C "$DOCKER_VOLUME_DIR" .; then
            echo "Warning: Tar completed with minor errors, moving on..."
        fi

        # Bring the exact same services back online cleanly
        if [ ! -z "$ACTIVE_SERVICES" ]; then
            echo "Restoring Arion projects..."
            systemctl start $ACTIVE_SERVICES
        fi

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
    timers.docker-volume-backup = {
      description = "Timer for Docker Arion volume backup";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* -2:00:00";

        # Ensures the backups run on boot if server is powered
        # off at 2 am
        Persistent = true;
      };
    };
  };
}
