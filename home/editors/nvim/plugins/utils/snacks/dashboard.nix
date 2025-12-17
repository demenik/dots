let
  themes = import ./themes.nix;
  theme = themes.dg_baby;
in {
  enabled = true;
  preset = {
    inherit (theme) header;
    keys = [
      {
        icon = " ";
        key = "f";
        desc = "Find File";
        action = ":lua Snacks.dashboard.pick('files')";
      }
      {
        icon = " ";
        key = "n";
        desc = "New File";
        action = ":ene | startinsert";
      }
      {
        icon = " ";
        key = "l";
        desc = "Live Grep";
        action = ":lua Snacks.dashboard.pick('live_grep')";
      }
      {
        icon = " ";
        key = "o";
        desc = "Old Files";
        action = ":lua Snacks.dashboard.pick('oldfiles')";
      }
      {
        icon = " ";
        key = "q";
        desc = "Quit";
        action = ":qa";
      }
    ];
  };
  sections = [
    {section = "header";}
    {
      section = "keys";
      gap = 1;
      padding = 1;
    }
    {
      title = theme.quote;
      align = "center";
    }
  ];
}
