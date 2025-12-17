{
  imports = [./dashboard.nix];

  plugins.snacks = {
    enable = true;
    settings = {
      bigfile.enabled = true;
      notifier = {
        enabled = true;
        timeout = 3000;
      };
      bufdelete.enabled = true;
      image.enabled = true;
      quickfile.enabled = true;
      rename.enabled = true;
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
}
