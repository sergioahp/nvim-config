return {
  "sergioahp/minuet-ai.nvim",
  branch = "main",
  -- commit = "9b1065a1ef891bcd7dfd1830d53355673c9ed951",
  -- name = "minuet-ai",
  -- dir = "~/code/lua/minuet-ai.nvim",
  enabled = true,
  opts = {
    provider = "codestral",
    provider_options = {
      codestral = {
        model = "codestral-latest",
        end_point = "https://api.mistral.ai/v1/fim/completions",
        api_key = "MISTRAL_API_KEY",
        stream = true,
        optional = {
          -- Single-line completions (autotrigger + <c-f>): a line tops out
          -- around ~200 chars, so 64 tokens is plenty. <C-S-f> overrides this
          -- to 256 for multi-line block completions.
          max_tokens = 64,
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
    -- Duet (NES, normal-mode next-edit prediction). Default to Inception Mercury
    -- Edit 2 via its native /v1/edit/completions endpoint (INCEPTION_API_KEY).
    -- The prompt matches the documented Next Edit format (tagged file +
    -- treesitter/diagnostics snippets + range-based edit_diff_history). Switch
    -- back to gpt-oss by setting provider = "openai_compatible" below.
    duet = {
      provider = "inception_edit",
      preview = {
        mode = "virtual_lines",
      },
      provider_options = {
        -- inception_edit inherits good defaults (cursor-centered editable region
        -- snapped to syntax, ~3 cross-file snippets, range-based history). Tune
        -- here if needed: lines_before/lines_after, max_editable_lines,
        -- snippet_count, snippet_radius, max_siblings.
        openai_compatible = {
          model = "openai/gpt-oss-120b",
          optional = {
            reasoning = { effort = "medium" },
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
      -- pool_size inherits the 128 default (large local cache).
      -- Pure append slack: steady typing or a paste at the cursor can grow 12k
      -- chars past the initial warm prefix before the anchor snaps.
      context_growth_slack = 12000,
      -- Divergence slack: if bytes inside the anchored prefix changed, cap the
      -- cold tail recomputed from the edit point to the cursor at 4k chars.
      context_divergence_slack = 4000,
      -- Size the prefix directly: 8k (trimmed from 16k -> 10k -> 8k to cut
      -- uncached latency and uncached input-token cost on the first FIM request).
      -- Without this the prefix is only context_window*context_ratio =
      -- 16000*0.75 = 12000; setting it decouples the prefix from the suffix so
      -- the prefix gets its full 8k and the suffix is sized on its own by
      -- context_after_chars. While anchored the prefix still grows up to
      -- context_growth_slack (12k) past this.
      -- Note: trimmed again to 6k
      context_before_chars = 6000,
      -- Keep fresh re-pins at 10k prefix. Rewinds that change the suffix are
      -- cold under SPM anyway, so do not pay extra cold prefix for headroom.
      context_back_slack = 0,
      -- Suffix budget (constant). Under SPM the suffix LEADS the prompt and is
      -- the cache gate, so it must stay byte-stable as you type -- which it does,
      -- since inserting before the cursor leaves the after-cursor text unchanged.
      -- A changed suffix (jump / edit-below) re-pins. Must be a constant, never
      -- a function of prefix length.
      -- Note: trimmed to 3k
      context_after_chars = 3000,
    },
    throttle = 0,
    debounce = 0,
    -- Number of alternatives requested at a time (parallel FIM requests).
    n_completions = 2,
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
        -- single-line: relies on provider default stop = { "\n" }
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
          m.with.optional("codestral", { stop = { "\n\n" }, max_tokens = 256 })
        )
      end,
      silent = true,
      mode = "i",
      desc = "Cycle next, or fire multi-line completion if none yet",
    },
    {
      "<c-e>", function ()
        local next = {
          off = "full",
          full = "unintrusive",
          unintrusive = "off",
        }
        local cur = vim.b.minuet_virtual_text_auto_trigger_mode or "off"
        require("minuet.virtualtext").action.set_auto_trigger_mode(next[cur])
      end,
      silent = true,
      mode = "i",
      desc = "Cycle auto trigger (off/full/unintrusive)",
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
    -- Normal-mode duet (NES) maps, mirroring the insert-mode flow:
    {
      "<Tab>", function()
        -- Avante fast-edit overlays take precedence: accept the pending hunk under
        -- the cursor, or jump to the next one. Only when nothing is pending do we
        -- fall through to minuet duet (jump/accept a prediction, else cycle a new one).
        local ok, fast = pcall(require, "avante.fast")
        if ok and fast.has_pending() then
          fast.accept_or_next()
          return
        end
        local d = require("minuet.duet").action
        -- on a shown suggestion: jump to the next change, then accept it once the
        -- cursor is on it; with nothing shown, fire/cycle a new prediction
        if d.is_visible() then d.accept_or_next() else d.cycle() end
      end,
      silent = true,
      mode = "n",
      desc = "Avante pending / Duet: accept-or-next, else predict",
    },
    {
      "<S-Tab>", function()
        -- NES only. Autocomplete (virtualtext) has its own <C-e> toggle.
        require("minuet.duet").action.toggle()
      end,
      silent = true,
      mode = "n",
      desc = "Duet (NES): toggle auto-trigger",
    },
    {
      "<leader>M", function()
        require("minuet.duet").action.inspect()
      end,
      silent = true,
      mode = "n",
      desc = "Duet: toggle prediction introspection float",
    },
  },
  init = function()
    -- lazy's keys spec normalizes <C-m> to <CR>; set directly here instead.
    vim.keymap.set('i', '<C-m>', function()
      require('minuet.virtualtext').action.accept_until_char()
    end, { silent = true, desc = 'Accept suggestion until char (f-like)' })
  end,
}
