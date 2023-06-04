-- Made from
-- https://www.youtube.com/watch?v=435-amtVYJ8
local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- shorten function name
local keymap = vim.api.nvim_set_keymap

-- remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal mode --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- NvimTree navigation
-- ToggleTree
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)
-- Change root to node at cursor
keymap("n", "<leader>l", ":lua require'nvim-tree'.change_dir(require'nvim-tree.lib'.get_node_at_cursor().absolute_path)<cr>", opts)
-- Change root to parent
keymap("n", "<leader>h", ":lua require'nvim-tree.actions.root.dir-up'.fn()<cr>", opts)
-- Toggle "hidden" files
keymap("n", "<leader>a", ":lua require'nvim-tree.api'.tree.toggle_hidden_filter()<cr>", opts)
-- Expand dir
keymap("n", "<CR>", ":lua require'nvim-tree.api'.node.open.edit()<cr>", opts)
-- Toggle Terminal
-- This is only necessary for toggling terminal from NvimTree buffer since the
-- setup configured for toggleterm on ../init.vim already configures the togging
-- for nvim
-- Also had to remove default keymaps for NvimTree at init.lua
keymap("n", "<C-t>", ":ToggleTerm<cr>", opts) 

-- Terminal mode --
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", opts)
