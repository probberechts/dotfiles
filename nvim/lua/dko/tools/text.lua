local tools = require("dko.tools")

tools.register({
  mason_type = "lsp",
  name = "harper_ls",
  runner = "mason-lspconfig",
})

tools.register({
  mason_type = "lsp",
  name = "texlab",
  runner = "mason-lspconfig",
})

tools.register({
  mason_type = "lsp",
  name = "ltex",
  runner = "mason-lspconfig",
})

tools.register({
  mason_type = "tool",
  name = "bibtex-tidy",
  fts = { "bib" },
  efm = function()
    return {
      formatCommand = "bibtex-tidy --quiet -",
      formatStdin = true,
    }
  end,
})
