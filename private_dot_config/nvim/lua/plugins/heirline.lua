return {
    "rebelot/heirline.nvim",
    event = "VeryLazy",
    dependencies = {
        "echanovski/mini.icons",
        "lewis6991/gitsigns.nvim",
    },
    config = function()
        local heirline_utils = require("heirline-config.utils")
        local colors = require("heirline-config.colors")
        local components = require("heirline-config.components")
        local conditions = require("heirline.conditions")
        local separator = "none"
        local palette = colors.get_colors()

        local function segment(...)
            return heirline_utils.segment(separator, palette, ...)
        end

        -- Create all components using the component factory functions
        local ViMode = components.create_vi_mode(palette)
        local FileNameBlock = components.create_file_name_block(palette)
        local MacroRec = components.create_macro_rec()
        local LSPActive = components.create_lsp_active(palette)
        local WorkDir = components.create_work_dir(palette)
        local VisualWords = components.create_visual_words()
        local DiagnosticCount = components.create_diagnostic_counts()
        local CodeCompanionStatus = components.create_codecompanion_status()
        local Git = components.create_git(palette)

        -- Wrap components in segments
        local Mode = segment(ViMode)
        local File = segment(FileNameBlock)
        WorkDir = segment(WorkDir)

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

        -- CodeCompanion Status with condition
        CodeCompanionStatus = {
            segment(CodeCompanionStatus),
            condition = function()
                return vim.g.codecompanion_request_active == true
            end,
        }

        -- Git with condition
        Git = {
            segment(Git),
            condition = conditions.is_git_repo,
        }

        -- Helper function for regular buffers
        local function is_regular_buffer()
            return not conditions.buffer_matches({ buftype = { "terminal", "TelescopePrompt", "quickfix", "help" } })
        end

        -- Define statuslines
        local ActiveStatusLine = {
            Mode,
            Git,
            {
                File,
                VisualWords,
                MacroRec,
                heirline_utils.Align,
                CodeCompanionStatus,
                DiagnosticCount,
                LSPActive,
                WorkDir,
                condition = is_regular_buffer,
            },
            heirline_utils.Space,
            condition = conditions.is_active,
        }

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
