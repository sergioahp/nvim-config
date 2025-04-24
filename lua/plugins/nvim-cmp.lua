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
    opts.formatting = {
      format = lspkind.cmp_format({
        mode = 'symbol',
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
    opts.mapping = {
      ['<C-space>'] = cmp.mapping.confirm({ select = true }),
      ['<C-n>'] = function ()
        if not cmp.visible() then
          cmp.complete()
        end
        cmp.select_next_item()
      end,
      ['<C-p>'] = function ()
        if not cmp.visible() then
          cmp.complete()
        end
        cmp.select_prev_item()
      end,
    }
    opts.sources = cmp.config.sources({
      { name = 'git' },
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer' },
    })
    opts.snippet = {
      expand = function (args)
        require'luasnip'.lsp_expand(args.body)
      end
    }
  end,
  config = function (_, opts)
    local cmp = require('cmp')
    cmp.setup(opts)
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
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
