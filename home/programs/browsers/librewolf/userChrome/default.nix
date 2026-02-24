let
  files = [
    ./hide-tabs.css
  ];

  contents = map (file: builtins.readFile file) files;
  combined = builtins.concatStringsSep "\n" contents;
in
  combined
