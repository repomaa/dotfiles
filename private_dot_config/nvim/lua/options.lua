local cmd = vim.cmd
local opt = vim.opt
local fn = vim.fn

opt.number = true
opt.ts = 4
opt.sts = 4
opt.sw = 4

local undodir = fn.stdpath('cache')..'/undo'
fn.mkdir(undodir, 'p')

opt.undofile = true
opt.undodir = undodir

opt.hidden = true

cmd('autocmd FileType crystal,ecrystal,ruby,eruby,javascriptreact,typescriptreact setlocal ts=2 sts=2 sw=2')
