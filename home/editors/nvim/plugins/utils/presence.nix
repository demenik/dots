{
  plugins.presence = {
    enable = true;
    settings = {
      neovim_image_text = "Neovim";
      main_image = "file";
      buttons.__raw = ''
        function (buffer, repo_url)
          local buttons = {}

          if repo_url ~= nil then
            table.insert(buttons, {
              label = "Git Repository",
              url = repo_url
            })
          end

          return buttons
        end
      '';
    };
  };
}
