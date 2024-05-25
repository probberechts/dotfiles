-- $VIMRUNTIME syntax indent settings

-- markdown
-- Variable to highlight markdown fenced code properly -- uses tpope's
-- vim-markdown plugin (which is bundled with vim7.4 now)
-- There are more syntaxes, but checking for them makes editing md very slow
vim.g.markdown_fenced_languages = {
  "javascript",
  "js=javascript",
  "javascriptreact",
  "json",
  "bash=sh",
  "sh",
  "vim",
  "help",
}

-- python
-- $VIMRUNTIME/syntax/python.vim
vim.g.python_highlight_all = 1

-- sh
-- $VIMRUNTIME/syntax/sh.vim - always assume bash
vim.g.is_bash = 1

-- vim
-- $VIMRUNTIME/syntax/vim.vim
-- disable mzscheme, tcl highlighting
vim.g.vimsyn_embed = "lpPr"
