local M = {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects'
  },
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
    textobjects = {
      select = {
        enable = true,

        lookahead = true,
        lookbehind = true,

        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['ib'] = '@block.inner',
          ['ab'] = '@block.outer',
          ['iC'] = '@call.inner',
          ['aC'] = '@call.outer',
          ['ic'] = '@class.inner',
          ['ac'] = '@class.outer',
          ['ak'] = '@comment.outer',
          ['id'] = '@conditional.inner',
          ['ad'] = '@conditional.outer',
          ['ir'] = '@frame.inner',
          ['ar'] = '@frame.outer',
          ['if'] = '@function.inner',
          ['af'] = '@function.outer',
          ['iL'] = '@loop.inner',
          ['aL'] = '@loop.outer',
          ['iP'] = '@parameter.inner',
          ['aP'] = '@parameter.outer',
          ['iK'] = '@scopename.inner',
          ['aK'] = '@scopename.outer',
          ['iM'] = '@statement.innet',
          ['aM'] = '@statement.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = false, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[k'] = '@block.outer',
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
    },
  },
  config = function (_, opts)
    require("nvim-treesitter.configs").setup(opts)
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  end
}

return { M }
