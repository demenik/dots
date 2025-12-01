{pkgs, ...}: {
  plugins.luasnip = {
    enable = true;
    settings = {
      enable_autosnippets = true;
      store_selection_keys = "<Tab>";
    };
    fromVscode = [
      {
        lazyLoad = true;
        paths = pkgs.vimPlugins.friendly-snippets;
      }
    ];
  };

  extraConfigLua = let
    snippets = {
      nix = import ./nix;
    };

    escape = text: pkgs.lib.generators.toLua {} text;
    escapeLines = text: pkgs.lib.generators.toLua {} (pkgs.lib.strings.splitString "\n" text);

    escapeLua = pkgs.lib.escape ["\\" "\"" "\n"];

    generateSnippetBody = {
      template,
      placeholders ? {},
      delimiters ? "<>",
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

        placeholderEntries = pkgs.lib.attrsets.mapAttrsToList generatePlaceholderEntry placeholders;
        placeholderTable = "{ ${pkgs.lib.strings.concatStringsSep ", " placeholderEntries} }";
        delimitersTable = "{ delimiters = \"${escapeLua delimiters}\" }";
      in "fmt(${templateStr}, ${placeholderTable}, ${delimitersTable})";

    generateLanguageSnippets = langSnippets: let
      snippetEntries =
        pkgs.lib.attrsets.mapAttrsToList (
          name: definition: let
            snippetName = escapeLua name;
            snippetBody = generateSnippetBody definition;
          in "    s(\"${snippetName}\", ${snippetBody})"
        )
        langSnippets;
    in
      pkgs.lib.strings.concatStringsSep ",\n" snippetEntries;

    buildLuasnipConfig = snippets: let
      languageBlocks =
        pkgs.lib.attrsets.mapAttrsToList (
          langName: langSnippets: ''
            ls.add_snippets("${langName}", {
            ${generateLanguageSnippets langSnippets}
            })
          ''
        )
        snippets;

      allLanguageBlocks = pkgs.lib.strings.concatStringsSep "\n\n" languageBlocks;
    in ''
      local ls = require("luasnip")
      local s = ls.snippet
      local i = ls.insert_node
      local t = ls.text_node
      local fmt = require("luasnip.extras.fmt").fmt

      ${allLanguageBlocks}
    '';
  in
    buildLuasnipConfig snippets;
}
