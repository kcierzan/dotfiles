return {
  {
    "folke/which-key.nvim",
    keys = { " ", "<Space>", "<leader>" },
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
        print(dir)
        return vim.fn.empty(vim.fn.glob(dir)) == 0, dir
      end

      function my_find_files()
        local tscope = require("telescope.builtin")
        local exists, _ = parent_git_dir()
        if exists then
          tscope.git_files({ show_untracked_files = true })
        else
          tscope.find_files()
        end
      end

      function my_project_grep()
        local tscope = require("telescope.builtin")
        local exists, dir = parent_git_dir()
        if exists then
          tscope.live_grep({ cwd = dir })
        else
          tscope.live_grep()
        end
      end

      local mappings = {
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
              c = { tscope_cmd("lsp_incoming_calls"), "incoming calls" }
            },
            n = { cmd("Lspsaga diagnostic_jump_next"), "jump to next diagnostic"},
            p = { cmd("Lspsaga diagnostic_jump_previous"), "jump to previous diagnostic" },
            i = { cmd("Lspsaga show_cursor_diagnostics"), "show cursor diagnostics" },
            a = { cmd("Lspsaga code_action"), "code action" },
            o = { cmd("LSoutlineToggle"), "toggle outline" },
            d = { cmd("Lspsaga peek_definition"), "peek definition" },
            h = { cmd("Lspsaga hover_doc"), "hover documentation" },
            r = { cmd("LspRestart"), "restart" },
            s = { cmd("LspStart"), "start" },
            L = { cmd("LspLog"), "log" },
            I = { cmd("LspInfo"), "info" }
          },
          f = {
            name = "+find",
            O = { tscope_cmd("vim_options"), "vim options" },
            T = { tscope_cmd("filetypes"), "filetypes" },
            t = { tscope_cmd("help_tags"), "help tags" },
            a = { tscope_cmd("autocommands"), "autocommands" },
            b = { tscope_cmd("buffers"), "buffers" },
            c = { tscope_cmd("git_commits"), "commits" },
            f = { cmd("lua my_find_files()"), "files in repo" },
            g = { cmd("lua my_project_grep()"), "text in git files" }
          }
        },
      }
      wk.register(mappings)
    end
  }
}
