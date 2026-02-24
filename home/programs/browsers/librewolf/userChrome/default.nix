let
  files = [
    ./hide-nav.css
    ./hide-tabs.css
  ];

  contents = map (file: builtins.readFile file) files;
  combined = builtins.concatStringsSep "\n" contents;
in
  combined
