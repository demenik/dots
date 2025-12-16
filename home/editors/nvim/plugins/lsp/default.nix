{
  imports = [
    ./servers.nix
    ./lint.nix
    ./otter.nix
    ./lazydev.nix
  ];

  programs.nixvim = {
    plugins = {
      lspkind = import ./lspkind.nix;
      lspconfig.enable = true;
      trouble.enable = true;
      tiny-inline-diagnostic = {
        enable = true;
        settings.options.multilines.enabled = true;
      };
    };

    keymaps = let
      trouble-lsp = key: action: {
        mode = "";
        inherit key;
        options.desc = action;
        action = "<cmd>Trouble lsp_${action}<cr>";
      };
    in [
      {
        mode = "";
        key = "K";
        options.desc = "Hover";
        action = "<cmd>Lspsaga hover_doc<cr>";
      }

      (trouble-lsp "gd" "definitions")
      (trouble-lsp "gr" "references")
      (trouble-lsp "gi" "implementations")
    ];
  };
}
