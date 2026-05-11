return {
  "sergioahp/minuet-ai.nvim",
  branch = "feat/merged",
  name = "minuet-ai",
  enabled = true,
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    provider = "codestral",
    provider_options = {
      codestral = {
        model = "codestral-latest",
        end_point = "https://api.mistral.ai/v1/fim/completions",
        api_key = "MISTRAL_API_KEY",
        stream = true,
        optional = {
          max_tokens = 256,
          stop = { '\n' },
        },
      },
      openai_fim_compatible = {
        model = "mercury-edit-2",
        end_point = "https://api.inceptionlabs.ai/v1/fim/completions",
        api_key = "INCEPTION_API_KEY",
        name = "Inception",
        stream = true,
        optional = {
          max_tokens = 256,
        },
      },
    },
    -- Enable nvim-cmp integration
    cmp = {
      enable = true,
    },
    -- Virtual text settings
    virtualtext = {
      auto_trigger_ft = { "rust", "python", "lua", "yaml", "nix", "typst" },
      -- Show virtual text suggestions even when cmp menu is visible
      show_on_completion_menu = true,
    },
    throttle = 0,
    debounce = 0,
    n_completions = 3,
    request_timeout = 10,
    before_cursor_filter_length = 0,
    after_cursor_filter_length = 0,
  },
  keys = {
    {
      "<c-o>", function ()
        require("minuet.virtualtext").action.accept()
      end,
      silent = true,
      mode = "i",
      desc = "Accept current suggestion",
    },
    {
      "<c-s>", function ()
        require("minuet.virtualtext").action.accept_line()
      end,
      silent = true,
      mode = "i",
      desc = "Accept current suggestion line"
    },
    {
      "<c-f>", function ()
        local m = require("minuet")
        require("minuet.virtualtext").action.next(
          m.with.optional("codestral", { stop = { "\n\n" } })
        )
      end,
      silent = true,
      mode = "i",
      desc = "Cycle next, or fire multi-line completion if none yet",
    },
    {
      "<c-e>", function ()
        require("minuet.virtualtext").action.prev()
      end,
      silent = true,
      mode = "i",
      desc = "Cycle to previous suggestion",
    },
    {
      "<c-c>", function ()
        require("minuet.virtualtext").action.toggle_auto_trigger()
      end,
      silent = true,
      mode = "i",
      desc = "Toggle auto trigger",
    },
    {
      "<c-a>", function ()
        require("minuet.virtualtext").action.dismiss()
      end,
      silent = true,
      mode = "i",
      desc = "Dismiss current suggestion",
    },
    {
      "<C-,>", function()
        require("minuet.virtualtext").action.accept_word()
      end,
      silent = true,
      mode = "i",
      desc = "Accept next word of suggestion",
    },
  },
  init = function()
    -- lazy's keys spec normalizes <C-m> to <CR>; set directly here instead.
    vim.keymap.set('i', '<C-m>', function()
      require('minuet.virtualtext').action.accept_until_char()
    end, { silent = true, desc = 'Accept suggestion until char (f-like)' })
  end,
}
