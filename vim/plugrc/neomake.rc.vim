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
