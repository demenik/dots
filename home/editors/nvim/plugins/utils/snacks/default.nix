{
  plugins.snacks = {
    enable = true;
    settings = {
      bigfile.enabled = true;
      notifier = {
        enabled = true;
        timeout = 3000;
      };
      bufdelete.enabled = true;
      image.enabled = true;
      quickfile.enabled = true;
      rename.enabled = true;
      dashboard = let
        themes = import ./themes.nix;
        theme = themes.dg_baby;
      in {
        enabled = true;
        preset = {
          inherit (theme) header;
          keys = [
            {
              icon = " ";
              key = "f";
              desc = "Find File";
              action = ":lua Snacks.dashboard.pick('files')";
            }
            {
              icon = " ";
              key = "n";
              desc = "New File";
              action = ":ene | startinsert";
            }
            {
              icon = " ";
              key = "l";
              desc = "Live Grep";
              action = ":lua Snacks.dashboard.pick('live_grep')";
            }
            {
              icon = " ";
              key = "o";
              desc = "Old Files";
              action = ":lua Snacks.dashboard.pick('oldfiles')";
            }
            {
              icon = " ";
              key = "q";
              desc = "Quit";
              action = ":qa";
            }
          ];
        };
        sections = [
          {section = "header";}
          {
            section = "keys";
            gap = 1;
            padding = 1;
          }
          {
            title = theme.quote;
            align = "center";
          }
        ];
      };
    };
  };

  extraConfigLua =
    # lua
    ''
      local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
      vim.api.nvim_create_autocmd("User", {
        pattern = "NvimTreeSetup",
        callback = function()
          local events = require("nvim-tree.api").events
          events.subscribe(events.Event.NodeRenamed, function(data)
            if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
              data = data
              Snacks.rename.on_rename_file(data.old_name, data.new_name)
            end
          end)
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "SnacksDashboardOpened",
        callback = function()
          if vim.bo.filetype == "snacks_dashboard" then
            vim.b.minitrailspace_disable = true
            vim.b.miniindentscope_disable = true
          end
        end,
      })
    '';
}
