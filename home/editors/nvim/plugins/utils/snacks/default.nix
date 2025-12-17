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
      dashboard = import ./dashboard.nix;
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
