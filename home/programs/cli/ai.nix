{pkgs, ...}: {
  home.packages = with pkgs; [
    gemini-cli
  ];

  home.file = {
    ".gemini/settings.json".text = builtins.toJSON {
      general = {
        vimMode = false;
        preferredEditor = "neovim";
        disableAutoUpdate = true;
        disableUpdateNag = true;
        previewFeatures = true;
        enablePromptCompletion = true;
      };
      security.auth.selectedType = "oauth-personal";
      ui = {
        # theme = "Catppuccin Mocha";
        # customThemes."Catppuccin Mocha" = builtins.fromJSON (builtins.readFile (pkgs.fetchurl {
        #   url = "https://raw.githubusercontent.com/catppuccin/gemini-cli/refs/heads/main/themes/catppuccin-mocha.json";
        #   hash = "sha256-BL4tR3cxM5nG3Hws5OaYbYQOvB4XLYN6uNFkXWIp1nU=";
        # }));
        footer.hideSandboxStatus = true;
        useAlternateBuffer = true;
      };
      output = {
        format = "text";
      };
      privacy.usageStatisticsEnabled = false;
      telemetry.enabled = false;
      tools.shell.showColor = true;
    };
  };
}
