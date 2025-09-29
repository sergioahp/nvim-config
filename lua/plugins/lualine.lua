return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'folke/tokyonight.nvim',
  },
  opts = {
    theme = 'tokyonight',
    sections = {
      lualine_c = {
        {
          'filename',
          path = 1,  -- 0 = just filename, 1 = relative path, 2 = absolute path, 3 = absolute path with tilde
          shorting_target = 40,  -- Shortens path to leave 40 spaces in the window for other components
        }
      }
    }
  },
  event = { 'BufEnter' }
}
