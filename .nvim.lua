local root_file = vim.fs.find({ "flake.nix" }, { upward = true })[1]
local root = root_file and vim.fs.dirname(root_file) or vim.fn.getcwd()

local function with_flake(expr)
  return '(let flake = builtins.getFlake "' .. root .. '"; in ' .. expr .. ")"
end

vim.lsp.config.nixd = {
  cmd = { "nixd" },
  root_dir = root,
  settings = {
    nixd = {
      nixpkgs = {
        expr = with_flake "import flake.inputs.nixpkgs { }",
      },
      options = {
        nixos = {
          expr = with_flake "flake.nixosConfigurations.desktop.options",
        },
        home_manager = {
          expr = with_flake 'flake.homeConfigurations."demenik@desktop".options',
        },
        nixvim = {
          expr = with_flake 'flake.homeConfigurations."demenik@desktop".options.programs.nixvim.type.getSubOptions []',
        },
      },
    },
  },
}

vim.lsp.enable "nixd"
