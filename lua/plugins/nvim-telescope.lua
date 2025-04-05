return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  cmd = 'Telescope',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    'nvim-tree/nvim-web-devicons',
    { 'nvim-telescope/telescope-fzf-native.nvim', build ='make' },
  },
  init = function ()
    vim.ui.select = function (items, opts, on_choice)
      require('telescope')
      vim.ui.select(items, opts, on_choice)
    end
  end,
  config = function (_, opts)
    require('telescope').setup(opts)
    require('telescope').load_extension('fzf')
    require('telescope').load_extension('ui-select')
  end,
  keys = {
    {
      "<leader>ff",
      function ()
        require('telescope.builtin').find_files()
      end,
      "n",
      desc = "telescope find files"
    },
    {
      "<leader>fi",
      function ()
        require('telescope.builtin').current_buffer_fuzzy_find()
      end,
      "n",
      desc = "telescope grep inside current file"
    },
    {
      "<leader>fb",
      function ()
        require('telescope.builtin').builtin()
      end,
      "n",
      desc = "telescope grep inside current dir"
    },
    {
      "<leader>fd",
      function ()
        require('telescope.builtin').grep_string()
      end,
      "n",
      desc = "telescope grep inside current dir"
    },
    {
      "<leader>ft",
      function ()
        require('telescope.builtin').treesitter()
      end,
      "n",
      desc = "telescope treesitter"
    },
    {
      "<leader>fR",
      function ()
        require('telescope.builtin').reloader()
      end,
      "n",
      desc = "telescope treesitter"
    },
    {
      "<leader>fk",
      function ()
        require('telescope.builtin').keymaps()
      end,
      "n",
      desc = "telescope keymaps"
    },
    {
      "<leader>fg",
      function ()
        require('telescope.builtin').git_files()
      end,
      "n",
      desc = "telescope git files"
    },
    {
      "<leader>fC",
      function ()
        require('telescope.builtin').git_commits()
      end,
      "n",
      desc = "telescope git commits"
    },
    {
      "<leader>fM",
      function ()
        require('telescope.builtin').git_bcommits()
      end,
      "n",
      desc = "telescope git bcommits"
    },
    {
      "<leader>fB",
      function ()
        require('telescope.builtin').git_branches()
      end,
      "n",
      desc = "telescope git branches"
    },
    {
      "<leader>fE",
      function ()
        require('telescope.builtin').live_grep()
      end,
      "n",
      desc = "telescope grep"
    },
    {
      "<leader>b",
      function ()
        require('telescope.builtin').buffers()
      end,
      "n",
      desc = "telescope buffers",
    },
    {
      "<leader>fh",
      function ()
        require('telescope.builtin').help_tags()
      end,
      "n",
      desc = "telescope help",
    },
    {
      "<leader>fc",
      function ()
        require('telescope.builtin').find_files {
          cwd = vim.fn.stdpath('config')
        }
      end,
      "n",
      desc = "telescope config files",
    },
    {
      "<leader>fo",
      function ()
        require('telescope.builtin').find_files {
          cwd = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy')
        }
      end,
      "n",
      desc = "telescope plugin files",
    },
    {
      "<leader>fq",
      function ()
        require("telescope.command").quickfix()
      end,
      "n",
      desc = "telescope quickfix",
    },
    {
      "<leader>fs",
      function ()
        require("telescope.command").load_command()
      end,
      "n",
      desc = "telescope commands",
    },
    {
      "<leader>fe",
      function ()
        require('config.multigrep').live_multigrep()
      end,
      "n",
      desc = "telescope multigrep",
    },
    {
      "<leader>fr",
      function ()
        require('telescope.builtin').resume()
      end,
      "n",
      desc = "telescope multigrep",
    },
  },
  opts = function ()
    return {
      extensions = {
        fzf = {},
        ['ui-select'] = {
          require('telescope.themes').get_dropdown {
          }
        },
      },
    }
  end
}
