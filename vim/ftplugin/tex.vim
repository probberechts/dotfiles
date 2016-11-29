" ftplugin/tex.vim
"

setlocal formatoptions=1
setlocal spell spelllang=en_gb
setlocal wrap

" Always start in display movement mode for tex
silent! call dkomovemode#setByDisplay()

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

  let g:vimtex_index_show_help = 0
  let g:vimtex_index_split_pos = 'vert rightbelow'
  let g:vimtex_toc_show_numbers = 0

  let g:vimtex_quickfix_ignored_warnings = [
        \ 'Underfull',
        \ 'Overfull',
        \ 'specifier changed to',
      \ ]

  let g:vimtex_view_general_viewer
        \ = '/Applications/Skim.app/Contents/SharedSupport/displayline'
  let g:vimtex_view_general_options = '-r @line @pdf @tex'

  " This adds a callback hook that updates Skim after compilation
  let g:vimtex_latexmk_callback_hooks = ['UpdateSkim']
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
    let g:vimtex_latexmk_progname = 'nvr'
  endif
endif
