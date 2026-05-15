return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  opts = {
    -- add any opts here
    -- for example
    provider = "openai",
    behaviour = {
      -- auto-approve file ops but require confirmation for shell execution
      auto_approve_tool_permissions = {
        "view", "ls", "glob", "grep",
        "create", "edit_file", "str_replace", "replace_in_file", "write_to_file", "insert", "undo_edit",
        "get_diagnostics", "think", "attempt_completion", "read_todos", "write_todos",
      },
    },
    providers = {
      openai = {
        endpoint = "https://api.openai.com/v1",
        model = "gpt-5.4-nano-2026-03-17", -- default Avante model
        -- timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
        -- temperature = 0,
        -- max_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
        extra_request_body = {
          reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
        },
        api_key_name = "OPENAI_API_KEY",
      },
      openrouter = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        model = "inception/mercury-2",
        api_key_name = "OPENROUTER_API_KEY",
        extra_request_body = {
          reasoning = {
            effort = "high",
          },
        },
      },
      aihubmix = {
        __inherited_from = "openai",
        endpoint = "https://api.aihubmix.com/v1",
        model = "gemini-2.5-pro-preview-05-06",
        api_key_name = "AVANTE_AIHUBMIX_API_KEY"
      },
      claude = {
        model = "claude-haiku-4-5",
        api_key_name = "AVANTE_ANTHROPIC_API_KEY",
        -- timeout = 30000, -- Timeout in milliseconds
        -- extra_request_body = {
        --   temperature = 0,
        --   max_tokens = 4096,
        -- },
        -- disable_tools = { "bash", "python" }, -- disable tools!
      },
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
      gemini_exp = {
        __inherited_from = "openai",
        endpoint = "https://api.aihubmix.com/v1",
        model = "gemini-2.5-pro-exp-03-25",
        api_key_name = "AVANTE_AIHUBMIX_API_KEY"
      },
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
