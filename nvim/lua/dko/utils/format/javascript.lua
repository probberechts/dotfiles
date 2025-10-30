local M = {}

---@return boolean, boolean -- success, formatted
M.format_with_lsp = function()
  local level = vim.log.levels.ERROR
  local message = "eslint-lsp"

  local has_eslint_plugin_prettier =
    require("dko.utils.format.eslint").has_eslint_plugin_prettier()

  local eslint_lsps = vim.lsp.get_clients({ bufnr = 0, name = "eslint" })
  if #eslint_lsps == 0 then
    message = ("eslint-lsp not attached %s"):format(
      has_eslint_plugin_prettier and "and eslint-plugin-prettier present" or ""
    )
  elseif vim.fn.exists(":LspEslintFixAll") then
    vim.cmd.LspEslintFixAll()
    message = has_eslint_plugin_prettier and "eslint-plugin-prettier" or message
    level = vim.log.levels.INFO
  else
    message = "Missing :LspEslintFixAll from nvim-lspconfig"
  end

  require("dko.utils.notify").toast(message, level, {
    group = "format",
    title = "[LSP] eslint-lsp",
    render = "wrapped-compact",
  })
  return level ~= vim.log.levels.ERROR, has_eslint_plugin_prettier
end

M.format = function()
  local _, is_lsp_formatted = M.format_with_lsp()
  if is_lsp_formatted then
    return true
  end

  if require("dko.utils.format.biome").has_biome() then
    local did_efm_format =
      require("dko.utils.format.efm").format({ pipeline = "javascript" })
    if not did_efm_format then
      require("dko.utils.notify").toast(
        "Did not format with efm/prettier",
        vim.log.levels.WARN,
        {
          group = "format",
          title = "[LSP] efm",
          render = "wrapped-compact",
        }
      )
    end
    return did_efm_format
  end

  -- Finally, run prettier via efm if eslint-plugin-prettier not found
  local did_efm_format =
    require("dko.utils.format.efm").format({ pipeline = "javascript" })
  if not did_efm_format then
    require("dko.utils.notify").toast(
      "Did not format with efm/prettier",
      vim.log.levels.WARN,
      {
        group = "format",
        title = "[LSP] efm",
        render = "wrapped-compact",
      }
    )
  end
  return did_efm_format
end

return M
