return {
  'declancm/maximize.nvim',
  cmd = { 'Maximize' },
  keys = {
    {
      '<leader>m',
      function ()
        require('maximize').toggle()
      end,
      'n',
      desc = 'maximize toggle',
    },
  },
  opts = {
  },
}
