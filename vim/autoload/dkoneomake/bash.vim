"" Called on *.sh, so we check the shebang or for extension contains bash
function! dkoneomake#bash#Setup() abort
  if dko#IsShebangBash() || expand('%:e') =~# 'bash'
    let b:neomake_sh_shellcheck_args = [
          \   '--format=gcc',
          \   '--external-sources',
          \   '--shell=bash',
          \ ]
  endif
endfunction
