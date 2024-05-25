" autoload/dko.vim
"
" vimrc and debugging helper funtions
"

" ============================================================================
" Guards
" ============================================================================

if exists('g:loaded_dko') | finish | endif
let g:loaded_dko = 1

" ============================================================================
" Setup vars
" ============================================================================

let g:dko#vim_dir = fnamemodify(resolve(expand('$MYVIMRC')), ':p:h')

let g:dko#plug_dir = '/vendor/'
let g:dko#plug_absdir = expand('$XDG_DATA_HOME') . '/vim' . g:dko#plug_dir

" ============================================================================
" General VimL utility functions
" ============================================================================

" Output &runtimepath, one per line, to current buffer
function! dko#Runtimepath() abort
  put! =split(&runtimepath, ',', 0)
endfunction

" Declare and define var as new dict if the variable has not been used before
"
" @param  {String} var
" @return {String} the declared var name
function! dko#InitDict(var) abort
  let {a:var} = exists(a:var) ? {a:var} : {}
  return {a:var}
endfunction

" Declare and define var as new list if the variable has not been used before
"
" @param  {String} var
" @return {String} the declared var name
function! dko#InitList(var) abort
  let {a:var} = exists(a:var) ? {a:var} : []
  return {a:var}
endfunction

" Generate a string command to map keys in nvo&ic modes to a command
"
" @param  {Dict}    settings
" @param  {String}  settings.key
" @param  {String}  [settings.command]
" @param  {Int}     [settings.special]
" @param  {Int}     [settings.remap]
" @return {String}  to execute (this way :verb map traces back to correct file)
function! dko#MapAll(settings) abort
  " Auto determine if special key was mapped
  " Just in case I forgot to include cpoptions guards somewhere
  let l:special = get(a:settings, 'special', 0) || a:settings.key[0] ==# '<'
        \ ? '<special>'
        \ : ''

  let l:remap = get(a:settings, 'remap', 1)
        \ ? 'nore'
        \ : ''

  " Key to map
  let l:lhs = '<silent>'
        \ . l:special
        \ . ' ' . a:settings.key . ' '

  " Command to map to
  if !empty(get(a:settings, 'command', ''))
    let l:rhs_nvo = ':<C-U>' . a:settings.command . '<CR>'
    let l:rhs_ic  = '<Esc>' . l:rhs_nvo
  else
    " No command
    " @TODO support non command mappings
    return ''
  endif

  " Compose result
  let l:mapping_nvo = l:remap . 'map '  . l:lhs . ' ' . l:rhs_nvo
  let l:mapping_ic  = l:remap . 'map! ' . l:lhs . ' ' . l:rhs_ic
  return l:mapping_nvo . '| ' . l:mapping_ic
endfunction

" @param {List} list
" @return {List} deduplicated list
function! dko#Unique(list) abort
  " stackoverflow style -- immutable, but unnecessary since we're operating on
  " a copy of the list in a:list anyway
  "return filter( copy(l:list), 'index(l:list, v:val, v:key + 1) == -1' )

  " xolox style -- mutable list
  return reverse(filter(reverse(a:list), 'count(a:list, v:val) == 1'))
endfunction

" @param {List} a:000 args
" @return {Mixed} first arg that is non-empty or empty string
function! dko#First(...) abort
  let l:list = type(a:1) == type([]) ? a:1 : a:000
  for l:item in l:list
    if !empty(l:item) | return l:item | endif
  endfor
  return ''
endfunction

" ============================================================================
" grepprg
" ============================================================================

function! dko#GetGrepper() abort
  if exists('s:grepper') | return s:grepper | endif

  let l:greppers = {}
  let l:greppers.rg = {
        \   'command': 'rg',
        \   'options': [
        \     '--hidden',
        \     '--smart-case',
        \     '--no-heading',
        \     '--vimgrep',
        \   ],
        \   'format': '%f:%l:%c:%m,%f:%l:%m,%f:%l%m,%f %l%m',
        \ }
  let l:greppers.ag = {
        \   'command': 'ag',
        \   'options': [
        \     '--hidden',
        \     '--smart-case',
        \     '--vimgrep',
        \   ],
        \   'format': '%f:%l:%c:%m,%f:%l:%m,%f:%l%m,%f %l%m',
        \ }
  let l:greppers.ack = {
        \   'command': 'ack',
        \   'options': [
        \     '--nogroup',
        \     '--nocolor',
        \     '--smart-case',
        \     '--column',
        \   ],
        \   'format': '%f:%l:%c:%m,%f:%l:%m,%f:%l%m,%f %l%m',
        \ }
  let l:greppers.grep = {
        \   'command': 'git grep',
        \   'options': [
        \     '--line-number',
        \   ],
        \   'format': '%f:%l:%c:%m,%f:%l:%m,%f:%l%m,%f %l%m',
        \ }


  let l:grepper_name =
        \   executable('rg') ? 'rg'
        \ : executable('ag') ? 'ag'
        \ : executable('ack') ? 'ack'
        \ : executable('grep') ? 'grep'
        \ : ''

  let s:grepper = empty(l:grepper_name) ? {} : l:greppers[l:grepper_name]

  return s:grepper
