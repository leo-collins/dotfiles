-- Set leader key to spacebar
vim.g.mapleader = " "

-- Spacebar-cd opens file explorer 
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)
