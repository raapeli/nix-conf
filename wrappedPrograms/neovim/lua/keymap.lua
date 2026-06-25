local map = vim.keymap.set

-- Better window navigation
map("n", "<M-h>", "<C-w>h", { desc = "Window left" })
map("n", "<M-j>", "<C-w>j", { desc = "Window down" })
map("n", "<M-k>", "<C-w>k", { desc = "Window up" })
map("n", "<M-l>", "<C-w>l", { desc = "Window right" })

-- Window management
map("n", "<A-w>", "<C-w>w", { desc = "Cycle windows" })

-- Move lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Clear search highlights
map("n", "<leader><esc>", ":nohlsearch<CR>", { desc = "Clear search" })

-- Resize windows
map("n", "<C-Left>", "<C-w><", { desc = "Decrease width" })
map("n", "<C-Right>", "<C-w>>", { desc = "Increase width" })
map("n", "<C-Up>", "<C-w>+", { desc = "Increase height" })
map("n", "<C-Down>", "<C-w>-", { desc = "Decrease height" })

-- Compile mode
map("n", "<leader>cc", "<cmd>Recompile<cr>", { desc = "Emacs compile mode" })

-- Better scrolling
vim.opt.smoothscroll = true
