nmap <Leader>n :VimFilerExplorer<CR>
nmap <Leader>t :TagbarToggle<CR>

nmap <C-h> :wincmd h<CR>
nmap <C-j> :wincmd j<CR>
nmap <C-k> :wincmd k<CR>
nmap <C-l> :wincmd l<CR>

nmap <Leader>e :exec(getline('.'))<CR>
nmap <Leader>l :!lualatex '%' && bibtex '%:r' && lualatex '%' && lualatex '%'<CR>
nmap <Leader>v :e ~/.config/vim/vimrc<CR>
