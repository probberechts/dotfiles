local uis = vim.api.nvim_list_uis()
local has_ui = #uis > 0

local BRACKETED_DISABLED = ""

return {
  -- because https://github.com/neovim/neovim/issues/1496
  -- once https://github.com/neovim/neovim/pull/10842 is merged, there will
  -- probably be a better implementation for this
  {
    "lambdalisue/vim-suda",
    cmd = "SudaWrite",
  },

  {
    "echasnovski/mini.bracketed",
    cond = has_ui,
    version = false,
    opts = {
      -- buffer = { suffix = "b" },
      -- comment = { suffix = "c" },
      -- conflict = { suffix = "x" },
      diagnostic = {
        --- something weird about the cursor positioning of this compared to the
        --- built-in ]d [d
        suffix = BRACKETED_DISABLED,
        -- options = {
        -- float = require("dko.settings").get("diagnostics.goto_float"),
        -- },
      },
      -- file = { suffix = "f" },
      indent = { suffix = BRACKETED_DISABLED }, -- confusing
      jump = { suffix = BRACKETED_DISABLED }, -- redundant
      -- location = { suffix = "l" },
      -- oldfile = { suffix = "o" },
      -- quickfix = { suffix = "q" },
      treesitter = { suffix = "n" }, -- n for node, default was t, using it for tab
      undo = { suffix = BRACKETED_DISABLED }, -- I'm using for url
      window = { suffix = BRACKETED_DISABLED }, -- broken going to unlisted
      yank = { suffix = BRACKETED_DISABLED }, -- confusing
    },
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    --- opts will be merged from other specs, e.g. from
    --- ./indent.lua
    --- ./components.lua
    opts = {
      styles = {
        notification = {
          wo = {
            winblend = 0,
          },
        },
      },
      picker = {
        layout = "ivy",
        win = {
          input = {
            keys = vim
              .iter({
                require("dko.mappings.finder").features,
              })
              :fold({}, function(acc, features)
                vim.iter(features):each(function(_, config)
                  acc[config.shortcut] = { "close", mode = { "n", "i" } }
                end)
                return acc
              end),
          },
        },
      },
    },
    config = true,
    init = function()
      vim.g.snacks_animate = false
    end,
  },

  -- https://github.com/AndrewRadev/bufferize.vim
  -- `:Bufferize messages` to get messages (or any :command) in a new buffer
  {
    "AndrewRadev/bufferize.vim",
    cmd = "Bufferize",
    config = function()
      vim.g.bufferize_command = "tabnew"
      vim.g.bufferize_keep_buffers = 1
    end,
  },

  -- =========================================================================
  -- ui: diagnostic
  -- =========================================================================

  {
    "nvim-neo-tree/neo-tree.nvim",
    cond = has_ui,
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
  },

  -- {
  --   "rachartier/tiny-inline-diagnostic.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("tiny-inline-diagnostic").setup({
  --       blend = {
  --         factor = 0.3,
  --       },
  --       options = {
  --         break_line = {
  --           enabled = true,
  --           after = 80,
  --         },
  --         multiple_diag_under_cursor = true,
  --         show_source = true,
  --       },
  --     })
  --     require("dko.settings").set("diagnostics.goto_float", false)
  --   end,
  -- },

  -- =========================================================================
  -- ui: buffer and window manipulation
  -- =========================================================================

  -- pretty format quickfix and loclist
  {
    "yorickpeterse/nvim-pqf",
    event = { "BufReadPost", "BufNewFile" },
    cond = has_ui,
    config = true,
  },

  -- remove buffers without messing up window layout
  -- https://github.com/echasnovski/mini.bufremove
  {
    "echasnovski/mini.bufremove",
    cond = has_ui,
    config = true,
    version = false, -- dev version
  },

  -- zoom in/out of a window
  -- this plugin accounts for command window and doesn't use sessions
  -- overrides <C-w>o (originally does an :only)
  {
    "troydm/zoomwintab.vim",
    keys = require("dko.mappings").zoomwintab,
    cmd = {
      "ZoomWinTabIn",
      "ZoomWinTabOut",
      "ZoomWinTabToggle",
    },
  },

  -- resize window to selection, or split new window with selection size
  {
    "wellle/visual-split.vim",
    cmd = {
      "VSResize",
      "VSSplit",
      "VSSplitAbove",
      "VSSplitBelow",
    },
  },

  -- <leader>w for picker
  -- https://github.com/yorickpeterse/nvim-window
  {
    "yorickpeterse/nvim-window",
    keys = vim.tbl_values(require("dko.mappings").nvim_window),
    config = function()
      require("nvim-window").setup({})
      require("dko.mappings").bind_nvim_window()
    end,
  },

  -- Remember/restore last cursor position in filesAdd commentMore actions
  --
  -- https://github.com/ethanholz/nvim-lastplace
  -- this plugin is archived by author
  -- maybe switch to https://github.com/vladdoster/remember.nvim if there are
  -- ever issues
  {
    "ethanholz/nvim-lastplace",
    cond = has_ui,
    config = true,
  },

  -- =========================================================================
  -- ui: terminal
  -- =========================================================================

  {
    "akinsho/toggleterm.nvim",
    keys = require("dko.mappings").toggleterm_all_keys,
    cmd = "ToggleTerm",
    config = function()
      require("toggleterm").setup({
        float_opts = {
          border = require("dko.settings").get("border"),
        },
        -- built-in mappings only work on LAST USED terminal, so it confuses
        -- the buffer terminal with the floating terminal
        open_mapping = nil,
      })
      require("dko.mappings").bind_toggleterm()
    end,
  },

  -- =========================================================================
  -- Reading
  -- =========================================================================

  -- jump to :line:column in filename:3:20
  --
  -- has indexing errors
  -- https://github.com/lewis6991/fileline.nvim/
  --{ "lewis6991/fileline.nvim" },
  --
  -- https://github.com/wsdjeg/vim-fetch
  {
    "wsdjeg/vim-fetch",
    cond = has_ui,
  },

  -- ]u [u mappings to jump to urls
  -- <A-u> to open link picker
  -- https://github.com/axieax/urlview.nvim
  {
    "axieax/urlview.nvim",
    keys = vim.tbl_values(require("dko.mappings").urlview),
    cmd = "UrlView",
    config = function()
      require("dko.mappings").bind_urlview()
    end,
  },

  -- highlight undo/redo text change
  -- https://github.com/tzachar/highlight-undo.nvim
  {
    "tzachar/highlight-undo.nvim",
    cond = has_ui,
    keys = { "u", "<c-r>" },
    config = function()
      require("highlight-undo").setup({})
    end,
  },

  -- =========================================================================
  -- Syntax
  -- =========================================================================

  -- highlight matching html/xml tag
  -- % textobject
  {
    "andymass/vim-matchup",
    cond = has_ui,
    -- author recommends against lazy loading
    lazy = false,
    init = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_status_offscreen = 0
      -- see behaviors.lua for treesitter integration
    end,
  },

  {
    "lukas-reineke/headlines.nvim",
    cond = has_ui,
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      markdown = {
        bullets = {},
      },
    }, -- or `opts = {}`
  },

  -- Works better than https://github.com/IndianBoy42/tree-sitter-just
  { "NoahTheDuke/vim-just" },

  -- https://github.com/brenoprata10/nvim-highlight-colors
  -- see output comparison here https://www.reddit.com/r/neovim/comments/1b5gw12/nvimhighlightcolors_now_supports_virtual_text/kt8gog6/?share_id=aUVLJ5zC3yMKjFuHqumGE
  -- can request and colorize from LSP textDocument/documentColor if available
  -- integrated into nvim-cmp in ./completion.lua
  {
    "brenoprata10/nvim-highlight-colors",
    cond = has_ui,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ---@usage 'background'|'foreground'|'virtual'
      render = "background",
      -- virtual_symbol_position = 'eow',
      -- virtual_symbol_prefix = ' ',
      -- virtual_symbol_suffix = '',
      ---Highlight tailwind colors, e.g. 'bg-blue-500'
      enable_tailwind = true,
      enable_var_usage = true,
      exclude_filetypes = {
        "lazy",
      },
    },
  },

  -- https://github.com/catgoose/nvim-colorizer.lua
  -- {
  --   "catgoose/nvim-colorizer.lua",
  --   cond = has_ui,
  --   event = { "BufReadPost", "BufNewFile" },
  --   config = function()
  --     require("colorizer").setup({
  --       buftypes = {
  --         "*",
  --         unpack(vim.tbl_map(function(v)
  --           return "!" .. v
  --         end, require("dko.utils.buffer").SPECIAL_BUFTYPES)),
  --       },
  --       filetypes = vim.tbl_extend("keep", {
  --         "css",
  --         "html",
  --         "scss",
  --       }, require("dko.utils.jsts").fts),
  --       user_default_options = {
  --         css = true,
  --         tailwind = true,
  --       },
  --     })
  --   end,
  -- },

  -- =========================================================================
  -- Writing
  -- =========================================================================

  {
    "reedes/vim-pencil",
    ft = { "markdown", "mdx", "tex", "bib" },
    config = function()
      vim.cmd([[let g:pencil#conceallevel = 2]]) -- no conceal
      vim.cmd([[autocmd Filetype markdown PencilSoft]])
      vim.cmd([[autocmd Filetype tex Pencil]])
      vim.cmd([[autocmd Filetype bib Pencil]])

      -- vim.cmd[[autocmd Filetype markdown set nobreakindent]] -- this is set by pencil and its slow af

      -- Wrapping
      vim.cmd([[autocmd Filetype markdown set linebreak]])
      vim.cmd([[autocmd Filetype markdown set breakindentopt=list:-1]])
    end,
  },

  {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup({
        window = {
          options = {
            signcolumn = "no", -- disable signcolumn
            number = false, -- disable number column
            relativenumber = false, -- disable relative numbers
            cursorline = false, -- disable cursorline
            cursorcolumn = false, -- disable cursor column
            foldcolumn = "0", -- disable fold column
            list = false, -- disable whitespace characters
          },
        },
        plugins = {
          twilight = { enabled = true }, -- start Twilight when zen mode opens
        },
      })
    end,
  },

  { "folke/twilight.nvim" },

  -- Override <A-hjkl> to move lines in any mode
  -- NB: Normally in insert mode, <A-hjkl> will exit insert and move cursor.
  -- You can use arrow keys in insert mode, so it's a little redundant.
  {
    "echasnovski/mini.move",
    cond = has_ui,
    config = true,
  },

  -- gcc / <Leader>gbc to comment with treesitter integration
  -- 0.10 has built-in treesitter comments, see :h commenting
  -- BUT it does not properly do jsx/tsx which is provided by
  -- ts_context_commentstring
  -- https://github.com/numToStr/Comment.nvim
  {
    "numToStr/Comment.nvim",
    cond = has_ui,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
        "JoosepAlviste/nvim-ts-context-commentstring",
        -- No longer needs nvim-treesitter after https://github.com/JoosepAlviste/nvim-ts-context-commentstring/pull/80
        opts = {
          -- Disable for Comment.nvim https://github.com/JoosepAlviste/nvim-ts-context-commentstring/wiki/Integrations#commentnvim
          enable_autocmd = false,
        },
      },
    },
    config = function()
      require("Comment").setup(
        require("dko.mappings").with_commentnvim_mappings({
          -- add treesitter support, want tsx/jsx in particular
          pre_hook = require(
            "ts_context_commentstring.integrations.comment_nvim"
          ).create_pre_hook(),
        })
      )
    end,
  },

  -- vim-sandwich provides a textobj!
  -- sa/sr/sd operators and ib/ab textobjs
  -- https://github.com/echasnovski/mini.surround -- no textobj
  -- https://github.com/kylechui/nvim-surround -- no textobj
  {
    "machakann/vim-sandwich",
    cond = has_ui,
  },

  -- https://github.com/chrisgrieser/nvim-various-textobj
  {
    "chrisgrieser/nvim-various-textobjs",
    cond = has_ui,
    config = function()
      require("various-textobjs").setup({
        keymaps = {
          useDefaults = false,
        },
        textobjs = {
          indentation = {
            -- `false`: only indentation decreases delimit the text object
            -- `true`: indentation decreases as well as blank lines serve as delimiter
            blanksAreDelimiter = false,
          },
        },
      })
      require("dko.mappings").bind_nvim_various_textobjs()
    end,
  },

  -- adds a 'cut' operation separate from 'delete'
  {
    "gbprod/cutlass.nvim",
    opts = {
      cut_key = "m",
    },
  },

  -- =========================================================================
  -- Testing
  -- =========================================================================

  {
    "nvim-neotest/neotest",
    cond = has_ui,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    config = function()
      require("neotest").setup({
        floating = {
          border = require("dko.settings").get("border"),
          max_height = 0.9,
          max_width = 0.9,
          options = {},
        },
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
