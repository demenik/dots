{
  home = {pkgs, ...}: {
    programs.herdr = {
      plugins = [
        {
          package = pkgs.fetchFromGitHub {
            owner = "ntindle";
            repo = "herdr-resurrect";
            rev = "5afa6755d4f35c62c7522ba4fd04922d1ac69602";
            hash = "sha256-t4HCaLy2yWkeuvDovFTRdG0jQvlyKf5Z+u5UIU3xvts=";
          };
          runtimeInputs = with pkgs; [nodejs fzf jq bash procps];
        }
      ];

      settings.keys.command = [
        {
          key = "prefix+ctrl+s";
          type = "plugin_action";
          command = "ntindle.herdr-resurrect.save";
          description = "Resurrect: save snapshot";
        }
        {
          key = "prefix+ctrl+r";
          type = "plugin_action";
          command = "ntindle.herdr-resurrect.restore";
          description = "Resurrect: restore last snapshot";
        }
      ];
    };
  };
}
