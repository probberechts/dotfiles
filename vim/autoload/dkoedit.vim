" autoload/dkoedit.vim

" ============================================================================
" Quick edit
" ec* - Edit closest (find upwards)
" er* - Edit from dko#project#GetRoot()
" ============================================================================

" @param {String} file
function! dkoedit#Edit(file) abort
  if empty(a:file)
    echomsg 'File not found: ' . a:file
    return
  endif
  execute 'edit ' . a:file
endfunction

" This executes instead of returns string so the mapping can noop when file
" not found.
" @param {String} file
function! dkoedit#EditClosest(file) abort
  let l:file = findfile(a:file, '.;')
  call dkoedit#Edit(l:file)
endfunction

" As above, this noops if file not found
" @param {String} file
function! dkoedit#EditRoot(file) abort
  let l:file = dkoproject#GetFile(a:file)
  call dkoedit#Edit(l:file)
endfunction
