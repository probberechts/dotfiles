" plugin/plug-vim-gutentags.vim
if !dko#IsPlugged('vim-gutentags') | finish | endif

let g:gutentags_tagfile = '.git/tags'

" Toggle :GutentagsToggleEnabled to enable
let g:gutentags_enabled                  = 1
let g:gutentags_generate_on_missing      = 0
let g:gutentags_generate_on_new          = 1
let g:gutentags_generate_on_write        = 1
let g:gutentags_define_advanced_commands = 1
let g:gutentags_resolve_symlinks         = 1
