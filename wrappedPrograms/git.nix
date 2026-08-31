{self, inputs, ...}: {
  flake.wrappersModules.git = {
    pkgs,
    ...
  }: { 
      settings = {
          user = {
            name = "Aapeli Rautiainen";
            email = "aapeli@rautiainen.info";
          };
          credential = {
            "https://github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
            "https://gist.github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
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
