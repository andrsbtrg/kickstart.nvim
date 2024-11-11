return {
  'jesseleite/nvim-noirbuddy',
  dependencies = {
    { 'tjdevries/colorbuddy.nvim' },
  },
  lazy = false,
  priority = 1000,
  opts = {
    colors = {
      background = '#191920',
      primary = '#6C9D79',
      secondary = '#618493',
    },
    preset = 'minimal',
  },
}
