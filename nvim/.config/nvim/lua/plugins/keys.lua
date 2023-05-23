return {
  {
    "folke/which-key.nvim",
    keys = { " ", "<Space>", "<leader>", "v", "V" },
    config = function()
      local wk = require("which-key")
      local lib = require("lib")

      local normal_mappings = {
        ["<leader>"] = {
          l = {
            name = "+LSP",
            f = {
              name = "+find",
              r = { lib.telescope_builtin("lsp_references"), "references" },
              s = { lib.lsp_document_symbols, "buffer symbols" },
              S = { lib.telescope_builtin("lsp_workspace_symbols"), "workspace symbols" },
              i = { lib.telescope_builtin("lsp_implementations"), "implementations" },
              d = { lib.telescope_builtin("lsp_definitions"), "definitions" },
              c = { lib.telescope_builtin("lsp_incoming_calls"), "incoming calls" },
              F = { lib.ex_cmd("Lspsaga lsp_finder"), "Finder UI" },
            },
            n = { lib.ex_cmd("Lspsaga diagnostic_jump_next"), "jump to next diagnostic" },
            p = { lib.ex_cmd("Lspsaga diagnostic_jump_previous"), "jump to previous diagnostic" },
            i = { lib.ex_cmd("Lspsaga show_cursor_diagnostics"), "show cursor diagnostics" },
            a = { lib.ex_cmd("Lspsaga code_action"), "code action" },
            F = { vim.lsp.buf.format, "format buffer" },
            o = { lib.ex_cmd("Lspsaga outline"), "toggle outline" },
            d = { lib.ex_cmd("Lspsaga peek_definition"), "peek definition" },
            h = { lib.ex_cmd("Lspsaga hover_doc"), "hover documentation" },
            q = { lib.ex_cmd("LspRestart"), "restart" },
            s = { lib.ex_cmd("LspStart"), "start" },
            L = { lib.ex_cmd("LspLog"), "log" },
            I = { lib.ex_cmd("LspInfo"), "info" },
            r = { lib.ex_cmd("Lspsaga rename"), "rename in file" },
            R = { lib.ex_cmd("Lspsaga rename ++project"), "rename in project" },
          },
          f = {
            name = "+find",
            O = { lib.telescope_builtin("vim_options"), "vim options" },
            T = { lib.telescope_builtin("filetypes"), "filetypes" },
            t = { lib.telescope_builtin("help_tags"), "help tags" },
            a = { lib.telescope_builtin("autocommands"), "autocommands" },
            b = { lib.telescope_builtin("buffers"), "buffers" },
            c = { lib.telescope_builtin("git_commits"), "commits" },
            f = { lib.fast_find_file, "files in repo" },
            g = { lib.live_grep_from_git_root, "text in git files" },
            G = { lib.super_fuzzy_grep, "super fuzzy grep" },
            h = { lib.telescope_builtin("highlights"), "highlights" },
            k = { lib.telescope_builtin("keymaps"), "keymaps" },
            l = { lib.telescope_builtin("current_buffer_fuzzy_find"), "line in buffer" },
            m = { lib.telescope_builtin("man_pages"), "man pages" },
            o = { lib.telescope_builtin("oldfiles"), "oldfiles" },
            p = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "projects" },
            s = { lib.grep_word_under_cursor, "word under cursor" },
            r = {
              name = "+rails",
              f = { lib.find_rails_app_file, "app files" },
              m = { lib.find_rails_model, "models" },
              c = { lib.find_rails_controller, "controllers" },
              v = { lib.find_rails_view, "views" },
              s = { lib.find_specs, "specs" },
              g = { lib.live_grep_rails_app_files, "find in app files" },
            },
          },
          v = {
            name = "+vim",
            e = { lib.ex_cmd("edit ~/.config/nvim/init.lua"), "edit init.lua" },
            l = { lib.ex_cmd("Lazy"), "lazy" },
            m = { lib.ex_cmd("Mason"), "mason" },
          },
          b = {
            name = "+buffer",
            C = { lib.ex_cmd("window diffoff"), "diff off" },
            c = { lib.ex_cmd("windo diffthis"), "diff on" },
            d = { lib.ex_cmd("Bdelete"), "delete" },
            f = { lib.ex_cmd('silent exec "!bundle exec rubocop -A %:p"'), "run rubocop on buffer" },
            m = { lib.open_in_rubymine, "open in rubymine" },
            r = { lib.ex_cmd("edit!"), "reload" },
            s = { lib.ex_cmd("w"), "write" },
            w = { lib.ex_cmd("%s/\\s\\+$//e"), "trim trailing whitespace" },
            y = { lib.ex_cmd('let @+ = expand("%:p")'), "yank name" },
          },
          w = {
            name = "+window",
            S = { "<C-w>J", "to horizontal split" },
            V = { "<C-w>H", "to vertical split" },
            e = { "<C-w>=", "equalize windows" },
            j = { "10<C-w>-", "decrease size" },
            k = { "10<C-w>+", "increase size" },
            o = { "<C-w>o", "delete other windows" },
            r = { "<C-w>r", "rotate windows" },
            s = { lib.ex_cmd("sp"), "split horizontal" },
            v = { lib.ex_cmd("vsp"), "split vertically" },
          },
          i = {
            name = "+interface",
            F = { lib.ex_cmd("NvimTreeFindFile"), "show current file in tree" },
            H = { lib.ex_cmd("TSHighlightCapturesUnderCursor"), "show highlights under cursor" },
            T = { lib.ex_cmd("ToggleTerm direction=float"), "toggle floating terminal" },
            ["#"] = { lib.ex_cmd("set invnumber"), "toggle line numbers" },
            ["%"] = { lib.ex_cmd("set invrelativenumber"), "toggle relative line numbers" },
            c = { lib.ex_cmd("nohlsearch"), "clear search highlight" },
            e = { lib.ex_cmd("Trouble"), "show errors and warnings" },
            f = { lib.ex_cmd("NvimTreeToggle"), "toggle tree" },
            h = { lib.ex_cmd("ColorizerAttachToBuffer"), "colorize buffer" },
            l = { lib.ex_cmd("IndentBlanklineToggle"), "toggle indentation lines" },
            t = { lib.ex_cmd("ToggleTerm direction=down"), "toggle terminal drawer" },
            L = { lib.ex_cmd("set cursorline"), "toggle cursorline" },
          },
          t = {
            name = "+test",
            b = { lib.ex_cmd("lua require('neotest').run.run(vim.fn.getcwd() .. '/b4b')"), "b4b suite" },
            c = { lib.ex_cmd("lua require('neotest').run.run(vim.fn.getcwd() .. '/clinic')"), "clinic suite" },
            f = { lib.test_file_from_engine_root, "file" },
            g = { lib.ex_cmd("A"), "show test file" },
            m = { lib.ex_cmd("lua require('neotest').run.run(vim.fn.getcwd() .. '/b4b_core')"), "b4b_core suite" },
            o = { lib.ex_cmd("lua require('neotest').output_panel.toggle()"), "toggle output" },
            s = { lib.stop_test, "stop test run" },
            t = { lib.test_test_from_engine_root, "test" },
          },
          g = {
            name = "+git",
            B = { lib.ex_cmd("Gitsigns stage_buffer"), "stage buffer" },
            R = { lib.ex_cmd("Gitsigns reset_buffer"), "reset bufffer" },
            d = { lib.ex_cmd("Gvdiffsplit"), "diff staged & working tree" },
            h = { lib.ex_cmd("Gitsigns stage_hunk"), "stage hunk" },
            o = { lib.ex_cmd("GBrowse"), "open in github" },
            p = { lib.ex_cmd("Gitsigns preview_hunk"), "preview hunk" },
            r = { lib.ex_cmd("Gitsigns reset_hunk"), "reset hunk" },
            s = { lib.ex_cmd("Git"), "status" },
            b = { lib.ex_cmd("Gitsigns toggle_current_line_blame"), "toggle blame" },
          },
          d = {
            name = "+debug",
            b = { lib.ex_cmd("lua require('dap').toggle_breakpoint()"), "toggle breakpoint" },
            c = { lib.ex_cmd("lua require('dap').continue()"), "continue" },
            o = { lib.ex_cmd("lua require('dap').step_over()"), "step over" },
            i = { lib.ex_cmd("lua require('dap').step_into()"), "step into" },
            u = { lib.ex_cmd("lua require('dapui').toggle()"), "toggle UI" },
            r = { lib.ex_cmd("lua require('dap').repl.toggle()"), "toggle repl" },
            f = {
              lib.ex_cmd(
                "lua require('dapui').float_element('repl', { height = 40, width = 140, position = 'center', enter = true })"
              ),
              "toggle floating repl",
            },
          },
        },
      }

      local visual_mappings = {
        ["<leader>"] = {
          g = {
            name = "+git",
            o = { lib.ex_cmd("GBrowse"), "open in github" },
            h = { lib.ex_cmd("Gitsigns stage_hunk"), "stage hunk" },
            r = { lib.ex_cmd("Gitsigns reset_hunk"), "reset hunk" },
          },
          f = {
            name = "+find",
            f = {
              "\"zy:lua require('telescope.builtin').live_grep({default_text=vim.api.nvim_exec([[echo getreg('z')]], true)})<cr>",
              "search visual selection",
            },
          },
        },
      }

      wk.register(normal_mappings)
      wk.register(visual_mappings, { mode = "v" })
      wk.setup({
        window = {
          border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
        },
      })
    end,
  },
}
