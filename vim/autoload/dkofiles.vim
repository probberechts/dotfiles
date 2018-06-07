" autoload/dkofiles.vim

" ============================================================================
" MRU based on v:oldfiles
" ============================================================================

let s:mru_blacklist = "v:val !~ '" . join([
      \   'fugitive:',
      \   'NERD_tree',
      \   '^/tmp/',
      \   '.git/',
      \   'vim/runtime/doc',
      \ ], '\|') . "'"

" @return {List} recently used and still-existing files
function! dkofiles#GetMru() abort
  return get(s:, 'mru_cache', dkofiles#RefreshMru())
endfunction

function! dkofiles#RefreshMru() abort
  let s:mru_cache = dko#ShortPaths(filter(copy(v:oldfiles), s:mru_blacklist))
  return s:mru_cache
endfunction

augroup dkomru
  autocmd! dkomru BufAdd,BufNew,BufFilePost * call dkofiles#RefreshMru()
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
