{
  name = "bat";

  modules = [../ai/.guidelines];

  overlays.home = [
    (final: prev: {
      bat-theme-catppuccin = final.fetchFromGitHub {
        owner = "catppuccin";
        repo = "bat";
        rev = "6810349b28055dce54076712fc05fc68da4b8ec0";
        sha256 = "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
      };
    })
  ];

  home = {pkgs, ...}: {
    programs.bat = {
      enable = true;
      config.theme = "Catppuccin Mocha";
      themes = {
        "Catppuccin Mocha" = {
          src = pkgs.bat-theme-catppuccin;
          file = "themes/Catppuccin Mocha.tmTheme";
        };
      };
    };

    home.shellAliases = {
      cat = "bat";
    };

    ai.guidelines.sections.tools.text = ''
      - `cat` is aliased to `bat`. When piped it behaves like plain `cat`; use `bat -p` for undecorated output in a terminal.
    '';
  };
}
