{pkgs, ...}: let
  silicon-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "silicon.nvim";
    version = "12-03-2024";
    src = pkgs.fetchFromGitHub {
      owner = "krivahtoo";
      repo = "silicon.nvim";
      rev = "d8a6852b7158cc98f44ab12a0811ccf7d111dc71";
      hash = "sha256-3ABUsfJpb6RO6AiuuSL5gwDofJIwC5tlEMzBrlY9/s0=";
    };
  };
  theme =
    pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "sublime-text";
      rev = "3d8625d937d89869476e94bc100192aa220ce44a";
      hash = "sha256-3ABUsfJpb6RO6AiuuSL5gwDofJIwC5tlEMzBrlY9/s0=";
    }
    + "/Mocha.tmTheme";
  font = "JetBrainsMono Nerd Font=16;Noto Color Emoji=16";
in {
  extraPackages = with pkgs; [
    silicon
    jetbrains-mono
    noto-fonts-color-emoji
  ];

  extraPlugins = [silicon-nvim];

  extraConfigLua =
    # lua
    ''
      require("silicon").setup {
        font = "${font}",
        theme = "${theme}",
        window_controls = false,
        output = {
          path = "~/Downloads",
        },
      }
    '';
}
