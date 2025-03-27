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
  lspconfig = function()
    ---@type lspconfig.Config
    return {
      filetypes = require("dko.dkotools").get_efm_filetypes(),
      single_file_support = true,
      init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
      },
      settings = { languages = require("dko.dkotools").get_efm_languages() },
    }
  end,
})
