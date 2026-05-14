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
  };

  config.programs.noctalia-shell.package = wrappedPackage;
}
