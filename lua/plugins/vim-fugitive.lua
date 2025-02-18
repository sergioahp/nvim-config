return {
  'tpope/vim-fugitive',
  event = 'BufEnter',
  keys = {
    {
      "<leader>gk",
      [[:diffget //2<CR>]],
      "n",
      desc = "diffget from 2",
    },
    {
      "<leader>gj",
      [[:diffget //3<CR>]],
      "n",
      desc = "diffget from 3",
    },
  },
}
