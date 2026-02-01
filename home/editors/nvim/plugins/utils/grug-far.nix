{
  plugins.grug-far.enable = true;

  keymaps = [
    {
      key = "<leader>r";
      action.__raw = ''
        function()
          require("grug-far").open()
        end
      '';
      options.desc = "Replace";
    }
  ];
}
