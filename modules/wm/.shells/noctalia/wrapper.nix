{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;

  cfg = config.programs.noctalia-shell.wrapper;

  pythonEnv = pkgs.python3.withPackages (ps: cfg.pythonPackages);
  giTypelib = lib.makeSearchPath "lib/girepository-1.0" cfg.giPackages;

  pluginPatcher = pkgs.writeShellScript "noctalia-plugin-patcher" ''
    mkdir -p ~/.config/noctalia/plugins
    (
      cd ~/.config/noctalia/plugins || exit 0
      ${cfg.pluginPatches}
    )
  '';

  wrapArgs = [
    (
      let
        binPath = lib.makeBinPath (cfg.packages ++ [pythonEnv]);
      in
        if (cfg.packages ++ cfg.pythonPackages) != []
        then "--prefix PATH : ${binPath}"
        else ""
    )

    (
      if cfg.giPackages != []
      then "--prefix GI_TYPELIB_PATH : ${giTypelib}"
      else ""
    )

    (
      if cfg.pluginPatches != ""
      then "--run ${pluginPatcher}"
      else ""
    )
  ];
  finalArgs = lib.concatStringsSep " " (lib.filter (s: s != "") wrapArgs);

  wrappedPackage = pkgs.symlinkJoin {
    name = "noctalia-shell-wrapped";
    paths = [cfg.package];
    buildInputs = [pkgs.makeWrapper];

    postBuild = ''
      if [ -n "${finalArgs}" ]; then
        wrapProgram "$out"/bin/noctalia-shell ${finalArgs}
      fi

      ${cfg.extraPostBuild}
    '';

    meta.mainProgram = "noctalia-shell";
  };
in {
  options.programs.noctalia-shell.wrapper = {
    package = mkOption {
      type = types.package;
      default = pkgs.noctalia-shell;
      description = "The base package to wrap";
    };

    packages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "List of packages to include";
    };
    pythonPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "List of python packages to include";
    };
    giPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "List of packages to add to GI_TYPELIB_PATH";
    };

    extraPostBuild = mkOption {
      type = types.lines;
      default = "";
      description = "Custom shell commands to run during postBuild";
    };
    pluginPatches = mkOption {
      type = types.lines;
      default = "";
      description = "Custom shell commands to run inside ~/.config/noctalia/plugins at startup";
    };
  };

  config.programs.noctalia-shell.package = wrappedPackage;
}
