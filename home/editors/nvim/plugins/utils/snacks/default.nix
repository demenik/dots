{
  imports = [./dashboard.nix];

  plugins.snacks = {
    enable = true;
    settings = {
      bigfile.enabled = true;
      notifier = {
        enabled = true;
        timeout = 3000;
        top_down = false;
      };
      bufdelete.enabled = true;
      image.enabled = true;
      quickfile.enabled = true;
      rename.enabled = true;
      gitbrowse = {
        enabled = true;
        url_patterns = {
          "gitlab%.uni-ulm%.de" = {
            branch = "/-/tree/{branch}";
            file = "/-/blob/{branch}/{file}#L{line_start}-{line_end}";
            permalink = "/-/blob/{commit}/{file}#L{line_start}-{line_end}";
            commit = "/-/commit/{commit}";
          };
          "gitea%.demenik%.dev" = {
            branch = "/src/branch/{branch}";
            file = "/src/branch/{branch}/{file}#L{line_start}-L{line_end}";
            permalink = "/src/commit/{commit}/{file}#L{line_start}-L{line_end}";
            commit = "/commit/{commit}";
          };
        };
      };
    };
  };

  extraConfigLuaPre =
    # lua
    ''
      if vim.env.PROF then
        require("snacks.profiler").startup {
          startup = {
            event = "VimEnter",
          },
        }
      end
    '';

  keymaps = [
    {
      mode = ["n" "v"];
      key = "<leader>gb";
      action.__raw = ''
        function()
          Snacks.gitbrowse()
        end
      '';
      options = {
        desc = "Git Browse (Open File)";
        silent = true;
      };
    }
    {
      key = "<leader>d";
      action.__raw = ''
        function()
          Snacks.bufdelete()
        end
      '';
      options.desc = "Delete buffer";
    }
    {
      key = "<leader>D";
      action.__raw = ''
        function()
          Snacks.bufdelete.all()
        end
      '';
      options.desc = "Delete all buffers";
    }
    {
      key = "<leader>z";
      action.__raw = ''
        function()
          Snacks.zen()
        end
      '';
      options.desc = "Zen Mode";
    }
  ];
}
