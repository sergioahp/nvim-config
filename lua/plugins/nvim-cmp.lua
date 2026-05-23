return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'onsails/lspkind.nvim',
    -- 'sergioahp/cmp-ai',
    {
      'petertriho/cmp-git',
      opts = true,
    },
    {
      -- Issue: cmp-dbee require()s dbee even on files it's it shouldn't provide
      -- completions on
      "MattiasMTS/cmp-dbee",
      dependencies = "kndndrj/nvim-dbee",
      ft = "sql",
      opts = {},
    },
  },
  event = {
    'InsertEnter',
    'CmdlineEnter',
  },
  opts = function (_, opts)
    local cmp = require('cmp')
    local lspkind = require('lspkind')
    opts.preselect = require('cmp').PreselectMode.None -- Do not preselect any item by default
    local function toggle_menu()
      if cmp.visible() then
        cmp.close()
      else
        cmp.complete()
      end
    end
    local complete_or_next = function()
      if not cmp.visible() then
        cmp.complete()
      else
        cmp.select_next_item()
      end
    end
    local complete_or_prev = function()
      if not cmp.visible() then
        cmp.complete()
      else
        cmp.select_prev_item()
      end
    end
    opts.formatting = {
      fields = { 'abbr', 'kind', 'menu' },
      format = lspkind.cmp_format({
        before = function(_, vim_item)
          vim_item.kind = lspkind.symbolic(vim_item.kind)
          return vim_item
        end,
        menu = {
          buffer = "",
          nvim_lsp = "L",
          luasnip = "",
          nvim_lua = "",
          latex_symbols = "𝓛",
          ["cmp-dbee"] = "",
          git = "",
        },
        maxwidth = {
            menu = 50,
            abbr = 50,
        },
        ellipsis_char = '…',
        show_labelDetails = true,
      })
    }
    -- Seems by defaults it overwrites i only
    -- you can specify more modes like i = cmp.mapping.close()
    -- but if passing mappings = ... to cmd's preset then you overwrite what you
    -- set here
    opts.mapping = {
      ['<C-space>'] = {
        i = cmp.mapping.confirm({ select = true }),
        c = cmp.mapping.confirm({ select = true })
      },
      ['<C-n>'] = complete_or_next,
      ['<C-p>'] = complete_or_prev,
      ['<C-c>'] = {
        i = toggle_menu,
        c = toggle_menu,

      },
      ['<Tab>'] = {
        c = complete_or_next
      },
      ['<S-Tab>'] = {
        c = complete_or_prev
      },
    }
    opts.sources = cmp.config.sources({
      -- { name = 'cmp_ai', keyword_length = 0 },
      { name = 'git' },
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer' },
    })
    -- opts.sources = { { name = 'cmp_ai' } }
    -- print(vim.inspect(opts.sources))
    opts.snippet = {
      expand = function (args)
        require'luasnip'.lsp_expand(args.body)
      end
    }
    opts.performance = {
      fetching_timeout = 2000,
    }
  end,
  config = function (_, opts)
    local cmp = require('cmp')
    cmp.setup(opts)
    cmp.setup.cmdline({ '/', '?' }, {
      sources = {
        { name = 'buffer' }
      }
    })

    cmp.setup.cmdline(':', {
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        { name = 'cmdline' }
      }),
      matching = { disallow_symbol_nonprefix_matching = false },
    })

    -- Note about cmp.setup.filetype(): When a filetype-specific setup is not defined,
    -- it inherits all sources from the global setup. However, when defining a
    -- filetype-specific setup, you must explicitly list ALL desired sources
    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        { name = 'git' },
      }, {
          { name = 'buffer' },
        })
    })

    cmp.setup.filetype('sql', {
      sources = cmp.config.sources({
        { name = "cmp-dbee" },
        { name = "buffer" },
        })
    })
  end
}
