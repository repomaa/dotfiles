local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt
local tbl_extend = vim.tbl_extend
local tbl_filter = vim.tbl_filter
local tbl_contains = vim.tbl_contains
local list_extend = vim.list_extend

local plugins = {}

ensure_packer = function()
	local installpath = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(installpath)) > 0 then
		fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', installpath})
	end
end

ensure_packer()

packer = require('packer')

packer.startup(function()
	use { 'svermeulen/vimpeccable' }
	vimp = require('vimp')

	local js_fts = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }
	local ruby_fts = { 'ruby', 'eruby' }
	local crystal_fts = { 'crystal', 'ecrystal' }
	local tabnine_fts = {}
	list_extend(tabnine_fts, js_fts)
	list_extend(tabnine_fts, ruby_fts)
	list_extend(tabnine_fts, crystal_fts)

	local coc = function(options)
		local merged = tbl_extend('keep', options, {
			requires = { 'neoclide/coc.nvim',
				run = 'yarn install --frozen-lockfile',
				config = function()
					local cocmap = function(lhs, func)
						local rhs = '<Plug>(coc-' .. func .. ')'
						vimp.nmap({ 'silent' }, lhs, rhs)
					end

					cocmap('[g', 'diagnostic-prev')
					cocmap(']g', 'diagnostic-next')
					cocmap('gd', 'definition')
					cocmap('gy', 'type-definition')
					cocmap('gi', 'implementation')
					cocmap('gr', 'references')

					vimp.nnoremap('K', function()
						local word = vim.fn.expand('<cword>')
						local ft = vim.bo.filetype
						if (ft == 'vim' or ft == 'help')
						then
							vim.cmd('h ' .. word)
						elseif (vim.fn['coc#rpc#ready']())
						then
							vim.fn['CocActionAsync']('doHover')
						else
							vim.cmd('!man ' .. word)
						end
					end)

					vim.cmd([[autocmd CursorHold * silent call CocActionAsync('highlight')]])
				end
			},
			run = 'yarn install --frozen-lockfile',
			keys = { '<Plug>(coc-' },
			fn = 'coc#',
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

	use { 'romgrk/nvim-treesitter-context' }

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
		requires = { 'tpope/vim-rhubarb' },
		fn = 'fugitive#',
		cmd = {
			'Gread',
			'Gwrite',
			'Gdiff',
			'Gdiffsplit',
			'Gvdiffsplit',
			'GMove',
			'GDelete',
			'GBrowse',
			'GRename',
			'Git',
			'G',
			'Git!',
			'G!'
		}
	}

	use { 'nvim-telescope/telescope.nvim',
		requires = {
			{'nvim-lua/plenary.nvim'},
			{'nvim-telescope/telescope-fzf-native.nvim'}
		},
		config = function ()
			local telemap = function(lhs, func, ...)
				local rhs = require('telescope.builtin')[func]
				local options = ...
				vimp.nnoremap(lhs, function ()
					if (options) then rhs(options) else rhs() end
				end)
			end

			telemap('<Leader>f', 'find_files', { hidden = true })
			telemap('<Leader>r', 'live_grep', { hidden = true })
			telemap('<Leader>b', 'buffers')
			telemap('<Leader>h', 'help_tags')
			telemap('<Leader>n', 'file_browser', { hidden = true })
			telemap('<Leader>o', 'oldfiles', { hidden = true })
		end
	}

	use { 'nvim-telescope/telescope-frecency.nvim',
		requires = { 'tami5/sqlite.lua' },
		config = function()
			local telescope = require('telescope')
			telescope.load_extension('frecency')
			vimp.nnoremap('<Leader>m', telescope.extensions.frecency.frecency)
		end
	}

	use { 'jparise/vim-graphql',
		setup = function ()
			vim.cmd('autocmd BufNewFile,BufReadPost *.gql,*.graphql setlocal filetype=graphql')
		end,
	}

	use { 'pwntester/octo.nvim',
		config = function()
			require('octo').setup()
		end
	}

	use { 'fannheyward/telescope-coc.nvim',
		config = function()
			local telescope = require('telescope')
			telescope.load_extension('coc')

			vimp.nnoremap('<Leader>ds', function ()
				telescope.extensions.coc.document_symbols({})
			end)

			vimp.nnoremap('<Leader>ws', function ()
				telescope.extensions.coc.workspace_symbols({})
			end)
		end
	}

	use { 'lewis6991/gitsigns.nvim',
		requires = { 'nvim-lua/plenary.nvim' },
		config = function ()
			require('gitsigns').setup()
		end
	}

	use { 'windwp/windline.nvim',
		config = function()
			require('wlsample.airline')
		end
	}

	coc { 'neoclide/coc-tsserver', ft = js_fts }
	coc { 'neoclide/coc-prettier', ft = js_fts }
	coc { 'neoclide/coc-eslint', ft = js_fts }
	coc { 'neoclide/coc-solargraph', ft = ruby_fts }
	coc { 'neoclide/coc-yaml', ft = { 'yaml' } }
	coc { 'neoclide/coc-tabnine', ft = tabnine_fts }
	coc { 'neoclide/coc-json', ft = { 'json' } }
	coc { 'iamcco/coc-diagnostic', ft = { 'sh' } }
end)

return plugins
