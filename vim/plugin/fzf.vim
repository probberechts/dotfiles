" plugin/fzf.vim
scriptencoding utf-8
if !dko#IsPlugged('fzf.vim') | finish | endif

let g:fzf_command_prefix = 'FZF'

let g:fzf_layout = { 'down': '10' }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

execute dko#MapAll({ 'key': '<F3>', 'command': 'FZFMRU' })
execute dko#MapAll({ 'key': '<F4>', 'command': 'FZFProject' })
execute dko#MapAll({ 'key': '<F5>', 'command': 'FZFGrepper' })
execute dko#MapAll({ 'key': '<F6>', 'command': 'FZFSpecs' })
execute dko#MapAll({ 'key': '<F9>', 'command': 'FZFVim' })

" ============================================================================
" Local Helpers
" ============================================================================

" fzf#run() can't use autoload function in options so wrap it with
" a script-local
"
" @return {String} project root
function! s:GetRoot() abort
  return dkoproject#GetRoot()
endfunction

" @return {String} test specs dir
function! s:GetSpecs() abort
  return dkotests#FindTests()
endfunction

" ============================================================================
" My custom sources
" ============================================================================
"
" Notes:
" - Use fzf#wrap() instead of 'sink' option to get the <C-T/V/X> keybindings
"   when the source is to open files
"

" Some default options.
" --cycle through list
" --multi select with <Tab>
let s:options = ' --cycle --multi '

" ----------------------------------------------------------------------------
" My vim runtime
" ----------------------------------------------------------------------------

" @return {List} my files in my vim runtime
function! s:GetFzfVimSource() abort
  " Want these recomputed every time in case files are added/removed
  let l:runtime_dirs_files = globpath(g:dko#vim_dir, '{' . join([
        \   'autoload',
        \   'ftplugin',
        \   'plugin',
        \   'snippets',
        \   'syntax',
        \ ], ',') . '}/*.vim', 0, 1)
  let l:runtime_dirs2_files = globpath(g:dko#vim_dir, '{' . join([
        \   'after',
        \ ], ',') . '}/**/*.vim', 0, 1)
  let l:runtime_files = globpath(g:dko#vim_dir, '*.vim', 0, 1)
  let l:rcfiles = globpath(g:dko#vim_dir, '*vimrc', 0, 1)
  return dko#ShortPaths( l:runtime_dirs_files + l:runtime_dirs2_files + l:runtime_files + l:rcfiles )
endfunction

command! FZFVim
      \ call fzf#run(fzf#wrap('Vim',
      \   fzf#vim#with_preview(extend({
      \     'source':   s:GetFzfVimSource(),
      \     'options':  s:options . ' --prompt="Vim> "',
      \   }, g:fzf_layout), 'right:50%')
      \ ))

" ----------------------------------------------------------------------------
" Whitelisted MRU/Buffer combined
" Regular MRU doesn't blacklist files
" ----------------------------------------------------------------------------

command! FZFMRU
      \ call fzf#run(fzf#wrap('MRU',
      \   fzf#vim#with_preview(extend({
      \     'source':  dko#GetMru(),
      \     'options': s:options . ' --no-sort --prompt="MRU> "',
      \   }, g:fzf_layout), 'right:50%')
      \ ))


" ----------------------------------------------------------------------------
" Test specs
" ----------------------------------------------------------------------------

command! FZFSpecs
      \ call fzf#run(fzf#wrap('Specs',
      \   fzf#vim#with_preview(extend({
      \     'source':   dko#ShortPaths(s:GetSpecs()),
      \     'options':  s:options . ' --prompt="Specs> "',
      \   }, g:fzf_layout), 'right:50%')
      \ ))

" ----------------------------------------------------------------------------
" FZFGrepper
" fzf.vim ripgrep or ag with preview (requires ruby, but safely checks for it)
" Fallback to git-grep if rg and ag not installed (e.g. I'm ssh'ed somewhere)
" @see https://github.com/junegunn/fzf.vim#advanced-customization
" ----------------------------------------------------------------------------

" FZFGrepper! settings
let s:grepper_full = fzf#vim#with_preview(
      \   { 'dir': s:GetRoot() },
      \   'up:60%'
      \ )

" FZFGrepper settings
let s:grepper_half = fzf#vim#with_preview(
      \   { 'dir': s:GetRoot() },
      \   'right:50%',
      \   '?'
      \ )

if dko#GetGrepper().command ==# 'rg'
  command! -bang -nargs=* FZFGrepper
        \ call fzf#vim#grep(
        \   'rg --color=always --column --hidden --line-number --no-heading '
        \     . '--no-ignore-vcs '
        \     . '--ignore-file "${DOTFILES}/ag/dot.ignore" '
        \     . shellescape(<q-args>),
        \   1,
        \   <bang>0 ? s:grepper_full : s:grepper_half,
        \   <bang>0
        \ )
elseif dko#GetGrepper().command ==# 'ag'
  " @see https://github.com/junegunn/fzf.vim/blob/abdf894edf5dbbe8eaa734a6a4dce39c9f174e33/autoload/fzf/vim.vim#L614
  " Default options are --nogroup --column --color
  let s:ag_options = ' --skip-vcs-ignores --smart-case '

  command! -bang -nargs=* FZFGrepper
        \ call fzf#vim#ag(
        \   <q-args>,
        \   s:ag_options,
        \   <bang>0 ? s:grepper_full : s:grepper_half,
        \   <bang>0
        \ )
else
  command! -bang -nargs=* FZFGrepper
        \ call fzf#vim#grep(
        \   'git grep --line-number ' . shellescape(<q-args>),
        \   1,
        \   <bang>0 ? s:grepper_full : s:grepper_half,
        \   <bang>0
        \ )
endif

" ----------------------------------------------------------------------------
" Files from project root
" ----------------------------------------------------------------------------

" FZFProject! settings
let s:project_full = fzf#vim#with_preview(
      \   {},
      \   'up:60%'
      \ )

" FZFProject settings
let s:project_half = fzf#vim#with_preview(
      \   {},
      \   'right:50%',
      \   '?'
      \ )

command! -bang FZFProject
      \ call fzf#vim#files(
      \   s:GetRoot(),
      \   <bang>0 ? s:project_full : s:project_half,
      \   <bang>0
      \ )
