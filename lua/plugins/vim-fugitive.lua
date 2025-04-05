return {
  'tpope/vim-fugitive',
  event = 'BufEnter',
  keys = {
    {
      "<leader>dk",
      [[:diffget //2<CR>]],
      "",
      desc = "diffget from 2",
    },
    {
      "<leader>dj",
      [[:diffget //3<CR>]],
      "",
      desc = "diffget from 3",
    },
  },
}
