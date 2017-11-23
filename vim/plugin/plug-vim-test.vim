" plugin/plug-vim-test.vim

nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

" make test commands execute using neomake
let test#strategy = "neovim"

" set project root dir
let test#project_root = dkoproject#GetRoot()
