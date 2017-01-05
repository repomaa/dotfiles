" set the runtime path to include Vundle and initialize
let s:bundle_dir = $XDG_DATA_HOME . '/vim/bundle'
let s:neobundle_dir = s:bundle_dir . '/neobundle.vim'
let s:neobundle_repo = 'https://github.com/Shougo/neobundle.vim'
let s:neobundle_toml = $XDG_CONFIG_HOME . '/vim/plugins.toml'
let s:plugrc = $XDG_CONFIG_HOME . '/vim/plugrc'
let g:neobundle#cache_file = $XDG_CACHE_HOME . '/vim/neobundlecache'
let &runtimepath.=','.s:neobundle_dir
try
	call neobundle#begin(expand('~/.local/share/vim/bundle/'))
catch /E117:/ " neobundle not installed
	execute "!mkdir -p " .  s:neobundle_dir
	execute "!git clone " . s:neobundle_repo . " " . s:neobundle_dir
	call neobundle#begin(s:bundle_dir)
	call neobundle#load_toml(s:neobundle_toml, {})
	NeoBundleInstall
	call neobundle#end()
	quit
endtry
if neobundle#load_cache(s:neobundle_toml)
	call neobundle#load_toml(s:neobundle_toml, {})
	NeoBundleSaveCache
endif

if neobundle#tap('unite.vim')
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
	let neobundle#hooks.on_source = s:plugrc . '/unite.rc.vim'
	let g:unite_redraw_hold_candidates = 50000
	if executable('ag')
		let g:unite_source_grep_command = 'ag'
		let g:unite_source_grep_default_opts = '--vimgrep'
		let g:unite_source_grep_recursive_opt = ''
	endif
	call neobundle#untap()
endif

if neobundle#tap('vimfiler.vim')
	let g:vimfiler_safe_mode_by_default = 0
	let g:vimfiler_as_default_explorer = 1
	let g:vimfiler_tree_leaf_icon = ''
	let g:vimfiler_tree_opened_icon = '▼'
	let g:vimfiler_tree_closed_icon = '▻'
	let neobundle#hooks.on_source = s:plugrc . '/vimfiler.rc.vim'
	call neobundle#untap()
endif

if neobundle#tap('neosnippet.vim')
	imap <C-k>     <Plug>(neosnippet_expand_or_jump)
	smap <C-k>     <Plug>(neosnippet_expand_or_jump)
	xmap <C-k>     <Plug>(neosnippet_expand_target)
	nnoremap <leader>s :NeoSnippetEdit -split<CR>
	let g:neosnippet#snippets_directory = s:plugrc . '/snippets'
	call neobundle#untap()
endif

if neobundle#tap('clang_complete')
	let neobundle#hooks.on_source = s:plugrc . '/clang_complete.rc.vim'
	call neobundle#untap()
endif

if neobundle#tap('syntastic')
	let g:syntastic_error_symbol   = '✗'
	let g:syntastic_warning_symbol = '!'
	let g:syntastic_ruby_checkers = ["rubocop", "mri"]
	let g:syntastic_ruby_rubocop_exe = "bundle exec rubocop"
	let g:syntastic_haml_checkers = ["haml_lint", "haml"]
	let g:syntastic_c_checkers = ["oclint", "gcc"]
	let g:syntastic_javascript_checkers = ['eslint']
	let g:syntastic_oclint_config_file = '.compiler-flags'
	let g:syntastic_oclint_options_config_file = '.oclint-options'
	let g:syntastic_oclint_clang_static_analyzer = 1
	let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
	call neobundle#untap()
endif

if neobundle#tap('base16-vim')
	let scheme = substitute(substitute($BASE16_SHELL, '.*/', '', ''), '\.sh', '', '')
	let g:base16theme = substitute(scheme, '\.\(dark\|light\)', '', '')
	let variant = substitute(scheme, '.*\(dark\|light\)', '\1', '')

	exe 'set bg=' . variant
	let base16colorspace=256
	function! neobundle#hooks.on_post_source(bundle)
		exe 'colorscheme '.g:base16theme
	endfunction
	call neobundle#untap()
