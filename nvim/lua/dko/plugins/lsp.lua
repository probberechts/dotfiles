-- =========================================================================
-- LSP
-- Scaffold dependencies like LazyVim
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua
-- =========================================================================

local dkosettings = require("dko.settings")
local dkolsp = require("dko.utils.lsp")
local dkotools = require("dko.tools")

local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

return {
  -- just provides lua objects to config lspconfig, doesn't call or access other
  -- plugins fns
  -- https://github.com/creativenull/efmls-configs-nvim
  { "creativenull/efmls-configs-nvim" },

  -- e.g. for go.mod and swagger yaml
  -- https://github.com/icholy/lsplinks.nvim
  {
    "icholy/lsplinks.nvim",
    cond = has_ui,
    opts = {
      highlight = true,
      hl_group = "Underlined",
    },
  },

  -- https://github.com/deathbeam/lspecho.nvim
  -- using fidget.nvim instead
  --{ "deathbeam/lspecho.nvim" },

  -- https://github.com/aznhe21/actions-preview.nvim
  {
    "aznhe21/actions-preview.nvim",
    cond = has_ui and dkosettings.get("lsp.code_action") == "actions-preview",
    dependencies = "nvim-telescope/telescope.nvim",
  },

  -- This keeps timing out on initial open
  -- https://github.com/rachartier/tiny-code-action.nvim
  -- https://www.reddit.com/r/neovim/comments/1eaxity/rachartiertinycodeactionnvim_a_simple_way_to_run/
  {
    "rachartier/tiny-code-action.nvim",
    cond = has_ui and dkosettings.get("lsp.code_action") == "tiny-code-action",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    event = "LspAttach",
    opts = { lsp_timeout = 4000 },
  },

  -- This has a cursor based code_action instead line based, so you get more
  -- specific actions.
  -- {
  --   "nvimdev/lspsaga.nvim",
  --   event = "LspAttach",
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter", -- optional
  --     "echasnovski/mini.icons",
  --     "nvim-tree/nvim-web-devicons", -- optional (and using mini.icons)
  --   },
  --   config = function()
  --     require("lspsaga").setup({
  --       implement = {
  --         enable = false,
  --       },
  --       lightbulb = {
  --         enable = false,
  --       },
  --       symbol_in_winbar = {
  --         enable = false,
  --       },
  --     })
  --   end,
  -- },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "creativenull/efmls-configs-nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- border on :LspInfo window
      require("lspconfig.ui.windows").default_options.border =
        dkosettings.get("border")
    end,
  },

  -- @TODO remove?
  -- https://github.com/pmizio/typescript-tools.nvim
  -- {
  --   "pmizio/typescript-tools.nvim",
  --   cond = has_ui and vim.tbl_contains(dkotools.get_mason_lsps(), "ts_ls"), -- I'm using vtsls now instead
  --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  --   config = function()
  --     local ts_ls_config = require("dko.utils.typescript").ts_ls.config
  --
  --     require("typescript-tools").setup({
  --       on_attach = ts_ls_config.on_attach,
  --       handlers = ts_ls_config.handlers,
  --       settings = {
  --         ts_ls_file_preferences = {
  --           -- https://github.com/microsoft/TypeScript/blob/v5.0.4/src/server/protocol.ts#L3487C1-L3488C1
  --           importModuleSpecifierPreference = "non-relative", -- "project-relative",
  --         },
  --       },
  --     })
  --   end,
  -- },

  -- https://github.com/marilari88/twoslash-queries.nvim
  -- {
  --   "marilari88/twoslash-queries.nvim",
  --   cond = has_ui,
  --   config = function()
  --     require("twoslash-queries").setup({ multi_line = true })
  --   end,
  -- },

  {
    "hrsh7th/cmp-nvim-lsp", -- provides some capabilities
    config = function()
      local cnl = require("cmp_nvim_lsp")
      cnl.setup()
      dkolsp.base_config.capabilities = vim.tbl_deep_extend(
        "force",
        dkolsp.base_config.capabilities,
        cnl.default_capabilities()
      )
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- provides some capabilities
      "neovim/nvim-lspconfig", -- wait for lspconfig

      -- @TODO move these somewhere else
      "b0o/schemastore.nvim", -- wait for schemastore for jsonls
      -- "davidosomething/format-ts-errors.nvim", -- extracted ts error formatter
      -- "marilari88/twoslash-queries.nvim", -- ts_ls comment with  ^? comment
    },
    config = function()
      local lspconfig = require("lspconfig")

      dkotools.setup_unmanaged_lsps(dkolsp.middleware)

      -- Note that instead of on_attach for each server setup,
      -- behaviors.lua has an autocmd LspAttach defined
      ---@type table<string, fun(server_name: string)>?
      local handlers = dkotools.get_mason_lspconfig_handlers(dkolsp.middleware)
      -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/init.lua#L62
      handlers[1] = function(server)
        lspconfig[server].setup(dkolsp.middleware())
      end

      local lsps = dkotools.get_mason_lsps()
      require("mason-lspconfig").setup({
        automatic_installation = has_ui,
        ensure_installed = lsps,
        handlers = handlers,
      })
    end,
  },
}
