return {
  "rebelot/heirline.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-mini/mini.base16",
    "echanovski/mini.icons",
    "lewis6991/gitsigns.nvim",
  },
  config = function()
    local heirline_utils = require("heirline-config.utils")
    local colors = require("heirline-config.colors")
    local conditions = require("heirline.conditions")
    local separator = "none"
    local palette = colors.get_colors()

    local function segment(...)
      return heirline_utils.segment(separator, palette, ...)
    end

    -- Create all components using the component factory functions
    local MacroRec = require("heirline-config.components.macro").new()
    local LSPActive = require("heirline-config.components.lsp").new(palette)
    local VisualWords = require("heirline-config.components.visual_words").new()
    local DiagnosticCount = require("heirline-config.components.diagnostics").new()
    local GitBranch = require("heirline-config.components.git_branch").new(palette)
    local GitAdded = require("heirline-config.components.git_added").new()
    local GitModified = require("heirline-config.components.git_modified").new()
    local GitRemoved = require("heirline-config.components.git_removed").new()
    local FileIcon = require("heirline-config.components.file_icon").new()

    -- Wrapped components in segments
    local Mode = require("heirline-config.components.mode").new()
    local File = segment(require("heirline-config.components.file").new(palette))
    local WorkDir = segment(require("heirline-config.components.work_dir").new(palette))

    -- Visual words with condition
    VisualWords = {
      segment(VisualWords),
      condition = function()
        local mode = vim.fn.mode()
        return mode == "v" or mode == "V"
      end,
    }

    -- LSP Active with condition
    LSPActive = {
      segment(LSPActive),
      condition = conditions.lsp_attached,
    }

    -- Diagnostic Count with condition
    DiagnosticCount = {
      segment(DiagnosticCount),
      condition = function()
        return conditions.lsp_attached()
            and (
              #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }) > 0
              or #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }) > 0
              or #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }) > 0
              or #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }) > 0
            )
      end,
    }

    GitBranch = {
      segment(GitBranch),
      condition = function()
        return conditions.is_git_repo()
      end,
    }

    GitChanges = {
      segment({
        GitAdded,
        heirline_utils.Space,
        GitModified,
        heirline_utils.Space,
        GitRemoved,
      }),
      condition = function()
        return conditions.is_git_repo()
      end
    }

    -- Helper function for regular buffers
    local function is_regular_buffer()
      return not conditions.buffer_matches({ buftype = { "terminal", "TelescopePrompt", "quickfix", "help" } })
    end

    -- Define statuslines
    local ActiveStatusLine = {
      Mode,
      {
        File,
        GitChanges,
        VisualWords,
        MacroRec,
        heirline_utils.Align,
        FileIcon,
        DiagnosticCount,
        LSPActive,
        WorkDir,
        condition = is_regular_buffer,
      },
      GitBranch,
      heirline_utils.Space,
      condition = conditions.is_active,
    }

    -- not relevant with global statusline (eg. it is not per-buffer)
    local InactiveStatusLine = {
      File,
    }

    require("heirline").setup({
      statusline = {
        ActiveStatusLine,
        InactiveStatusLine,
        fallthrough = false,
      },
    })
  end,
}
