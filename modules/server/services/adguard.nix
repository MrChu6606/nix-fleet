{ ... }:
{
  services.adguardhome = {
    enable = true;

    # ts just opens the required ports??
    # lowk dont like that cause i specified ports in networking
    # and now that file is a liar cause more ports are open
    openFirewall = true;
  };
}
