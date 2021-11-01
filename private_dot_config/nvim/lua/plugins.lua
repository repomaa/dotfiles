local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt
local tbl_extend = vim.tbl_extend
local tbl_filter = vim.tbl_filter
local tbl_contains = vim.tbl_contains
local list_extend = vim.list_extend

ensure_packer = function()
	local installpath = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(installpath)) > 0 then
		fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', installpath})
	end
end

ensure_packer()

packer = require('packer')

packer.startup(function()
	local js_fts = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }
	local ruby_fts = { 'ruby', 'eruby' }
	local crystal_fts = { 'crystal', 'ecrystal' }
	local tabnine_fts = {}
	list_extend(tabnine_fts, js_fts)
	list_extend(tabnine_fts, ruby_fts)
	list_extend(tabnine_fts, crystal_fts)

	local coc = function(options)
		local merged = tbl_extend('keep', options, {
			requires = { 'neoclide/coc.nvim', run = 'yarn install --frozen-lockfile' },
			run = 'yarn install --frozen-lockfile',
			keys = { '<Plug>(coc-' },
			fn = 'coc#'
		})

		use(merged)
	end

	use 'wbthomason/packer.nvim'
	use { 'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup {
				ensure_installed = { 'ruby', 'javascript', 'typescript' },
				highlight = { enable = true }
			}
		end
	}
	use { 'chriskempson/base16-vim',
		config = function()
			vim.g['base16colorspace'] = 256
			vim.cmd('source ~/.vimrc_background')
		end

	}
	use { 'vim-crystal/vim-crystal',
		setup = function ()
			vim.cmd('autocmd BufNewFile,BufReadPost *.cr setlocal filetype=crystal')
			vim.cmd('autocmd BufNewFile,BufReadPost Projectfile setlocal filetype=crystal')
			vim.cmd('autocmd BufNewFile,BufReadPost *.ecr setlocal filetype=ecrystal')
		end,
		ft = crystal_fts
	}
	use { 'vim-scripts/DrawIt',
		keys = { '<Leader>di' }
	}
	use { 'tpope/vim-fugitive',
		fn = 'fugitive#',
		cmd = { 'Gwrite', 'Gdiff', 'Gdiffsplit', 'Gread', 'Git', 'G', 'Git!', 'G!' }
	}

	use {
		'nvim-telescope/telescope.nvim',
		requires = {
			{'nvim-lua/plenary.nvim'},
			{'nvim-telescope/telescope-fzf-native.nvim'}
		},
		module = 'telescope',
		setup = function ()
			local map = vim.api.nvim_set_keymap
			local telemap = function(lhs, func, args)
				local rhs = [[<cmd>lua require('telescope.builtin').]] .. func .. '(' .. args .. ')<cr>'
				map('n', lhs, rhs, { noremap = true })
			end

			telemap('<Leader>f', 'find_files', '{ hidden = true }')
			telemap('<Leader>g', 'live_grep', '{ hidden = true }')
			telemap('<Leader>b', 'buffers', '')
			telemap('<Leader>h', 'help_tags', '')
			telemap('<Leader>n', 'file_browser', '{ hidden = true }')
		end
	}

	use {
		'jparise/vim-graphql',
		setup = function ()
			vim.cmd('autocmd BufNewFile,BufReadPost *.gql,*.graphql setlocal filetype=graphql')
		end,
	}

	coc { 'neoclide/coc-tsserver', ft = js_fts }
	coc { 'neoclide/coc-prettier', ft = js_fts }
	coc { 'neoclide/coc-solargraph', ft = ruby_fts }
	coc { 'neoclide/coc-yaml', ft = { 'yaml' } }
	coc { 'neoclide/coc-tabnine', ft = tabnine_fts }
	coc { 'neoclide/coc-json', ft = { 'json' } }
	coc { 'iamcco/coc-diagnostic', ft = { 'sh' } }
end)
