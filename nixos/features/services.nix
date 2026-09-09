{
  flake.nixosModules.services = { pkgs, ... }: {
    # Printing
    services.printing.enable = true;

    # Removable media
    services.udisks2.enable = true;

    # Sound with pipewire
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Bluetooth
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;

    # OpenSSH daemon
    services.openssh.enable = true;
  };
}
