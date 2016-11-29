" plugin/plug-tagbar.vim


execute dko#MapAll({ 'key': '<F2>', 'command': 'TagbarToggle' })

" omit the short help at the top and the blank lines in between top-level scopes
let g:tagbar_compact = 1
