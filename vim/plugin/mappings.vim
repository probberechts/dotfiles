" plugin/mappings.vim
scriptencoding utf-8

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================
" My abbreviations and autocorrect
" ============================================================================

inoreabbrev :lod: ಠ_ಠ
inoreabbrev :flip: (ﾉಥ益ಥ）ﾉ︵┻━┻
inoreabbrev :yuno: ლ(ಠ益ಠლ)
inoreabbrev :strong: ᕦ(ò_óˇ)ᕤ

inoreabbrev unlabeled   unlabelled

inoreabbrev targetted   targeted
inoreabbrev targetting  targeting
inoreabbrev targetter   targeter

inoreabbrev threshhold  threshold
inoreabbrev threshholds thresholds

inoreabbrev removeable  removable

inoreabbrev p'' Pieter
inoreabbrev r'' Robberechts
inoreabbrev p@@ pieter_robberechts@msn.com
inoreabbrev w@@ pieter.robberechts@kuleuven.be

" ============================================================================
" Disable for reuse
" ============================================================================

" [n]gs normally waits for [n] seconds, totally useless
noremap   gs    <NOP>

noremap   <F1>  <NOP>

" ============================================================================
" Commands
" ============================================================================

command! Q q

" ============================================================================
" Quick edit
" ec* - Edit closest (find upwards)
" er* - Edit from dkoproject#GetRoot()
" ============================================================================

nnoremap  <silent><special>  <Leader>ecr
      \ :<C-U>call dkoedit#EditClosest('README.md')<CR>

nnoremap  <silent><special>  <Leader>eci
      \ :<C-U>call dkoedit#EditClosest('.gitignore')<CR>

" ============================================================================
" FZF
" ============================================================================

nnoremap  <silent><special>   <A-b>   :<C-U>FZFBuffers<CR>
nnoremap  <silent><special>   <A-c>   :<C-U>FZFCommands<CR>
nnoremap  <silent><special>   <A-f>   :<C-U>FZFFiles<CR>
nnoremap  <silent><special>   <A-g>   :<C-U>FZFGrepper<CR>
nnoremap  <silent><special>   <A-m>   :<C-U>FZFMRU<CR>
nnoremap  <silent><special>   <A-p>   :<C-U>FZFProject<CR>
nnoremap  <silent><special>   <A-r>   :<C-U>FZFRelevant<CR>
nnoremap  <silent><special>   <A-t>   :<C-U>FZFTests<CR>
nnoremap  <silent><special>   <A-v>   :<C-U>FZFVim<CR>

" ============================================================================
" Run :make
" ============================================================================

nnoremap  <special>   <Leader>mk  :<C-U>lmake!<CR>

" ============================================================================
" Buffer manip
" ============================================================================

" ----------------------------------------------------------------------------
" Prev buffer with <BS> backspace in normal (C-^ is kinda awkward)
" ----------------------------------------------------------------------------

nnoremap  <special>   <BS>  <C-^>

" ============================================================================
" Window manipulation
" ============================================================================

" ----------------------------------------------------------------------------
" Navigate with ctrl+arrow (insert mode leaves user in normal)
" ----------------------------------------------------------------------------

nnoremap  <special>   <C-Left>    <C-w>h
nnoremap  <special>   <C-Down>    <C-w>j
nnoremap  <special>   <C-Up>      <C-w>k
nnoremap  <special>   <C-Right>   <C-w>l

" ----------------------------------------------------------------------------
" Cycle with tab in normal mode
" ----------------------------------------------------------------------------

nnoremap  <special>   <Tab>       <C-w>w
nnoremap  <special>   <S-Tab>     <C-w>W

" ----------------------------------------------------------------------------
" Resize (can take a count, eg. 2<S-Left>)
" ----------------------------------------------------------------------------

nnoremap  <special>   <S-Left>    <C-w><
imap      <special>   <S-Left>    <C-o><S-Left>
nnoremap  <special>   <S-Down>    <C-W>-
imap      <special>   <S-Down>    <C-o><S-Down>
nnoremap  <special>   <S-Up>      <C-W>+
imap      <special>   <S-Up>      <C-o><S-Up>
nnoremap  <special>   <S-Right>   <C-w>>
imap      <special>   <S-Right>   <C-o><S-Right>

" ============================================================================
" Mode and env
" ============================================================================

" ----------------------------------------------------------------------------
" Toggle visual/normal mode with space-space
" ----------------------------------------------------------------------------

nnoremap  <Leader><Leader>  V
vnoremap  <Leader><Leader>  <Esc>

" ----------------------------------------------------------------------------
" Back to normal mode
" ----------------------------------------------------------------------------

silent! iunmap jj
silent! cunmap jj
inoremap jj <Esc>
cnoremap jj <Esc>

" ----------------------------------------------------------------------------
" Unfuck my screen
" https://bitbucket.org/sjl/dotfiles/src/2c4aba25376c6c5cb5d4610cf80109d99b610505/vim/vimrc?at=default#cl-444
" ----------------------------------------------------------------------------

nnoremap <silent> U :<C-U>:diffupdate<CR>:syntax sync fromstart<CR><C-L>

" ----------------------------------------------------------------------------
" cd to current buffer's git root
" ----------------------------------------------------------------------------

nnoremap <silent><special>   <Leader>cr
      \ :<C-U>execute 'cd! ' . dkoproject#GetRoot()<CR>

" ----------------------------------------------------------------------------
" cd to current buffer path
" ----------------------------------------------------------------------------

nnoremap <silent><special>   <Leader>cd
      \ :<C-U>cd! %:h<CR>

" ----------------------------------------------------------------------------
" go up a level
" ----------------------------------------------------------------------------

nnoremap <silent><special>   <Leader>..
      \ :<C-U>cd! ..<CR>

" ============================================================================
" Editing
" ============================================================================

" ----------------------------------------------------------------------------
" Quickly apply macro q
" ----------------------------------------------------------------------------

nnoremap  <special> <Leader>q   @q

" ----------------------------------------------------------------------------
" Map the arrow keys to be based on display lines, not physical lines
" ----------------------------------------------------------------------------

vnoremap  <special>   <Down>      gj
vnoremap  <special>   <Up>        gk

" ----------------------------------------------------------------------------
" Start/EOL
" ----------------------------------------------------------------------------

" Easier to type, and I never use the default behavior.
" From https://bitbucket.org/sjl/dotfiles/
" default is {count}from top line in visible window
noremap   H   ^
" default is {count}from last line in visible window
noremap   L   g_

" ----------------------------------------------------------------------------
" Reselect visual block after indent
" ----------------------------------------------------------------------------

xnoremap  <   <gv
xnoremap  >   >gv

" ----------------------------------------------------------------------------
" <Tab> indents in visual mode (recursive map to the above)
" ----------------------------------------------------------------------------

silent! vunmap <Tab>
silent! vunmap <S-Tab>
vmap <special> <Tab>     >
vmap <special> <S-Tab>   <

" ----------------------------------------------------------------------------
" <Tab> space or real tab based on line contents and cursor position
" ----------------------------------------------------------------------------

function! s:DKO_Tab() abort
  " If characters all the way back to start of line were all whitespace,
  " insert whatever expandtab setting is set to do.
  if strpart(getline('.'), 0, col('.') - 1) =~? '^\s*$'
    return "\<Tab>"
  endif

  " The PUM is closed and characters before the cursor are not all whitespace
  " so we need to insert alignment spaces (always spaces)
  " Calc how many spaces, support for negative &sts values
  let l:sts = (&softtabstop <= 0) ? shiftwidth() : &softtabstop
  let l:sp = (virtcol('.') % l:sts)
  if l:sp == 0 | let l:sp = l:sts | endif
  return repeat(' ', 1 + l:sts - l:sp)
endfunction

silent! iunmap <Tab>
inoremap  <silent><special><expr>  <Tab>     <SID>DKO_Tab()

" Tab inserts a tab, shift-tab should remove it
inoremap <S-Tab> <C-d>

" ----------------------------------------------------------------------------
" Sort lines (use unix sort)
" https://bitbucket.org/sjl/dotfiles/src/2c4aba25376c6c5cb5d4610cf80109d99b610505/vim/vimrc?at=default#cl-288
" ----------------------------------------------------------------------------

" Auto select paragraph (bounded by blank lines) and sort
nnoremap  <special> <Leader>s   vip:!sort<CR>

" Sort selection (no clear since in visual)
xnoremap  <special> <Leader>s   :!sort<CR>

" ----------------------------------------------------------------------------
" Clean up whitespace
" ----------------------------------------------------------------------------

nnoremap  <special> <Leader>ws  :<C-U>call dkowhitespace#clean()<CR>

" ----------------------------------------------------------------------------
" Intentional system clipboard
" ----------------------------------------------------------------------------

" nnoremap <special> <C-p> "*p
" vnoremap <special> <C-p> "*p

nnoremap <special> <C-y> "*y
xnoremap <special> <C-y> "*y

" ----------------------------------------------------------------------------
" Silent delete to black hole
" ----------------------------------------------------------------------------

nnoremap sx "_x
nnoremap sd "_d
nnoremap sD "_D

" ----------------------------------------------------------------------------
" Don't jump on first * -- simpler vim-asterisk
" https://stackoverflow.com/questions/4256697/vim-search-and-highlight-but-do-not-jump#comment91750564_4257175
" ----------------------------------------------------------------------------

nnoremap * m`:<C-U>keepjumps normal! *``<CR>

" ----------------------------------------------------------------------------
" Swap comma and semicolon
" ----------------------------------------------------------------------------

nnoremap <Leader>, $r,
nnoremap <Leader>; $r;

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
