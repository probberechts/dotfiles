local tools = require("dko.tools")

-- just use ruff, it's >99.99% compatible with black
-- tools.register({
--   mason_type = "tool",
--   require = "python",
--   name = "black",
--   fts = { "python" },
--   efm = function()
--     return require("efmls-configs.formatters.black")
--   end,
-- })

-- ruff can also sort, but does it in two passes,
-- see https://docs.astral.sh/ruff/formatter/#sorting-imports
-- use isort for now
tools.register({
  mason_type = "tool",
  require = "python",
  name = "isort",
  fts = { "python" },
  efm = function()
    return {
      formatCommand = "isort --profile black --quiet -",
      formatStdin = true,
    }
  end,
})

-- type checker, go to def
tools.register({
  mason_type = "lsp",
  require = "python",
  name = "basedpyright",
  runner = "mason-lspconfig",
  lspconfig = function()
    return {
      settings = {
        basedpyright = {
          typeCheckingMode = "standard",
          disableOrganizeImports = true, -- prefer ruff or isort
        },
        python = {
          analysis = {
            -- Ignore all files for analysis to exclusively use Ruff for linting
            ignore = { "*" },
          },
        },
      },
    }
  end,
})

-- syntax checker, python hover and some diagnostics from jedi
-- https://github.com/pappasam/jedi-language-server#capabilities
tools.register({
  mason_type = "lsp",
  require = "python",
  name = "jedi_language_server",
  runner = "mason-lspconfig",
})

-- python lint and format from ruff using "ruff server", configuration
-- (newer than ruff-lsp standalone project)
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/ruff.lua
tools.register({
  name = "ruff",
  mason_type = "lsp",
  require = "python",
  lspconfig = function()
    local ruff_config_path = require("dko.utils.file").find_exists({
      vim.loop.os_homedir() .. "/.config/ruff/ruff.toml",
      require("dko.utils.project").root() .. "/ruff.toml",
      require("dko.utils.project").root() .. "/pyproject.toml",
    })
    local args = {}
    if ruff_config_path then
      args = { "--config=" .. ruff_config_path }
    end
    return {
      ---note: local on_attach happens AFTER autocmd LspAttach
      on_attach = function(client)
        -- basedpyright instead
        client.server_capabilities.hoverProvider = false
      end,
      init_options = {
        settings = {
          format = {
            args = args,
          },
          lint = {
            args = args,
          },
        },
      },
    }
  end,
})
