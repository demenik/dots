{
  programs.nixvim = {
    plugins = {
      markdown-preview = {
        enable = true;
        settings = {
          auto_close = 0;
          page_title = "Markdown Preview";
        };
      };

      render-markdown = {
        enable = true;
        settings = {
          pipe_table.border = ["╭" "┬" "╮" "├" "┼" "┤" "╰" "┴" "╯" "│" "─"];
        };
      };
    };

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>m";
        group = "Markdown";
        icon = {
          icon = " ";
          color = "blue";
        };
      }
    ];
    keymaps = [
      {
        key = "<leader>mr";
        action = "<cmd>RenderMarkdown toggle<cr>";
        options.desc = "Toggle render";
      }
      {
        key = "<leader>mv";
        action = "<cmd>MarkdownPreviewToggle<cr>";
        options.desc = "Browser preview";
      }
    ];
  };
}
