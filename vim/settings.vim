set backup
set backupdir=~/.cache/vim/bak,/var/tmp/vim/bak,/tmp/vim/bak
set undodir=~/.cache/vim/undo,/var/tmp/vim/undo,/tmp/vim/undo
set undofile
set dir=~/.cache/vim/swp//,/var/tmp/vim/swp//,/tmp/vim/swp//
set viminfo+=n~/.cache/vim/viminfo

filetype plugin indent on
syntax enable
set hidden

set guioptions=""
set guifont=yancfont
set mouse=""

set lazyredraw
set regexpengine=1
set ttyfast

set ts=4 sts=0 sw=4 noet
au BufNewFile,BufRead *.tex setlocal ft=tex spell
au BufNewFile,BufRead *.tixz setlocal ft=tex
au BufNewFile,BufRead /dev/shm/pass.* setlocal noswapfile nobackup noundofile ft=yaml
au BufNewFile,BufRead *.rake,*.rb.example setlocal ft=ruby
au BufNewFile,BufRead *.scad setlocal ft=openscad
au FileType markdown setlocal sw=4 ts=4 sts=4 et tw=80
au FileType ruby,yaml,crystal setlocal sw=2 ts=2 sts=2 et
au FileType ruby setlocal makeprg=bundle\ exec\ rspec\ --require\ ~/.config/vim/plugrc/rspec-vim/quickfix_formatter.rb\ --format\ QuickfixFormatter
au FileType ledger,vhdl,sh setlocal sw=4 ts=4 sts=4 et

set complete+=kspell

set rnu
set nu
set cursorline

set diffopt+=vertical

set colorcolumn=80
set list listchars=tab:►\ ,trail:◆,eol:¬

let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1
