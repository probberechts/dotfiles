return {
  "lervag/vimtex",
  lazy = false,
  init = function()
    vim.g.vimtex_quickfix_mode = 0 -- the quickfix window is not opened automatically
  end,
}
