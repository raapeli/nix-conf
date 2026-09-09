{ self, inputs, ... }: {
  flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit self inputs; };
    modules = [ self.nixosModules.hostNixos ];
  };

  flake.nixosModules.hostNixos = { pkgs, self, lib, ... }: let
    selfPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    imports =
      [
        self.nixosModules.nixosHardware
        self.nixosModules.desktop
        self.nixosModules.laptop
        self.nixosModules.services
        self.nixosModules.networking
        self.nixosModules.nix
        self.nixosModules.firefox
        self.nixosModules.idea
        self.nixosModules.podman
        self.nixosModules.tailscale
        self.nixosModules.syncthing
        inputs.nix-index-database.nixosModules.default
        { programs.nix-index-database.comma.enable = true; }
        self.nixosModules.helium
        self.nixosModules.codium
      ];

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Use latest kernel
    boot.kernelPackages = pkgs.linuxPackages_latest;

    systemd.tpm2.enable = false;
    boot.initrd.systemd.tpm2.enable = false;
    boot.tmp.cleanOnBoot = true;

    networking.hostName = "nixos"; # Define your hostname.

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

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    fonts.enableDefaultPackages = true;
    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      font-awesome
      noto-fonts
      noto-fonts-color-emoji
    ];

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      wget curl htop  fd
      unzip p7zip
      pavucontrol
      vim
      file
      gh
      python3
    ];

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

    #Tmpfiles
    systemd.tmpfiles.rules = [
      "L+ /home/aapeli/Documents/todo - - - - /home/aapeli/sync/todo"
    ];

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It's perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "26.05"; # Did you read the comment?
  };
}
