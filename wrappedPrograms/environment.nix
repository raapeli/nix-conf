{
  lib,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.environment = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = self'.packages.fish;
      runtimeInputs = [
        pkgs.fzf
        pkgs.btop
        pkgs.eza
        pkgs.zoxide
        pkgs.dust
        pkgs.ripgrep
        pkgs.bat
        pkgs.jq
        pkgs.unzip
        pkgs.zip
        pkgs.p7zip
        pkgs.wget
        pkgs.rbw
        pkgs.shotwell
        pkgs.pinentry-curses
        pkgs.fuzzel
        pkgs.ddcutil
        pkgs.tuxedo
        pkgs.zathura
        pkgs.libqalculate
        pkgs.feh
        pkgs.gcc
        pkgs.gh
        pkgs.python3

        # wrapped
        self'.packages.git
        self'.packages.jujutsu
        self'.packages.jjui
        self'.packages.kitty
        self'.packages.neovim
        self'.packages.mango
        self'.packages.yazi
      ];
      env = {
        EDITOR = lib.getExe self'.packages.neovim;
        TODO_DIR = "/home/aapeli/Documents/todo";
        SSH_ASKPAS = "";
      };
    };
  };
}
