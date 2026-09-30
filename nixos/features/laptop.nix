{
  flake.nixosModules.laptop = { pkgs, ... }: {
    services.logind.settings.Login = {
      HandleLidSwitch = "lock";
      HandleLidSwitchExternalPower = "lock";
      HandleLidSwitchDocked = "ignore";

      IdleAction = "suspend";
      IdleActionSec = "10min";
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
