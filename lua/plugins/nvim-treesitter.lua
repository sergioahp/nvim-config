local M = {
  "nvim-treesitter/nvim-treesitter",
  build = function()
    require("nvim-treesitter.install").update({ with_sync = true })()
  end,
  opts = {
    ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query', 'javascript', 'html' , 'typst', 'bash', 'luadoc', 'markdown', 'requirements', 'toml', 'yaml', 'python', 'nix', 'yuck' },
    sync_install = false,
    highlight = { enable = true, additional_vim_regex_highlighting = false },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<leader>i",
        node_incremental = "<leader>i",
        scope_incremental = "<leader>ts",
        node_decremental = "<leader>I",
      },
    },
  },
  config = function (_, opts)
    require("nvim-treesitter.configs").setup(opts)
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  end
}

return { M }
