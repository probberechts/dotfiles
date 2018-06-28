" plugin/fzf.vim
scriptencoding utf-8

augroup dkofzf
  autocmd!
augroup END

if !dko#IsPlugged('fzf.vim') | finish | endif

" ============================================================================
" fzf.vim settings
" ============================================================================

let g:fzf_command_prefix = 'FZF'

let g:fzf_layout = { 'down': '10' }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" ============================================================================
" Mappings
" ============================================================================

" junegunn/fzf mappings for the neovim :term
" Bind <fx> to abort FZF (<C-g> is one of the default abort keys in FZF)
" @see #f-keys
function! s:MapCloseFzf() abort
  if !has('nvim') | return | endif

  tnoremap <buffer><special> <F1> <C-g>
  tnoremap <buffer><special> <F2> <C-g>
  tnoremap <buffer><special> <F3> <C-g>
  tnoremap <buffer><special> <F4> <C-g>
  tnoremap <buffer><special> <F5> <C-g>
  tnoremap <buffer><special> <F6> <C-g>
  tnoremap <buffer><special> <F7> <C-g>
  tnoremap <buffer><special> <F8> <C-g>
  tnoremap <buffer><special> <F9> <C-g>
  tnoremap <buffer><special> <F10> <C-g>
  tnoremap <buffer><special> <F11> <C-g>
  tnoremap <buffer><special> <F12> <C-g>
endfunction
autocmd dkofzf FileType fzf call s:MapCloseFzf()

" Map the commands
nnoremap  <silent><special>   <A-b>   :<C-U>FZFBuffers<CR>
nnoremap  <silent><special>   <A-c>   :<C-U>FZFCommands<CR>
nnoremap  <silent><special>   <A-f>   :<C-U>FZFFiles<CR>
nnoremap  <silent><special>   <A-g>   :<C-U>FZFGrepper!<CR>
nnoremap  <silent><special>   <A-m>   :<C-U>FZFMRU<CR>
nnoremap  <silent><special>   <A-p>   :<C-U>FZFProject<CR>
nnoremap  <silent><special>   <A-r>   :<C-U>FZFRelevant<CR>
nnoremap  <silent><special>   <A-t>   :<C-U>FZFSpecs<CR>
nnoremap  <silent><special>   <A-v>   :<C-U>FZFVim<CR>

execute dko#MapAll({ 'key': '<F3>', 'command': 'FZFMRU' })
execute dko#MapAll({ 'key': '<F4>', 'command': 'FZFRelevant' })
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
  return dkoproject#GetDir('tests')
endfunction

" ============================================================================
" Custom sources for junegunn/fzf
" ============================================================================

" Notes:
" - Use fzf#wrap() instead of 'sink' option to get the <C-T/V/X> keybindings
"   when the source is to open files
"

" Some default options.
" --cycle through list
" --multi select with <Tab>
let s:options = ' --cycle --multi '

" ----------------------------------------------------------------------------
" git relevant
" ----------------------------------------------------------------------------

" Depends on my `git-relevant` script, see:
" https://github.com/davidosomething/dotfiles/blob/master/bin/git-relevant
" Alternatively use git-extras' `git-delta` (though it doesn't get unstaged
" files)
"
" @param {String[]} args passed to git-relevant, e.g. `--branch somebranch`
" @return {String[]} list of shortfilepaths that are relevant to the branch
function! s:GetFzfRelevantSource(...) abort
  let l:args = get(a:, '000', [])
  let l:relevant = system(
        \   'cd -- "' . s:GetRoot() . '" '
        \ . '&& git relevant ' . join(l:args, ' ')
        \)
  if v:shell_error
    return []
  endif

  " List of paths, relative to the buffer's b:dkoproject_root
  let l:relevant_list = split(l:relevant, '\n')

  " Check that the paths, prefixed with the root exist
  let l:filtered = filter(l:relevant_list,
        \ 'filereadable(expand("' . s:GetRoot() . '/" . v:val))'
        \ )
  return l:filtered
endfunction

" List relevant and don't include anything .gitignored
" Accepts args for `git-relevant`
command! -nargs=* FZFRelevant call fzf#run(fzf#wrap('Relevant',
      \   fzf#vim#with_preview(extend({
      \     'dir':      s:GetRoot(),
      \     'source':   s:GetFzfRelevantSource(<f-args>),
      \     'options':  s:options . ' --prompt="Rel> "',
      \   }, g:fzf_layout), 'right:50%')
      \ ))

