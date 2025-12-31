vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2       -- 2 space for tabs (prettier default)
opt.shiftwidth = 2    -- 2 spaces for indent width
opt.expandtab = true  -- expand tab to space
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = false      -- doesn't wap line.

-- search settings
-- - only small case -> ignore case
-- - mixed cases     -> case sensitive
-- - only big case   -> case sensitive
opt.ignorecase = true -- ignore case when search
opt.smartcase = true  -- if you include upper case in your sarch, assumes you want case-sensitive.

opt.cursorline = true -- hilight cursol line

-- turn on termguicolors for tokyonight colorscheme to work
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be "light" or "dark"
opt.signcolumn = "yes"  -- show sign column so that text doesn't shift

-- backspace
-- if this is set as "indent,eol", backspace can't delete charactors before start position.
-- see: https://www.softel.co.jp/blogs/tech/archives/7459
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start positon

-- clipborad
opt.clipboard:append("unnamedplus") -- use system clipbord as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizonatal window to the bottom

-- being visible tab, space
vim.opt.listchars = { tab = ">-", trail = "-", extends = "»", precedes = "«", nbsp = "%" }
vim.opt.list = true
