local tools = require("dko.tools")

tools.register({
  fts = { "html" },
  name = "prettier",
  efm = function()
    return require("efmls-configs.formatters.prettier")
  end,
})

tools.register({
  name = "html",
  runner = "lspconfig",
})
