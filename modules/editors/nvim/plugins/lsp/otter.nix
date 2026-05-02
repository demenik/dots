{
  programs.nixvim = {
    plugins.otter = {
      enable = true;
      autoActivate = false;

      settings = {
        handle_leading_whitespace = true;
      };
    };

    autoCmd = [
      {
        event = ["FileType"];
        pattern = ["markdown" "norg" "nix"];
        callback.__raw = ''
          function()
            require("otter").activate()
          end
        '';
      }
    ];
  };
}
