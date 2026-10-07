{ ... }: {
  flake.nixosModules.mathematica = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.mathematica ];
  };
}
