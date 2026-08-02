{
  pkgs,
  lib,
  ...
}: let
  flakeModule = import ./flake;
  snippets = flakeModule.programs.nixvim.snippets.nix;

  flakeSnippets =
    lib.attrsets.filterAttrs
    (trigger: _: lib.strings.hasPrefix "flake" trigger)
    snippets;

  shortName = trigger: let
    stripped = lib.strings.removePrefix "flake" trigger;
  in
    if stripped == ""
    then "default"
    else if stripped == "c#"
    then "csharp"
    else stripped;

  entries =
    lib.attrsets.mapAttrsToList (trigger: def: {
      inherit trigger;
      name = shortName trigger;
      inherit (def) template;
      hasPlaceholders = (def.placeholders or {}) != {};
    })
    flakeSnippets;

  # Templates without placeholders are written to disk directly, without
  # going through Neovim; this farm holds a copy of each, named by trigger.
  templatesDir = pkgs.linkFarm "flake-init-templates" (
    map (e: {
      name = e.trigger;
      path = pkgs.writeText e.trigger e.template;
    })
    entries
  );

  escapeBash = lib.strings.escape ["\\" "\""];

  triggerByName =
    lib.strings.concatMapStringsSep "\n" (
      e: "  [\"${escapeBash e.name}\"]=\"${escapeBash e.trigger}\""
    )
    entries;

  hasPlaceholdersByTrigger =
    lib.strings.concatMapStringsSep "\n" (
      e: "  [\"${escapeBash e.trigger}\"]=${
        if e.hasPlaceholders
        then "1"
        else "0"
      }"
    )
    entries;

  flakeInitScript =
    builtins.replaceStrings
    ["@triggerByName@" "@hasPlaceholdersByTrigger@" "@templatesDir@"]
    [triggerByName hasPlaceholdersByTrigger "${templatesDir}"]
    (builtins.readFile ./flake-init.sh);

  flakeInit = pkgs.writeShellApplication {
    name = "flake-init";
    runtimeInputs = with pkgs; [fzf coreutils gnugrep];
    text = flakeInitScript;
  };
in
  flakeModule
  // {
    home.packages = [flakeInit];
  }
