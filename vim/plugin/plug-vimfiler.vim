" plugin/plug-vimfiler.vim
scriptencoding utf-8
if !dko#IsPlugged('vimfiler.vim') | finish | endif

let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0

" ============================================================================
" List settings
" ============================================================================

" Default was all dot files. Overriding with just these:
let g:vimfiler_ignore_pattern = 
      \ '^\%(\.git\|\.idea\|\.DS_Store\|\.vagrant\|\.stversions\|\.tmp'
      \ .'\|node_modules\|.*\.pyc\|.*\.class\|.*\.egg-info\|__pycache__\)$'

" ============================================================================
" Symbol setup
" ============================================================================

let g:vimfiler_tree_leaf_icon     = ' '
let g:vimfiler_tree_opened_icon   = '▾'
let g:vimfiler_tree_closed_icon   = '▸'
let g:vimfiler_file_icon          = '-'
let g:vimfiler_marked_file_icon   = '*'
let g:vimfiler_readonly_file_icon = 'ʀ'

" ============================================================================
" Shortcut
" ============================================================================

execute dko#MapAll({
      \   'key':     '<F1>',
      \   'command': 'VimFilerExplorer -parent -explorer-columns=type'
      \ })

" ============================================================================
" Keymappings
" ============================================================================

augroup dkovimfiler
  autocmd FileType vimfiler
        \ nmap <buffer> u <Plug>(vimfiler_switch_to_parent_directory)
  autocmd FileType vimfiler
        \ nmap <buffer> q <Plug>(vimfiler_close)
  autocmd FileType vimfiler
        \ set nonumber |
        \ set norelativenumber
augroup END
