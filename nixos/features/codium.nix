{ ... }: {
  flake.nixosModules.codium = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.elan
      pkgs.lean4
      (pkgs.vscode-with-extensions.override {
        vscode = pkgs.vscodium;
        vscodeExtensions = with pkgs.vscode-extensions; [
          leanprover.lean4
          tamasfe.even-better-toml
          editorconfig.editorconfig
          ms-python.black-formatter
          ms-python.python
          ms-python.vscode-pylance
          esbenp.prettier-vscode
          dbaeumer.vscode-eslint
        ];
      })
    ];
  };
}
