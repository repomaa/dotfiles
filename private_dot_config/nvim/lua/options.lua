local cmd = vim.cmd
local opt = vim.opt

opt.number = true
opt.ts = 4
opt.sts = 4
opt.sw = 4

cmd('autocmd FileType crystal,ecrystal,ruby,eruby setlocal ts=2 sts=2 sw=2')
