{
  name = "ai-guidelines";

  imports = [./sections.nix];

  home = {
    lib,
    config,
    ...
  }: {
    options.ai.guidelines = with lib; {
      header = mkOption {
        type = types.lines;
        default = "# Agent Behavior and Workflow Guidelines";
        description = "Text placed above all guideline sections.";
      };

      sections = mkOption {
        description = ''
          Guideline topics, stitched together into one markdown file. Multiple modules
          may contribute to the same topic, their text is joined line by line. Sections
          are sorted by 'order', then by name, and numbered on render. Empty sections
          are omitted.
        '';
        default = {};
        type = types.attrsOf (types.submodule ({name, ...}: {
          options = {
            title = mkOption {
              type = types.str;
              default = name;
              description = "Section heading.";
            };
            order = mkOption {
              type = types.int;
              default = 1000;
              description = "Sort key; lower values come first.";
            };
            text = mkOption {
              type =
                types.lines
                // {
                  merge = _: defs: concatMapStringsSep "\n" (d: trim d.value) defs;
                };
              default = "";
              description = "Markdown body of the section.";
            };
          };
        }));
      };

      text = mkOption {
        type = types.str;
        readOnly = true;
        description = "Rendered guidelines markdown, to be written by each AI CLI module.";
      };
    };

    config.ai.guidelines.text = let
      cfg = config.ai.guidelines;
      sections =
        lib.sort (
          a: b:
            if a.order == b.order
            then a.name < b.name
            else a.order < b.order
        ) (lib.filter (s: lib.trim s.text != "") (
          lib.mapAttrsToList (name: s: s // {inherit name;}) cfg.sections
        ));
      rendered = lib.imap1 (i: s: "## ${toString i}. ${s.title}\n${lib.trim s.text}") sections;
    in
      lib.concatStringsSep "\n\n" ([(lib.trim cfg.header)] ++ rendered) + "\n";
  };
}
