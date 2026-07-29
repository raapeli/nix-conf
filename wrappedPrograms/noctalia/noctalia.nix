{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages.noctalia-config = pkgs.runCommand "noctalia-config" {} ''
      mkdir -p $out/config/noctalia
      cp ${./config.toml} $out/config/noctalia/config.toml
    '';
  };
}
