{
  plugins = {
    markdown-preview = {
      enable = true;
      settings = {
        auto_close = 0;
        browser = "firefox";
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
}
