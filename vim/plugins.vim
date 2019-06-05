let s:dein_dir = $XDG_DATA_HOME . '/vim/dein'
let s:dein_repo_path = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let s:dein_repo_url = 'https://github.com/Shougo/dein.vim'
let s:dein_toml = $XDG_CONFIG_HOME . '/vim/dein.toml'
let s:plugrc = $XDG_CONFIG_HOME . '/vim/plugrc'
let &runtimepath .= ',' . s:dein_repo_path

function! s:hook_source() abort
	let l:rcfile = s:plugrc . '/' . g:dein#plugin.normalized_name . '.rc.vim'
	let g:dein#plugin.hook_soure = 'source ' . l:rcfile
endfunction

let g:dein#types#git#clone_depth = 1

try
	if dein#load_state(s:dein_dir)
		call dein#begin(s:dein_dir)
		call dein#load_toml(s:dein_toml)
		call dein#end()
		call dein#save_state()
	endif
catch /E117:/ " dein not installed
	execute 'silent !git clone' s:dein_repo_url s:dein_repo_path
	call dein#begin(s:dein_dir)
	call dein#load_toml(s:dein_toml)
	set nomore
	call dein#install()
	call dein#end()
	quit
endtry

if dein#tap('unite.vim')
	nnoremap <leader>a :<C-u>Unite grep
			\ -auto-preview
			\ -no-split
			\ -no-empty<CR>
	nnoremap <leader>f :<C-u>Unite file_mru file/async file_rec/async
			\ -start-insert <CR>
	nnoremap <leader>g :<C-u>Unite file_mru file/async file_rec/git
			\ -start-insert <CR>
	nnoremap <leader>b :<C-u>Unite buffer
			\ -start-insert
			\ -no-split <CR>
	nnoremap <leader>r :<C-u>UniteResume
			\ -start-insert
			\ -force-redraw<CR>
	let g:unite_redraw_hold_candidates = 50000
	if executable('rg')
		let g:unite_source_grep_command = 'rg'
		let g:unite_source_grep_recursive_opt = ''
		let g:unite_source_grep_default_opts = '-S --hidden --vimgrep'
	elseif executable('ag')
		let g:unite_source_grep_command = 'ag'
		let g:unite_source_grep_default_opts = '--vimgrep'
		let g:unite_source_grep_recursive_opt = ''
	endif
	call s:hook_source()
endif

if dein#tap('vimfiler.vim')
	let g:vimfiler_safe_mode_by_default = 0
	let g:vimfiler_as_default_explorer = 1
	let g:vimfiler_tree_leaf_icon = ''
	let g:vimfiler_tree_opened_icon = '▼'
	let g:vimfiler_tree_closed_icon = '▻'
	autocmd FileType vimfiler nmap <buffer> <C-l> :wincmd l<CR>
	call s:hook_source()
endif

if dein#tap('neosnippet.vim')
	imap <C-k>     <Plug>(neosnippet_expand_or_jump)
	smap <C-k>     <Plug>(neosnippet_expand_or_jump)
	xmap <C-k>     <Plug>(neosnippet_expand_target)
	nnoremap <leader>s :NeoSnippetEdit -split<CR>
	let g:neosnippet#snippets_directory = s:plugrc . '/snippets'
endif

if dein#tap('clang_complete')
	call s:hook_source()
endif

if dein#tap('neomake')
	let g:neomake_error_sign = { 'text': '✗', 'texthl': 'NeomakeErrorSign' }
	let g:neomake_warning_sign = { 'text': '!', 'texthl': 'NeomakeWarningSign' }
	let g:neomake_message_sign_sign = { 'text': '>', 'texthl': 'NeomakeMessageSign' }
	let g:neomake_info_sign = { 'text': 'i', 'texthl': 'NeomakeInfoSign' }

	fun! s:bundled_rubocop_exe()
		let l:argv = split(BundleExec('rubocop'))
		return l:argv[0]
	endfun

	fun! s:bundled_rubocop_args()
		let l:argv = split(BundleExec('rubocop'))
		return l:argv[1:-1] + neomake#makers#ft#ruby#rubocop().args
	endfun

	let g:neomake_rubocop_exe = { 'fn': function('s:bundled_rubocop_exe') }
	let g:neomake_rubocop_args = { 'fn': function('s:bundled_rubocop_args') }
	let g:neomake_eslint_exe = $PWD . '/node_modules/.bin/eslint'
	let g:neomake_javascript_enabled_makers = ['eslint']
	let g:neomake_tslint_exe = $PWD . '/node_modules/.bin/tslint'
	let g:neomake_typescript_enabled_makers = ['tsc', 'tslint']

	let g:neomake_ameba_exe = $PWD . '/bin/ameba'

	call neomake#configure#automake('w')
