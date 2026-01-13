{
  home.shellAliases = {
    v = "nvim";
    c = "clear";
    cp = "cp -riv";
    zip = "zip -r";
    ssh = "kitten ssh";
    hm = "home-manager";

    "nix-shell" = "nix-shell --command zsh";

    zipx = "zip -x '*.direnv*' -x '*node_modules*' -x '*build*' -x '*target*' -x '*.git*' -x '*.DS_Store*' -r";
  };
}
