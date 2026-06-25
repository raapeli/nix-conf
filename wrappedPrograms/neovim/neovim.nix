{
  inputs,
  self,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
in {
  flake.modules.neovim.main = {
    config,
    wlib,
    lib,
    pkgs,
    ...
  }: {
    options = {
      dynamicMode = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          If true, use impure config for fast edits
        '';
      };
      initLua = lib.mkOption {
        type = wlib.types.stringable;
        default = ./.;
      };
      dynamicInitLua = lib.mkOption {
        type = lib.types.either wlib.types.stringable lib.types.luaInline;
        default = lib.generators.mkLuaInline "vim.uv.os_homedir() .. '/mynix/wrappedPrograms/neovim'";
      };
    };
    config = let
      compile-mode-nvim = pkgs.stdenv.mkDerivation {
        name = "compile-mode-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "ej-shafran";
          repo = "compile-mode.nvim";
          rev = "dd3e952076a33faba0a55b04b2b73945832c0527";
          hash = "sha256-aaQ4CVJMUdNBJUYCYowXxd1oCnssnjPbpOEzIE8H+m8=";
        };
        dontBuild = true;
        dontConfigure = true;
        installPhase = ''
          mkdir -p $out
          cp -r lua plugin after doc $out/ 2>/dev/null || true
        '';
      };
    in {
      settings.config_directory =
        if config.dynamicMode
        then config.dynamicInitLua
        else config.initLua;

      runtimePkgs = [
        pkgs.ffmpeg-full
        pkgs.wl-clipboard
        pkgs.ripgrep
        pkgs.fd
      ];

      specs.init = {
        data = null;
        before = ["MAIN_INIT"];
        config = "require('init')";
      };

      specs.plugins = {
        data = with pkgs.vimPlugins; [
          lz-n
          plenary-nvim
          which-key-nvim
          nvim-lspconfig
          nvim-treesitter.withAllGrammars
          nvim-treesitter-textobjects
          blink-cmp
          vim-sleuth
          lualine-nvim
          snacks-nvim
          luasnip
          friendly-snippets
        ] ++ [compile-mode-nvim];
      };

      specs.lazyPlugins = {
        lazy = true;
        data = [
          pkgs.vimPlugins.gitsigns-nvim
          pkgs.vimPlugins.bufferline-nvim
          pkgs.vimPlugins.trouble-nvim
          pkgs.vimPlugins.todo-comments-nvim
          pkgs.vimPlugins.noice-nvim
          pkgs.vimPlugins.nui-nvim
          pkgs.vimPlugins.nvim-notify
          pkgs.vimPlugins.lazydev-nvim
          pkgs.vimPlugins.conform-nvim
          pkgs.vimPlugins.flash-nvim
          pkgs.vimPlugins.dial-nvim
          pkgs.vimPlugins.yanky-nvim
          pkgs.vimPlugins.persistence-nvim
          pkgs.vimPlugins.nvim-autopairs
          pkgs.vimPlugins.mini-ai
          pkgs.vimPlugins.mini-surround
          pkgs.vimPlugins.mini-comment
          pkgs.vimPlugins.mini-hipatterns
          pkgs.vimPlugins.mini-icons
          pkgs.vimPlugins.mini-pairs
          pkgs.vimPlugins.tokyonight-nvim
          pkgs.vimPlugins.ts-comments-nvim
          pkgs.vimPlugins.nvim-ts-autotag
          pkgs.vimPlugins.nvim-dap
          pkgs.vimPlugins.nvim-dap-ui
          pkgs.vimPlugins.nvim-dap-virtual-text
          pkgs.vimPlugins.nvim-nio
        ];
      };

      env.LADSPA_PATH = "${pkgs.deepfilternet}lib/ladspa/libdeep_filter_ladspa.so";
    };
  };

  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.neovim = inputs.wrapper-modules.wrappers.neovim.wrap {
      inherit pkgs;
      imports = [
        self.modules.neovim.main
        self.modules.neovim.lua
        self.modules.neovim.nix
      ];
    };

    packages.neovimDynamic = inputs.wrapper-modules.wrappers.neovim.wrap {
      inherit pkgs;
      dynamicMode = true;
      imports = [
        self.modules.neovim.main
        self.modules.neovim.allServers
      ];
    };
  };
}
