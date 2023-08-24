return {
  {
    "folke/which-key.nvim",
    keys = { " ", "<Space>", "<leader>", "g", "]", "[" },
    config = function()
      local wk = require("which-key")
      local lib = require("lib")

      -- TODO: add descriptions via table arg to nvim_set_keymap()
      lib.nmap("gh", lib.ex_cmd("lua vim.lsp.buf.hover()"))
      lib.nmap("gd", lib.ex_cmd("lua vim.lsp.buf.definition()"))
      lib.nmap("gD", lib.ex_cmd("lua vim.lsp.buf.incoming_calls()"))
      lib.nmap("gr", lib.ex_cmd("lua require('navigator.reference').reference()"))
      lib.nmap("gW", lib.ex_cmd("lua require('navigator.workspace').workspace_symbol_live()"))
      lib.nmap("gp", lib.ex_cmd("lua require('navigator.definition').definition_preview()"))
      lib.nmap("gi", lib.ex_cmd("lua vim.lsp.buf.implementation()"))
      lib.nmap("gL", lib.ex_cmd("lua require('navigator.diagnostics').show_diagnostics()"))
      lib.nmap("]e", lib.ex_cmd("lua vim.diagnostic.goto_next()"))
      lib.nmap("[e", lib.ex_cmd("lua vim.diagnostic.goto_prev()"))
      lib.nmap("]g", lib.ex_cmd("Gitsigns next_hunk"))
      lib.nmap("[g", lib.ex_cmd("Gitsigns prev_hunk"))

      local normal_mappings = {
        ["<leader>"] = {
          [":"] = { lib.ex_cmd("ToggleTerm direction=horizontal"), "toggle terminal drawer" },
          Q = { lib.ex_cmd("q!"), "quit without saving" },
          q = { lib.ex_cmd("wq"), "save and quit" },
          l = {
            name = "+lsp",
            F = { vim.lsp.buf.format, "format buffer" },
            I = { lib.ex_cmd("LspInfo"), "info" },
            L = { lib.ex_cmd("LspLog"), "log" },
            a = { lib.ex_cmd("lua require('navigator.codeAction').code_action()"), "code action" },
            e = { lib.ex_cmd("Trouble"), "show errors and warnings" },
            o = { lib.ex_cmd("LspSymbols"), "toggle outline" },
            q = { lib.ex_cmd("LspRestart"), "restart" },
            r = { lib.ex_cmd("lua vim.lsp.buf.rename()"), "rename" },
            s = { lib.ex_cmd("LspStart"), "start" },
          },
          f = {
            name = "+find",
            G = { lib.super_fuzzy_grep, "super fuzzy grep" },
            b = { lib.telescope_builtin("buffers"), "buffers" },
            c = { lib.telescope_builtin("git_commits"), "commits" },
            d = { lib.telescope_builtin("lsp_definitions"), "definitions" },
            f = { lib.fast_find_file, "files in repo" },
            R = { lib.ex_cmd("Spectre"), "replace" },
            g = { lib.live_grep_from_git_root, "text in git files" },
            h = { lib.telescope_builtin("oldfiles"), "oldfiles" },
            i = { lib.telescope_builtin("lsp_implementations"), "implementations" },
            j = { lib.ex_cmd(":lua require('telescope').extensions.zoxide.list()"), "recent dirs" },
            l = { lib.telescope_builtin("current_buffer_fuzzy_find"), "line in buffer" },
            o = { lib.telescope_builtin("lsp_workspace_symbols"), "workspace symbols" },
            s = { lib.lsp_document_symbols, "buffer symbols" },
            u = { lib.telescope_builtin("lsp_references"), "usages" },
            w = { lib.grep_word_under_cursor, "word under cursor" },
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
            T = { lib.telescope_builtin("filetypes"), "filetypes" },
            a = { lib.telescope_builtin("autocommands"), "autocommands" },
            c = { lib.telescope_builtin("highlights"), "highlights" },
            e = { lib.ex_cmd("edit ~/.config/nvim/init.lua"), "edit init.lua" }, -- TODO: make this a telescope function to browse lua config files
            h = { lib.telescope_builtin("help_tags"), "help tags" },
            k = { lib.telescope_builtin("keymaps"), "keymaps" },
            m = { lib.telescope_builtin("man_pages"), "man pages" },
            o = { lib.telescope_builtin("vim_options"), "vim options" },
            p = { lib.ex_cmd("Lazy"), "plugins" },
            t = { lib.ex_cmd("Mason"), "tools" },
          },
          b = {
            name = "+buffer",
            C = { lib.ex_cmd("window diffoff"), "diff off" },
            c = { lib.ex_cmd("windo diffthis"), "diff on" },
            d = { lib.ex_cmd("Bdelete"), "delete" },
            f = { lib.ex_cmd('silent exec "!bundle exec rubocop -A %:p"'), "run rubocop on buffer" },
            m = { lib.open_in_rubymine, "open in rubymine" },
            r = { lib.ex_cmd("edit!"), "reload" },
            s = { lib.ex_cmd("silent! w"), "write" },
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
            t = { lib.ex_cmd("ToggleTerm direction=float"), "toggle floating terminal" },
            T = { lib.ex_cmd("ToggleTerm direction=horizontal"), "toggle drawer terminal" },
            ["#"] = { lib.ex_cmd("set invnumber"), "toggle line numbers" },
            ["%"] = { lib.ex_cmd("set invrelativenumber"), "toggle relative line numbers" },
            c = { lib.ex_cmd("nohlsearch"), "clear search highlight" },
            f = { lib.ex_cmd("NvimTreeToggle"), "toggle tree" },
            h = { lib.ex_cmd("ColorizerAttachToBuffer"), "colorize buffer" },
            l = { lib.ex_cmd("IndentBlanklineToggle"), "toggle indentation lines" },
            L = { lib.ex_cmd("set cursorline"), "toggle cursorline" },
          },
          o = {
            name = "+filetree",
            t = { lib.ex_cmd("Neotree focus filesystem reveal left"), "show file in tree" },
            o = { lib.ex_cmd("Neotree show filesystem left"), "open filetree" },
            g = { lib.ex_cmd("Neotree git_status left"), "git status tree" },
            b = { lib.ex_cmd("Neotree buffers"), "open buffers tree" },
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
            b = { lib.ex_cmd("Gitsigns toggle_current_line_blame"), "toggle blame" },
            c = { lib.ex_cmd("Gvdiffsplit!"), "3 way merge" },
            d = { lib.ex_cmd("Gvdiffsplit"), "diff staged & working tree" },
            h = { lib.ex_cmd("Gitsigns stage_hunk"), "stage hunk" },
            l = { lib.ex_cmd("TermExec direction=float cmd=lazygit"), "open lazygit" },
            o = { lib.ex_cmd("GBrowse"), "open in github" },
            p = { lib.ex_cmd("Gitsigns preview_hunk"), "preview hunk" },
            r = { lib.ex_cmd("Gitsigns reset_hunk"), "reset hunk" },
            s = { lib.ex_cmd("Git"), "status" },
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
            o = { lib.ex_cmd("'<,'>GBrowse"), "open in github" },
            h = { lib.ex_cmd("Gitsigns stage_hunk"), "stage hunk" },
            r = { lib.ex_cmd("Gitsigns reset_hunk"), "reset hunk" },
          },
          f = {
            name = "+find",
            f = {
              "\"zy:lua require('telescope.builtin').live_grep({default_text=vim.api.nvim_exec([[echo getreg('z')]], true), glob_pattern='!**/spec/**/*'})<cr>",
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
