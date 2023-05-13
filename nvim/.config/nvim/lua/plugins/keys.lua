return {
  {
    "folke/which-key.nvim",
    keys = { " ", "<Space>", "<leader>", "v", "V" },
    config = function()
      local wk = require("which-key")

      local function cmd(command)
        return "<cmd>" .. command .. "<cr>"
      end

      local function tscope_cmd(method)
        return cmd("lua require('telescope.builtin')." .. method .. "()")
      end

      local function parent_git_dir()
        local dir = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
        return vim.fn.empty(vim.fn.glob(dir)) == 0, dir
      end

      local function create_rails_fd_command(directory)
        local excludes = { ".git/", "node_modules", "**/*migration*/**/*", "**/vendor/**/*", "**/migrate/**/*" }
        if directory ~= 'spec' then
          table.insert(excludes, "**/spec/**/*")
        end
        return {
          "fd",
          "--type",
          "f",
          "--hidden",
          "--strip-cwd-prefix",
          "--full-path",
          "--glob",
          "**/" .. directory .. "/**/*.{erb,rb}",
          "-E",
          table.concat(excludes, ",")
        }
      end

      local function my_find_files()
        local tscope = require("telescope.builtin")
        local exists, _ = parent_git_dir()
        if exists then
          tscope.git_files({ show_untracked_files = true })
        else
          tscope.find_files()
        end
      end

      local function find_in_app_files()
        require("telescope.builtin").live_grep({
          glob_pattern = {
            "!**/spec/**/*",
            "!**/*migration*/**/*",
            "!**/vendor/**/*",
            "!**/migrate/**/*",
            "!**/doc/**/*",
            "!node_modules"
          }
        })
      end

      local function find_app_files()
        local tscope = require("telescope.builtin")
        tscope.find_files(
          {
            find_command = {
              "fd",
              "--type",
              "f",
              "--hidden",
              "--strip-cwd-prefix",
              "-E",
              "{.git/,node_modules,**/spec/**/*,**/*migration*/**/*,**/vendor/**/*,**/migrate/**/*}"
            },
            prompt_prefix = "💎 "
          }
        )
      end

      local function find_models()
        require("telescope.builtin").find_files(
          {
            find_command = create_rails_fd_command("models"),
            prompt_prefix = "🗿"
          }
        )
      end

      local function find_controllers()
        require("telescope.builtin").find_files(
          {
            find_command = create_rails_fd_command("controllers"),
            prompt_prefix = "🎛️"
          }
        )
      end

      local function find_views()
        require("telescope.builtin").find_files(
          {
            find_command = create_rails_fd_command("views"),
            prompt_prefix = "👁️"
          }
        )
      end

      local function find_specs()
        require("telescope.builtin").find_files(
          {
            find_command = create_rails_fd_command("spec"),
            prompt_prefix = "🧪"
          }
        )
      end

      local function open_in_rubymine()
        vim.fn.system({ "rubymine", vim.fn.expand("%:p") })
      end

      local function my_project_grep()
        local tscope = require("telescope.builtin")
        local exists, dir = parent_git_dir()
        if exists then
          tscope.live_grep({ cwd = dir })
        else
          tscope.live_grep()
        end
      end

      local normal_mappings = {
        ["<leader>"] = {
          l = {
            name = "+LSP",
            f = {
              name = "+find",
              r = { tscope_cmd("lsp_references"), "references" },
              s = { tscope_cmd("lsp_document_symbols"), "buffer symbols" },
              S = { tscope_cmd("lsp_workspace_symbols"), "workspace symbols" },
              i = { tscope_cmd("lsp_implementations"), "implementations" },
              d = { tscope_cmd("lsp_definitions"), "definitions" },
              c = { tscope_cmd("lsp_incoming_calls"), "incoming calls" },
              F = { cmd("Lspsaga lsp_finder"), "Finder UI" }
            },
            n = { cmd("Lspsaga diagnostic_jump_next"), "jump to next diagnostic"},
            p = { cmd("Lspsaga diagnostic_jump_previous"), "jump to previous diagnostic" },
            i = { cmd("Lspsaga show_cursor_diagnostics"), "show cursor diagnostics" },
            a = { cmd("Lspsaga code_action"), "code action" },
            F = { vim.lsp.buf.format, "format buffer" },
            o = { cmd("Lspsaga outline"), "toggle outline" },
            d = { cmd("Lspsaga peek_definition"), "peek definition" },
            h = { cmd("Lspsaga hover_doc"), "hover documentation" },
            q = { cmd("LspRestart"), "restart" },
            s = { cmd("LspStart"), "start" },
            L = { cmd("LspLog"), "log" },
            I = { cmd("LspInfo"), "info" },
            r = { cmd("Lspsaga rename"), "rename in file" },
            R = { cmd("Lspsaga rename ++project"), "rename in project" }
          },
          f = {
            name = "+find",
            O = { tscope_cmd("vim_options"), "vim options" },
            T = { tscope_cmd("filetypes"), "filetypes" },
            t = { tscope_cmd("help_tags"), "help tags" },
            a = { tscope_cmd("autocommands"), "autocommands" },
            b = { tscope_cmd("buffers"), "buffers" },
            c = { tscope_cmd("git_commits"), "commits" },
            f = { my_find_files, "files in repo" },
            g = { my_project_grep, "text in git files" },
            G = { "<cmd>lua require('telescope.builtin').grep_string({ search = '' })<cr>", "super fuzzy grep" },
            h = { tscope_cmd("highlights"), "highlights" },
            k = { tscope_cmd("keymaps"), "keymaps" },
            l = { tscope_cmd("current_buffer_fuzzy_find"), "line in buffer" },
            m = { tscope_cmd("man_pages"), "man pages" },
            o = { tscope_cmd("oldfiles"), "oldfiles" },
            p = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "projects" },
            s = { "<cmd>lua require('telescope.builtin').grep_string()<cr>", "word under cursor"},
            r = {
              name = "+rails",
              f = { find_app_files, "app files"},
              m = { find_models, "models" },
              c = { find_controllers, "controllers" },
              v = { find_views, "views" },
              s = { find_specs, "specs" },
              g = { find_in_app_files, "find in app files"}
            }
          },
          v = {
            name = "+vim",
            e = { cmd("edit ~/.config/nvim/init.lua"), "edit init.lua" },
            l = { cmd("Lazy"), "lazy" },
            m = { cmd("Mason"), "mason" },
          },
          b = {
            name = "+buffer",
            C = { cmd("window diffoff"), "diff off" },
            c = { cmd("windo diffthis"), "diff on" },
            d = { cmd("Bdelete"), "delete" },
            f = { cmd("silent exec \"!bundle exec rubocop -A %:p\""), "run rubocop on buffer" },
            m = { open_in_rubymine, "open in rubymine" },
            r = { cmd("edit!"), "reload" },
            s = { cmd("w"), "write" },
            w = { cmd("%s/\\s\\+$//e"), "trim trailing whitespace" },
            y = { cmd("let @+ = expand(\"%:p\")"), "yank name" },
          },
          w = {
            name = "+window",
            S =  { "<C-w>J", "to horizontal split" },
            V =  { "<C-w>H", "to vertical split" },
            e =  { "<C-w>=", "equalize windows" },
            j =  { "10<C-w>-", "decrease size" },
            k =  { "10<C-w>+", "increase size" },
            o =  { "<C-w>o", "delete other windows" },
            r =  { "<C-w>r", "rotate windows" },
            s =  { cmd("sp"), "split horizontal" },
            v =  { cmd("vsp"), "split vertically" }
          },
          i = {
            name = "+gui",
            F = { cmd("NvimTreeFindFile"), "show current file in tree" },
            H = { cmd("TSHighlightCapturesUnderCursor"), "show highlights under cursor" },
            T = { cmd("ToggleTerm direction=float"), "toggle floating terminal" },
            ["#"] = { cmd("set invnumber"), "toggle line numbers" },
            ["%"] = { cmd("set invrelativenumber"), "toggle relative line numbers" },
            c = { cmd("nohlsearch"), "clear search highlight" },
            e = { cmd("Trouble"), "show errors and warnings" },
            f = { cmd("NvimTreeToggle"), "toggle tree" },
            h = { cmd("ColorizerAttachToBuffer"), "colorize buffer" },
            l = { cmd("IndentBlanklineToggle"), "toggle indentation lines" },
            t = { cmd("ToggleTerm direction=down"), "toggle terminal drawer" }
          }
        },
        t = {
          name = "+test",
          b = { cmd("lua require('neotest').run.run(vim.fn.getcwd() .. '/b4b')"), "b4b suite" },
          c = { cmd("lua require('neotest').run.run(vim.fn.getcwd() .. '/clinic')"), "clinic suite" },
          f = { cmd("lua require('neotest').run.run(vim.fn.expand('%'))"), "file" },
          g = { cmd("A"), "show test file" },
          m = { cmd("lua require('neotest').run.run(vim.fn.getcwd() .. '/b4b_core')"), "b4b_core suite" },
          o = { cmd("lua require('neotest').output_panel.toggle()"), "toggle output" },
          s = { cmd("lua require('neotest').run.stop()"), "stop test run" },
          t = { cmd("lua require('neotest').run.run()"), "test" },
        },
        g = {
          name = "+git",
          B = { cmd("Gitsigns stage_buffer"), "stage buffer" },
          R = { cmd("Gitsigns reset_buffer"), "reset bufffer" },
          d = { cmd("Gvdiffsplit"), "diff staged & working tree" },
          h = { cmd("Gitsigns stage_hunk"), "stage hunk" },
          o = { cmd("GBrowse"), "open in github" },
          p = { cmd("Gitsigns preview_hunk"), "preview hunk" },
          r = { cmd("Gitsigns reset_hunk"), "reset hunk" },
          s = { cmd("Git"), "status" },
          b = { cmd("Gitsigns toggle_current_line_blame"), "toggle blame" },
        }
      }

      local visual_mappings = {
        ["<leader>"] = {
          g = {
            name = "+git",
            o = { cmd("GBrowse"), "open in github" },
            h = { cmd("Gitsigns stage_hunk"), "stage hunk" },
            r = { cmd("Gitsigns reset_hunk"), "reset hunk" },
          },
          f = {
            name = "+find",
            f = { "\"zy:lua require('telescope.builtin').live_grep({default_text=vim.api.nvim_exec([[echo getreg('z')]], true)})<cr>", "search visual selection" }
          }
        }
      }

      wk.register(normal_mappings)
      wk.register(visual_mappings, { mode = "v" }) -- TODO: make these only relevant keybinds
      wk.setup({
        window = {
          border = { "┏", "━", "┓", "┃", "┛","━", "┗", "┃" },
        }
      })
    end
  }
}
