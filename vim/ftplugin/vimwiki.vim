augroup vimwiki
  au! BufRead ~/Notes/Home.md !git pull
  au! BufWritePost ~/Notes/* !git add -A;git commit -m "update";git push
augroup END
