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
keymap.set("n", "<Esc><Esc>", ":nohlsearch<CR><Esc>", {desc = "Clear search highlights"})
keymap.set("v", "<Esc><Esc>", ":nohlsearch<CR><Esc>", {desc = "Clear search highlights"})

-- To be easy manipulate
keymap.set("n", "<leader>a", "ggVG", { desc = "Select all"} )
keymap.set("i", "<C-a>", "<Esc>ggVG", { desc = "Select all from insert mode" } )
keymap.set("n", "<leader><C-e>", ":new ~/.config/nvim<CR>", { desc = "Open nvim setting" } )
-- https://qiita.com/t_o_d/items/4c0a841778712e1eed4e#%E7%B5%90%E6%9E%9C
-- keymap.set("",  "<leader>n", ":call RenameFile()<CR>", { desc = "Rename editing file name" })

keymap.set("n", "Y", "y$", { desc = "Yunk words to the end on line with Y" })
keymap.set("n", "<leader>p", '"0p', { desc = "Past from yunk register" }) -- yunked value is sent to yunk register

-- move settings
keymap.set("n", "j", "gj", { desc = "Be able to move next line in wraped line"})
keymap.set("n", "k", "gk", { desc = "Be able to move previous line in wraped line"})

-- increment/decrement
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) 
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

keymap.set("n", "<leader>sv", ":sp<CR>", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", ":vs<CR>", { desc = "Split window vertically" })
keymap.set("n", "<leader>sx", ":close<CR>",  { desc = "Close current split" })

keymap.set("n", "<leader>to", ":tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", ":tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", ":tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", ":tabnew %<CR>", { desc = "Open current buffer in new tab" })

