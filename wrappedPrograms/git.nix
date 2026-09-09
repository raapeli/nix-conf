{self, inputs, ...}: {
  flake.wrappersModules.git = {
    pkgs,
    ...
  }: { 
      settings = {
          user = {
            name = "Aapeli Rautiainen";
            email = "aapeli@rautiainen.info";
            signingkey = "~/.ssh/id_ed25519_sign.pub";
          };
          credential = {
            "https://github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
            "https://gist.github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
          };
          gpg = {
            format = "ssh";
            ssh.allowedSignersFile = "~/.config/git/allowed_signers";
          };
          commit = {
            gpgsign = true;
          };
        };

    };
  perSystem = {pkgs, ...}: {
    packages.git = inputs.wrapper-modules.wrappers.git.wrap {
      inherit pkgs;
      imports = [self.wrappersModules.git];
    };
  };
}
