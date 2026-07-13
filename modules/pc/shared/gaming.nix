_: {
  programs.steam.enable = true;

  hardware.xone.enable = true;

  # Overlay to swap the source of xone under the hood
  nixpkgs.overlays = [
    (final: prev: {
      linuxPackages = prev.linuxPackages.extend (lFinal: lPrev: {
        xone = lPrev.xone.overrideAttrs (oldAttrs: {
          src = final.unstable.linuxPackages.xone.src;
        });
      });
    })
  ];
}
