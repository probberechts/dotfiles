local tools = require("dko.tools")

tools.register({
  fts = { "json", "jsonc" },
  name = "prettier",
  efm = function()
    return require("efmls-configs.formatters.prettier")
  end,
})

tools.register({
  fts = { "json", "jsonc" },
  name = "biome",
  efm = require("dko.tools.biome"),
})

-- not used for formatting - prefer prettier since it does one-line arrays
-- when they fit
tools.register({
  name = "jsonls",
  runner = "lspconfig",
})
