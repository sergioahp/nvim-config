local textobj_pairs = {
  t = { inner = "@attribute.inner",   outer = "@attribute.outer"   },
  b = { inner = "@block.inner",       outer = "@block.outer"       },
  c = { inner = "@call.inner",        outer = "@call.outer"        },
  k = { inner = "@class.inner",       outer = "@class.outer"       },
  m = { inner = "@comment.inner",     outer = "@comment.outer"     },
  o = { inner = "@conditional.inner", outer = "@conditional.outer" },
  r = { inner = "@frame.inner",       outer = "@frame.outer"       },
  f = { inner = "@function.inner",    outer = "@function.outer"    },
  l = { inner = "@loop.inner",        outer = "@loop.outer"        },
  a = { inner = "@parameter.inner",   outer = "@parameter.outer"   },
}

-- Non-paired textobjects.
-- Here the original select mappings used more than one character.
local nonpaired = {
  h = "@assignment.inner",
  e = "@assignment.lhs",
  r = "@assignment.rhs",
  u = "@number.inner",
}

-- Build the select keymaps table dynamically.
-- For paired ones, we generate an inner key "i<letter>" and an outer key "a<letter>".
-- For non-paired ones, we generate both a lower-case version and an uppercase version.
local select_keymaps = {}
for letter, obj in pairs(textobj_pairs) do
  select_keymaps["i" .. letter] = obj.inner
  select_keymaps["a" .. letter] = obj.outer
end
for key, capture in pairs(nonpaired) do
  select_keymaps["i" .. key] = capture
end

-- Build swap mapping tables.
local swap_next     = {}
local swap_previous = {}
for letter, obj in pairs(textobj_pairs) do
  -- For paired textobjects, add both inner and outer swaps.
  swap_next["<leader>s" .. letter]     = obj.inner
  swap_previous["<leader>S" .. letter] = obj.inner
  swap_next["<leader>a" .. letter]     = obj.outer
  swap_previous["<leader>A" .. letter] = obj.outer
end
for key, capture in pairs(nonpaired) do
  swap_next["<leader>s" .. key]     = capture
  swap_previous["<leader>S" .. key] = capture
end

-- Build move mapping tables.
local goto_next_start = {}
local goto_next_end   = {}
local goto_prev_start = {}
local goto_prev_end   = {}
for letter, obj in pairs(textobj_pairs) do
  -- Outer textobject moves.
  goto_next_start["<leader>n" .. letter] = obj.outer
  goto_prev_start["<leader>p" .. letter] = obj.outer
  goto_next_end["<leader>n" .. string.upper(letter)] = obj.outer
  goto_prev_end["<leader>p" .. string.upper(letter)] = obj.outer

  -- Inner textobject moves.
  goto_next_start["<leader>N" .. letter] = obj.inner
  goto_prev_start["<leader>P" .. letter] = obj.inner
  goto_next_end["<leader>N" .. string.upper(letter)] = obj.inner
  goto_prev_end["<leader>P" .. string.upper(letter)] = obj.inner
end
for key, capture in pairs(nonpaired) do
  goto_next_start["<leader>n" .. key] = capture
  goto_prev_start["<leader>p" .. key] = capture
  goto_next_end["<leader>n" .. string.upper(key)] = capture
  goto_prev_end["<leader>p" .. string.upper(key)] = capture
end

local M = {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  build = function()
    require("nvim-treesitter.install").update({ with_sync = true })()
  end,
  opts = {
    ensure_installed = {
      "c", "lua", "vim", "vimdoc", "query", "javascript", "html",
      "typst", "bash", "luadoc", "markdown", "requirements", "toml",
      "yaml", "python", "nix", "yuck", "rust", "sql",
    },
    sync_install = false,
    highlight = { enable = true, additional_vim_regex_highlighting = false },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection    = "<leader>i",
        node_incremental  = "<leader>i",
        scope_incremental = "<leader>ts",
        node_decremental  = "<leader>I",
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        lookbehind = true,
        include_surrounding_whitespace = false,
        keymaps = select_keymaps,  -- our dynamically built select mappings
      },
      swap = {
        enable = true,
        swap_next     = swap_next,
        swap_previous = swap_previous,
      },
      move = {
        enable = true,
        set_jumps = false,
        goto_next_start     = goto_next_start,
        goto_next_end       = goto_next_end,
        goto_previous_start = goto_prev_start,
        goto_previous_end   = goto_prev_end,
      },
    },
  },
  config = function (_, opts)
    require("nvim-treesitter.configs").setup(opts)
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move, { silent = true } )
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite, { silent = true })
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true, silent = true })
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true, silent = true })
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true, silent = true })
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true, silent = true })
  end,
}

return { M }
