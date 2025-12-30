local ruff_config_path = require("dko.utils.file").find_exists({
  vim.loop.os_homedir() .. "/.config/ruff/ruff.toml",
  require("dko.utils.project").root() .. "/ruff.toml",
  require("dko.utils.project").root() .. "/pyproject.toml",
})
local args = {}
if ruff_config_path then
  args = { "--config=" .. ruff_config_path }
end

---@type vim.lsp.Config
return {
  ---note: local on_attach happens AFTER autocmd LspAttach
  on_attach = function(client)
    -- basedpyright instead
    client.server_capabilities.hoverProvider = false
  end,
  init_options = {
    settings = {
      format = {
        args = args,
      },
      lint = {
        args = args,
      },
    },
  },
}
