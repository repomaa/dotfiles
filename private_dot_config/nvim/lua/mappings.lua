local vimp = require('vimp')

local nmap = function(...)
	vimp.nmap({'override'}, ...)
end

local vmap = function(...)
	vimp.vmap({'override'}, ...)
end


nmap('<C-h>', '<C-w>h')
nmap('<C-j>', '<C-w>j')
nmap('<C-k>', '<C-w>k')
nmap('<C-l>', '<C-w>l')
vmap('<tab>', '>gv^')
vmap('<s-tab>', '<gv^')
