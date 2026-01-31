{
  programs.nixvim = {
    plugins = {
      nvim-tree = {
        enable = true;
        settings = {
          hijack_cursor = true;
          view.width = {
            min = 30;
            max = -1;
          };
          renderer = {
            group_empty = true;
            icons = {
              show.modified = true;
              glyphs.modified = "";
            };
            indent_markers.enable = true;
            highlight_git = "name";
          };
          modified = {
            enable = true;
            show_on_dirs = false;
          };
          update_focused_file.enable = true;
          filters.git_ignored = false;
        };
      };
    };

    highlight = rec {
      # Gitignore highlights
      NvimTreeGitFileIgnoredHL = {
        fg = "#585b70";
        italic = true;
      };
      NvimTreeGitFolderIgnoredHL = NvimTreeGitFileIgnoredHL;
      NvimTreeGitIgnoredIcon = {inherit (NvimTreeGitFileIgnoredHL) fg;};
    };
  };
}
