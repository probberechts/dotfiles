local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

return {
  -- {
  --   "davidosomething/everandever.nvim",
  --   cond = has_ui,
  --   dev = true,
  -- },

  {
    "rebelot/heirline.nvim",
    cond = has_ui,
    dependencies = {
      "echasnovski/mini.icons",
      -- "davidosomething/everandever.nvim",
    },
    init = function()
      local NEVER = 0
      vim.o.showtabline = NEVER
      local GLOBAL = 3
      vim.o.laststatus = GLOBAL
    end,
    config = function()
      require("heirline").setup({
        statusline = require("dko.heirline.statusline-default"),
        tabline = require("dko.heirline.tabline"),
        winbar = require("dko.heirline.winbar"),
        opts = {
          -- if the callback returns true, the winbar will be disabled for that window
          -- the args parameter corresponds to the table argument passed to autocommand callbacks. :h nvim_lua_create_autocmd()
          disable_winbar_cb = function(args)
            return require("heirline.conditions").buffer_matches({
              buftype = vim.tbl_filter(function(bt)
                return not vim.tbl_contains(
                  { "help", "quickfix", "terminal" },
                  bt
                )
              end, require("dko.utils.buffer").SPECIAL_BUFTYPES),
            }, args.buf)
          end,
        },
      })

      vim.api.nvim_create_autocmd("colorscheme", {
        desc = "Clear heirline color cache",
        callback = function()
          require("heirline").reset_highlights()
        end,
        group = vim.api.nvim_create_augroup("dkoheirline", {}),
      })
    end,
  },
}
