return {
  'nvim-cmp',
  dependencies = {'neovim/nvim-lspconfig', 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-cmdline', 'L3MON4D3/LuaSnip' },
  event = { 'VeryLazy', 'InsertEnter', 'CmdlineEnter' },
  opts = function (_, opts)
    local cmp = require('cmp')
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
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })

    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      }),
      matching = { disallow_symbol_nonprefix_matching = false },
    })
    return opts
  end,
}
