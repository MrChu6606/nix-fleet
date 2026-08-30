{ lib, ... }: {
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
          IdleTimeout = 0;
          FastConnectable = "true";
        };
        Policy.AutoEnable = true;
      };
    };

    uinput.enable = true;

    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  # allows solaar to see bluetooth mouse
  users.users.nic.extraGroups = lib.mkMerge [ [ "input" "plugdev" ] ];

  services.blueman.enable = true;

  # Grant access to Bluetooth Logitech HIDRAW devices for Solaar/LogiOps
  services.udev.extraRules = ''
    KERNEL=="hidraw*", KERNELS=="*0003:046D:*|*0005:046D:*", MODE="0660", GROUP="input", TAG+="uaccess"
    KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
  '';
}
