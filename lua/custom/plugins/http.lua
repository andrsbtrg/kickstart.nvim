-- rest.nvim — HTTP client for testing REST APIs from a .http file
vim.pack.add { 'https://github.com/rest-nvim/rest.nvim' }
require('rest-nvim').setup {}

-- rest.nvim needs the treesitter 'http' parser. If you're using the
-- Section 9 treesitter block from before, just add 'http' to that
-- shared `parsers` list instead of installing it separately here:
--   local parsers = { 'bash', 'c', 'diff', 'html', 'http', 'lua', ... }
-- Otherwise, install it standalone:
require('nvim-treesitter').install { 'http' }

-- Load the telescope integration (pcall in case telescope isn't ready yet)
pcall(require('telescope').load_extension, 'rest')
