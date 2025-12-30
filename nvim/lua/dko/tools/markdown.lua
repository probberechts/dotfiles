local tools = require("dko.tools")

tools.register({
  fts = { "markdown" },
  name = "markdownlint",
  efm = function()
    return vim.tbl_extend(
      "force",
      require("efmls-configs.linters.markdownlint"),
      { lintSource = "efm" }
    )
  end,
})

-- code actions for link completion
tools.register({
  fts = { "markdown" },
  name = "marksman",
  runner = "lspconfig",
})

tools.register({
  fts = { "markdown" },
  name = "prettier",
  efm = function()
    return require("efmls-configs.formatters.prettier")
  end,
})
