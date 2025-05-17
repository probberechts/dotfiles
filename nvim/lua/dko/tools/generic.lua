local dkotools = require("dko.tools")

dkotools.register({
  mason_type = "tool",
  require = "_",
  name = "tree-sitter-cli",
})

dkotools.register({
  mason_type = "lsp",
  require = "go",
  name = "efm",
  runner = "mason-lspconfig",
})
