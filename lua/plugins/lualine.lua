return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'folke/tokyonight.nvim',
  },
  opts = {
    theme = 'tokyonight',
  },
  event = { 'BufEnter' }
}
