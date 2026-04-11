{
  name = "gemini-cli";

  modules = [./default.nix];

  home = {pkgs, ...}: {
    home.packages = [pkgs.gemini-cli];

    home.file.".gemini/settings.json".text = builtins.toJSON {
      general = {
        vimMode = false;
        preferredEditor = "nvim";
        disableAutoUpdate = true;
        disableUpdateNag = true;
        previewFeatures = true;
      };

      security.auth.selectedType = "oauth-personal";

      ui = {
        theme = "Catppuccin Mocha";
        customThemes."Catppuccin Mocha" = builtins.fromJSON (builtins.readFile (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/gemini-cli/refs/heads/main/themes/catppuccin-mocha.json";
          hash = "sha256-dRD5ixkbdRgnejWkLSzSnBWzlQap4Kz18n49NtXQfU4=";
        }));

        footer.hideSandboxStatus = true;
        useAlternateBuffer = true;
      };

      output.format = "text";

      privacy.usageStatisticsEnabled = false;
      telemetry.enabled = false;
      tools.shell.showColor = true;
    };
  };
}