endif

if dein#tap('base16-vim')
	if filereadable(expand("~/.vimrc_background"))
		let base16colorspace=256
		source ~/.vimrc_background
	endif
endif

if dein#tap('tagbar')
	let g:tagbar_autofocus=1
endif

if dein#tap('vim-ledger')
	let g:ledger_maxwidth = 80
	let g:ledger_default_commodity = '€'
	let g:ledger_commodity_sep = ' '
	let g:ledger_commodity_before = 0
	au FileType ledger noremap <silent><buffer> gt :call ledger#transaction_state_toggle(line('.'), ' *!')<CR>
	au FileType ledger inoremap <silent><buffer> <C-l> <C-o>:call ledger#align_amount_at_cursor()<CR>
	au FileType ledger inoremap <silent><buffer> <C-e> <Esc>:call ledger#entry()<CR>
endif

if dein#tap('securemodelines')
	let g:secure_modelines_allowed_items = [
	\	'textwidth', 'tw',
	\	'softtabstop', 'sts',
	\	'tabstop', 'ts',
	\	'shiftwidth', 'sw',
	\	'expandtab', 'et', 'noexpandtab', 'noet',
	\	'filetype', 'ft',
	\	'foldmethod', 'fdm',
	\	'readonly', 'ro', 'noreadonly', 'noro',
	\	'rightleft', 'rl', 'norightleft', 'norl',
	\   'spelllang'
	\]
endif

if dein#tap('vimtex')
	let g:vimtex_complete_enabled = 1
	let g:vimtex_latexmk_build_dir = 'out'
endif

if dein#tap('vim-abolish')
	let g:abolish_save_file = '~/.config/vim/abbreviations'
endif

if dein#tap('vim-lexical')
	let g:lexical#spelllang = [
	\	'de_de'
	\]
	let g:lexical#dictionary = [
	\	$XDG_DATA_HOME . '/vim/hunspell.de.txt'
	\]
	let g:lexical#thesaurus = [
	\	$XDG_DATA_HOME . '/vim/thesaurus.de.txt'
	\]
	augroup lexical
		autocmd FileType markdown,tex,mail,text call lexical#init()
	augroup END
endif

if dein#tap('LanguageTool')
	let g:languagetool_jar = '/usr/share/java/languagetool/languagetool-commandline.jar'
endif

if dein#tap('deoplete.nvim')
	let g:deoplete#enable_at_startup = 1
	let g:deoplete#enable_smart_case = 1
	let g:deoplete#auto_completion_start_length = 4
	if !exists('g:deoplete#keyword_patterns')
		let g:deoplete#keyword_patterns = {}
	endif
	let g:deoplete#keyword_patterns.default = '\h\w*'
	inoremap <expr><C-l> deoplete#complete_common_string()
	inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
	inoremap <expr><BS> deoplete#smart_close_popup()."\<C-h>"
	function! s:my_cr_function()
		return pumvisible() ? "\<C-y>" : "\<CR>"
	endfunction
	autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete 
	let g:rubycomplete_buffer_loading = 1
	let g:rubycomplete_classes_in_global = 1

	if !exists('g:deoplete#omni_patterns')
	  let g:deoplete#omni_patterns = {}
	endif
	let g:deoplete#omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
	let g:deoplete#omni_patterns.tex = '\\cite{\|\\c\?ref{.\+:'
	let g:deoplete#omni_patterns.ruby = '[^.[:digit:] \t]\%(\.\|::\)'
endif

if dein#tap('vimfiler-prompt')
	autocmd FileType vimfiler nmap <buffer> i :VimFilerPrompt<CR>
endif

if dein#tap('vim-operator-surround')
	map <silent>sa <Plug>(operator-surround-append)
	map <silent>sd <Plug>(operator-surround-delete)
	map <silent>sc <Plug>(operator-surround-replace)
endif

if dein#tap('vim-easy-align')
	" Start interactive EasyAlign in visual mode (e.g. vipga)
	xmap ga <Plug>(EasyAlign)

	" Start interactive EasyAlign for a motion/text object (e.g. gaip)
	nmap ga <Plug>(EasyAlign)
endif

if dein#tap('devdocs.vim')
	let g:devdocs_filetype_map = {
	\	'dockerfile': 'docker~17',
	\}
	nmap K <Plug>(devdocs-under-cursor)
endif

if dein#check_install()
	call dein#install()
endif
