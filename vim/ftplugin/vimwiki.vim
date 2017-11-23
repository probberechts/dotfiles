augroup vimwiki
  au! BufRead ~/Notes/Front\ Page.page !git pull
  au! BufWritePost ~/Notes/* !git add -A;git commit -m "update";git push
augroup END

setlocal nonumber
setlocal norelativenumber
set foldcolumn=5
set columns=85

setlocal formatoptions=antw
setlocal textwidth=80
setlocal wrapmargin=0

setlocal noautoindent
setlocal nocindent
setlocal nosmartindent
setlocal indentexpr=

let &guifont=substitute(&guifont, ':h\zs\d\+', '\=submatch(0)+1', '')
