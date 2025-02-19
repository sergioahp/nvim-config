return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  cmd = 'Telescope',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build ='make' },
  },
  config = function ()
    require('telescope').setup {
      extensions = {
        fzf = {},
        ['ui-select'] = {
          require('telescope.themes').get_dropdown {
          }
        },
      },
    }
    require('telescope').load_extension('fzf')
    require('telescope').load_extension('ui-select')
  end,
  keys = {
    {
      "<leader>ff",
      function ()
        -- require('telescope').load_extension('fzf')
        require('telescope.builtin').find_files()
      end,
      "n",
      desc = "telescope find files"
    },
    -- {
    --   "<leader>fe",
    --   function ()
    --     require('telescope').load_extension('fzf')
    --     require('telescope.builtin').live_grep()
    --   end,
    --   "n",
    --   desc = "telescope grep"
    -- },
    {
      "<leader>b",
      function()
        -- require('telescope').load_extension('fzf')
        require('telescope.builtin').buffers()
      end,
      "n",
      desc = "telescope buffers",
    },
    {
      "<leader>fh",
      function ()
        -- require('telescope').load_extension('fzf')
        require('telescope.builtin').help_tags()
      end,
      "n",
      desc = "telescope help",
    },
    {
      "<leader>fc",
      function ()
        -- require('telescope').load_extension('fzf')
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
        -- require('telescope').load_extension('fzf')
        require('telescope.builtin').find_files {
          cwd = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy')
        }
      end,
      "n",
      desc = "telescope plugin files",
    },
    {
      "<leader>fs",
      function()
        require("telescope.command").load_command()
      end,
      "n",
      desc = "telescope commands",
    },
    {
      "<leader>fe",
      function ()
        -- require('telescope').load_extension('fzf')
        require('config.multigrep').live_multigrep()
      end,
      "n",
      desc = "telescope multigrep",
    },
    {
      "<leader>fr",
      function ()
        -- require('telescope').load_extension('fzf')
        require('telescope.builtin').resume()
      end,
      "n",
      desc = "telescope multigrep",
    },
  },
  -- opts = {
  --   extensions = {
  --     fzf = {}
  --   }
  -- },
}
