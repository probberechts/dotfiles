local tools = require("dko.tools")

tools.register({
  mason_type = "lsp",
  name = "harper_ls",
  runner = "mason-lspconfig",
  lspconfig = function()
    return {
      settings = {
        ["harper-ls"] = {
          codeActions = {
            ForceStable = true,
          },
          linters = {
            Matcher = false, -- e.g. deps to dependencies
            SentenceCapitalization = false,
            SpellCheck = false,
            ToDoHyphen = false,
          },
          userDictPath = os.getenv("DOTFILES") .. "/harper-ls/dictionary.txt",
        },
      },
    }
  end,
})

tools.register({
  mason_type = "lsp",
  name = "texlab",
  runner = "mason-lspconfig",
  lspconfig = function()
    return {
      settings = {
        texlab = {
          -- build = {
          -- executable = "latexmk",
          -- args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
          -- onSave = true,
          -- },
        },
      },
    }
  end,
})

tools.register({
  mason_type = "lsp",
  name = "ltex",
  runner = "mason-lspconfig",
  lspconfig = function()
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
  end,
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
