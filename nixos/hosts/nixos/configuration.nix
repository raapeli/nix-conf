{ self, inputs, ... }: {
  flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit self; };
    modules = [ self.nixosModules.hostNixos ];
  };

  flake.nixosModules.hostNixos = { pkgs, self, lib, ... }:   
    let selfPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    imports =
      [
        self.nixosModules.nixosHardware
        self.nixosModules.firefox
        self.nixosModules.podman
        self.nixosModules.tailscale
        self.nixosModules.syncthing
        inputs.nix-index-database.nixosModules.default
        { programs.nix-index-database.comma.enable = true; }
      ];

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Use latest kernel
    boot.kernelPackages = pkgs.linuxPackages_latest;

    systemd.tpm2.enable = false;
    boot.initrd.systemd.tpm2.enable = false;


    networking.hostName = "nixos"; # Define your hostname.

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Helsinki";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "fi_FI.UTF-8";
      LC_IDENTIFICATION = "fi_FI.UTF-8";
      LC_MEASUREMENT = "fi_FI.UTF-8";
      LC_MONETARY = "fi_FI.UTF-8";
      LC_NAME = "fi_FI.UTF-8";
      LC_NUMERIC = "fi_FI.UTF-8";
      LC_PAPER = "fi_FI.UTF-8";
      LC_TELEPHONE = "fi_FI.UTF-8";
      LC_TIME = "fi_FI.UTF-8";
    };

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "fi";
      variant = "";
    };

    # Configure console keymap
    console.keyMap = "fi";

    # Enable CUPS to print documents.
    services.printing.enable = true;


    services.udisks2.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

   hardware.bluetooth.enable = true;
   hardware.bluetooth.powerOnBoot = true;
   services.blueman.enable = true;


   services.thermald.enable = true;

    services.logind.settings.Login = {
      HandleLidSwitch = "poweroff";
      HandleLidSwitchExternalPower = "lock";
      HandleLidSwitchDocked = "ignore";
    };

    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;
    hardware.graphics.extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];

    programs.niri.enable = true;
    programs.niri.package = selfPkgs.niri;

    programs.mango.enable = true;
    programs.mango.package = selfPkgs.mango;

   services.desktopManager.plasma6.enable = true;
   services.displayManager.defaultSession = lib.mkForce "mango";
    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

    # Define a user account. Don't forget to set a password with 'passwd'
    users.users."aapeli" = {
      isNormalUser = true;
      description = "Aapeli";
      extraGroups = [ "networkmanager" "wheel" "video" "audio" "input" "podman"];
      shell = selfPkgs.environment;
      packages = with pkgs; [
        thunderbird
      ];
    };

    programs.zsh.enable = true;

    programs.nix-index-database.comma.enable = true;
    programs.nix-index.enableFishIntegration = true;


    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    services.upower.enable = true;
    services.tuned.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
      ];
      configPackages = [ pkgs.niri ];
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    fonts.enableDefaultPackages = true;
    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      font-awesome
      noto-fonts
      noto-fonts-color-emoji
    ];

     nix.settings = { 
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
      experimental-features = [ "nix-command" "flakes" ];

        extra-substituters = [ "https://noctalia.cachix.org" ];
  extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
    };
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      wget curl htop  fd
      unzip p7zip
      brightnessctl
      acpi
      pavucontrol
      vim
      file
      gh
      python3
    ];

    nix.settings = {
      max-jobs = "auto";
      cores = 8;
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
     programs.mtr.enable = true;
     programs.gnupg.agent = {
       enable = true;
       enableSSHSupport = true;
     };

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/aapeli/mynix";
    };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
     services.openssh.enable = true;

    #Tmpfiles
    systemd.tmpfiles.rules = [
      "L+ /home/aapeli/Documents/todo - - - - /home/aapeli/sync/todo"
    ];

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It's perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "26.05"; # Did you read the comment?

  };
}
