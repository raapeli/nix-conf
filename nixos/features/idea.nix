{ inputs, ... }: {
  flake.nixosModules.idea = { pkgs, ... }: {
    environment.systemPackages = with inputs.nix-jetbrains-plugins.lib; [
      (buildIdeWithPlugins pkgs "idea" ["fi.aalto.cs.intellij-plugin"
        "com.intellij.ml.llm"
        "Pythonid"
        "PythonCore"
        "intellij.python.dap.plugin"
        "org.intellij.scala"])
    ];
  };
}
