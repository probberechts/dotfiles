" filetype.vim
"
" This needs to be first -- don't move into after/ or else some manually
" defined ftplugins won't load
"
" These do NOT get overridden -- see *ftdetect* in vim filetype help
" http://vimdoc.sourceforge.net/htmldoc/filetype.html
"
" Runs on `filetype on`
"

if exists('g:did_load_filetypes_user') | finish | endif
let g:did_load_filetypes_user = 1

function! s:SetByShebang() abort
  let l:shebang = getline(1)
  if l:shebang =~# '^#!.*/.*\s\+node\>' | setfiletype javascript | endif
  if l:shebang =~# '^#!.*/.*\s\+zsh\>' | setfiletype zsh | endif
endfunction

" For filetypes that can be detected by filename (option C in the docs for
" `new-filetype`)
" Use `autocmd!` so the original filetype autocmd for the given extension gets
" cleared (otherwise it will run, and then this one, possible causing two
" filetype events to execute in succession)
augroup filetypedetect
  autocmd! BufNewFile,BufRead * call s:SetByShebang()

  autocmd! BufNewFile,BufRead *.dump setfiletype sql
  autocmd! BufNewFile,BufRead .flake8 setfiletype dosini

  autocmd! BufNewFile,BufRead *.gitconfig setfiletype gitconfig

  " git branch description (opened via `git branch --edit-description`)
  autocmd! BufNewFile,BufRead BRANCH_DESCRIPTION setfiletype gitbranchdescription.markdown

augroup END
