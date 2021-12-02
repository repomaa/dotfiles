local cmd = vim.cmd
local opt = vim.opt
local fn = vim.fn

opt.number = true
opt.ts = 4
opt.sts = 4
opt.sw = 4
opt.signcolumn = 'yes'

local undodir = fn.stdpath('cache')..'/undo'
fn.mkdir(undodir, 'p')

opt.undofile = true
opt.undodir = undodir

opt.hidden = true

opt.listchars = [[tab:> ,trail:~]]
opt.list = true

cmd('autocmd FileType crystal,ecrystal,ruby,eruby,javascript,typescript,javascriptreact,typescriptreact,json setlocal et ts=2 sts=2 sw=2')
