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
          '[d',
          function ()
            vim.diagnostic.goto_prev()
          end,
          { desc = "previous diagnostic" },
        },
        {
          '',
          ']d',
          function ()
            vim.diagnostic.goto_next()
          end,
          { desc = "next diagnostic" },
        },
        {
          '',
          '[g',
          function ()
            vim.diagnostic.goto_prev({ severity = "HINT" })
          end,
          { desc = "previous hint" },
        },
        {
          '',
          ']g',
          function ()
            vim.diagnostic.goto_next({ severity = "HINT" })
          end,
          { desc = "next hint" },
        },
        {
          '',
          '[s',
          function ()
            vim.diagnostic.goto_prev({ severity = "INFO" })
          end,
          { desc = "previous info" },
        },
        {
          '',
          ']s',
          function ()
            vim.diagnostic.goto_next({ severity = "INFO" })
          end,
          { desc = "next info" },
        },
        {
          '',
          '[w',
          function ()
            vim.diagnostic.goto_prev({ severity = "WARN" })
          end,
          { desc = "previous warning" },
        },
        {
          '',
          ']w',
          function ()
            vim.diagnostic.goto_next({ severity = "WARN" })
          end,
          { desc = "next warning" },
        },
        {
          '',
          '[r',
          function ()
            vim.diagnostic.goto_prev({ severity = "ERROR" })
          end,
          { desc = "previous error" },
        },
        {
          '',
          ']r',
          function ()
            vim.diagnostic.goto_next({ severity = "ERROR" })
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
            _opts = vim.tbl_deep_extend(
              'keep',
              _opts,
              { noremap = true, buffer = bufnr }
            )
            vim.keymap.set(mode, lhs, rhs, _opts)
          end
        end,
      }
      local per_server = {
        ltex_plus = {
          autostart = false,
          on_attach = function(client, bufnr)
            require("ltex_extra").setup {}
          end,
        },
        lua_ls = {},
        pylsp = {},
        nil_ls = {},
        tinymist = {
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
      -- local servers = { 'lua_ls', 'pylsp', 'nil_ls', 'rust_analyzer', }
      local lspconfig = require('lspconfig')
      -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
      for server, setup_args in pairs(opts._user_settings.per_server) do
        local tbl = vim.tbl_deep_extend('force', opts._user_settings.global_options, setup_args)
        -- print(vim.inspect(tbl))
        lspconfig[server].setup(
          tbl
        )
      end
      -- lspconfig.tinymist.setup {
      --   capabilities = capabilities,
      --   settings = {
      --     exportPdf = "onSave",
      --   },
      -- }
      -- lspconfig.rust_analyzer.setup {
      --   capabilities = capabilities,
      --   settings = {
      --     ['rust-analyzer'] = {
      --       diagnostics = {
      --         enable = false
      --       }
      --     }
      --   }
      -- }
    end,
  },
}
