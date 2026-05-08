{ ... }:
{
  virtualization.oci-containers.containers."npm" = {
    image = "jc21/nginx-proxy-manager:latest";

    # Make sure these ports are open in the firewall
    ports = [
      "80:80" #dashboard
      "81:81" #admin? i forget
      "443:443" #https
    ];

    volumes = [
      "/var/lib/npm/data:/data"
      "/var/lib/npm/letsencrypt:/etc/letsencrypt"
    ];

    environment = {
      DB_SQLITE_FILE = "/data/database.sqlite";
    };
  };
}
