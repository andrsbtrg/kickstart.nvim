vim.pack.add { 'https://github.com/tpope/vim-fugitive' }
vim.keymap.set('n', '<leader>gt', ':Git | res -6<CR>', { desc = 'Open Git' })
