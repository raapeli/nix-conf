{
  inputs,
  self,
  ...
}: {
  flake.wrappersModules.niri = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options.terminal = lib.mkOption {
      type = lib.types.str;
      default = "kitty";
    };
      config = {
        settings = let
          noctaliaExe = "${inputs.noctalia.packages.${config.pkgs.stdenv.hostPlatform.system}.default}/bin/noctalia";
          rbwPick = config.pkgs.writeShellApplication {
            name = "rbw-pick";
            runtimeInputs = [ config.pkgs.rbw config.pkgs.fuzzel config.pkgs.wl-clipboard config.pkgs.pinentry-curses ];
            text = ''
              selected=$(rbw list --fields name,user | fuzzel --dmenu -p "bw> " -w 60 -l 15)
              if [ -n "$selected" ]; then
                name=$(echo "$selected" | cut -f1)
                rbw get "$name" | tr -d '\n' | wl-copy
                (sleep 30 && wl-copy --clear) &
              fi
            '';
          };
          bwPickCmd = "${lib.getExe rbwPick}";
        in {
        prefer-no-csd = _: { };

        input = {
          focus-follows-mouse = _: { };

          keyboard = {
            xkb = {
              layout = "fi";
            };
            repeat-rate = 40;
            repeat-delay = 250;
          };

          touchpad = {
            natural-scroll = _: { };
            tap = _: { };
            dwt = _: { };
          };
        };

        gestures = {
          hot-corners = {
            off = _: {};
         };
        };

        binds = {
          "Mod+Return".spawn = "${self.packages.${pkgs.stdenv.hostPlatform.system}.kitty}/bin/kitty";

          "Mod+Q".close-window = _: { };
          "Mod+F".maximize-column = _: { };
          "Mod+G".fullscreen-window = _: { };
          "Mod+Shift+F".toggle-window-floating = _: { };
          "Mod+C".center-column = _: { };

          "Mod+H".focus-column-left = _: { };
          "Mod+L".focus-column-right = _: { };
          "Mod+K".focus-window-up = _: { };
          "Mod+J".focus-window-down = _: { };

          "Mod+Left".focus-column-left = _: { };
          "Mod+Right".focus-column-right = _: { };
          "Mod+Up".focus-window-up = _: { };
          "Mod+Down".focus-window-down = _: { };

          "Mod+Comma".consume-window-into-column = {};
          "Mod+Period".expel-window-from-column = {};

          "Mod+Shift+H".move-column-left = _: { };
          "Mod+Shift+L".move-column-right = _: { };
          "Mod+Shift+K".move-window-up = _: { };
          "Mod+Shift+J".move-window-down = _: { };

          "Mod+1".focus-workspace = "w0";
          "Mod+2".focus-workspace = "w1";
          "Mod+3".focus-workspace = "w2";
          "Mod+4".focus-workspace = "w3";
          "Mod+5".focus-workspace = "w4";
          "Mod+6".focus-workspace = "w5";
          "Mod+7".focus-workspace = "w6";
          "Mod+8".focus-workspace = "w7";
          "Mod+9".focus-workspace = "w8";
          "Mod+0".focus-workspace = "w9";

          "Mod+Shift+1".move-column-to-workspace = "w0";
          "Mod+Shift+2".move-column-to-workspace = "w1";
          "Mod+Shift+3".move-column-to-workspace = "w2";
          "Mod+Shift+4".move-column-to-workspace = "w3";
          "Mod+Shift+5".move-column-to-workspace = "w4";
          "Mod+Shift+6".move-column-to-workspace = "w5";
          "Mod+Shift+7".move-column-to-workspace = "w6";
          "Mod+Shift+8".move-column-to-workspace = "w7";
          "Mod+Shift+9".move-column-to-workspace = "w8";
          "Mod+Shift+0".move-column-to-workspace = "w9";


          "Mod+Shift+u".set-dynamic-cast-window = _: { };
          "Mod+S".spawn-sh = "${noctaliaExe} msg panel-toggle launcher";
          "Mod+d".spawn-sh = self.mkWhichKeyExe config.pkgs [
            {
              key = "b";
              desc = "Bluetooth";
              cmd = "${noctaliaExe} msg panel-toggle control-center";
            }
            {
              key = "w";
              desc = "Wifi";
              cmd = "${noctaliaExe} msg panel-toggle control-center";
            }
            {
              key = "f";
              desc = "Firefox";
              cmd = "firefox";
            }
            {
              key = "p";
              desc = "Passwords";
              cmd = bwPickCmd;
            }
            {
              key = "s";
              desc = "Pavucontrol";
              cmd = "${lib.getExe pkgs.pavucontrol}";
            }
          ];
          "XF86AudioMicMute".spawn-sh = ''${config.pkgs.alsa-utils}/bin/amixer sset Capture toggle'';

          "Mod+Shift+X".spawn-sh = "${noctaliaExe} msg session lock";

          "XF86AudioMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";

          "Mod+Ctrl+H".set-column-width = "-5%";
          "Mod+Ctrl+L".set-column-width = "+5%";
          "Mod+Ctrl+J".set-window-height = "-5%";
          "Mod+Ctrl+K".set-window-height = "+5%";

          "Mod+WheelScrollDown".focus-column-left = _: { };
          "Mod+WheelScrollUp".focus-column-right = _: { };
          "Mod+Ctrl+WheelScrollDown".focus-workspace-down = _: { };
          "Mod+Ctrl+WheelScrollUp".focus-workspace-up = _: { };

          "Mod+Ctrl+S".spawn-sh = ''${lib.getExe config.pkgs.grim} -l 0 - | ${config.pkgs.wl-clipboard}/bin/wl-copy'';

          "Mod+Shift+E".spawn-sh = "${noctaliaExe} msg panel-toggle session";

          "Mod+Shift+S".spawn-sh = lib.getExe (config.pkgs.writeShellApplication {
            name = "screenshot";
            text = ''
              ${lib.getExe config.pkgs.grim} -g "$(${lib.getExe config.pkgs.slurp} -w 0)" - \
              | ${config.pkgs.wl-clipboard}/bin/wl-copy
            '';
          });

          "Mod+B".spawn-sh = bwPickCmd;

       };

        layout = {
          gaps = 5;

          focus-ring = {
            width = 2;
            active-color = "#${self.themeNoHash.base09}";
          };
        };

        workspaces = let
          settings = {layout.gaps = 5;};
        in {
          "w0" = settings;
          "w1" = settings;
          "w2" = settings;
          "w3" = settings;
          "w4" = settings;
          "w5" = settings;
          "w6" = settings;
          "w7" = settings;
          "w8" = settings;
          "w9" = settings;
        };

        xwayland-satellite.path =
          lib.getExe config.pkgs.xwayland-satellite;

        spawn-at-startup = [
          "env" "NOCTALIA_CONFIG_HOME=${self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia-config}/config" "${inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/noctalia"
        ];

        window-rules = [
          {
            matches = [ { is-window-cast-target = true; } ];
            focus-ring = {
              active-color = "#f38ba8";
              inactive-color = "#7d0d2d";
            };
            border = {
              inactive-color = "#7d0d2d";
            };
            shadow = {
              color = "#7d0d2d70";
            };
            tab-indicator = {
              active-color = "#f38ba8";
              inactive-color = "#7d0d2d";
            };
          }
        ];
      };
    };
  };

  perSystem = {pkgs, lib, ...}: {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      imports = [self.wrappersModules.niri];
    };

  };
}
