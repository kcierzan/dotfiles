local M = {}

function M.get_colors()
  local utils = require("heirline.utils")
  return {
    segment_bg = utils.get_highlight("b16_base01").fg,
    normal_mode_fg = utils.get_highlight("String").fg,
    insert_mode_fg = utils.get_highlight("StorageClass").fg,
    file_path_fg = utils.get_highlight("@markup.list.unchecked").fg,
    file_name_fg = utils.get_highlight("Normal").fg,
    modified_light_fg = utils.get_highlight("StorageClass").fg,
    lsp_fg = utils.get_highlight("StorageClass").fg,
    cwd_fg = utils.get_highlight("Number").fg,
    branch_fg = utils.get_highlight("Conditional").fg,
    jj_rev_fg = utils.get_highlight("Number").fg,
    jj_description_fg = utils.get_highlight("Normal").fg,
    jj_bookmark_fg = utils.get_highlight("Bookmark").fg,
    override_sp = utils.get_highlight("LspReferenceText").bg,
    statusline_bg = utils.get_highlight("Statusline").bg,
  }
end

return M
