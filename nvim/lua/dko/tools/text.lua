local tools = require("dko.tools")

tools.register({
  name = "harper_ls",
  runner = "lspconfig",
})

tools.register({
  name = "texlab",
  runner = "lspconfig",
})

tools.register({
  name = "ltex",
  runner = "lspconfig",
})

tools.register({
  fts = { "bib" },
  name = "bibtex-tidy",
  efm = function()
    return {
      formatCommand = "bibtex-tidy --quiet -",
      formatStdin = true,
    }
  end,
})
