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

    packages.noctalia = pkgs.writeShellScriptBin "noctalia" ''
      export NOCTALIA_CONFIG_HOME="${self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia-config}/config"
      exec "${inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/noctalia" "$@"
    '';
  };
}
