let
  files = [
    ./adjust-nav.css
    ./hide-tabs.css
    ./theme-buttons.css
  ];

  contents = map (file: builtins.readFile file) files;
  combined = builtins.concatStringsSep "\n" contents;
in
  combined
