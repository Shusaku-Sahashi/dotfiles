local keymap = vim.keymap

keymap.set("", "<Space>", "<Nop>")
vim.g.mapleader = " "

-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x'
--   term_mode = 't',
--   command_mode = 'c',
-- Caution 🧐:
--	 When you add insert_mode key map, don't use <Space>. Buecase it causes waiting after input <Space>
keymap.set("n", "<Esc><Esc>", ":nohlsearch<CR><Esc>", { desc = "Clear search highlights" })
keymap.set("v", "<Esc><Esc>", ":nohlsearch<CR><Esc>", { desc = "Clear search highlights" })

-- To be easy manipulate
keymap.set("n", "<C-a>", "ggVG", { desc = "Select all" })
keymap.set("i", "<C-a>", "<Esc>ggVG", { desc = "Select all from insert mode" })
keymap.set("n", "<leader><C-e>", ":new ~/.config/nvim<CR>", { desc = "Open nvim setting" })
-- https://qiita.com/t_o_d/items/4c0a841778712e1eed4e#%E7%B5%90%E6%9E%9C
-- keymap.set("",  "<leader>n", ":call RenameFile()<CR>", { desc = "Rename editing file name" })

-- edit files
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Down the line" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Up the line" })

keymap.set("n", "Y", "y$", { desc = "Yunk words to the end on line with Y" })
keymap.set("n", "<leader>p", '"0p', { desc = "Past from yank register" })

keymap.set("n", "J", "mzJ`z") -- Jを実行してもその位置に止まる。
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")
keymap.set("v", "<space>p", "\"_dP")

-- move settings
keymap.set("n", "j", "gj", { desc = "Be able to move next line in wraped line" })
keymap.set("n", "k", "gk", { desc = "Be able to move previous line in wraped line" })


-- window split
keymap.set("n", "<leader>sv", ":sp<CR>", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", ":vs<CR>", { desc = "Split window hirizonally" })
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Close current split" })

-- window tab
keymap.set("n", "<leader>to", ":tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tf", ":tabnew %<CR>", { desc = "Open current buffer in new tab" })
keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", ":tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", ":tabp<CR>", { desc = "Go to previous tab" })

-- x command don't user register
keymap.set("n", "x", '"_x')
keymap.set("x", "x", '"_x')
keymap.set("n", "X", '"_d$')
keymap.set("x", "X", '"_d$')

-- copy to cripbord
keymap.set("n", "<leader>y", "\"+y")
keymap.set("v", "<leader>y", "\"+y")
keymap.set("n", "<leader>Y", "\"+Y")

-- leave terminal mode with ESC
keymap.set("t", "<ESC>", '<c-\\><c-n><Plug>(esc)')
keymap.set("n", "<Plug>(esc)<ESC>", "i<ESC>")

-- select command with Down/Up
vim.keymap.set("c", "<Down>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Down>"
end, { expr = true })

vim.keymap.set("c", "<Up>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<Up>"
end, { expr = true })
