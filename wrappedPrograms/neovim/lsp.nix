{
  inputs,
  self,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
in {
  flake.modules.neovim.lua = {
    pkgs,
    ...
  }: {
    runtimePkgs = [
      pkgs.lua-language-server
    ];
  };

  flake.modules.neovim.nix = {pkgs, ...}: {
    runtimePkgs = [
      pkgs.nixd
      pkgs.alejandra
    ];
  };

  flake.modules.neovim.clangd = {pkgs, ...}: {
    runtimePkgs = [
      pkgs.clang-tools
    ];
  };

  flake.modules.neovim.cmake = {pkgs, ...}: {
    runtimePkgs = [
      pkgs.cmake-language-server
    ];
  };

  flake.modules.neovim.python = {pkgs, ...}: {
    runtimePkgs = [
      pkgs.pyright
      pkgs.ruff
    ];
  };

  flake.modules.neovim.typescript = {pkgs, ...}: {
    runtimePkgs = [
      pkgs.typescript-language-server
      pkgs.prettier
    ];
  };

  flake.modules.neovim.allServers = {
    imports = [
      self.modules.neovim.clangd
      self.modules.neovim.cmake
      self.modules.neovim.python
      self.modules.neovim.typescript
      self.modules.neovim.lua
      self.modules.neovim.nix
    ];
  };
}
