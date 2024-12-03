local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.fn.getftype(lazypath) == "dir" then
  vim
    .system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
    :wait()
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("dko.plugins", {
  change_detection = {
    enabled = false,
  },
  checker = {
    -- needed to get the output of require("lazy.status").updates()
    enabled = true,
    -- get a notification when new updates are found?
    notify = false,
  },
  dev = {
    fallback = true,
    patterns = { "davidosomething" },
  },
  rocks = { enabled = false, hererocks = false },
  ui = { border = require("dko.settings").get("border") },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen", -- vim-matchup will re-load this anyway
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
