local conditions = require("heirline.conditions")
return {
  init = function(self)
    self.branch = conditions.is_git_repo() and vim.g.gitsigns_head or ""

    self.cwd = vim.uv.cwd()
  end,

  require("dko.heirline.cwd"),
  require("dko.heirline.git"),
  require("dko.heirline.bufferstats"),

  { provider = "%=", hl = "StatusLineNC" },

  require("dko.heirline.clipboard"),
  require("dko.heirline.remote"),
  require("dko.heirline.lazy"),
  require("dko.heirline.doctor"),

  -- still buggy on their side
  -- require("dko.heirline.dko-heirline-package-info"),
}
