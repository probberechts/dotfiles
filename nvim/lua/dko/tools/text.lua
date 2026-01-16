local tools = require("dko.tools")

tools.register({
  name = "harper_ls",
  runner = "lspconfig",
})

tools.register({
  name = "texlab",
  runner = "lspconfig",
})

-- Harper does not support latex yet
-- https://github.com/Automattic/harper/discussions/1164
-- TODO: switch to ltex-plus once java 21 is available
tools.register({
  name = "ltex",
  runner = "lspconfig",
  fts = { "tex" },
})

tools.register({
  fts = { "bibtex" },
  name = "bibtex-tidy",
  efm = function()
    return {
      formatCommand = "bibtex-tidy --quiet --sort-fields --blank-lines --curly -",
      formatStdin = true,
    }
  end,
})
