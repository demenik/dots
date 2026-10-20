{
  name = "eza";

  modules = [../ai/.guidelines];

  home = {
    programs.eza = {
      enable = true;
      enableZshIntegration = true;

      colors = "auto";
      extraOptions = [
        "--classify"
        "--group-directories-first"
      ];
    };

    home.shellAliases = {
      ls = "eza";
    };

    ai.guidelines.sections.tools.text = ''
      - `ls` is aliased to `eza --classify --group-directories-first`. Entries carry type suffixes (`/`, `*`, `@`), so do not parse its output as plain file names.
    '';
  };
}
