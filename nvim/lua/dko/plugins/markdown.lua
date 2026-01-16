local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

---@type LazySpec
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
        require("dko.mappings").bind_markdown(bufnr)
      end,
    },
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = { "markdown" },
    config = function()
      vim.g.mkdp_open_to_the_world = 1
      vim.g.mkdp_open_ip = "127.0.0.1"
      vim.g.mkdp_port = 8080
      vim.g.mkdp_browser = "none"
      vim.g.mkdp_echo_preview_url = 1
    end,
  },

  -- https://github.com/lukas-reineke/headlines.nvim
  {
    "lukas-reineke/headlines.nvim",
    cond = has_ui,
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = "markdown",
    opts = {
      markdown = {
        bullets = {},
      },
    },
  },

  {
    "davidmh/mdx.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
