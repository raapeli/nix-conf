{
  flake.nixosModules.laptop = { pkgs, ... }: {
    services.logind.settings.Login = {
      HandleLidSwitch = "poweroff";
      HandleLidSwitchExternalPower = "lock";
      HandleLidSwitchDocked = "ignore";
    };

    services.upower.enable = true;
    services.thermald.enable = true;
    services.tuned.enable = true;

    environment.systemPackages = with pkgs; [
      brightnessctl
      acpi
    ];
  };
}
