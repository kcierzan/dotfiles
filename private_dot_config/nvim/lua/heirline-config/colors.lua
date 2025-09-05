local M = {}

local function get_catppuccin_colors()
    -- TODO: make this a bunch of utils.get_highlight calls
    local scheme_colors = require("catppuccin.palettes").get_palette("mocha")
    local utils = require("heirline.utils")
    return {
        segment_bg = scheme_colors.surface0,
        normal_mode_fg = scheme_colors.green,
        insert_mode_fg = scheme_colors.yellow,
        file_path_fg = scheme_colors.overlay1,
        file_name_fg = scheme_colors.text,
        modified_light_fg = scheme_colors.yellow,
        lsp_fg = scheme_colors.yellow,
        cwd_fg = scheme_colors.mauve,
        branch_fg = scheme_colors.cyan,
        override_sp = scheme_colors.surface2,
        statusline_bg = utils.get_highlight("Statusline").bg,
    }
end

local function get_kanso_colors()
    local utils = require("heirline.utils")
    return {
        segment_bg = utils.get_highlight("Cursorline").bg,
        insert_mode_fg = utils.get_highlight("String").fg,
        normal_mode_fg = utils.get_highlight("Function").fg,
        file_path_fg = utils.get_highlight("Operator").fg,
        file_name_fg = utils.get_highlight("Normal").fg,
        modified_light_fg = utils.get_highlight("Special").fg,
        lsp_fg = utils.get_highlight("Special").fg,
        cwd_fg = utils.get_highlight("Number").fg,
        branch_fg = utils.get_highlight("Type").fg,
        override_sp = utils.get_highlight("Operator").fg,
        statusline_bg = utils.get_highlight("Statusline").bg,
    }
end

local function get_kanso_pearl_colors()
    local utils = require("heirline.utils")
    local colors = get_kanso_colors()
    colors.file_name_fg = utils.get_highlight("Operator").fg
    colors.file_path_fg = utils.get_highlight("Normal").fg
    colors.segment_bg = utils.get_highlight("Pmenu").bg
    return colors
end

function M.get_colors()
    local theme_name = vim.g.ghostty_theme_name

    if theme_name == "catppuccin-mocha" or theme_name == "catppuccin-xcode" then
        return get_catppuccin_colors()
    elseif theme_name == "kanso-pearl" then
        return get_kanso_pearl_colors()
    elseif theme_name:match("^kanso%-") then
        return get_kanso_colors()
    else
        vim.notify("Unknown ghostty theme: " .. tostring(theme_name) .. ". Falling back to kanso!")
        return get_kanso_colors()
    end
end

return M
