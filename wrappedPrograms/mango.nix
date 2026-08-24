{
  inputs,
  self,
  ...
}: {
  flake.wrappersModules.mangowc = {
    config,
    lib,
    pkgs,
    ...
  }: let
    selfPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
    noctaliaExe = lib.getExe selfPkgs.noctalia;
    screenshotFull = lib.getExe (pkgs.writeShellApplication {
      name = "screenshot";
      text = ''
        ${lib.getExe config.pkgs.grim} -l 0 - | ${config.pkgs.wl-clipboard}/bin/wl-copy
      '';
    });
    screenshot = lib.getExe (pkgs.writeShellApplication {
      name = "screenshot";
      text = ''
        ${lib.getExe config.pkgs.grim} -g "$(${lib.getExe config.pkgs.slurp} -w 0)" - | ${config.pkgs.wl-clipboard}/bin/wl-copy
      '';
    });
    rbwPick = pkgs.writeShellApplication {
      name = "rbw-pick";
      runtimeInputs = [ pkgs.rbw pkgs.fuzzel pkgs.wl-clipboard pkgs.pinentry-curses ];
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
  mod = "SUPER";
  wsKeys = [
      {
        key = "1";
        ws = 1;
      }
      {
        key = "2";
        ws = 2;
      }
      {
        key = "3";
        ws = 3;
      }
      {
        key = "4";
        ws = 4;
      }
      {
        key = "5";
        ws = 5;
      }
      {
        key = "6";
        ws = 6;
      }
      {
        key = "8";
        ws = 7;
      }
      {
        key = "9";
        ws = 8;
      }
      {
        key = "0";
        ws = 9;
      }
    ];

  in {
      options.terminal = lib.mkOption {
        type = lib.types.str;
        default = "kitty";
      };

      config = {
        package = pkgs.mango;

        autostart_sh = ''
          ${noctaliaExe} &'';
        settings = {
          new_is_master = 1;
          default_mfact = 0.55;
          default_nmaster = 1;
          smartgaps = 1;

          hotarea_size = 10;
          enable_hotarea = 0;
          ov_tab_mode = 1;
          overviewgappi = 5;
          overviewgappo = 30;

          no_border_when_single = 1;
          axis_bind_apply_timeout = 100;
          focus_on_activate = 0;
          idleinhibit_ignore_visible = 0;
          sloppyfocus = 1;
          warpcursor = 1;
          focus_cross_monitor = 0;
          focus_cross_tag = 0;
          enable_floating_snap = 0;
          snap_distance = 30;
          # cursor_theme = self.cursor.name;
          # cursor_size = self.cursor.size;
          drag_tile_to_tile = 1;

          repeat_rate = 40;
          repeat_delay = 250;
          numlockon = 0;
          xkb_rules_layout = "fi";

          disable_trackpad = 0;
          tap_to_click = 1;
          tap_and_drag = 1;
          drag_lock = 1;
          trackpad_natural_scrolling = 0;
          trackpad_disable_while_typing = 1;
          trackpad_left_handed = 0;
          trackpad_middle_button_emulation = 0;
          swipe_min_threshold = 1;

          mouse_natural_scrolling = 0;
          mouse_accel_profile = 1;
          mouse_accel_speed = 0.0;

          gappih = 5;
          gappiv = 5;
          gappoh = 10;
          gappov = 10;
          scratchpad_width_ratio = 0.8;
          scratchpad_height_ratio = 0.9;
          borderpx = 2;

          rootcolor = "0x${self.themeNoHash.base00}ff";
          bordercolor = "0x${self.themeNoHash.base00}ff";
          focuscolor = "0x${self.themeNoHash.base0E}ff";
          maximizescreencolor = "0x${self.themeNoHash.base0B}ff";
          urgentcolor = "0x${self.themeNoHash.base08}ff";
          scratchpadcolor = "0x${self.themeNoHash.base0A}00";
          globalcolor = "0x${self.themeNoHash.base0E}ff";
          overlaycolor = "0x${self.themeNoHash.base0C}ff";


          windowrule = "isnamedscratchpad:1,width:1000,height:700,title:kitty-scratch";
 
          tag_num = 17;

          tagrule = map (id: "id:${toString id},layout_name:tile") (lib.range 1 17);

          bind = let 
              viewBinds = map (e: "${mod},${e.key},view,${toString e.ws}") wsKeys;
              tagBinds = map (e: "${mod}+SHIFT, ${e.key},tag,${toString e.ws}") wsKeys;
            in
              viewBinds++
              tagBinds
              ++[
                "${mod},space,spawn,${noctaliaExe} msg panel-toggle launcher"
                "${mod},Return,spawn,${config.terminal}"

                "${mod}+SHIFT,e,spawn,${noctaliaExe} msg panel-toggle session"
                "${mod},q,killclient"

                "${mod},h,focusdir,left"
                "${mod},l,focusdir,right"
                "${mod},k,focusdir,up"
                "${mod},j,focusdir,down"

                "${mod},Left,focusdir,left"
                "${mod},Right,focusdir,right"
                "${mod},Up,focusdir,up"
                "${mod},Down,focusdir,down"

                "${mod}+SHIFT,Up,exchange_client,up"
                "${mod}+SHIFT,Down,exchange_client,down"
                "${mod}+SHIFT,Left,exchange_client,left"
                "${mod}+SHIFT,Right,exchange_client,right"
                "${mod}+SHIFT,k,exchange_client,up"
                "${mod}+SHIFT,j,exchange_client,down"
                "${mod}+SHIFT,h,exchange_client,left"
                "${mod}+SHIFT,l,exchange_client,right"

                "${mod}+CTRL,h,resizewin,-50,+0"
                "${mod}+CTRL,l,resizewin,+50,+0"
                "${mod}+CTRL,k,resizewin,+0,-50"
                "${mod}+CTRL,j,resizewin,+0,+50"

                "${mod}+CTRL,Left,resizewin,-50,+0"
                "${mod}+CTRL,Right,resizewin,+50,+0"
                "${mod}+CTRL,Up,resizewin,+0,-50"
                "${mod}+CTRL,Down,resizewin,+0,+50"

                "${mod},t,toggleglobal"
                "ALT,Tab,toggleoverview"
                "${mod},f,togglemaximizescreen"
                "${mod}+shift,f,togglefloating"
                "${mod},g,togglefullscreen"
                "${mod},i,minimized"
                "${mod},o,toggleoverlay"
                "${mod}+SHIFT,I,restore_minimized"
                "${mod},s,toggle_scratchpad"
                "${mod}+SHIFT,Return,toggle_named_scratchpad,none,kitty-scratch,kitty -T kitty-scratch"

                "ALT,e,set_proportion,1.0"
                "ALT,x,switch_proportion_preset"

                "${mod},n,switch_layout"
                "${mod}+SHIFT,n,setlayout, tile"

                "${mod}+SHIFT,x,spawn,${noctaliaExe} msg session lock"

                "${mod}+CTRL,s,spawn,${screenshot}"
                "${mod}+SHIFT,s,spawn,${screenshotFull}"


                "${mod},d,spawn,${self.mkWhichKeyExe config.pkgs [
                  {
                    key = "b";
                    desc = "Bluetooth";
                    cmd = "${noctaliaExe} msg panel-toggle bluetooth";
                  }
                  {
                    key = "w";
                    desc = "Wifi";
                    cmd = "${noctaliaExe} msg panel-toggle wifi";
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
                ]}"
            ];


            mousebind = [
              "SUPER,btn_left,moveresize,curmove"
              "SUPER,btn_right,moveresize,curresize"
            ];
        };
    };


  };
  perSystem = {pkgs, ...}: {
    packages.mango = inputs.wrapper-modules.wrappers.mangowc.wrap {
      inherit pkgs;
      imports = [self.wrappersModules.mangowc];
    };
  };
}
