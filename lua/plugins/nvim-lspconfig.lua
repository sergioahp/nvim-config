return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        'hrsh7th/cmp-nvim-lsp'
      },
      {
        'barreiroleo/ltex_extra.nvim',
        -- comentario
      },
      {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    opts = function (_, opts)

      local global_keys = {
        {
          '',
          '<leader>lr',
          vim.lsp.buf.rename,
          { desc = "lsp go to declaration" },
        },
        {
          '',
          '<leader>la',
          vim.lsp.buf.code_action,
          { desc = "lsp go to code actions" },
        },
        {
          '',
          '<leader>ld',
          function()
            vim.diagnostic.open_float()
          end,
          { desc = "open diagnostic under cursor" },
        },
        -- {
        --   'i',
        --   '<c-i>',
        --   function()
        --     vim.lsp.buf.signature_help({
        --       close_events = {'BufLeave', 'InsertLeave'},
        --     })
        --   end,
        --   { desc = "signature help" },
        -- },
        -- NOTE: For some reason <C-i> works when set with:
        -- :lua vim.keymap.set('i', '<C-i>', function() vim.lsp.buf.signature_help({ close_events = {'BufLeave', 'InsertLeave'} }) end, { desc = "signature help" })
        -- but not like it is on the config above: in the config it cannot distinguish between <C-i> and Tab and both are mapped to that same function
        -- Same bug occurs with nvim_buf_set_keymap:
        -- :lua vim.api.nvim_buf_set_keymap(0, 'i', '<C-i>', '', { noremap = true, callback = function() vim.lsp.buf.signature_help({ close_events = {'BufLeave', 'InsertLeave'} }) end, desc = "signature help" })
        -- The issue is the buffer = bufnr argument - buffer-local mappings don't distinguish <C-i> from <Tab>:
        -- :lua vim.keymap.set('i', '<C-i>', function() vim.lsp.buf.signature_help({ close_events = {'BufLeave', 'InsertLeave'} }) end, { desc = "signature help", noremap = true, buffer = 0 })
        -- This is a known issue: https://github.com/neovim/neovim/issues/28022
        -- Buffer-local mappings don't properly handle CSI extended keys/modifyOtherKeys even in supported terminals
        -- Workaround: Use global_only flag to set as global mapping instead of buffer-local
        {
          'i',
          '<C-i>',
          function()
            vim.lsp.buf.signature_help({
              close_events = {'BufLeave', 'InsertLeave'},
            })
          end,
          { desc = "signature help", global_only = true },
        },
        {
          '',
          '[d',
          function ()
            vim.diagnostic.jump({ count = -1, float = true })
          end,
          { desc = "previous diagnostic" },
        },
        {
          '',
          ']d',
          function ()
            vim.diagnostic.jump({ count = 1, float = true })
          end,
          { desc = "next diagnostic" },
        },
        {
          '',
          '[h',
          function ()
            vim.diagnostic.jump({ count = -1, float = true, severity = "HINT" })
          end,
          { desc = "previous hint" },
        },
        {
          '',
          ']h',
          function ()
            vim.diagnostic.jump({ count = 1, float = true, severity = "HINT" })
          end,
          { desc = "next hint" },
        },
        {
          '',
          '[s',
          function ()
            vim.diagnostic.jump({ count = -1, float = true, severity = "INFO" })
          end,
          { desc = "previous info" },
        },
        {
          '',
          ']s',
          function ()
            vim.diagnostic.jump({ count = 1, float = true, severity = "INFO" })
          end,
          { desc = "next info" },
        },
        {
          '',
          '[w',
          function ()
            vim.diagnostic.jump({ count = -1, float = true, severity = "WARN" })
          end,
          { desc = "previous warning" },
        },
        {
          '',
          ']w',
          function ()
            vim.diagnostic.jump({ count = 1, float = true, severity = "WARN" })
          end,
          { desc = "next warning" },
        },
        {
          '',
          '[e',
          function ()
            vim.diagnostic.jump({ count = -1, float = true, severity = "ERROR" })
          end,
          { desc = "previous error" },
        },
        {
          '',
          ']e',
          function ()
            vim.diagnostic.jump({ count = 1, float = true, severity = "ERROR" })
          end,
          { desc = "next error" },
        },
      }
      local global_options = {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        on_attach = function (client, bufnr)
          for _, v in ipairs(global_keys) do
            local mode = v[1]
            local lhs = v[2]
            local rhs = v[3]
            local _opts = v[4]
            if _opts.global_only then
              -- Set as global mapping, removing our custom flag
              local opts = vim.tbl_deep_extend('keep', _opts, { noremap = true })
              opts.global_only = nil
              vim.keymap.set(mode, lhs, rhs, opts)
            else
              -- Set as buffer-local mapping
              _opts = vim.tbl_deep_extend(
                'keep',
                _opts,
                { noremap = true, buffer = bufnr }
              )
              vim.keymap.set(mode, lhs, rhs, _opts)
            end
          end
        end,
      }
      local per_server = {
        ltex_plus = {
          autostart = false,
          on_attach = function(client, bufnr)
            require("ltex_extra").setup {
              load_langs = { "en-US", "es" },
            }
          end,
          settings = {
            ltex = { language = "en" },
          },
        },
        lua_ls = {},
        pylsp = {},
        nil_ls = {},
        tinymist = {
          autostart = true,
          settings = {
            exportPdf = "onType",
          },
        },
        rust_analyzer = {
          settings = {
            ['rust-analyzer'] = {
              diagnostics = {
                enable = false
              },
            },
          },
        },
      }
      opts._user_settings = {
        global_options = global_options,
        global_keys = global_keys,
        per_server = per_server,
      }

    end,
    config = function (_, opts)
      -- Configure diagnostic updates to happen in insert mode
      vim.lsp.handlers["textDocument/publishDiagnostic"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
          update_in_insert = true,
        }
      )

      -- local servers = { 'lua_ls', 'pylsp', 'nil_ls', 'rust_analyzer', }
      -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
      for server, setup_args in pairs(opts._user_settings.per_server) do
        local tbl = vim.tbl_deep_extend('force', opts._user_settings.global_options, setup_args)
        -- print(vim.inspect(tbl))
        vim.lsp.config(server, tbl)
        vim.lsp.enable(server)
      end
    end,
  },
}
