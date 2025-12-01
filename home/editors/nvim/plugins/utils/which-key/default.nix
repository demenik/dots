{pkgs, ...}: {
  extraPackages = with pkgs; [lazygit];

  plugins.which-key = {
    enable = true;
    settings = {
      preset = "helix"; # "classic" | "modern" | "helix"
      sort = ["manual"];
      win = {
        border = "rounded";
      };
      icon.mappings = false;
    };
  };

  extraConfigLua = builtins.readFile ./config.lua;
}