" ----------------------------------------------------------------------------
" My vim runtime files
" ----------------------------------------------------------------------------

" @return {List} my files in my vim runtime
function! s:GetFzfVimSource() abort
  " Want these recomputed every time in case files are added/removed
  let l:runtime_dirs_files = globpath(g:dko#vim_dir, '{' . join([
        \   'after',
        \   'autoload',
        \   'ftplugin',
        \   'mine',
        \   'plugin',
        \   'snippets',
        \   'syntax',
        \ ], ',') . '}/**/*.vim', 0, 1)
  let l:runtime_files = globpath(g:dko#vim_dir, '*.vim', 0, 1)
  let l:rcfiles = globpath(g:dko#vim_dir, '*vimrc', 0, 1)
  return l:runtime_dirs_files + l:runtime_files + l:rcfiles
endfunction

command! FZFVim
      \ call fzf#run(fzf#wrap('Vim',
      \   fzf#vim#with_preview(extend({
      \     'dir':      s:GetRoot(),
      \     'source':   s:GetFzfVimSource(),
      \     'options':  s:options . ' --prompt="Vim> "',
      \   }, g:fzf_layout), 'right:50%')
      \ ))

" ----------------------------------------------------------------------------
" Whitelisted MRU/Buffer combined.
" Regular :FZFHistory doesn't blacklist files
" ----------------------------------------------------------------------------

command! FZFMRU
      \ call fzf#run(fzf#wrap('MRU',
      \   fzf#vim#with_preview(extend({
      \     'source':  dkofiles#GetMru(),
      \     'options': s:options . ' --no-sort --prompt="MRU> "',
      \   }, g:fzf_layout), 'right:50%')
      \ ))

" ----------------------------------------------------------------------------
" Test specs
" ----------------------------------------------------------------------------

command! FZFSpecs
      \ call fzf#run(fzf#wrap('Specs',
      \   fzf#vim#with_preview(extend({
      \     'source':   dko#ShortPaths(dkotests#FindSpecs()),
      \     'options':  s:options . ' --prompt="Specs> "',
      \   }, g:fzf_layout), 'right:50%')
      \ ))

" ============================================================================
" Custom commands for fzf.vim
" ============================================================================

" ----------------------------------------------------------------------------
" FZFGrepper
" fzf.vim ripgrep or ag with preview (requires ruby, but safely checks for it)
" Fallback to git-grep if rg and ag not installed (e.g. I'm ssh'ed somewhere)
" @see https://github.com/junegunn/fzf.vim#advanced-customization
" ----------------------------------------------------------------------------

if dko#GetGrepper().command ==# 'rg'
  command! -bang -nargs=* FZFGrepper
        \ call fzf#vim#grep(
        \   'rg --color=always --column --hidden --line-number --no-heading '
        \     . '--no-ignore-vcs '
        \     . '--ignore-file "${DOTFILES}/ag/dot.ignore" '
        \     . shellescape(<q-args>),
        \   1,
        \   <bang>0 ? fzf#vim#with_preview({ 'dir': s:GetRoot() }, 'up:60%')
        \           : fzf#vim#with_preview({ 'dir': s:GetRoot() }, 'right:50%', '?'),
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
        \   <bang>0 ? fzf#vim#with_preview({ 'dir': s:GetRoot() }, 'up:60%')
        \           : fzf#vim#with_preview({ 'dir': s:GetRoot() }, 'right:50%', '?'),
        \   <bang>0
        \ )
else
  command! -bang -nargs=* FZFGrepper
        \ call fzf#vim#grep(
        \   'git grep --line-number ' . shellescape(<q-args>),
        \   1,
        \   <bang>0 ? fzf#vim#with_preview({ 'dir': s:GetRoot() }, 'up:60%')
        \           : fzf#vim#with_preview({ 'dir': s:GetRoot() }, 'right:50%', '?'),
        \   <bang>0
        \ )
endif

" ----------------------------------------------------------------------------
" Files from project root
" ----------------------------------------------------------------------------

command! -bang FZFProject
      \ call fzf#vim#files(
      \   s:GetRoot(),
      \   <bang>0 ? fzf#vim#with_preview({}, 'up:60%')
      \           : fzf#vim#with_preview({}, 'right:50%', '?'),
      \   <bang>0
      \ )
