return {
  'tpope/vim-fugitive',
  event = 'BufEnter',
  keys = {
    -- TODO: Change these mappings to a different prefix as they conflict with telescope git mappings
    {
      "<leader>gk",
      [[:diffget //2<CR>]],
      "",
      desc = "diffget from 2",
    },
    {
      "<leader>gj",
      [[:diffget //3<CR>]],
      "",
      desc = "diffget from 3",
    },
  },
}
