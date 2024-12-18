-- List format-on-save clients for the buffer
return {
  condition = function()
    return vim.b.formatters ~= nil and #vim.b.formatters > 0
  end,
  update = { "User", pattern = "FormatterChanged" },
  {
    provider = function()
      return " 󰳻 "
    end,
    hl = "dkoStatusKey",
  },
  {
    provider = function()
      return (" %s "):format(table.concat(vim.b.formatters, ", "))
    end,
    hl = "dkoStatusItem",
  },
}
