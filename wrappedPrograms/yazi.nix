{
self,
inputs,
...
}: {
  flake.wrappersModules.yazi = {
    wlib,
    lib,
    pkgs,
    ...
  }: {
    imports = [
      wlib.wrapperModules.yazi
      ({config, ...}: {
        constructFiles.init-lua = {
          relPath = "${config.binName}-config/init.lua";
          content = ''
            require("git"):setup()
            require("starship"):setup()
          '';
        };
      })
    ];

    plugins = with pkgs.yaziPlugins; {
      git = git;
      jjui = jjui;
      lazygit = lazygit;
      piper = piper;
      smart-enter = smart-enter;
      starship = starship;
    };

    runtimePkgs = with pkgs; [
      git
      glow
      jj
      jjui
      lazygit
      starship
      hexyl
      feh
      zathura
      yazi
    ];

    settings.keymap.mgr.prepend_keymap = [
      {
        on = [ "l" ];
        run = "plugin smart-enter";
        desc = "Enter the child directory, or open the hovered file";
      }
      {
        on = [ "<Enter>" ];
        run = "plugin smart-enter";
        desc = "Same as l";
      }
      {
        on = [ "g" "j" ];
        run = "plugin jjui";
        desc = "Run jjui";
      }
      {
        on = [ "g" "i" ];
        run = "plugin lazygit";
        desc = "Run lazygit";
      }
    ];

    settings.yazi.opener = {
      explore = [
        {
          run = "${lib.getExe pkgs.yazi} \"$0\"";
          desc = "Open the folder in a new yazi instance";
        }
      ];
      image = [
        {
          run = "${lib.getExe pkgs.feh} --auto-zoom --force-alias \"$@\"";
          block = true;
          desc = "Open the image(s) with feh";
        }
      ];
      pdf = [
        {
          run = "${lib.getExe pkgs.zathura} \"$@\"";
          block = true;
          desc = "Open the document(s) with zathura";
        }
      ];
    };

    settings.yazi.open = {
      prepend_rules = [
        {
          url = "*/";
          use = "explore";
        }
        {
          mime = "application/pdf";
          use = "pdf";
        }
        {
          mime = "image/*";
          use = "image";
        }
        {
          url = "*.pdf";
          use = "pdf";
        }
      ];
    };

    settings.yazi.plugin = {
      prepend_fetchers = [
        {
          url = "*";
          run = "git";
          group = "git";
        }
        {
          url = "*/";
          run = "git";
          group = "git";
        }
      ];

      prepend_previewers = [
        {
          url = "*.md";
          run = "piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark \"$1\"";
        }
        {
          url = "*.tar*";
          run = "piper --format=url -- tar tf $1";
        }
      ];
      append_previewers = [
          {
          url = "*";
          run = "piper -- hexyl --border=none --terminal-width=$w $1";
          }    
      ];
    };
  };

  perSystem = {pkgs, ...}: {
    packages.yazi = inputs.wrapper-modules.wrappers.yazi.wrap {
      inherit pkgs;
      imports = [self.wrappersModules.yazi];
    };
  };
}
