{
  pkgs,
  lib,
  ...
}: let
  packages = p:
    with p; [
      # defaults
      pynvim
      jupyter-client
      cairosvg
      ipython
      nbformat
      ipykernel

      # optional
      (pnglatex.overridePythonAttrs (old: {
        postPatch =
          (old.postPatch or "")
          + ''
            substituteInPlace pnglatex/pnglatex.py \
              --replace-fail "with Path(jobname + suffix) as p:" "for p in [Path(jobname + suffix)]:"

            substituteInPlace pnglatex/pnglatex.py \
              --replace-fail 'with Path(output) as o:' 'for o in [Path(output)]:'

            substituteInPlace pnglatex/pnglatex.py \
              --replace-fail \
              'popen(pnm2png, stdin=ppm.stdout, out=f) as png:' \
              'popen("pnminvert", stdin=ppm.stdout, out=PIPE) as inv, popen(pnm2png, "-transparent", "black", stdin=inv.stdout, out=f) as png:'
          '';
      }))
      plotly
      kaleido
      pyperclip
      requests
      websocket-client
    ];

  python = pkgs.python3.withPackages packages;
in {
  programs.nixvim = {
    withPython3 = true;
    extraPython3Packages = packages;
    globals.python3_host_prog = lib.getExe python;

    extraPackages = with pkgs; [
      python3Packages.jupytext

      # pnglatex deps
      (texlive.combine {
        inherit (texlive) scheme-small dvipng pdfcrop;
      })
      netpbm
      poppler-utils
    ];

    plugins = {
      molten = {
        enable = true;
        settings = {
          image_provider = "image.nvim";
          max_width = 100;
          max_height = 12;
          max_height_window_percentage.__raw = "math.huge";
          max_width_window_percentage.__raw = "math.huge";
          output_win_max_height = 20;
        };
      };

      image = {
        enable = true;
        settings = {
          backend = "kitty";
          window_overlap_clear_enabled = true;
          window_overlap_clear_ft_ignore = ["cmp_menu" "cmp_docs" ""];
        };
      };
    };

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>i";
        group = "Notebook";
        icon = {
          icon = " ";
          color = "orange";
        };
      }
    ];
    keymaps = let
      molten = key: action: desc: {
        mode = "n";
        key = "<leader>i${key}";
        action = ":Molten${action}<CR>";
        options = {
          silent = true;
          inherit desc;
        };
      };
    in [
      (molten "i" "Init" "Initialize")
      (molten "d" "Delete" "Delete output")
      {
        mode = "v";
        key = "<leader>iv";
        action = ":<C-u>MoltenEvaluateVisual<CR>gv";
        options = {
          silent = true;
          desc = "Evaluate selection";
        };
      }
      {
        key = "<leader>ir";
        options = {
          silent = true;
          desc = "Evaluate current cell";
        };
        action.__raw = ''
          function()
            local current_line = vim.fn.line(".")

            local start_line = vim.fn.search("^```\\w\\+", "bcWn")
            local end_line = vim.fn.search("^```\\s*", "cWn")

            if start_line > 0 and end_line > 0 and start_line <= current_line and current_line <= end_line then
              vim.api.nvim_win_set_cursor(0, {start_line + 1, 0})

              local keys = string.format("mZV%dG:<C-u>MoltenEvaluateVisual<CR>`Z", end_line - 1)
              local term_keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
              vim.api.nvim_feedkeys(term_keys, "n", false)
            else
              vim.notify("No valid Markdown code block found!", vim.log.levels.WARN)
            end
          end
        '';
      }
    ];

    autoGroups.jupytext.clear = true;
    autoCmd = [
      # Read existing file
      {
        event = ["BufReadCmd"];
        pattern = ["*.ipynb"];
        group = "jupytext";
        callback.__raw = ''
          function(opts)
            local buf = opts.buf
            local filepath = opts.file

            if vim.fn.getfsize(filepath) <= 0 then
              vim.bo[buf].filetype = "markdown"
              vim.bo[buf].buftype = "acwrite"
              vim.bo[buf].modified = false
              pcall(vim.cmd, "MoltenInit python3")
              return
            end

            vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"Loading notebook..."})

            local cmd = {"jupytext", "--to", "md", "--output", "-", opts.file}
            local output = {}
            local err_output = {}

            vim.fn.jobstart(cmd, {
              stdout_buffered = true,
              stderr_buffered = true,
              on_stdout = function(_, data)
                if data then
                  for _, line in ipairs(data) do
                    table.insert(output, line)
                  end
                end
              end,
              on_stderr = function(_, data)
                if data then
                  for _, line in ipairs(data) do
                    if line ~= "" then table.insert(err_output, line) end
                  end
                end
              end,
              on_exit = function(_, exit_code)
                vim.schedule(function()
                  if not vim.api.nvim_buf_is_valid(buf) then return end

                  if exit_code ~= 0 then
                    local err_msg = table.concat(err_output, "\n")
                    err_msg = err_msg ~= "" and err_msg or "Unknown error"

                    vim.notify("Error while reading notebook:\n" .. err_msg, vim.log.levels.ERROR)
                    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"Error while loading the notebook"})
                    return
                  end

                  if output[#output] == "" then table.remove(output, #output) end

                  vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
                  vim.bo[buf].filetype = "markdown"
                  vim.bo[buf].buftype = "acwrite"
                  vim.bo[buf].modified = false

                  pcall(vim.cmd, "MoltenInit python3")
                end)
              end
            })
          end
        '';
      }
      # Create file
      {
        event = ["BufNewFile"];
        pattern = ["*.ipynb"];
        group = "jupytext";
        callback.__raw = ''
          function(opts)
            local buf = opts.buf
            vim.bo[buf].filetype = "markdown"
            vim.bo[buf].buftype = "acwrite"
            vim.bo[buf].modified = false
            pcall(vim.cmd, "MoltenInit python3")
          end
        '';
      }
      # Write file
      {
        event = ["BufWriteCmd"];
        pattern = ["*.ipynb"];
        group = "jupytext";
        callback.__raw = ''
          function(opts)
            local buf = opts.buf
            local filepath = opts.file

            local tmp_md = vim.fn.tempname() .. ".md"
            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            vim.fn.writefile(lines, tmp_md)

            local cmd = {
              "jupytext", "--from", "md", "--to", "ipynb"
            }
            if vim.fn.getfsize(filepath) > 0 then
              table.insert(cmd, "--update")
            end
            table.insert(cmd, "--output")
            table.insert(cmd, filepath)
            table.insert(cmd, tmp_md)

            local err_output = {}

            vim.fn.jobstart(cmd, {
              stderr_buffered = true,
              on_stderr = function(_, data)
                if data then
                  for _, line in ipairs(data) do
                    if line ~= "" then table.insert(err_output, line) end
                  end
                end
              end,
              on_exit = function(_, exit_code, _)
                os.remove(tmp_md)

                vim.schedule(function()
                  if exit_code == 0 then
                    vim.bo[buf].modified = false
                    vim.notify("Notebook saved.", vim.log.levels.INFO)
                  else
                    local err_msg = table.concat(err_output, "\n")
                    err_msg = err_msg ~= "" and err_msg or "Unknown error"
                    vim.notify("Error while writing notebook:\n" .. err_msg, vim.log.levels.ERROR)
                  end
                end)
              end
            })
          end
        '';
      }
    ];
  };
}
