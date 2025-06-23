-- Typescript specific

local Methods = vim.lsp.protocol.Methods

local M = {}

---Go to source definition using LSP command
---@param name 'vtsls'|'ts_ls'
---@param command "typescript.goToSourceDefinition"|"_typescript.goToSourceDefinition"
---@return boolean
M.go_to_source_definition = function(name, command)
  local client = vim.lsp.get_clients({ bufnr = 0, name = name })[1]
  if not client then
    vim.notify(("Cannot find %s"):format(name), vim.log.levels.ERROR)
    return false
  end

  local position_params =
    vim.lsp.util.make_position_params(0, client.offset_encoding)

  local definition_handler = function(...)
    local args = { ... }
    local res = args[2] or {}
    -- local client = args[3] or {}
    if not vim.tbl_isempty(res) then
      local location = res[#res]
      vim.lsp.util.show_document(location, client.offset_encoding)
    end
  end

  return client:request(Methods.workspace_executeCommand, {
    command = command,
    arguments = { position_params.textDocument.uri, position_params.position },
  }, definition_handler, 0)
end

M.ts_ls = {}

---@type lspconfig.Config
M.ts_ls.config = {
  on_attach = function(client, bufnr)
    local twoslashok, twoslash = pcall(require, "twoslash-queries")
    if twoslashok then
      twoslash.attach(client, bufnr)
    end

    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end,
}

return M
