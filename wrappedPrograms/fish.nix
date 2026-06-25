{
  self,
  inputs,
  ...
}: {
  flake.wrappersModules.fish = {
    config,
    lib,
    pkgs,
    ...
  }: {
    config = {
      flags."--no-config" = false;

      configFile.content = ''
        function fish_prompt
            string join "" -- (set_color red) "[" (set_color yellow) $USER (set_color green) "@" (set_color blue) $hostname (set_color magenta) " " $(prompt_pwd) (set_color red) ']' (set_color normal) "\$ "
        end

        set fish_greeting
        set fish_color_autosuggestion 555
        fish_vi_key_bindings

        ${lib.getExe pkgs.zoxide} init fish --cmd cd | source

        function lf --wraps="lf" --description="lf - Terminal file manager (changing directory on exit)"
            cd "$(command lf -print-last-dir $argv)"
        end

        function vim --description="nvim locally, vim on remote"
            if set -q SSH_TTY
                command vim $argv
            else
                command nvim $argv
            end
        end

        function npi --description="Open config to add a package declaratively"
            nvim ~aapeli/mynix/nixos/hosts/nixos/configuration.nix +163
        end

        function nfu --description="Update nix flake"
            set -l prev (pwd)
            cd ~aapeli/mynix; and nix flake update; or begin; cd $prev; return 1; end
            cd $prev
        end

        function nru --description="Update nix flake and rebuild switch"
            set -l prev (pwd)
            cd ~aapeli/mynix; and nix flake update; or begin; cd $prev; return 1; end
            sudo nixos-rebuild switch --flake ~aapeli/mynix; or begin; cd $prev; return 1; end
            cd $prev
        end

        function nixup --description="Alias for nru"
            nru $argv
        end

        if type -q direnv
            direnv hook fish | source
        end
      '';

      shellAliases = {
        g = "git";
        ga = "git add";
        gaa = "git add --all";
        gapa = "git add --patch";
        gb = "git branch";
        gba = "git branch -a";
        gbd = "git branch -d";
        gbD = "git branch -D";
        gbl = "git blame -b -w";
        gbr = "git branch --remote";
        gc = "git commit -v";
        "gc!" = "git commit -v --amend";
        gca = "git commit -v -a";
        "gca!" = "git commit -v -a --amend";
        gcb = "git checkout -b";
        gcl = "git clone --recurse-submodules";
        gclean = "git clean -id";
        gcm = "git checkout main";
        gcmsg = "git commit -m";
        gco = "git checkout";
        gd = "git diff";
        gdca = "git diff --cached";
        gds = "git diff --staged";
        gf = "git fetch";
        gfa = "git fetch --all --prune";
        gfo = "git fetch origin";
        gl = "git pull";
        glg = "git log --stat --oneline";
        glgg = "git log --graph --oneline";
        glgga = "git log --graph --oneline --all";
        glo = "git log --oneline --decorate";
        glog = "git log --oneline --decorate --graph";
        gloga = "git log --oneline --decorate --graph --all";
        gm = "git merge";
        gmtl = "git mergetool --no-prompt";
        gp = "git push";
        gpd = "git push --dry-run";
        gpf = "git push --force-with-lease";
        "gpf!" = "git push --force";
        gpoat = "git push origin --all && git push origin --tags";
        gpr = "git pull --rebase";
        gpristine = "git reset --hard && git clean -dffx";
        gpsup = "git push --set-upstream origin (git branch --show-current)";
        gr = "git remote";
        gra = "git remote add";
        grb = "git rebase";
        grba = "git rebase --abort";
        grbc = "git rebase --continue";
        grbi = "git rebase -i";
        grbm = "git rebase main";
        grbo = "git rebase --onto";
        grbs = "git rebase --skip";
        grev = "git revert";
        grh = "git reset HEAD";
        grhh = "git reset HEAD --hard";
        grmv = "git remote rename";
        grrm = "git remote remove";
        grset = "git remote set-url";
        gru = "git reset --";
        grup = "git remote update";
        grv = "git remote -v";
        gs = "git status";
        gsa = "git stash apply";
        gsh = "git show";
        gsi = "git submodule init";
        gss = "git status -s";
        gst = "git stash";
        gsta = "git stash apply";
        gstc = "git stash clear";
        gstd = "git stash drop";
        gstl = "git stash list";
        gstp = "git stash pop";
        gsts = "git stash show --text";
        gsu = "git submodule update";
        gsw = "git switch";
        gswc = "git switch -c";
        gts = "git tag -s";
        gup = "git pull --rebase";
        gwch = "git whatchanged";
        wtf = "git-wtf";

        # Nix/NixOS
        nrs = "sudo nixos-rebuild switch --flake ~aapeli/mynix";
        nrt = "sudo nixos-rebuild test --flake ~aapeli/mynix";
        nrb = "sudo nixos-rebuild boot --flake ~aapeli/mynix";
        nrc = "sudo nix-collect-garbage -d";

      };

      runtimePkgs = [pkgs.zoxide];
    };
  };

  perSystem = {pkgs, ...}: {
    packages.fish = inputs.wrapper-modules.wrappers.fish.wrap {
      inherit pkgs;
      imports = [self.wrappersModules.fish];
    };
  };
}
