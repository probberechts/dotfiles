" plugin/colorscheme.vim

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  set termguicolors
endif

if dko#IsPlugged('vim-one')
  set background=dark
  let g:one_allow_italics = 1
  silent! colorscheme one

elseif dko#IsPlugged('Base2Tone-vim')
  set background=dark
  silent! colorscheme Base2Tone-Lake-dark

elseif dko#IsPlugged('vim-hybrid')
  set background=dark
  let g:hybrid_custom_term_colors = 1
  let g:hybrid_reduced_contrast = 1 " Remove this line if using the default palette.
  silent! colorscheme hybrid

else
  silent! colorscheme darkblue

endif
