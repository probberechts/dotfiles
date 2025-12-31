local dkotools = require("dko.tools")
-- local dkots = require("dko.utils.typescript")

local M = {}

dkotools.register({
  fts = require("dko.utils.jsts").fts,
  name = "prettier",
  efm = function()
    return require("efmls-configs.formatters.prettier")
  end,
})

dkotools.register({
  fts = require("dko.utils.jsts").fts,
  name = "biome",
  efm = require("dko.tools.biome"),
})

-- jumping into classnames from jsx/tsx
-- dkotools.register({
--   name = "cssmodules_ls",
--   mason_type = "lsp",
--   require = "npm",
-- })

-- Provides textDocument/documentColor that nvim-highlight-colors can use
-- Trigger tailwind completion manually using <C-Space> since coc is probably
-- handling default completion using @yaegassy/coc-tailwindcss3
--"cssls", -- conflicts with tailwindcss
--"cssls", -- conflicts with tailwindcss
dkotools.register({
  name = "tailwindcss",
  runner = "lspconfig",
})

dkotools.register({
  name = "eslint",
  runner = "lspconfig",
})

dkotools.register({
  name = "vtsls",
  runner = "lspconfig",
})

-- ts_ls with no integration, used for "pmizio/typescript-tools.nvim"
-- dkotools.register({
--   name = "ts_ls",
--   runner = "lspconfig",
--   skip_init = true,
-- })

return M
