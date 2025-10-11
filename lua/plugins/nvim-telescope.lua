return {
  'nvim-telescope/telescope.nvim', branch = 'master',
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
      '<leader>ff',
      function ()
        require('telescope.builtin').find_files()
      end,
      '',
      desc = 'telescope find files'
    },
    {
      '<leader>fi',
      function ()
        require('telescope.builtin').current_buffer_fuzzy_find()
      end,
      '',
      desc = 'telescope grep inside current file'
    },
    {
      '<leader>fb',
      function ()
        require('telescope.builtin').builtin()
      end,
      '',
      desc = 'telescope grep inside current dir'
    },
    {
      '<leader>fd',
      function ()
        require('telescope.builtin').grep_string()
      end,
      '',
      desc = 'telescope grep inside current dir'
    },
    {
      '<leader>ft',
      function ()
        require('telescope.builtin').treesitter()
      end,
      '',
      desc = 'telescope treesitter'
    },
    {
      '<leader>fR',
      function ()
        require('telescope.builtin').reloader()
      end,
      '',
      desc = 'telescope treesitter'
    },
    {
      '<leader>fk',
      function ()
        require('telescope.builtin').keymaps()
      end,
      '',
      desc = 'telescope keymaps'
    },
    {
      '<leader>gf',
      function ()
        require('telescope.builtin').git_files()
      end,
      '',
      desc = 'telescope git files'
    },
    {
      '<leader>gc',
      function ()
        require('telescope.builtin').git_commits()
      end,
      '',
      desc = 'telescope git commits'
    },
    {
      '<leader>gm',
      function ()
        require('telescope.builtin').git_bcommits()
      end,
      '',
      desc = 'telescope git buffer commits'
    },
    {
      '<leader>gb',
      function ()
        require('telescope.builtin').git_branches()
      end,
      '',
      desc = 'telescope git branches'
    },
    {
      '<leader>ge',
      function ()
        require('config.multigrep').live_multigrep({ git_files = true })
      end,
      '',
      desc = 'telescope multigrep on git-tracked files',
    },
    {
      '<leader>gl',
      function ()
        require('telescope.builtin').live_grep({ grep_open_files = true })
      end,
      '',
      desc = 'telescope grep in git tracked files'
    },
    {
      '<leader>fE',
      function ()
        require('telescope.builtin').live_grep()
      end,
      '',
      desc = 'telescope grep'
    },
    {
      '<leader>b',
      function ()
        require('telescope.builtin').buffers()
      end,
      '',
      desc = 'telescope buffers',
    },
    {
      '<leader>fh',
      function ()
        require('telescope.builtin').help_tags()
      end,
      '',
      desc = 'telescope help',
    },
    {
      '<leader>fc',
      function ()
        require('telescope.builtin').find_files {
          cwd = vim.fn.stdpath('config')
        }
      end,
      '',
      desc = 'telescope config files',
    },
    {
      '<leader>fo',
      function ()
        require('telescope.builtin').find_files {
          cwd = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy')
        }
      end,
      '',
      desc = 'telescope plugin files',
    },
    {
      '<leader>fq',
      function ()
        require('telescope.command').quickfix()
      end,
      '',
      desc = 'telescope quickfix',
    },
    {
      '<leader>fs',
      function ()
        require('telescope.command').load_command()
      end,
      '',
      desc = 'telescope commands',
    },
    {
      '<leader>fe',
      function ()
        require('config.multigrep').live_multigrep()
      end,
      '',
      desc = 'telescope multigrep',
    },
    {
      '<leader>fr',
      function ()
        require('telescope.builtin').resume()
      end,
      '',
      desc = 'telescope resume last search',
    },
    -- t for treesitter/symbols - symbol search using textobject suffixes (via LSP)
    -- we might want to explore how treesitter text objects does it too, but LSP is cool too
    {
      '<leader>tk',
      function()
        require('telescope.builtin').lsp_document_symbols({ symbols = { "Class", "Struct", "Interface" } })
      end,
      '',
      desc = 'telescope search classes'
    },
    {
      '<leader>tm',
      function()
        require('telescope.builtin').lsp_document_symbols({ symbols = { "Function", "Method" } })
      end,
      '',
      desc = 'telescope search functions/methods'
    },
    {
      '<leader>tf',
      function()
        require('telescope.builtin').lsp_document_symbols({ symbols = { "Function" } })
      end,
      '',
      desc = 'telescope search functions'
    },
    {
      '<leader>tv',
      function()
        require('telescope.builtin').lsp_document_symbols({ symbols = { "Variable" } })
      end,
      '',
      desc = 'telescope search variables'
    },
    {
      '<leader>tj',
      function()
        require('telescope.builtin').lsp_document_symbols({ symbols = { "Constructor" } })
      end,
      '',
      desc = 'telescope search constructors'
    },
    {
      '<leader>tr',
      function()
        require('telescope.builtin').lsp_document_symbols({ symbols = { "Property", "Field" } })
      end,
      '',
      desc = 'telescope search properties/fields'
    },
    {
      '<leader>tg',
      function()
        require('telescope.builtin').lsp_document_symbols({ symbols = { "Constant" } })
      end,
      '',
      desc = 'telescope search constants'
    },
    {
      '<leader>tz',
      function()
        require('telescope.builtin').lsp_document_symbols({ symbols = { "Variable", "Field" } })
      end,
      '',
      desc = 'telescope search assignments'
    },
    {
      '<leader>tu',
      function()
        require('telescope.builtin').lsp_document_symbols({ symbols = { "Number", "String", "Constant" } })
      end,
      '',
      desc = 'telescope search literals'
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
