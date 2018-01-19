augroup vimwiki
  au! BufRead ~/Notes/Front\ Page.page !git pull
  au! BufWritePost ~/Notes/* !git add -A;git commit -m "update";git push
augroup END

setlocal nonumber
setlocal norelativenumber
setlocal foldcolumn=5
setlocal columns=85

" setlocal formatoptions=antw
setlocal formatoptions+=tcqln
setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^[-*+]\\s\
setlocal textwidth=80
setlocal wrapmargin=0

setlocal noautoindent
setlocal nocindent
setlocal nosmartindent
setlocal indentexpr=

let &guifont=substitute(&guifont, ':h\zs\d\+', '\=submatch(0)+1', '')
