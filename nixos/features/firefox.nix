{
  flake.nixosModules.firefox = { ... }: {
    programs.firefox = {
      enable = true;

      preferences = {
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.enabled" = true;
        "widget.wayland.enabled" = true;
        "layers.acceleration.force-enabled" = true;
      };
    };

    environment.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
    };
  };
}
