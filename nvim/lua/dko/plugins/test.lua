---@type LazySpec
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- == adapters ===========================================================
      "nvim-neotest/neotest-python",
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("neotest").setup({
        floating = {
          border = require("dko.settings").get("border"),
          max_height = 0.9,
          max_width = 0.9,
          options = {},
        },
        ---@diagnostic disable-next-line: missing-fields
        summary = {
          open = "botright vsplit | vertical resize 60",
        },
        adapters = {
          require("neotest-python")({
            pytest_discover_instances = true,
          }),
        },
      })

      require("dko.mappings").bind_neotest()
    end,
  },
}
