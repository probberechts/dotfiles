local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

return {

  -- https://github.com/tadmccorkle/markdown.nvim
  {
    "tadmccorkle/markdown.nvim",
    ft = "markdown", -- or 'event = "VeryLazy"'
    opts = {
      mappings = {
        inline_surround_toggle = false,
        inline_surround_toggle_line = false,
        inline_surround_delete = false,
        inline_surround_change = false,
        link_add = "gl", -- (string|boolean) add link
        link_follow = false, -- (string|boolean) follow link
        go_curr_heading = false,
        go_parent_heading = false,
        go_next_heading = "]]", -- (string|boolean) set cursor to next section heading
        go_prev_heading = "[[", -- (string|boolean) set cursor to previous section heading
      },
      on_attach = function(bufnr)
        local map = vim.keymap.set
        local opts = { buffer = bufnr }
        map("n", "<c-x>", "<Cmd>MDTaskToggle<CR>", opts)
      end,
    },
  },

  {
    "lukas-reineke/headlines.nvim",
    cond = has_ui,
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = "markdown",
    opts = {
      markdown = {
        bullets = {},
      },
    }, -- or `opts = {}`
  },

  {
    "davidmh/mdx.nvim",
    config = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
