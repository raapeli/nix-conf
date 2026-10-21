{ inputs, ... }: {
  flake.nixosModules.mathematica = { pkgs, ... }: {
    environment.systemPackages = [
      (import inputs.mathematica-nixpkgs {
        system = pkgs.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      }).mathematica
    ];
  };
}
