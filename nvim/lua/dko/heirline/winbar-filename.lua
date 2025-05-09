local dkohl = require("dko.heirline.utils").hl
local utils = require("heirline.utils")

local DIRTY = { fg = utils.get_highlight("Todo").fg }

return {
  condition = function()
    return vim.bo.buftype == "" or vim.bo.buftype == "help"
  end,

  { provider = " " },

  -- fwiw you can have both lock and dirty
  {
    condition = function()
      return vim.bo.buftype == "" and (not vim.bo.modifiable or vim.bo.readonly)
    end,
    provider = " ",
    hl = function()
      return dkohl("Special")
    end,
  },

  {
    provider = function()
      return vim.bo.modified and "● " or ""
    end,
    -- Always has color, even on inactive pane
    hl = DIRTY,
  },

  {
    provider = function(self)
      if self.filepath == "" then
        return "ᴜɴɴᴀᴍᴇᴅ"
      end
      return vim.fn.fnamemodify(self.filepath, ":t")
    end,
    hl = function()
      return dkohl(vim.bo.modified and DIRTY or "StatusLine")
    end,
  },
  { provider = " " },
}
