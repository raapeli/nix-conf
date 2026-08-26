{ inputs, ... }: let
  heliumModule = inputs.helium-browser.nixosModules.default;
in {
  flake.nixosModules.helium = { ... }: {
    imports = [ heliumModule ];
    programs.helium.enable = true;
  };
}
