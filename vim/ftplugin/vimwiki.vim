augroup vimwiki
  au! BufRead ~/Notes/Front\ Page.page !git pull
  au! BufWritePost ~/Notes/* !git add -A;git commit -m "update";git push
augroup END

silent! call dko#WordProcessorMode()
