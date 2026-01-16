local tools = require("dko.tools")

-- ruff to sort imports
tools.register({
  fts = { "python" },
  name = "isort",
  efm = function()
    return {
      -- 1. check: run the linter
      -- 2. --select I001: ONLY look at import sorting (ignore other lint errors)
      -- 3. --fix: apply the sort
      formatCommand = "ruff check --select I001 --fix --quiet --stdin-filename '${INPUT}' -",
      formatStdin = true,
    }
  end,
})

-- type checker, go-to definition support
tools.register({
  require = "basedpyright",
  runner = "lspconfig",
})

-- syntax checker, python hover and some diagnostics from jedi
-- https://github.com/pappasam/jedi-language-server#capabilities
tools.register({
  name = "jedi_language_server",
  runner = "lspconfig",
})

-- python lint and format from ruff using "ruff server", configuration
-- (newer than ruff-lsp standalone project)
-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/ruff.lua
tools.register({
  name = "ruff",
  runner = "lspconfig",
})
