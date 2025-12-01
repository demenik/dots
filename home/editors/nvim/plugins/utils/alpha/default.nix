let
  themes = import ./themes.nix;
  theme = themes.dg_baby;
in {
  plugins.alpha = {
    enable = true;
    settings = {
      layout = [
        {
          type = "padding";
          val = 2;
        }
        {
          type = "text";
          val = theme.image;
          opts = {
            position = "center";
            hl = "Type";
          };
        }
        {
          type = "padding";
          val = 2;
        }
        {
          type = "group";
          val = let
            button = shortcut: val: {
              type = "button";
              inherit val;
              opts = {
                position = "center";
                inherit shortcut;
                cursor = 3;
                width = 50;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
              };
            };
          in [
            (button "󱁐 ff" "󰱼 Find file")
            (button "󱁐 fo" "󱋡 Recently opened files")
            (button "󱁐 fl" " Live-Grep")
          ];
        }
        {
          type = "padding";
          val = 2;
        }
        {
          type = "text";
          val = theme.quote;
          opts = {
            position = "center";
            hl = "Keyword";
          };
        }
      ];
    };
  };
}
