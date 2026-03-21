local M = {}

function M.new(palette)
  return {
    update = { "LspAttach", "LspDetach", "BufEnter", "WinEnter" },
    provider = function()
      local lsp_icons = {
        ["obsidian-ls"] = " ",
        ["vscode-html-language-server"] = " ",
        basedpyright = " ",
        bashls = " ",
        biome = "󰂦 ",
        clangd = " ",
        copilot = " ",
        cssls = " ",
        emmet_language_server = " ",
        golangci_lint_ls = " ",
        gopls = " ",
        html = " ",
        json_ls = "󰘦 ",
        lua_ls = " ",
        marksman = " ",
        nil_ls = "󱄅 ",
        nushell = " ",
        postgres_lsp = " ",
        rubocop = "󱅧 ",
        ruby_lsp = " ",
        rust_analyzer = " ",
        sorbet = " ",
        tailwindcss = "󱏿 ",
        templ = "{} ",
        ty = " ",
        typos_lsp = "󰓆 ",
        ["harper-ls"] = " ",
        vtsls = " ",
        zls = " ",
      }
      local names = {}
      for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
        table.insert(names, lsp_icons[server.name] or server.name)
      end
      return table.concat(names)
    end,
    hl = { fg = palette.modified_light_fg },
  }
end

return M
