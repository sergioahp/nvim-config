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
    config = function()
      local servers = { 'lua_ls', 'pylsp', 'nil_ls' }
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      for _, server in ipairs(servers) do
        lspconfig[server].setup {
          capabilities = capabilities
      }
      end
      lspconfig.tinymist.setup {
        capabilities = capabilities,
        settings = {
          exportPdf = "onSave",
        },
      }
    end,
  },
}
