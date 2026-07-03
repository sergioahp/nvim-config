return {
  "sergioahp/avante.nvim",
  -- dir = "/home/admin/code/lua/avante.nvim",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  branch = "main", -- fast chat mode (commit 34564ce)
  -- Fast-edit overlays: drop a pending review only when entering insert mode (you're
  -- editing now, so the diff is stale). NOT on BufEnter: in the sidebar/zen fast flow
  -- you submit from the sidebar, then move into the code window TO review -- that
  -- BufEnter would dismiss the overlay right as you arrive, leaving has_pending()
  -- false so <Tab> falls through to minuet and mutates the buffer. Extmark overlays
  -- stay attached to their own buffer across navigation, so no buffer-switch cleanup
  -- is needed. Building blocks in `avante.fast`: has_pending / accept_or_next /
  -- reject_under_cursor / accept_all / dismiss_all.
  init = function()
    vim.api.nvim_create_autocmd("InsertEnter", {
      group = vim.api.nvim_create_augroup("avante_fast_dismiss", { clear = true }),
      callback = function(ev)
        local ok, fast = pcall(require, "avante.fast")
        if ok and fast.has_pending(ev.buf) then fast.dismiss_all(ev.buf) end
      end,
    })
    -- Sticky provider toggle: <C-g> (g = GLM) flips between the default
    -- gpt_oss_120b and glm_4_7 (GLM 4.7 pinned to cerebras, see `providers`).
    -- switch_provider mutates Config.provider, which every request path
    -- (sidebar, zen, floating prompt, fast engine, selection edit) reads at
    -- submit time, so the choice sticks until toggled back. Bound per-buffer on
    -- the avante filetypes: AvanteInput covers the sidebar + zen input,
    -- AvantePromptInput the floating prompt, Avante the result window.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("avante_provider_toggle", { clear = true }),
      pattern = { "AvanteInput", "AvantePromptInput", "Avante" },
      callback = function(ev)
        vim.keymap.set({ "n", "i" }, "<C-g>", function()
          local Config = require("avante.config")
          local target = Config.provider == "glm_4_7" and "gpt_oss_120b" or "glm_4_7"
          require("avante.api").switch_provider(target)
          -- switch_provider notifies with once=true (silent on repeat toggles),
          -- so echo the new state ourselves every time
          vim.notify("avante provider: " .. target, vim.log.levels.INFO)
        end, { buffer = ev.buf, desc = "avante: toggle gpt_oss_120b <-> glm_4_7" })
      end,
    })
  end,
  opts = {
    -- add any opts here
    -- for example
    provider = "gpt_oss_120b",
    -- Run the sidebar + zen mode on the minimal fast Morph engine (edits land as a
    -- pending virtual-text overlay; <Tab> accepts). The no-selection <leader>ae float
    -- prompt and the <Tab> "chat" route use it regardless.
    chat_mode = "fast",
    -- The chat reply renders as Markdown in the terminal but LaTeX is NOT rendered,
    -- so tell the model to write math as Unicode (β, Σ, √, a/b) instead of $...$ /
    -- \frac. Prose only -- edits keep the file's own math syntax (e.g. typst).
    unicode_math = true,
    -- Per-file extra instructions. Called each request with { filetype, filepath,
    -- filepaths, cwd, mode }; return "" to add nothing. The model already sees the
    -- path + language, but it still confuses Typst with LaTeX, so hammer the point
    -- on typst buffers. Branch on cwd/filetype here for other project-specific rules.
    system_prompt = function(ctx)
      if ctx and ctx.filetype == "typst" then
        return table.concat({
          "This file is Typst, which is NOT LaTeX. Typst math is its own language; do not write LaTeX commands.",
          "- fractions: use the / operator, e.g. a/b or (a + b)/c. frac(...) exists but we almost never use it; never \\frac{a}{b}.",
          "- sums/products: sum_(i=1)^N, product_(i=1)^N -- never \\sum / \\prod",
          "- roots and accents: sqrt(x), macron(X), hat(x), bar(x) -- no backslash commands",
          "- math delimiters are $ ... $ (display is a $ on its own lines) -- never \\(...\\) or $$...$$",
          "Match the surrounding Typst conventions already in the file.",
        }, "\n")
      end
      return ""
    end,
    behaviour = {
      -- Supervise a fast model: auto-approve only read-only/search tools.
      -- Every mutating tool (edit_file/str_replace/write_to_file/create/insert/
      -- undo_edit) and run_command are absent here, so they prompt for approval.
      auto_approve_tool_permissions = {
        "view", "ls", "glob", "grep",
        "get_diagnostics", "think", "attempt_completion", "read_todos", "write_todos",
      },
      -- Fast Apply: route edits through the dedicated Morph apply model (see the
      -- `morph` provider below). Edits then arrive via the `edit_file` tool,
      -- which is mutating and so still prompts per the approvals above.
      enable_fastapply = true,
    },
    selection = {
      -- Route the visual-selection edit through Morph fast-apply: the provider
      -- drafts a lazy edit snippet, the morph provider merges it into the selection.
      fastapply = true,
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
      gpt_oss_120b = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        model = "openai/gpt-oss-120b",
        api_key_name = "OPENROUTER_API_KEY",
        -- Fast streaming on cerebras/groq: 100ms throttle on the edit-feature
        -- buffer writes is a comfortable spot for these providers.
        edit_stream_flush_interval_ms = 900,
        -- Benchmark mode: no incremental writes; single buffer update at completion.
        -- Only honored on the `bench/coalesce-vs-wait` branch of avante.nvim;
        -- `feat/edit-streaming-throttle` (the PR branch) does not define this field.
        -- edit_stream_disabled = true,
        -- edit_stream_disabled = false,
        extra_request_body = {
          reasoning = {
            effort = "medium",
          },
          -- OpenRouter routing: try cerebras first, then groq, no fallback to
          -- other providers if both are unavailable. See
          -- https://openrouter.ai/docs/guides/routing/provider-selection
          provider = {
            order = { "cerebras", "groq" },
            allow_fallbacks = false,
          },
        },
      },
      glm_4_7 = {
        -- GLM 4.7 on cerebras, the <C-g> toggle target (see init above).
        -- Pinned to cerebras only: the point is the speed, so no fallbacks.
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        model = "z-ai/glm-4.7",
        api_key_name = "OPENROUTER_API_KEY",
        edit_stream_flush_interval_ms = 900,
        extra_request_body = {
          reasoning = {
            effort = "medium",
          },
          provider = {
            order = { "cerebras" },
            allow_fallbacks = false,
          },
        },
      },
      morph = {
        -- Fast Apply model, called directly at api.morphllm.com with
        -- MORPH_API_KEY (sourced from ~/.secrets in zshrc). avante hardcodes the
        -- `morph` provider for the edit_file/fast-apply path, so this is the
        -- knob. "auto" lets Morph route; pin morph-v3-large (accuracy) or
        -- morph-v3-fast (speed) for a specific model. Needs enable_fastapply.
        __inherited_from = "openai",
        endpoint = "https://api.morphllm.com/v1",
        model = "auto",
        api_key_name = "MORPH_API_KEY",
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
