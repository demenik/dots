{
  home.shellAliases = {
    v = "nvim";
    g = "git";
    c = "clear";
    cp = "cp -riv";
    zip = "zip -r";

    hm = "home-manager";

    zipx = "zip -x '*.direnv*' -x '*node_modules*' -x '*build*' -x '*target*' -x '*result*' -x '*.DS_Store*' -r";
  };

  ai.guidelines.sections.tools.text = ''
    - `cp` is aliased to `cp -riv`, which is recursive and prompts before overwriting. Use `command cp` (or `cp -f`) to avoid blocking on an interactive prompt.
  '';
}
