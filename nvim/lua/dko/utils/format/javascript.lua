local dkonode = require("dko.utils.node")

local toast = require("dko.utils.notify").toast

local function format_with_lsp()
  if vim.lsp.get_clients({ bufnr = 0, name = "eslint" }) == 0 then
    toast("eslint-lsp not attached", vim.log.levels.WARN, {
      group = "format",
      title = "[LSP] eslint-lsp",
      render = "wrapped-compact",
    })
    return false
  end

  vim.cmd.EslintFixAll()
  local formatter = vim.b.has_eslint_plugin_prettier
      and "eslint-plugin-prettier"
    or "eslint-lsp"
  toast(formatter, vim.log.levels.INFO, {
    group = "format",
    title = "[LSP] eslint-lsp",
    render = "wrapped-compact",
  })
  return true
end

return function()
  -- Find and buffer cache prettier presence
  if vim.b.has_eslint_plugin_prettier == nil then
    vim.b.has_eslint_plugin_prettier = dkonode.has_eslint_plugin("prettier")
  end

  -- Run eslint via nvim-lsp eslint-lsp
  format_with_lsp()

  -- Finally, run prettier via efm if eslint-plugin-prettier not found
  if not vim.b.has_eslint_plugin_prettier then
    local did_efm_format =
      require("dko.utils.format.efm").format({ pipeline = "javascript" })
    if not did_efm_format then
      toast("Did not format with efm/prettier", vim.log.levels.WARN, {
        group = "format",
        title = "[LSP] efm",
        render = "wrapped-compact",
      })
    end
    return did_efm_format
  end
end
