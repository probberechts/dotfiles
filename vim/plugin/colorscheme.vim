" plugin/colorscheme.vim

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
