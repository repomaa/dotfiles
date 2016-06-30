function! ToPdf(start, end)
	let basename = expand("%:r")
	let ps_file = expand(basename) . ".ps"
	let range = expand(a:start) . "," . expand(a:end)
	silent exe expand(range) . "hardcopy > " . expand(ps_file)
	silent exe "!ps2pdf " . expand(ps_file) . " && rm " . expand(ps_file)
	redraw!
	let range = expand(a:start) . " to " . expand(a:end)
	let pdf = expand(basename) . ".pdf"
	echo "Wrote lines " . expand(range) . " to " . expand(pdf)
endfunction

com! -nargs=0 -range=% Pdf :call ToPdf(<line1>, <line2>)

function! Filebin(start, end)
	let range = a:start . "," . a:end
	let name = expand("%:t")
	if (name == "")
		let name = "scratch"
	endif
	let extension = expand(&ft)
	if (extension == "")
		let extension = "text"
	endif
	let command = "w !fb -n '" . name . "' -e '" . extension . "'"
	silent exe expand(range) . command
	redraw!
endfunction


com! -nargs=0 -range=% Fb :call Filebin(<line1>, <line2>)
vmap F :Fb<CR>

function! Gist(start, end)
	let range = expand(a:start) . "," . expand(a:end)
	let name = expand("%:t")
	if (name == "")
		let name = "scratch"
	endif

	let command = "w !gist -c -p -f '" . name . "'"
	exe expand(range) . command
endfunction

com! -nargs=0 -range=% Gist :call Gist(<line1>, <line2>)

function! SudoWrite()
	set ar
	silent w !sudo tee %
	redraw!
	edit!
endfunction

function! Mkdir()
	silent exe "!mkdir -p $(dirname \"" . expand("%") . "\")"
	redraw!
endfunction

com! -nargs=0 Suw :call SudoWrite()

function! SaveSession(path)
	silent exe "mksession! " . a:path
endfunction

com! -nargs=0 Mkdir :call Mkdir()

function! SynctexMake()
	if v:servername == ""
		throw "vim must be started with --servername"
	endif
	let position = line(".").':'.col(".").':'.expand("%:p")

	let editor = 'vim --servername '.v:servername.' --remote +\%{line} \%{input}'
	exe 'make view "SYNCTEX_FORWARD='.position.'" "SYNCTEX_EDITOR='.editor.'"'
endfunction

com! -nargs=0 SyncMake :call SynctexMake()

function! Extract(start, end)
	let range = a:start.','.a:end
	call inputsave()
	let file = input('To File: ', expand('%:h').'/', 'file')
	call inputrestore()
	exe range.'w '.file
	exe range.'del'
	call setreg('"', file)
endfunction

com! -range Extract :call Extract(<line1>, <line2>)

function! Crystallize(start, end)
	let lines = ['macro crystallize']
	call extend(lines, getline(a:start, a:end))
	call extend(lines, ['end', 'print crystallize.inspect'])
	let tempfile = system('mktemp /tmp/crystallize.XXXXXXXX')
	call system('echo -e '.shellescape(join(lines, '\n')).'> '.tempfile)
	echo system('cd /tmp && crystal run --no-color '.tempfile)
endfunction

com! -range Crystallize :call Crystallize(<line1>, <line2>)

fun! Gem(name, ...)
	let json = system('curl -s https://rubygems.org/api/v1/versions/' . a:name . '/latest.json')
	let version_dict = json_decode(json)
	let latest_version = version_dict['version']

	if latest_version == 'unknown'
		throw 'unknown gem "' . a:name . '"'
	endif

	let latest_minor_version = substitute(latest_version, '\(\d\+\.\d\+\)\@<=.*', '', '')

	let suffix = ''
	if expand('%') =~ '\.gemspec'
		let line = '  spec.add_'
		if exists('a:1') && a:1 =~ '^dev'
			let line .= 'development_'
		endif
		let line .= 'dependency '
	else
		let line = 'gem '
		if exists('a:1') && a:1 =~ '^dev'
			let suffix = ', group: :development'
		elseif exists('a:1')
			let suffix = ', group: :' . a:1
		endif
	endif

	let line .= "'" . a:name . "', '~> " . latest_minor_version . "'" . suffix

	call append(line('.'), line)
endfun

com! -nargs=* Gem :call Gem(<f-args>)

fun! Gitlink(start, end)
	let file = expand('%:p')
	if (!exists('b:git_dir'))
		throw 'b:git_dir is not set, cannot continue'
	endif

	let relative_file = strpart(file, strlen(b:git_dir) - 4)
	let origin = substitute(system('git remote get-url origin'), "\n", '', '')
	if (origin =~ '^git@')
		let origin = substitute(origin, ':', '/', '')
		let origin = substitute(origin, '^git@', 'https://', '')
		let origin = substitute(origin, '\.git$', '', '')
	endif
	let branch = substitute(system('git rev-parse --abbrev-ref HEAD'), "\n", '', '')

	let url = origin . '/blob/' . branch . '/' . relative_file . '#L' . a:start . '-' . a:end
	call system("echo '" . url . "' | xclip")
	echo url
endfun

com! -range -nargs=0 Gitlink :call Gitlink(<line1>, <line2>)

" vim: filetype=vim
