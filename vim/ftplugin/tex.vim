" ftplugin/tex.vim
"

" Always start in display movement mode for tex
" silent! call dkomovemode#setByDisplay()
silent! call dko#WordProcessorMode()

let g:tex_flavor = 'latex'

" Conceal
setlocal conceallevel=2
setlocal concealcursor=nvc
let g:tex_conceal="adgms"

" Fold
setlocal foldmethod=expr
setlocal foldexpr=vimtex#fold#level(v:lnum)
setlocal foldtext=dko#foldtext()

" No limit for syntax highlighting
setlocal synmaxcol=0

" Reformat lines (getting the spacing correct) {{{
fun! TeX_fmt()
    if (getline(".") != "")
    let save_cursor = getpos(".")
        let op_wrapscan = &wrapscan
        set nowrapscan
        let par_begin = '^\(%D\)\=\s*\($\|\\begin\|\\end\|\\\[\|\\\]\|\\\(sub\)*section\>\|\\item\>\|\\NC\>\|\\blank\>\|\\noindent\>\)'
        let par_end   = '^\(%D\)\=\s*\($\|\\begin\|\\end\|\\\[\|\\\]\|\\place\|\\\(sub\)*section\>\|\\item\>\|\\NC\>\|\\blank\>\)'
    try
      exe '?'.par_begin.'?+'
    catch /E384/
      1
    endtry
        norm V
    try
      exe '/'.par_end.'/-'
    catch /E385/
      $
    endtry
    norm gq
        let &wrapscan = op_wrapscan
    call setpos('.', save_cursor) 
    endif
endfun

nmap W :call TeX_fmt()<CR>


if dko#IsPlugged('vimtex')
  execute dko#MapAll({ 'key': '<F2>', 'command': 'VimtexTocToggle' })

  " TOC settings
  let g:vimtex_toc_config = {
      \ 'name' : 'TOC',
      \ 'layers' : ['content', 'todo', 'include'],
      \ 'resize' : 1,
      \ 'split_width' : 50,
      \ 'todo_sorted' : 0,
      \ 'show_help' : 0,
      \ 'show_numbers' : 0,
      \ 'mode' : 2,
      \}

  let g:vimtex_quickfix_ignore_filters = [
        \ 'Underfull',
        \ 'Overfull',
        \ 'specifier changed to',
      \ ]

  if executable('okular')
    let g:vimtex_view_general_viewer = 'okular'
    let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
  elseif executable('/Applications/Skim.app/Contents/SharedSupport/displayline')
    let g:vimtex_view_general_viewer
          \ = '/Applications/Skim.app/Contents/SharedSupport/displayline'
    let g:vimtex_view_general_options = '-r @line @pdf @tex'
    let g:vimtex_latexmk_callback_hooks = ['UpdateSkim']
  endif

  " This adds a callback hook that updates Skim after compilation
  function! UpdateSkim(status)
    if !a:status | return | endif

    let l:out = b:vimtex.out()
    let l:tex = expand('%:p')
    let l:cmd = [g:vimtex_view_general_viewer, '-r']
    if !empty(system('pgrep Skim'))
      call extend(l:cmd, ['-g'])
    endif
    if has('nvim')
      call jobstart(l:cmd + [line('.'), l:out, l:tex])
    elseif has('job')
      call job_start(l:cmd + [line('.'), l:out, l:tex])
    else
      call system(join(l:cmd + [line('.'), shellescape(l:out), shellescape(l:tex)], ' '))
    endif
  endfunction

  if has('nvim')
  " `latexmk` coupling and some of the viewer functionality require the |--remote|
  " options. These options have been removed from neovim. `neovim-remote` [1] is
  " a simple tool that implements the |--remote| options through a python script.
    let g:vimtex_compiler_progname = 'nvr'
  endif
endif
