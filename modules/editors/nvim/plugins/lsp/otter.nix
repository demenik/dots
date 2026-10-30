{pkgs, ...}: {
  programs.nixvim = {
    plugins.otter = {
      enable = true;
      autoActivate = false;
      package = pkgs.vimPlugins.otter-nvim.overrideAttrs (old: {
        patches = (old.patches or []) ++ [./otter-gap-fillers.patch];
      });

      settings = {
        handle_leading_whitespace = true;

        # Treesitter excludes interpolations and escapes from injected Nix strings, which splits a
        # line into several regions. Join them again so shellcheck etc. see valid code.
        buffers.gap_fillers.nix.__raw =
          # lua
          ''
            function(gap, _, before, after)
              local placeholder = "_"
              if before:match("^%s*$") and after:match("^%s*$") then
                placeholder = " "
              end
              local out, i = {}, 1
              while i <= #gap do
                local interp = gap:match("^%$%b{}", i)
                if interp then
                  table.insert(out, placeholder:rep(#interp))
                  i = i + #interp
                elseif gap:sub(i, i + 2) == "\39\39\39" then
                  table.insert(out, "\39\39")
                  i = i + 3
                elseif gap:sub(i, i + 2) == "\39\39\\" and i + 3 <= #gap then
                  table.insert(out, "\\" .. gap:sub(i + 3, i + 3))
                  i = i + 4
                elseif gap:sub(i, i + 1) == "\39\39" then
                  i = i + 2
                elseif gap:sub(i, i) == "\\" then
                  local c = gap:sub(i + 1, i + 1)
                  table.insert(out, c == "" and "" or c:match('["$\\]') and c or "\\" .. c)
                  i = i + 2
                else
                  return nil
                end
              end
              return table.concat(out)
            end
          '';
      };
    };

    autoCmd = [
      {
        event = ["FileType"];
        pattern = ["markdown" "norg" "nix"];
        callback.__raw = ''
          function()
            require("otter").activate()
          end
        '';
      }
    ];
  };
}
