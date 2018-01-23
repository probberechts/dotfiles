" after/ftplugin/markdown.vim
"
" There are additional settings in ftplugin/markdown.vim that are set for
" plugins that need variables set before loading.
"
" This is run AFTER after/ftplugin/html.vim
" It needs to explicitly override anything there
"
silent! call dko#WordProcessorMode()

" too slow
"setlocal complete+=kspell

if dko#IsPlugged('vim-pandoc')
  execute dko#MapAll({ 'key': '<F2>', 'command': 'TOC' })
endif
