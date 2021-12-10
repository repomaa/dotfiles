local lsp = {}
local vimp = require('vimp')
local lsp_installer = require('nvim-lsp-installer')
local luasnip = require('luasnip')

local dump

dump = function (o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

local on_attach = function (client, bufnr)
	for k, _ in pairs(client.server_capabilities) do
		print(k .. ', ')
	end

	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	-- Enable completion triggered by <c-x><c-o>
	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	vimp.add_buffer_maps(bufnr, function ()
		local function map(mapping, func) vimp.nnoremap({'silent', 'override'}, mapping, func) end
		map('gD', vim.lsp.buf.declaration)
		map('gd', vim.lsp.buf.definition)
		if client.server_capabilities.hoverProvider then
			map('K', vim.lsp.buf.hover)
		end
		map('gi', vim.lsp.buf.implementation)
		map('<space>wa', vim.lsp.buf.add_workspace_folder)
		map('<space>wr', vim.lsp.buf.remove_workspace_folder)
		map('<space>wl', function () print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end)
		map('<space>D', vim.lsp.buf.type_definition)
		map('<space>rn', vim.lsp.buf.rename)
		map('<space>ca', vim.lsp.buf.code_action)
		map('gr', vim.lsp.buf.references)
		map('<space>e', vim.lsp.diagnostic.show_line_diagnostics)
		map('[d', vim.lsp.diagnostic.goto_prev)
		map(']d', vim.lsp.diagnostic.goto_next)
		map('<space>q', vim.lsp.diagnostic.set_loclist)
		map('<space>f', vim.lsp.buf.formatting)
	end)
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
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end
		},
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
			{ name = 'luasnip' },
		},
	}
end

return lsp
