local fn = vim.fn

local plugins = {}

local ensure_packer = function()
	local installpath = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(installpath)) > 0 then
		fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', installpath})
	end
end

ensure_packer()

local packer = require('packer')

packer.startup(function(use)
	use { 'svermeulen/vimpeccable' }

	local crystal_fts = { 'crystal', 'ecrystal' }

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
			{'nvim-telescope/telescope-fzf-native.nvim'},
			{ 'nvim-telescope/telescope-frecency.nvim',
				requires = { 'tami5/sqlite.lua' },
			},
		},
		config = function ()
			require('telescope_config').setup()
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

	use {
		'neovim/nvim-lspconfig',
		requires = {
			'williamboman/nvim-lsp-installer',
			'hrsh7th/nvim-cmp',
			'hrsh7th/cmp-nvim-lsp',
		},
		config = function ()
			require('lsp').setup()
		end
	}

	use {
		'mhartington/formatter.nvim',
		config = function ()
			require('formatters').setup()
		end
	}

	use { 'tpope/vim-abolish' }
end)

return plugins
