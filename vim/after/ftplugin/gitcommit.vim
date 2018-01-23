" after/ftplugin/gitcommit.vim
"
" Nice big git commit message window
" Only runs in a vim server named GIT (probably opened via my "e" script)
"

silent! call dko#WordProcessorMode()

setlocal complete+=kspell

" override settings that were undone by @gtd in tpope/vim-git
setlocal textwidth=80
setlocal tabstop=4
setlocal formatoptions+=croq
