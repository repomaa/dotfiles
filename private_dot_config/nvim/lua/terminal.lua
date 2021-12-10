local vimp = require('vimp')
local toggleterm = require('toggleterm')
local Terminal = require('toggleterm.terminal').Terminal
local module = {}

module.set_mappings = function ()
	vimp.add_buffer_maps(function ()
		vimp.tnoremap('<esc>', [[<C-\><C-n>]])
		vimp.tnoremap('<C-h>', [[<C-\><C-n><C-W>h]])
		vimp.tnoremap('<C-j>', [[<C-\><C-n><C-W>j]])
		vimp.tnoremap('<C-k>', [[<C-\><C-n><C-W>k]])
		vimp.tnoremap('<C-l>', [[<C-\><C-n><C-W>l]])
	end)
end

module.setup = function ()
	local lazygit = Terminal:new({
		count = 100,
		cmd = [[env EDITOR='nvr -cc close' lazygit]],
		hidden = true,
		direction = 'float',
		on_open = function (term)
			vimp.add_buffer_maps(term.bufnr, function ()
				vimp.tnoremap({'override'}, '<esc>', '<esc>')
				vimp.tnoremap({'silent', 'override'}, 'q', [[<cmd>close<cr>]])
			end)
		end,
	})

	local toggle_lazygit = function ()
		lazygit:toggle()
	end

	toggleterm.setup({
		open_mapping = [[<c-\>]],
		insert_mappings = true,
	})

	vim.cmd([[autocmd! TermOpen term://* lua require('terminal').set_mappings()]])

	vimp.nnoremap({ 'silent' }, '<leader>g', toggle_lazygit)
end

return module
