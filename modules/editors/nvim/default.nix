{
  name = "nvim";

  secrets = {
    wakatime = {
      description = "Content of .wakatime.cfg";
      requiredBy = "none";
    };

    gitlab = {
      description = "Gitlab Tokens as a map: <instance url> -> <token>";
      requiredBy = "none";
    };
  };

  home = {
    inputs,
    config,
    lib,
    ...
  }: {
    imports = [
      inputs.nixvim.homeModules.nixvim
      ./options.nix
      ./keymaps.nix
      ./autocmds.nix
      ./theme.nix
      ./plugins
    ];

    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      extraConfigLua =
        # lua
        ''
          -- Add filetypes
          vim.filetype.add({
            pattern = {
              [".*%.arb"] = "json",
              ["%.sqruff"] = "toml",
            },
          })

          -- Set up OSC 52
          if os.getenv("SSH_TTY") or os.getenv("SSH_CONNECTION") then
            local osc52 = require("vim.ui.clipboard.osc52")
            vim.g.clipboard = {
              name = "OSC 52",
              copy = {
                ["+"] = osc52.copy("+"),
                ["*"] = osc52.copy("*"),
              },
              paste = {
                ["+"] = osc52.paste("+"),
                ["*"] = osc52.paste("*"),
              },
            }
          end
        '';
    };

    xdg.desktopEntries.nvim = lib.mkIf (lib.hasAttr "terminal" config && config.terminal.command != null) {
      name = "Neovim";
      genericName = "Text Editor";
      exec = "${config.terminal.command} -e nvim %F";
      terminal = false;
      categories = ["Utility" "TextEditor"];
      mimeType = [
        "text/english"
        "text/plain"
        "text/x-makefile"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
        "application/x-shellscript"
        "text/x-c"
        "text/x-c++"
      ];
      icon = "nvim";
    };
  };
}
