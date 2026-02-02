{
  programs.nixvim = {
    plugins.fzf-lua = {
      enable = true;
      settings = {
        winopts = {};
        files = {
          git_icons = true;
          file_icons = true;
        };
      };
    };

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>f";
        group = "FZF";
        icon = {
          icon = "󰍉 ";
          color = "purple";
        };
      }
      {
        __unkeyed-1 = "<leader>fg";
        group = "Git";
        icon = {
          icon = "󰊢 ";
          color = "orange";
        };
      }
      {
        __unkeyed-1 = "<leader>fL";
        group = "LSP";
        icon = {
          icon = " ";
          color = "orange";
        };
      }
    ];
    keymaps = let
      fzf = key: action: desc: {
        key = "<leader>f${key}";
        action.__raw = "function() require('fzf-lua').${action}() end";
        options.desc = desc;
      };
      fzf-git = key: action: desc: {
        key = "<leader>fg${key}";
        action.__raw = "function() require('fzf-lua').${action}() end";
        options.desc = desc;
      };
      fzf-lsp = key: action: desc: {
        key = "<leader>fL${key}";
        action.__raw = "function() require('fzf-lua').${action}() end";
        options.desc = desc;
      };
    in [
      (fzf "f" "files" "Files")
      (fzf "o" "oldfiles" "Old files")
      (fzf "l" "live_grep" "Live grep")
      (fzf "b" "buffers" "Buffers")
      (fzf "k" "keymaps" "Keymaps")
      (fzf "j" "jumps" "Jumps")
      (fzf "c" "commands" "Commands")
      (fzf "C" "colorschemes" "Colorschemes")
      (fzf "t" "tabs" "Tabs")
      (fzf "T" "treesitter" "Treesitter")
      (fzf "s" "spell_suggest" "Spelling suggest")

      (fzf-git "g" "git_files" "Files")
      (fzf-git "s" "git_status" "Status")
      (fzf-git "b" "git_bcommits" "Buffer commits")
      (fzf-git "B" "git_branches" "Branches")

      (fzf-lsp "r" "lsp_references" "References")
      (fzf-lsp "d" "lsp_definitions" "Definitions")
      (fzf-lsp "D" "lsp_declarations" "Declarations")
      (fzf-lsp "t" "lsp_typedefs" "Type definitions")
      (fzf-lsp "i" "lsp_implementations" "Implementations")
      (fzf-lsp "s" "lsp_document_symbols" "Symbols")
      (fzf-lsp "S" "lsp_workspace_symbols" "Workspace symbols")
      (fzf-lsp "I" "lsp_incoming_calls" "Incoming calls")
      (fzf-lsp "c" "lsp_code_actions" "Code actions")
      (fzf-lsp "f" "lsp_finder" "Finder")
      (fzf-lsp "o" "lsp_outgoing_calls" "Outgoing calls")
    ];
  };
}
