local conditions = require("heirline.conditions")
return {
  init = function(self)
    self.branch = vim.g.gitsigns_head or ""

    self.cwd = vim.uv.cwd()
  end,

  hl = "StatusLineNC",

  require("dko.heirline.bufferstats"),

  require("dko.heirline.cwd"),
  require("dko.heirline.git"),

  { provider = "%=" },

  require("dko.heirline.clipboard"),
  require("dko.heirline.remote"),
  require("dko.heirline.lazy"),
  require("dko.heirline.doctor"),
}
