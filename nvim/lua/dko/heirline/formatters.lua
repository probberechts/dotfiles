local conditions = require("heirline.conditions")

-- List format-on-save clients for the buffer
return {
  condition = function()
    return vim.b.formatters ~= nil and #vim.b.formatters > 0
  end,
  {
    provider = function()
      if vim.b.enable_format_on_save then
        return " 󰳻 "
      else
        return " ⏼"
      end
    end,
    hl = function()
      return conditions.is_active() and "dkoStatusKey" or "StatusLineNC"
    end,
  },
  {
    provider = function()
      return (" %s "):format(table.concat(vim.b.formatters, ", "))
    end,
    hl = function()
      return conditions.is_active() and "StatusLine" or "StatusLineNC"
    end,
  },
}
