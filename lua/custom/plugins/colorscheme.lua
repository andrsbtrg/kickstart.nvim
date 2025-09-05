-- lua/plugins/rose-pine.lua
return {
  'rose-pine/neovim',
  name = 'rose-pine',
  config = function()
    require('rose-pine').setup {
      styles = {
        bold = true,
        italic = false,
        transparency = true,
      },
    }
    vim.cmd 'colorscheme rose-pine'
  end,
}
