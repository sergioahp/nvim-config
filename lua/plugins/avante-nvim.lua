return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  opts = {
    -- add any opts here
    -- for example
    provider = "openai",
    openai = {
      endpoint = "https://api.openai.com/v1",
      model = "gpt-4.1", -- your desired model (or use gpt-4o, etc.)
      -- timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
      -- temperature = 0,
      -- max_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
      reasoning_effort = "high", -- low|medium|high, only used for reasoning models
      api_key_name = "AVANTE_OPENAI_API_KEY",
    },
    aihubmix = {
      model = "DeepSeek-R1",
      api_key_name = "AVANTE_AIHUBMIX_API_KEY"
    },
    claude = {
      endpoint = "https://api.anthropic.com",
      model = "claude-3-5-sonnet-20241022",
      api_key_name = "AVANTE_ANTHROPIC_API_KEY",
      timeout = 30000, -- Timeout in milliseconds
      temperature = 0,
      max_tokens = 4096,
      -- disable_tools = { "bash", "python" }, -- disable tools!
    },
    vendors = {
      perplexity = {
        __inherited_from = "openai",
        api_key_name = "AVANTE_PERPLEXITY_API_KEY",
        endpoint = "https://api.perplexity.ai",
        model = "llama-3.1-sonar-large-128k-online",
      },
      perplexity2 = {
        __inherited_from = "openai",
        api_key_name = "AVANTE_PERPLEXITY_API_KEY",
        endpoint = "https://api.perplexity.ai",
        model = "sonar-deep-research",
      },
      perplexity3 = {
        __inherited_from = "openai",
        api_key_name = "AVANTE_PERPLEXITY_API_KEY",
        endpoint = "https://api.perplexity.ai",
        model = "sonar-reasoning-pro",
      },
      perplexity4 = {
        __inherited_from = "openai",
        api_key_name = "AVANTE_PERPLEXITY_API_KEY",
        endpoint = "https://api.perplexity.ai",
        model = "sonar-reasoning",
      },
      perplexity5 = {
        __inherited_from = "openai",
        api_key_name = "AVANTE_PERPLEXITY_API_KEY",
        endpoint = "https://api.perplexity.ai",
        model = "sonar-pro",
      },
      perplexity6 = {
        __inherited_from = "openai",
        api_key_name = "AVANTE_PERPLEXITY_API_KEY",
        endpoint = "https://api.perplexity.ai",
        model = "sonar",
      },
      perplexity7 = {
        __inherited_from = "openai",
        api_key_name = "AVANTE_PERPLEXITY_API_KEY",
        endpoint = "https://api.perplexity.ai",
        model = "r1-1776",
      },
      -- gemini_exp = {
      --   __inherited_from = "aihubmix",
      --   model = "gemini-2.5-pro-exp-03-25",
      -- },
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    --"echasnovski/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    -- "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    -- "zbirenbaum/copilot.lua", -- for providers='copilot'
    -- {
    --   -- support for image pasting
    --   "HakonHarnes/img-clip.nvim",
    --   event = "VeryLazy",
    --   opts = {
    --     -- recommended settings
    --     default = {
    --       embed_image_as_base64 = false,
    --       prompt_for_file_name = false,
    --       drag_and_drop = {
    --         insert_mode = true,
    --       },
    --       -- required for Windows users
    --       use_absolute_path = true,
    --     },
    --   },
    -- },
  },
}
