{
  name = "ripgrep";

  modules = [../ai/.guidelines];

  home = {
    programs.ripgrep = {
      enable = true;
    };

    home.shellAliases = {
      grep = "rg";
    };

    ai.guidelines.sections.tools.text = ''
      - `grep` is aliased to `rg` (ripgrep). Use ripgrep syntax and flags; it is recursive by default and respects `.gitignore`.
    '';
  };
}
