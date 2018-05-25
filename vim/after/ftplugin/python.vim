" after/ftplugin/python.vim

" Make Python follow PEP8 for whitespace
" vim 7.4.051 already does this, so only here for backwards compat
setlocal softtabstop=4
setlocal tabstop=4
setlocal shiftwidth=4

" Auto format
map <buffer> <C-Y> :call yapf#YAPF()<cr>
imap <buffer> <C-Y> <c-o>:call yapf#YAPF()<cr>

" Sort imports
let g:vim_isort_python_version = 'python3'
map <buffer> <C-I> :py3 isort_file()<cr>

" Pydocstring
nmap <silent> <C-K> <Plug>(pydocstring)
