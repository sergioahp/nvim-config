local FIM_PREFIX = "<|fim_prefix|>"
local FIM_SUFFIX = "<|fim_suffix|>"
local FIM_MIDDLE = "<|fim_middle|>"

-- Terminators from Qwen3-Coder-Next's model card: eos_token_ids
-- [151659, 151661, 151662, 151663, 151664, 151643, 151645]. Note <|fim_middle|>
-- (151660) is intentionally NOT a terminator (it precedes the generated middle).
local QWEN_EOS = {
  FIM_PREFIX,        -- 151659
  FIM_SUFFIX,        -- 151661
  "<|fim_pad|>",     -- 151662
  "<|repo_name|>",   -- 151663
  "<|file_sep|>",    -- 151664
  "<|endoftext|>",   -- 151643
  "<|im_end|>",      -- 151645
}

-- qwen3-coder-next FIM on OpenRouter's /completions endpoint. OpenRouter ignores
-- the OpenAI `suffix` field for FIM (verified: prompt+suffix gives 0/9 valid
-- completions), so we assemble Qwen's raw FIM control tokens in the prompt and
-- set suffix = false.
--
-- PSM = prefix, suffix, then generate the middle. This is Qwen's official
-- model-card order and what the latency benchmark settled on.
local function qwen_fim_psm(before, after, _)
  return FIM_PREFIX .. before .. FIM_SUFFIX .. after .. FIM_MIDDLE
end

-- SPM = suffix first, prefix last. The growing prefix sits at the very end of
-- the prompt, so typing at the cursor only appends and never invalidates the
-- earlier tokens. Paired with minuet's virtualtext context anchor this keeps the
-- server-side KV cache warm across keystrokes.
local function qwen_fim_spm(before, after, _)
  return FIM_PREFIX .. FIM_SUFFIX .. after .. FIM_MIDDLE .. before
end

-- Single-line for auto-trigger (cheap, unintrusive); multi-line on demand. Both
-- include the model card's eos tokens so the model never spills past the hole;
-- the leading "\n"/"\n\n" just bounds how far it runs.
local qwen_stops_singleline = vim.list_extend({ "\n" }, QWEN_EOS)
local qwen_stops_multiline = vim.list_extend({ "\n\n" }, QWEN_EOS)

-- OpenRouter's default routing can land on a backend that mishandles the raw FIM
-- tokens; pin to providers that serve them correctly (verified 3/3 clean).
local qwen_provider_routing = { order = { "parasail/bf16", "atlas-cloud/fp8" }, allow_fallbacks = false }

return {
  "sergioahp/minuet-ai.nvim",
  branch = "main",
  -- commit = "9b1065a1ef891bcd7dfd1830d53355673c9ed951",
  -- name = "minuet-ai",
  -- dir = "~/code/lua/minuet-ai.nvim",
  enabled = true,
  opts = {
    provider = "openai_fim_compatible",
    provider_options = {
      openai_fim_compatible = {
        model = "qwen/qwen3-coder-next",
        end_point = "https://openrouter.ai/api/v1/completions",
        api_key = "OPENROUTER_API_KEY",
        name = "Openrouter",
        stream = true,
        optional = {
          max_tokens = 256,
          stop = qwen_stops_singleline,
          provider = qwen_provider_routing,
          -- n_completions = 3 fires 3 requests; non-zero temp so they actually
          -- diverge instead of returning the same deterministic FIM middle.
          temperature = 0.7,
        },
        -- Active default: SPM. Measured on OpenRouter (ionstream/parasail): with
        -- PSM the prompt cache drops to 0% on every keystroke (the cursor edit
        -- lands mid-prompt, so the whole suffix region shifts and prefill reruns),
        -- while SPM keeps ~99% cached (the edit is at the very end). That cache
        -- gap is the dominant TTFT lever here. Flip to PSM to compare with
        -- `:Minuet change_preset psm` (back with `:Minuet change_preset spm`).
        template = {
          prompt = qwen_fim_spm,
          suffix = false,
        },
      },
      -- Alternate FIM provider, kept for quick `:Minuet change_provider codestral`.
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
      -- Previous openai_fim_compatible target (Inception mercury-edit-2). Only
      -- one openai_fim_compatible slot exists, so this is parked here for
      -- reference; restore it by swapping the block above back in.
      -- openai_fim_compatible = {
      --   model = "mercury-edit-2",
      --   end_point = "https://api.inceptionlabs.ai/v1/fim/completions",
      --   api_key = "INCEPTION_API_KEY",
      --   name = "Inception",
      --   stream = true,
      --   optional = {
      --     max_tokens = 256,
      --   },
      -- },
    },
    -- PSM vs SPM ordering, switchable so both can be A/B tested under
    -- auto-trigger. `original` (the full config above, PSM) is added automatically.
    presets = {
      psm = {
        provider = "openai_fim_compatible",
        provider_options = {
          openai_fim_compatible = {
            template = { prompt = qwen_fim_psm, suffix = false },
          },
        },
      },
      spm = {
        provider = "openai_fim_compatible",
        provider_options = {
          openai_fim_compatible = {
            template = { prompt = qwen_fim_spm, suffix = false },
          },
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
      pool_size = 32,
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
        -- single-line: relies on the active provider's default stop (qwen
        -- single-line stop includes "\n")
        require("minuet.virtualtext").action.next()
      end,
      silent = true,
      mode = "i",
      desc = "Cycle next, or fire single-line completion if none yet",
    },
    {
      "<C-S-f>", function ()
        local m = require("minuet")
        require("minuet.virtualtext").action.next(
          m.with.optional("openai_fim_compatible", { stop = qwen_stops_multiline })
        )
      end,
      silent = true,
      mode = "i",
      desc = "Cycle next, or fire multi-line completion if none yet",
    },
    {
      "<c-e>", function ()
        require("minuet.virtualtext").action.toggle_auto_trigger()
      end,
      silent = true,
      mode = "i",
      desc = "Toggle auto trigger (full/off)",
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
