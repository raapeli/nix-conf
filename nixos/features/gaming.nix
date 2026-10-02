{ ... }: {
  flake.nixosModules.gaming = { lib, ... }: {
    hardware.graphics.enable = lib.mkDefault true;

    programs = {
      gamescope.enable = true;
      steam.enable = true;
    };
  };
}
