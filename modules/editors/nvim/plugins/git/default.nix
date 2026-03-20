{
  programs.nixvim = {
    plugins = {
      fugitive.enable = true;
      diffview.enable = true;
      gitmessenger = {
        enable = true;
        settings = {
          include_diff = "current";
          no_default_mappings = true;
        };
      };

      gitsigns = {
        enable = true;
        settings = {
          numhl = true;
          current_line_blame = true;
          signs = {
            add.text = "▎";
            change.text = "▎";
            delete.text = "";
            topdelete.text = "";
            changedelete.text = "▎";
            untracked.text = "▎";
          };
          signs_staged = {
            add.text = "▎";
            change.text = "▎";
            delete.text = "";
            topdelete.text = "";
            changedelete.text = "▎";
          };
        };
      };
    };

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>g";
        group = "Git";
      }
      {
        __unkeyed-1 = "<leader>gh";
        group = "Hunk";
      }
    ];
    keymaps = let
      gitsigns = key: action: desc: {
        key = "<leader>g${key}";
        action.__raw = "function() require('gitsigns').${action}() end";
        options.desc = desc;
      };
      gitsigns-hunk = key: action: desc: {
        key = "<leader>gh${key}";
        action.__raw = "function() require('gitsigns').${action}() end";
        options.desc = desc;
      };
    in [
      {
        key = "<leader>gm";
        action = "<cmd>GitMessenger<cr>";
        options.desc = "Show Message";
      }

      # Gitsigns
      (gitsigns "s" "stage_buffer" "Stage buffer")
      (gitsigns "R" "reset_buffer" "Reset buffer")
      (gitsigns "t" "toggle_signs" "Toggle signs")
      (gitsigns "n" "toggle_numhl" "Toggle numhl")
      (gitsigns "L" "toggle_linehl" "Toggle linehl")
      (gitsigns "d" "toggle_deleted" "Toggle deleted")

      # Hunk
      (gitsigns-hunk "s" "stage_hunk" "Stage")
      (gitsigns-hunk "r" "reset_hunk" "Reset")
      (gitsigns-hunk "v" "preview_hunk" "Preview")
      (gitsigns-hunk "u" "undo_stage_hunk" "Undo Stage")
      (gitsigns-hunk "d" "diffthis" "Diff this")

      {
        key = "<leader>ghn";
        action.__raw = "function() require('gitsigns').nav_hunk('next') end";
        options.desc = "Next";
      }
      {
        key = "<leader>ghp";
        action.__raw = "function() require('gitsigns').nav_hunk('prev') end";
        options.desc = "Previous";
      }
      {
        key = "<leader>ghD";
        action.__raw = "function() require('gitsigns').diffthis('~') end";
        options.desc = "Diff this";
      }
    ];
  };
}
