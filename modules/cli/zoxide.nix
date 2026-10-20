{
  name = "zoxide";

  modules = [../ai/.guidelines];

  home = {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    home.shellAliases = {
      cd = "z";
    };

    ai.guidelines.sections.tools.text = ''
      - `cd` is aliased to `z` (zoxide). Always pass explicit, existing paths; a non-existent argument is treated as a fuzzy query and may jump to an unrelated directory.
    '';
  };
}
