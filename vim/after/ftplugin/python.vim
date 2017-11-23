" after/ftplugin/python.vim

" Make Python follow PEP8 for whitespace
" vim 7.4.051 already does this, so only here for backwards compat
setlocal softtabstop=4
setlocal tabstop=4
setlocal shiftwidth=4

" Autoformat with '=' according to PEP8 guidelines
set equalprg=yapf

" Sort imports
nnoremap <Leader>i :!isort %<CR><CR>

