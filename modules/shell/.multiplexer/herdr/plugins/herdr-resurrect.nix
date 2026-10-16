{
  overlays.home = [
    (final: prev: {
      herdr-resurrect = final.fetchFromGitHub {
        owner = "ntindle";
        repo = "herdr-resurrect";
        rev = "109a9376549e29646c77fdfb7ed8ba456a9d6617";
        hash = "sha256-nFffAoY+PE1hwHMK1jBgLUFHcgLzS+3KO/kIN8u6W/o=";
      };
    })
  ];

  home = {pkgs, ...}: {
    programs.herdr = {
      plugins = [
        {
          package = pkgs.herdr-resurrect;
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
