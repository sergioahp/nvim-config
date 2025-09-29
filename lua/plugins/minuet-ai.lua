return {
  -- dir = "/home/admin/.config/nvim/llm_context/minuet-ai.nvim",
  -- name = "minuet-ai",
  "milanglacier/minuet-ai.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    provider = "openai",
    openai = {
      model = "gpt-4.1",
      api_key = os.getenv("OPENAI_API_KEY"),
      optional = {
        -- not working
        max_tokens = 256,
        temperature = 0.1,
      },
    },
    -- Enable nvim-cmp integration
    cmp = {
      enable = true,
    },
    -- Virtual text settings (disabled by default)
    virtualtext = {
      auto_trigger_ft = { "rust", "python", "lua" }, -- Empty means no auto-trigger
    },
    throttle = 0,
    debounce = 0,
    n_completions = 1,
    request_timeout = 10,
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
        require("minuet.virtualtext").action.next()
      end,
      silent = true,
      mode = "i",
      desc = "Cycle to next suggestion",
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
        require("minuet.virtualtext").action.enable_auto_trigger()
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
  },
}
