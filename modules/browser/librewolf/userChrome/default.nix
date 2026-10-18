{font}: let
  files = [
    ./adjust-nav.css
    ./hide-sidebar-launcher.css
    ./hide-tabs.css
    ./theme-buttons.css
    ./theme-menus.css
    ./theme-statuspanel.css
  ];

  contents = map (file: builtins.readFile file) files;
  combined = builtins.concatStringsSep "\n" contents;
in
  # css
  ''
    ${combined}

    * {
      font-family: "${font}", sans-serif !important;
    }
  ''
