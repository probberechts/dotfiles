" autoload/dkofiles.vim

" ============================================================================
" MRU based on v:oldfiles
" ============================================================================

let s:mru_blacklist = join([
      \   '.git/',
      \   'NERD_tree',
      \   'NetrwTreeListing',
      \   '^/tmp/',
      \   'fugitive:',
      \   'vim/runtime/doc',
      \ ], '|')

" @return {List} recently used and still-existing files
function! dkofiles#GetMru() abort
  return get(s:, 'mru_cache', dkofiles#RefreshMru())
endfunction

function! dkofiles#RefreshMru() abort
  let s:mru_cache =
        \ dko#ShortPaths(map(
        \   filter(
        \     copy(v:oldfiles),
        \     'filereadable(v:val) && v:val !~ "\\v(' . s:mru_blacklist . ')"'
        \   ),
        \   'expand(v:val)'
        \ ))
  return s:mru_cache
endfunction

function! dkofiles#UpdateMru(file) abort
  if dko#IsEditable('%')
    let s:mru_cache = add(get(s:, 'mru_cache', []), a:file)
  endif
endfunction

augroup dkomru
  autocmd!
  autocmd dkomru BufAdd,BufNew,BufFilePost *
        \ call dkofiles#UpdateMru(expand('<amatch>'))
augroup END

" ============================================================================
" Clean buffer names
" ============================================================================

" @return {List} listed buffers
function! dkofiles#GetBuffers() abort
  return map(
        \   filter(range(1, bufnr('$')), 'buflisted(v:val) && !empty(v:val)'),
        \   'bufname(v:val)'
        \ )
endfunction
