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
keymap.set("n", "<C-a>", "ggVG", { desc = "Select all"} )
keymap.set("i", "<C-a>", "<Esc>ggVG", { desc = "Select all from insert mode" } )
keymap.set("n", "<leader><C-e>", ":new ~/.config/nvim<CR>", { desc = "Open nvim setting" } )
-- https://qiita.com/t_o_d/items/4c0a841778712e1eed4e#%E7%B5%90%E6%9E%9C
-- keymap.set("",  "<leader>n", ":call RenameFile()<CR>", { desc = "Rename editing file name" })

-- edit files
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Down the line" } )
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Up the line" } )

keymap.set("n", "Y", "y$", { desc = "Yunk words to the end on line with Y" })
keymap.set("n", "<leader>p", '"0p', { desc = "Past from yank register" })

keymap.set("n", "J", "mzJ`z") -- Jを実行してもその位置に止まる。
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")
keymap.set("v", "<space>p", "\"_dP")

-- move settings
keymap.set("n", "j", "gj", { desc = "Be able to move next line in wraped line"})
keymap.set("n", "k", "gk", { desc = "Be able to move previous line in wraped line"})


-- window split
keymap.set("n", "<leader>sv", ":sp<CR>", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", ":vs<CR>", { desc = "Split window hirizonally" })
keymap.set("n", "<leader>sx", ":close<CR>",  { desc = "Close current split" })

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

-- Jump list navigation (you can see the all of jump list with `:jump`)
-- ファイルのカーソル履歴のみを対象としたジャンプ機能
local function jump_to_prev_file_location()
  local jumplist, current_pos = unpack(vim.fn.getjumplist())

  -- 現在位置から前方向に検索
  for i = current_pos, 1, -1 do
    local jump = jumplist[i]
    if jump and jump.bufnr > 0 and vim.api.nvim_buf_is_valid(jump.bufnr) then
      local buftype = vim.api.nvim_buf_get_option(jump.bufnr, 'buftype')
      local filetype = vim.api.nvim_buf_get_option(jump.bufnr, 'filetype')
      local bufname = vim.api.nvim_buf_get_name(jump.bufnr)

      -- 通常のファイルかチェック（NvimTree、help、terminal等を除外）
      if buftype == '' and
         filetype ~= 'NvimTree' and
         filetype ~= 'help' and
         filetype ~= 'terminal' and
         bufname ~= '' then

        -- そのジャンプ位置に移動
        vim.api.nvim_set_current_buf(jump.bufnr)
        vim.api.nvim_win_set_cursor(0, {jump.lnum, jump.col})
        return
      end
    end
  end
  print("No previous file location found")
end

local function jump_to_next_file_location()
  local jumplist, current_pos = unpack(vim.fn.getjumplist())

  -- 現在位置から後方向に検索
  for i = current_pos + 2, #jumplist do
    local jump = jumplist[i]
    if jump and jump.bufnr > 0 and vim.api.nvim_buf_is_valid(jump.bufnr) then
      local buftype = vim.api.nvim_buf_get_option(jump.bufnr, 'buftype')
      local filetype = vim.api.nvim_buf_get_option(jump.bufnr, 'filetype')
      local bufname = vim.api.nvim_buf_get_name(jump.bufnr)

      if buftype == '' and
         filetype ~= 'NvimTree' and
         filetype ~= 'help' and
         filetype ~= 'terminal' and
         bufname ~= '' then

        vim.api.nvim_set_current_buf(jump.bufnr)
        vim.api.nvim_win_set_cursor(0, {jump.lnum, jump.col})
        return
      end
    end
  end
  print("No next file location found")
end

keymap.set("n", "<C-_>", jump_to_prev_file_location, { desc = "Jump to previous file location" })
keymap.set("n", "<C-S-_>", jump_to_next_file_location, { desc = "Jump to next file location" })

