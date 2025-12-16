local wk = require "which-key"
local gitsigns = require "gitsigns"
local Terminal = require("toggleterm.terminal").Terminal

local set_key = {
	cmd = function(key, action, desc, hidden)
		return {
			"<leader>" .. key,
			type(action) == "string" and "<cmd>" .. action .. "<cr>" or action,
			desc = desc:gsub("^%l", string.upper),
			hidden = hidden or false,
		}
	end,
}

local function smart_buffer_delete()
  local current_buf = vim.api.nvim_get_current_buf()
  pcall(vim.cmd.bnext)
  if current_buf == vim.api.nvim_get_current_buf() then
    vim.cmd.enew()
  end
  pcall(vim.cmd, "bdelete " .. current_buf)
end

wk.add {
	set_key.cmd("e", require("nvim-tree.api").tree.toggle, "Files"),
	set_key.cmd("w", "w!", "Write buffer"),
	set_key.cmd("d", smart_buffer_delete, "Delete buffer"),
	set_key.cmd("Q", "qa", "Quit all", true),
	set_key.cmd("q", "quit", "Quit window", true),
}

set_key.git_signs = function(key, action, desc)
	return set_key.cmd("g" .. key, function()
		gitsigns[action]()
	end, desc)
end

local function lazygit_toggle()
	local lazygit = Terminal:new {
		cmd = "lazygit",
		hidden = true,
		direction = "float",
	}
	lazygit:toggle()
end

wk.add {
	{ "<leader>g", group = "Git" },

	-- Gitsigns --
	set_key.git_signs("s", "stage_buffer", "Stage buffer"),
	set_key.git_signs("R", "reset_buffer", "Reset buffer"),
	set_key.git_signs("t", "toggle_signs", "Toggle signs"),
	set_key.git_signs("n", "toggle_numhl", "Toggle numhl"),
	set_key.git_signs("L", "toggle_linehl", "Toggle linehl"),
	set_key.git_signs("d", "toggle_deleted", "Toggle deleted"),

	set_key.cmd("gg", lazygit_toggle, "Lazygit"),
	set_key.cmd("gH", "GhActions", "Github Actions"),
	set_key.cmd("gm", "GitMessenger", "Show Message"),

	{ "<leader>gh", group = "Hunk" },

	set_key.git_signs("hs", "stage_hunk", "Stage"),
	set_key.git_signs("hr", "reset_hunk", "Reset"),
	set_key.git_signs("hv", "preview_hunk", "Preview"),
	set_key.git_signs("hu", "undo_stage_hunk", "Undo Stage"),
	set_key.cmd("ghn", function()
		gitsigns.nav_hunk "next"
	end, "Next"),
	set_key.cmd("ghp", function()
		gitsigns.nav_hunk "prev"
	end, "Previous"),
	set_key.git_signs("hd", "diffthis", "Diff this"),
	set_key.cmd("ghD", function()
		gitsigns.diffthis "~"
	end, "Diff this"),
}

--- LSP keys ---
set_key.lsp = function(key, action)
	return set_key.cmd("l" .. key, "Lsp" .. action, action)
end
wk.add {
	{ "<leader>l", group = "Lsp" },
	set_key.lsp("i", "Info"),
	set_key.lsp("R", "Restart"),
	set_key.lsp("s", "Start"),
	set_key.lsp("x", "Stop"),
	set_key.cmd("lf", require("conform").format, "Format"),
	set_key.cmd("lF", "ConformInfo", "Format"),

  set_key.cmd("lr", vim.lsp.buf.rename, "Rename"),
  set_key.cmd("lo", vim.lsp.buf.document_symbol, "Outline"),
  set_key.cmd("la", vim.lsp.buf.code_action, "Code Action"),
}

--- FZF keys ---
set_key.fzf = function(key, action, desc)
	return set_key.cmd("f" .. key, function()
		local fzf = require "fzf-lua"
		fzf[action]()
	end, desc or action)
end

