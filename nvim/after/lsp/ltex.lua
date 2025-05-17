return {
  settings = {
    ltex = {
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
      checkFrequency = "edit",
      language = "en-US",
      completionEnabled = true,
      additionalRules = {
        enablePickyRules = true,
      },
    },
  },
}
