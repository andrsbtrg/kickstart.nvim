-- This plugin adds colors when a hex text is recognized
-- Example: #348492
return {
  'norcalli/nvim-colorizer.lua',
  config = function()
    require('colorizer').setup()
  end,
}