wk.add {
	{ "<leader>f", group = "FZF" },
	set_key.fzf("f", "files", "Files"),
	set_key.fzf("o", "oldfiles", "Old files"),
	set_key.fzf("l", "live_grep", "Live grep"),
	set_key.fzf("b", "buffers", "Buffers"),
	set_key.fzf("k", "keymaps", "Keymaps"),
	set_key.fzf("j", "jumps", "Jumps"),
	set_key.fzf("c", "commands", "Commands"),
	set_key.fzf("C", "colorschemes", "Colorschemes"),
	set_key.fzf("t", "tabs", "Tabs"),
	set_key.fzf("T", "treesitter", "Treesitter"),
	-- set_key.cmd("fh", "FzfHarpoon", "Harpoon"),
	set_key.fzf("s", "spell_suggest", "Spelling suggest"),

	{ "<leader>fg", group = "Git" },
	set_key.fzf("gg", "git_files", "Files"),
	set_key.fzf("gs", "git_status", "Status"),
	set_key.fzf("gb", "git_bcommits", "Buffer commits"),
	set_key.fzf("gB", "git_branches", "Branches"),

	{ "<leader>fL", group = "LSP" },
	set_key.fzf("Lr", "lsp_references", "References"),
	set_key.fzf("Ld", "lsp_definitions", "Definitions"),
	set_key.fzf("LD", "lsp_declarations", "Declarations"),
	set_key.fzf("Lt", "lsp_typedefs", "Type definitions"),
	set_key.fzf("Li", "lsp_implementations", "Implementations"),
	set_key.fzf("Ls", "lsp_document_symbols", "Symbols"),
	set_key.fzf("LS", "lsp_workspace_symbols", "Workspace symbols"),
	-- set_key.fzf("LS", "lsp_live_workspace_symbols", "Live workspace symbols"),
	set_key.fzf("LI", "lsp_incoming_calls", "Incoming calls"),
	set_key.fzf("Lc", "lsp_code_actions", "Code actions"),
	set_key.fzf("Lf", "lsp_finder", "Finder"),
	set_key.fzf("Lo", "lsp_outgoing_calls", "Outgoing calls"),
	-- set_key.fzf("LD", "diagnostics_document", "Diagnostics document"),
	-- set_key.fzf("LD", "diagnostics_workspace", "Diagnostics workspace"),
}

set_key.trouble = function(key, action, desc)
	return set_key.cmd("x" .. key, "Trouble " .. action .. " focus=true win.position=bottom", desc)
end
wk.add {
	{ "<leader>x", group = "Trouble" },
	set_key.trouble("x", "diagnostics filter.buf=0", "Buffer Diagnostics"),
	set_key.trouble("X", "diagnostics", "Diagnostics"),
	set_key.trouble("t", "todo", "Todo"),
	set_key.trouble("q", "qflist", "QuickFix List"),
	set_key.trouble("L", "loclist", "Location List"),
  set_key.cmd("xv", "TinyInlineDiag toggle", "Toggle virtual text"),

	--- LSP ---
	set_key.trouble("l", "lsp", "LSP"),
	set_key.trouble("D", "lsp_declarations", "declarations"),
	set_key.trouble("d", "lsp_definitions", "definitions"),
	set_key.trouble("s", "symbols", "Symbols"),
	set_key.trouble("i", "lsp_implementations", "implementations"),
	set_key.trouble("I", "lsp_incoming_calls", "Incoming calls"),
	set_key.trouble("O", "lsp_outgoing_calls", "Outgoing calls"),
	set_key.trouble("r", "lsp_references", "references"),
	set_key.trouble("T", "lsp_type_definitions", "type definitions"),
}

set_key.latex = function(key, action)
	return set_key.cmd("L" .. key, "Vimtex" .. action, action)
end

wk.add {
	{ "<leader>m", group = "Markdown" },
	set_key.cmd("mr", "RenderMarkdown toggle", "Toggle render"),
	set_key.cmd("mv", "MarkdownPreviewToggle", "Browser preview"),

	--- Snap (Silicon) --
	{ "<leader>S", group = "Snap(Silicon)" },
	set_key.cmd("Ss", require("silicon").file, "Save as file"),
	set_key.cmd("Sc", require("silicon").clip, "Copy to clipboard"),

	--- Latex (Vimtex) --
	{ "<leader>L", group = "Latex" },
	set_key.latex("v", "View"),
	set_key.latex("e", "Errors"),
	set_key.latex("r", "Reload"),
	set_key.latex("c", "Compile"),

	set_key.cmd("r", require("grug-far").open, "Replace"),
	set_key.cmd("z", function()
		vim.wo.number = false
		require("zen-mode").toggle()
	end, "Zen Mode"),
	set_key.cmd("u", "UndotreeToggle", "Undo Tree"),
	set_key.cmd("H", "HexokinaseToggle", "Hexokinase"),
}

wk.add {
  { "<leader>t", group = "Debugging" },
  --- dap ---
  set_key.cmd("tb", "DapToggleBreakpoint", "Toggle Breakpoint"),
  set_key.cmd("td", "DapContinue", "Continue Debug Session"),
  set_key.cmd("tD", "DapNew", "New Debug Session"),
  set_key.cmd("ts", "DapStepInto", "Step Into"),
  set_key.cmd("tS", "DapStepOver", "Step Over"),
  set_key.cmd("tr", function()
    require("dap").repl.toggle()
  end, "Toggle Debug REPL"),

  --- neotest ---
  set_key.cmd("tt", function()
    require("neotest").run.run()
  end, "Run nearest test"),
  set_key.cmd("tT", function()
    require("neotest").run.run({strategy = "dap"})
  end, "Debug nearest test"),
  set_key.cmd("ta", function()
    require("neotest").run.run(vim.fn.expand("%"))
  end, "Run all tests in file"),
}
