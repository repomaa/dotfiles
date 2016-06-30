au FileType vimfiler nmap <buffer> <C-r> <Plug>(vimfiler_redraw_screen)
au FileType vimfiler nunmap <buffer> <C-l>
au FileType vimfiler nunmap <buffer> \

call vimfiler#custom#profile('default', 'context', {
	\'safe': 0
\})
