local smallcaps = require("dko.utils.string").smallcaps

local conditions = require("heirline.conditions")

local function active_highlight(active)
  active = active or "StatusLine"
  return conditions.is_active() and active or "StatusLineNC"
end

local hidden_filetypes = vim.tbl_extend("keep", {
  "markdown",
}, require("dko.utils.jsts").fts)

return {
  {
    init = function(self)
      self.filepath = vim.api.nvim_buf_get_name(0)
      self.filetype_text = vim.tbl_contains(hidden_filetypes, vim.bo.filetype)
          and ""
        or smallcaps(vim.bo.filetype)
    end,
    hl = function()
      return active_highlight()
    end,

    {
      condition = function()
        return vim.bo.filetype ~= ""
      end,

      -- =======================================================================
      -- treesitter highlight status
      -- =======================================================================

      {
        provider = function()
          if
            conditions.buffer_matches({
              buftype = require("dko.utils.buffer").SPECIAL_BUFTYPES,
              filetype = require("dko.utils.buffer").SPECIAL_FILETYPES,
            })
          then
            return ""
          end
          return "  "
        end,
        hl = function()
          return active_highlight(
            require("dko.utils.treesitter").is_highlight_enabled() and "DiffAdd"
              or "DiffDelete"
          )
        end,
      },

      -- =======================================================================
      -- filetype icon and text
      -- =======================================================================

      {
        init = function(self)
          if vim.bo.buftype ~= "" then
            self.icon = ""
            self.icon_not_found = true
          else
            ---@diagnostic disable-next-line: undefined-field
            self.icon = _G.MiniIcons and _G.MiniIcons.get("file", self.filepath)
              or ""
          end
        end,
        provider = function(self)
          -- don't add a space if we're hiding the filetype in the interest of
          -- space saving
          local spaced_filetype = self.filetype_text ~= ""
              and (" " .. self.filetype_text)
            or ""
          return (" %s%s "):format(self.icon, spaced_filetype)
        end,
        hl = function()
          return active_highlight("dkoStatusKey")
        end,
      },
    },

    -- =========================================================================
    -- terminal help
    -- =========================================================================

    {
      condition = function()
        return vim.bo.buftype == "terminal"
      end,
      provider = function()
        return " [<A-i> hide] [<A-x> mode] "
      end,
      hl = function()
        return active_highlight()
      end,
    },

    -- =========================================================================
    -- filename
    -- =========================================================================
    {
      condition = function()
        return vim.bo.buftype == "" or vim.bo.buftype == "help"
      end,

      {
        provider = function(self)
          if self.filepath == "" then
            return " ᴜɴɴᴀᴍᴇᴅ "
          end

          local filename = vim.fn.fnamemodify(self.filepath, ":t")
          return (" %s "):format(filename)
        end,
        hl = function()
          return vim.bo.modified and "Todo" or active_highlight("StatusLine")
        end,
      },

      {
        condition = function()
          return not vim.bo.modifiable or vim.bo.readonly
        end,
        {
          provider = "  ",
          hl = "dkoLineImportant",
        },
        {
          provider = " ",
        },
      },
    },

    -- =========================================================================
    -- path
    -- =========================================================================

    {
      condition = function()
        return vim.bo.buftype == "" or vim.bo.buftype == "help"
      end,

      {
        provider = function(self)
          if self.filepath == "" then
            return ""
          end

          local win_width = vim.api.nvim_win_get_width(0)
          local extrachars = 3 + 3 + self.filetype_text:len()
          local remaining = win_width - extrachars

          local final
          local cwd = vim.fn.fnamemodify(vim.uv.cwd() or "", ":~")
          local path = vim.fn.fnamemodify(self.filepath, ":~:h")
          local cwd_relative = require("dko.utils.path").common_root(cwd, path)
          local relative = vim.fn.fnamemodify(path, ":~:.") or ""

          if
            cwd_relative.levels < 4 and cwd_relative.root:len() < remaining
          then
            if cwd_relative.levels == 0 then
              if cwd_relative.b == "" then
                return smallcaps("[cwd]")
              end
              final = ("%s"):format(cwd_relative.b)
            else
              final = ("↑%d/%s"):format(cwd_relative.levels, cwd_relative.b)
            end
          elseif relative:len() < remaining then
            final = relative
          else
            local len = 8
            while len > 0 and type(final) ~= "string" do
              local attempt = vim.fn.pathshorten(path, len)
              final = attempt:len() < remaining and attempt
              len = len - 2
            end
            if not final then
              final = vim.fn.pathshorten(path, 1)
            end
          end
          return ("in %s%s/ "):format("%<", final)
        end,
        hl = function()
          return active_highlight("Comment")
        end,
      },
    },
  },

  -- spacer with active bg color
  {
    provider = "%=",
    hl = function()
      return active_highlight()
    end,
  },

  {
    condition = function()
      return vim.bo.buftype == "" -- normal
    end,
    require("dko.heirline.lsp"),
    require("dko.heirline.formatters"),
    require("dko.heirline.diagnostics"),
    -- require("dko.heirline.dko-heirline-package-info"),
  },
}
