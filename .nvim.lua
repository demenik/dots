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
				expr = with_flake("import flake.inputs.nixpkgs { }"),
			},
			options = {
				nixos = {
					expr = with_flake("flake.nixosConfigurations.desktop.options"),
				},
				home_manager = {
					expr = with_flake('flake.homeConfigurations."demenik@desktop".options'),
				},

				flake_modules_module = {
					expr = with_flake(
						'(flake.inputs.nixpkgs.lib.evalModules { modules = [ "${flake.inputs.flake-modules}/lib/schemas/module.nix" ]; }).options'
					),
				},
				flake_modules_host = {
					expr = with_flake(
						'(flake.inputs.nixpkgs.lib.evalModules { modules = [ "${flake.inputs.flake-modules}/lib/schemas/host.nix" ]; }).options'
					),
				},
				flake_modules_user = {
					expr = with_flake(
						'(flake.inputs.nixpkgs.lib.evalModules { modules = [ "${flake.inputs.flake-modules}/lib/schemas/user.nix" ]; }).options'
					),
				},
			},
		},
	},
}

vim.lsp.enable("nixd")
