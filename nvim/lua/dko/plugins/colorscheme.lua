local dev = vim.env.NVIM_DEV ~= nil

return require("dko.utils.lazyspec")(function(ctx)
  ---@type LazySpec
  return {
    {
      "navarasu/onedark.nvim",
      cond = ctx.has_ui,
      dependencies = {
        -- { "rakr/vim-two-firewatch", lazy = true },
        -- {
        --   "mcchrish/zenbones.nvim",
        --   lazy = true,
        --   dependencies = { "rktjmp/lush.nvim" },
        -- },
        -- "ntk148v/komau.vim",
        "oskarnurm/koda.nvim",
      },
      dev = dev,
      lazy = false,
      priority = 1000,
      init = function()
        require("dko.settings").set("colors.dark", "onedark")
        require("dko.settings").set("colors.light", "koda-glade")
      end,
      config = function()
        require("onedark").setup({
          style = "dark",
          toggle_style_key = "<leader>ts",
        })
        vim.cmd.colorscheme("onedark")
        if vim.env.TERM_PROGRAM == "WezTerm" then
          require("dko.colors").wezterm_sync()
        end
      end,
    },
  }
end)
