return {
  'declancm/maximize.nvim',
  cmd = { 'Maximize' },
  keys = {
    {
      '<leader>m',
      function ()
        require('maximize').toggle()
      end,
      '',
      desc = 'maximize toggle',
    },
  },
  opts = {
  },
}
