local lsp = {}
local vimp = require('vimp')
local lsp_installer = require('nvim-lsp-installer')

local mappingsDone = false

local on_attach = function ()
	if mappingsDone then
		return
	end

	local function buf_set_keymap(mapping, func) vimp.nnoremap({'buffer', 'silent'}, mapping, func) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	-- Enable completion triggered by <c-x><c-o>
	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap('gD', vim.lsp.buf.declaration)
	buf_set_keymap('gd', vim.lsp.buf.definition)
	buf_set_keymap('K', vim.lsp.buf.hover)
	buf_set_keymap('gi', vim.lsp.buf.implementation)
	buf_set_keymap('<space>wa', vim.lsp.buf.add_workspace_folder)
	buf_set_keymap('<space>wr', vim.lsp.buf.remove_workspace_folder)
	buf_set_keymap('<space>wl', function () print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end)
	buf_set_keymap('<space>D', vim.lsp.buf.type_definition)
	buf_set_keymap('<space>rn', vim.lsp.buf.rename)
	buf_set_keymap('<space>ca', vim.lsp.buf.code_action)
	buf_set_keymap('gr', vim.lsp.buf.references)
	buf_set_keymap('<space>e', vim.lsp.diagnostic.show_line_diagnostics)
	buf_set_keymap('[d', vim.lsp.diagnostic.goto_prev)
	buf_set_keymap(']d', vim.lsp.diagnostic.goto_next)
	buf_set_keymap('<space>q', vim.lsp.diagnostic.set_loclist)
	buf_set_keymap('<space>f', vim.lsp.buf.formatting)

	mappingsDone = true
end

lsp.setup = function ()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

	lsp_installer.on_server_ready(function (server)
		server:setup({
			on_attach = on_attach,
			capabilities = capabilities,
			flags = {
				debounce_text_changes = 150
			},
			settings = {
				Lua = {
					diagnostics = {
						globals = {'vim'}
					}
				}
			}
		})
	end)

	vim.o.completeopt = 'menuone,noselect'
	vim.o.updatetime = 250
	vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = {
			source = "if_many",
		}
	})

	local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end

	local cmp = require('cmp')

	cmp.setup {
		mapping = {
			['<C-p>'] = cmp.mapping.select_prev_item(),
			['<C-n>'] = cmp.mapping.select_next_item(),
			['<C-d>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.close(),
			['<CR>'] = cmp.mapping.confirm {
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			},
			['<Tab>'] = function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				else
					fallback()
				end
			end,
			['<S-Tab>'] = function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				else
					fallback()
				end
			end,
		},
		sources = {
			{ name = 'nvim_lsp' },
		},
	}
end

return lsp