endif

if neobundle#tap('tagbar')
	let g:tagbar_autofocus=1
	call neobundle#untap()
endif

if neobundle#tap('vim-ledger')
	let g:ledger_maxwidth = 80
	let g:ledger_default_commodity = '€'
	let g:ledger_commodity_sep = ' '
	let g:ledger_commodity_before = 0
	au FileType ledger noremap <silent><buffer> gt :call ledger#transaction_state_toggle(line('.'), ' *!')<CR>
	au FileType ledger inoremap <silent><buffer> <C-l> <C-o>:call ledger#align_amount_at_cursor()<CR>
	au FileType ledger inoremap <silent><buffer> <C-e> <Esc>:call ledger#entry()<CR>
	call neobundle#untap()
endif

if neobundle#tap('securemodelines')
	let g:secure_modelines_allowed_items = [
	\	'textwidth', 'tw',
	\	'softtabstop', 'sts',
	\	'tabstop', 'ts',
	\	'shiftwidth', 'sw',
	\	'expandtab', 'et', 'noexpandtab', 'noet',
	\	'filetype', 'ft',
	\	'foldmethod', 'fdm',
	\	'readonly', 'ro', 'noreadonly', 'noro',
	\	'rightleft', 'rl', 'norightleft', 'norl'
	\]
	call neobundle#untap()
endif

if neobundle#tap('vimtex')
	let g:vimtex_complete_enabled = 1
	let g:vimtex_latexmk_build_dir = 'out'
	call neobundle#untap()
endif

if neobundle#tap('vim-abolish')
	let g:abolish_save_file = '~/.config/vim/abbreviations'
	call neobundle#untap()
endif

if neobundle#tap('vim-lexical')
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
	call neobundle#untap()
endif

if neobundle#tap('LanguageTool')
	let g:languagetool_jar = '/usr/share/java/languagetool/languagetool-commandline.jar'
	call neobundle#untap()
endif

if neobundle#tap('neocomplete.vim')
	let g:acp_enableAtStartup = 0
	let g:neocomplete#enable_at_startup = 1
	let g:neocomplete#enable_auto_select = 1
	let g:neocomplete#enable_at_startup = 1
	let g:neocomplete#enable_smart_case = 1
	let g:neocomplete#auto_completion_start_length = 4
	let g:neocomplete#sources#syntax#min_keyword_length = 3
	let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
	let g:neocomplete#sources#dictionary#dictionaries = {
		\ 'default': '',
		\ 'vimshell': $HOME.'/.vimshell_history'
	\ }
	if !exists('g:neocomplete#keyword_patterns')
		let g:neocomplete#keyword_patterns = {}
	endif
	let g:neocomplete#keyword_patterns['default'] = '\h\w*'
	inoremap <expr><C-l> neocomplete#complete_common_string()
	inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
	inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
	function! s:my_cr_function()
		return pumvisible() ? "\<C-y>" : "\<CR>"
	endfunction
	autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS

	if !exists('g:neocomplete#sources#omni#input_patterns')
	  let g:neocomplete#sources#omni#input_patterns = {}
	endif
	if !exists('g:neocomplete#force_omni_input_patterns')
		let g:neocomplete#force_omni_input_patterns = {}
    endif
	let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
	let g:neocomplete#sources#omni#input_patterns.tex = '\\cite{\|\\c\?ref{.\+:'
	call neobundle#untap()
endif

if neobundle#tap('vimfiler-prompt')
	autocmd FileType vimfiler nmap <buffer> i :VimFilerPrompt<CR>
	call neobundle#untap()
endif

" vim-operator-surround
map <silent>sa <Plug>(operator-surround-append)
map <silent>sd <Plug>(operator-surround-delete)
map <silent>sc <Plug>(operator-surround-replace)

call neobundle#end()

NeoBundleCheck