endfunction

" ============================================================================
" vim-plug helpers
" ============================================================================

" Memory cache
let s:plugged = {}

" @param  {String} name
" @return {Boolean} true if the plugin is installed
function! dko#IsPlugged(name) abort
  if has_key(s:plugged, a:name)
    return s:plugged[a:name]
  endif

  " Use exists instead of has_key so can skip checking if g:plugs itself
  " exists
  let l:is_plugged = exists("g:plugs['" . a:name . "']")
        \ && ( isdirectory(expand(g:plug_home . '/' . a:name))
        \      || isdirectory(expand(g:dko#vim_dir . '/mine/' . a:name)) )

  let s:plugged[a:name] = l:is_plugged

  return l:is_plugged
endfunction


" ============================================================================
" Filepath helpers
" ============================================================================

" Hide CWD in a path (make relative to CWD)
"
" @param {String[]} pathlist to shorten and validate
" @param {String} base to prepend to paths
" @return {String[]} filtered pathlist
function! dko#ShortPaths(pathlist, ...) abort
  let l:pathlist = a:pathlist

  " Prepend base path
  if isdirectory(get(a:, 1, ''))
    call map(l:pathlist, "a:1 . '/' . v:val")
  endif

  " Shorten
  return map(l:pathlist, "fnamemodify(v:val, ':.')" )
endfunction

" Return shortened path
"
" @param {String} path
" @param {Int} max
" @return {String}
function! dko#HomePath(path, ...) abort
  let l:max = get(a:, 1, 0)
  let l:full = fnamemodify(a:path, ':~:.')
  return l:max && len(l:full) > l:max
        \ ? ''
        \ : (len(l:full) == 0 ? '~' : l:full)
endfunction

" ============================================================================
" Filetype
" ============================================================================

function! dko#IsShebangBash() abort
  return getline(1) =~# '^#!.*bash'
endfunction

" ============================================================================
" Buffer info
" ============================================================================

" @param {Int|String} bufnr or {expr} as in bufname()
" @return {Boolean}
function! dko#IsHelp(bufnr) abort
  return getbufvar(a:bufnr, '&buftype') ==# 'help'
endfunction

let s:nonfilebuftypes = join([
      \ 'help',
      \ 'nofile',
      \ 'quickfix',
      \ 'terminal',
      \], '|')

let s:nonfilefiletypes = join([
      \ 'git$',
      \ 'netrw',
      \ 'vim-plug'
      \], '|')

" @param {Int|String} bufnr or {expr} as in bufname()
" @return {Boolean}
function! dko#IsNonFile(bufnr) abort
  let l:ft = getbufvar(a:bufnr, '&filetype')
  let l:bt = getbufvar(a:bufnr, '&buftype')
  return l:bt =~# '\v(' . s:nonfilebuftypes . ')'
        \ || l:ft =~# '\v(' . s:nonfilefiletypes . ')'
endfunction

" @param {Int|String} bufnr or {expr} as in bufname()
" @return {Boolean}
function! dko#IsEditable(bufnr) abort
  return getbufvar(a:bufnr, '&modifiable')
        \ && !getbufvar(a:bufnr, '&readonly')
        \ && !dko#IsNonFile(a:bufnr)
endfunction

" Usually to see if there's a linter/syntax
"
" @param {Int|String} bufnr
" @return {Boolean}
function! dko#IsTypedFile(...) abort
  let l:bufnr = get(a:, 1, '%')
  return !empty(getbufvar(l:bufnr, '&filetype')) && !dko#IsNonFile(l:bufnr)
endfunction

" ============================================================================
" Code parsing
" ============================================================================

" @param {String} [1] cursor position to look, defaults to current cursorline
" @return {String}
function! dko#GetFunctionInfo() abort

  " --------------------------------------------------------------------------
  " By current-func-info.vim
  " --------------------------------------------------------------------------

  if exists('g:loaded_cfi')
    return {
          \   'name':   cfi#get_func_name(),
          \   'source': 'cfi',
          \ }
  endif

  " --------------------------------------------------------------------------
  " By VimL
  " --------------------------------------------------------------------------

  "let l:position = get(a:, 1, getline('.')[:col('.')-2])
  let l:position = getline('.')
  let l:matches = matchlist(l:position, '\(()\s[a-zA-Z0-9_]*\)([^()]*$')
  if empty(l:matches) || empty(l:matches[1])
    return {}
  endif
  return {
        \   'name':   l:matches[1],
        \   'source': 'viml',
        \ }

endfunction

" ============================================================================
" Restore Position
" From vim help docs on last-position-jump
" ============================================================================

" http://stackoverflow.com/questions/6496778/vim-run-autocmd-on-all-filetypes-except
let s:excluded_ft = [
      \   'gitbranchdescription',
      \   'gitcommit',
      \   'gitrebase',
      \   'hgcommit',
      \   'svn',
      \ ]
function! dko#RestorePosition() abort
  if !dko#IsNonFile('%') || (
        \   index(s:excluded_ft, &filetype) < 0
        \   && line("'\"") > 1 && line("'\"") <= line('$')
        \)

    " Last check for file exists
    " https://github.com/farmergreg/vim-lastplace/blob/48ba343c8c1ca3039224727096aae214f51327d1/plugin/vim-lastplace.vim#L38
    try
      if empty(glob(@%)) | return | endif
    catch | return
    endtry
    silent! normal! g`"
  endif
endfunction

" ============================================================================
" Toggle prose writing mode
" ============================================================================

function! dko#WordProcessorMode() abort
  " Always start in display movement mode for prose
  silent! call dkomovemode#setByDisplay()

  if has('conceal')
    let b:indentLine_ConcealOptionSet=1 " Don't let indentLine overwrite us.
    setlocal concealcursor=nc
  endif
  setlocal spell spelllang=en
  setlocal wrap linebreak nolist
  setlocal textwidth=0 wrapmargin=0
  setlocal formatoptions-=t
  setlocal nonumber norelativenumber

  " C-g u sets an undo point, so this has the effect of letting me type for
  " a while and have undo just revert one sentence at a time, instead of
  " everything I've typed since entering insert mode.
  inoremap . .<C-g>u
  inoremap ! !<C-g>u
  inoremap ? ?<C-g>u
  inoremap : :<C-g>u

  map <leader>g :Goyo<CR>:GitGutterToggle<CR>

  " Ideally would keep 'list' set, and restrict 'listchars' to just show
  " whitespace errors, but 'listchars' is global and I don't want to go through
  " the hassle of saving and restoring.
  if has('autocmd')
    autocmd BufWinEnter <buffer> match Error /\s\+$/
    autocmd InsertEnter <buffer> match Error /\s\+\%#\@<!$/
    autocmd InsertLeave <buffer> match Error /\s\+$/
    autocmd BufWinLeave <buffer> call clearmatches()
  endif
endfunction

" ============================================================================
" Whitespace settings
" ============================================================================

function! dko#TwoSpace() abort
  setlocal expandtab shiftwidth=2 softtabstop=2
endfunction

function! dko#FourSpace() abort
  setlocal expandtab shiftwidth=4 softtabstop=4
endfunction

function! dko#TwoTabs() abort
  setlocal noexpandtab shiftwidth=2 softtabstop=2
endfunction

function! dko#FourTabs() abort
  setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=0
endfunction

function! dko#PrettierSpace() abort
  let l:rc_candidate = dkoproject#GetPrettierrc()
  if empty(l:rc_candidate)
    return v:false
  endif

  let l:rc_file = dkoproject#GetFile(l:rc_candidate)
  try
    let l:contents = json_decode(readfile(l:rc_file))
    if l:contents['tabWidth'] == 4
      call dko#FourSpace()
      return v:true
    elseif l:contents['tabWidth'] == 2
      call dko#TwoSpace()
      return v:true
    endif
  catch
  endtry

  return v:false
endfunction
