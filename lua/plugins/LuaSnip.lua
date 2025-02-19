  -- # TODO: handle the error when jumping to non-existant snippets
return {
  "L3MON4D3/LuaSnip",
  -- follow latest release.
  version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  -- install jsregexp (optional!).
  build = "make install_jsregexp",
  dependencies = { 'rafamadriz/friendly-snippets' },
  event = 'BufEnter',
  keys = {
    {
      '<c-j>', function ()
        local ls = require'luasnip'
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end,
      silent = true,
      mode = {'n', 's', 'i'},
      desc = 'luasnip next',
    },
    {
      '<c-k>', function ()
        local ls = require'luasnip'
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end,
      silent = true,
      mode = {'n', 'i', 's'},
      desc = 'luasnip prev',
    },
    {
      '<c-l>', function ()
        local ls = require('luasnip')
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end,
      mode = {'n', 'i', 's'},
      desc = 'luasnip choice',
    },
    {
      '<leader>ne', function ()
        require('luasnip.loaders').edit_snippet_files()
      end,
      desc = 'luasnip edit',
    },
  },
  config = function (_, opts)
    require'luasnip'.setup(opts)
    require'luasnip.loaders.from_vscode'.lazy_load()
    local snippets_path = vim.fs.joinpath(vim.fn.stdpath('config'), 'snippets/')
    require'luasnip.loaders.from_lua'.lazy_load({ paths = { snippets_path } })
  end,
  opts = function(_, opts)
    -- # TODO: don't just silently ignore opts(?)
    local types = require'luasnip.util.types'
    local m = {
      update_events = {"TextChanged", "TextChangedI"},
      keep_roots = true,
      link_roots = true,
      exit_roots = false,
      ext_opts = {
        [types.choiceNode] = {
          active = {
            virt_text = { { "<", "Err" } },
          },
        },
      },
    }
    return m
  end,
}
