{
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;

    settings = fromTOML (builtins.readFile ./theme.omp.toml);
  };
}
