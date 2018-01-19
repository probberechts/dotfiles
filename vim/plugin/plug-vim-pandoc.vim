" plugin/plug-vim-pandoc.vim

" Use this plugin on markdown
let g:pandoc#filetypes#handled = ['pandoc', 'markdown']

" but don't override the filetype (leave it as 'markdown')
"let g:pandoc#filetypes#pandoc_markdown = 0

let g:pandoc#modules#disabled = ["folding"]

" Don't bind keys since they assume use of \ instead of <Leader>
" let g:pandoc#keyboard#use_default_mappings = 0

let g:pandoc#syntax#conceal#use = 1

let g:pandoc#syntax#codeblocks#embeds#langs = [
      \   'bash=sh',
      \   'html',
      \   'javascript',
      \   'vim',
      \ ]

let g:pandoc#biblio#bibs = ['~/.pandoc/default.bib']

let g:pandoc#toc#close_after_navigating = 0
