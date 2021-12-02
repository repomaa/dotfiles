local module = {}

local vimp = require('vimp')
local telescope = require('telescope')

local telemap = function(lhs, func, ...)
	local rhs = require('telescope.builtin')[func]
	local options = ...
	vimp.nnoremap(lhs, function ()
		if (options) then rhs(options) else rhs() end
	end)
end

module.setup = function ()
	telemap('<Leader>f', 'find_files', { hidden = true })
	telemap('<Leader>r', 'live_grep', { hidden = true })
	telemap('<Leader>b', 'buffers')
	telemap('<Leader>h', 'help_tags')
	telemap('<Leader>n', 'file_browser', { hidden = true })
	telemap('<Leader>o', 'oldfiles', { hidden = true })

	telescope.load_extension('frecency')
	vimp.nnoremap('<Leader>m', telescope.extensions.frecency.frecency)
end

return module
