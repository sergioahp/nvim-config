return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        'hrsh7th/cmp-nvim-lsp'
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
          'n',
          '<leader>lr',
          vim.lsp.buf.rename,
          { desc = "lsp go to declaration" },
        },
        {
          'n',
          '<leader>la',
          vim.lsp.buf.code_action,
          { desc = "lsp go to code actions" },
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
    config = function(_, opts)
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
