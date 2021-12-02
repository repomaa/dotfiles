local formatters = {}
local formatter = require('formatter')

local js = {
	function ()
		return {
			exe = "npx",
			args = {"prettier", "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
			stdin = true,
		}
	end
}

local ruby = {
	function ()
		return {
			exe = "bundle",
			args = {"exec", "rufo", "--filename", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
			stdin = true,
		}
	end
}

formatters.setup = function ()
	formatter.setup {
		filetype = {
			javascript = js,
			typescript = js,
			javascriptreact = js,
			typescriptreact = js,
			ruby = ruby,
		}
	}

	vim.api.nvim_exec([[
	augroup FormatAutogroup
	  autocmd!
	  autocmd BufWritePost *.js,*.ts,*.jsx,*.tsx,*.svelte,*.rb,*.haml,Gemfile,*.rake FormatWrite
	augroup END
	]], true)
end

return formatters
