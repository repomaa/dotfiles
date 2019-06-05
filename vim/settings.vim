set backup
set backupdir=~/.cache/vim/bak,/var/tmp/vim/bak,/tmp/vim/bak
set undodir=~/.cache/vim/undo,/var/tmp/vim/undo,/tmp/vim/undo
set undofile
set dir=~/.cache/vim/swp//,/var/tmp/vim/swp//,/tmp/vim/swp//
set backupcopy=yes

if has('nvim')
	set viminfo+=n~/.cache/vim/nviminfo
else
	set viminfo+=n~/.cache/vim/viminfo
endif

filetype plugin indent on
syntax enable
set hidden

set guioptions=""
set guifont=yanc\ yancfont
set mouse=""

set lazyredraw
set regexpengine=1
set ttyfast

set ts=4 sts=0 sw=4 noet
au BufNewFile,BufRead *.tex setlocal ft=tex spell
au BufNewFile,BufRead *.tixz setlocal ft=tex
au BufNewFile,BufRead /dev/shm/pass.* setlocal noswapfile nobackup noundofile ft=yaml
au BufNewFile,BufRead *.rake,*.rb.example,*.cap setlocal ft=ruby
au BufNewFile,BufRead *.scad setlocal ft=openscad
au FileType markdown setlocal sw=4 ts=4 sts=4 et tw=80
au FileType json,pug,js,ts,ruby,yaml,crystal,puppet setlocal sw=2 ts=2 sts=2 et
au FileType ruby setlocal makeprg=bundle\ exec\ rspec\ --require\ ~/.config/vim/plugrc/rspec-vim/quickfix_formatter.rb\ --format\ QuickfixFormatter
au FileType ledger,vhdl,sh setlocal sw=4 ts=4 sts=4 et

set complete+=kspell

set rnu
set nu
set cursorline

set diffopt+=vertical

set colorcolumn=80
set list listchars=tab:►\ ,trail:◆,eol:¬
if !has('nvim')
	set pyxversion=3
endif

let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

set wildmode=longest,list,full
set wildmenu
