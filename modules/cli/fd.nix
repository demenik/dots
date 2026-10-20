{
  name = "fd";

  modules = [../ai/.guidelines];

  home = {
    programs.fd = {
      enable = true;
    };

    home.shellAliases = {
      find = "fd";
    };

    ai.guidelines.sections.tools.text = ''
      - `find` is aliased to `fd`. Use fd syntax (`fd <pattern> [path]`); POSIX `find` expressions like `-name` will not work. It respects `.gitignore` and skips hidden files unless `-H`/`-I` is given.
    '';
  };
}
