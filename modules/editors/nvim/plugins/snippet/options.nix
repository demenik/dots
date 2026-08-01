{
  lib,
  config,
  ...
}: let
  escape = text: lib.generators.toLua {} text;
  escapeLines = text: lib.generators.toLua {} (lib.strings.splitString "\n" text);

  escapeLua = lib.escape ["\\" "\"" "\n"];

  generateSnippetBody = {
    template,
    placeholders,
    delimiters,
    ...
  }:
    if placeholders == {}
    then "t(${escapeLines template})"
    else let
      templateStr = escape template;

      generatePlaceholderEntry = index: defaultValue: let
        node =
          if defaultValue == null
          then "i(${index})"
          else "i(${index}, \"${escapeLua defaultValue}\")";
      in "[${index}] = ${node}";

      placeholderEntries = lib.attrsets.mapAttrsToList generatePlaceholderEntry placeholders;
      placeholderTable = "{ ${lib.strings.concatStringsSep ", " placeholderEntries} }";
      delimitersTable = "{ delimiters = \"${escapeLua delimiters}\", repeat_duplicates = true }";
    in "fmt(${templateStr}, ${placeholderTable}, ${delimitersTable})";

  generateLanguageSnippets = langSnippets:
    lib.strings.concatStringsSep ",\n" (
      lib.attrsets.mapAttrsToList (
        trigger: definition: "    s(\"${escapeLua trigger}\", ${generateSnippetBody definition})"
      )
      langSnippets
    );

  languageBlocks =
    lib.attrsets.mapAttrsToList (
      langName: langSnippets: ''
        ls.add_snippets("${escapeLua langName}", {
          ${generateLanguageSnippets langSnippets}
        })
      ''
    )
    (lib.attrsets.filterAttrs (_: langSnippets: langSnippets != {}) config.snippets);
in {
  options.snippets = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrsOf (lib.types.submodule {
      options = {
        template = lib.mkOption {
          type = lib.types.str;
          description = "Snippet body, usually `builtins.readFile ./some-file`.";
        };

        placeholders = lib.mkOption {
          type = lib.types.attrsOf (lib.types.nullOr lib.types.str);
          default = {};
          description = ''
            Insert nodes keyed by the index used in the template, e.g. `<1>`.
            A `null` value produces a stop with no default text. When empty,
            the template is inserted verbatim and no index is interpreted.
          '';
        };

        delimiters = lib.mkOption {
          type = lib.types.str;
          default = "<>";
          description = "Opening and closing delimiter surrounding a placeholder index.";
        };
      };
    }));
    default = {};
    description = ''
      LuaSnip snippets, keyed by filetype and then by trigger.
      Note that a literal opening delimiter must be doubled in a template.
    '';
  };

  config.extraConfigLua = lib.mkIf (languageBlocks != []) (
    # lua
    ''
      local ls = require("luasnip")
      local s = ls.snippet
      local i = ls.insert_node
      local t = ls.text_node
      local fmt = require("luasnip.extras.fmt").fmt

      ${lib.strings.concatStringsSep "\n" languageBlocks}
    ''
  );
}
