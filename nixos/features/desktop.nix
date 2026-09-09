{ self, ... }: {
  flake.nixosModules.desktop = { pkgs, lib, ... }: let
    selfPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    # Compositor: mango is the active session
    programs.mango.enable = true;
    programs.mango.package = selfPkgs.mango;

    services.desktopManager.plasma6.enable = true;
    services.displayManager.defaultSession = lib.mkForce "mango";

    # X11 windowing + keyboard layout
    services.xserver.enable = true;
    services.xserver.xkb = {
      layout = "fi";
      variant = "";
    };
    console.keyMap = "fi";

    # Touchpad
    services.libinput.enable = true;

    # Graphics
    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;
    hardware.graphics.extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
}
