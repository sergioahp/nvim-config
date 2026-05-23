-- nvim-treesitter-textobjects `main` branch.
-- master is frozen (Oct 2025). On main the keymap-table config is gone:
-- every keymap is set explicitly by calling functions from the
-- `select` / `swap` / `move` / `repeatable_move` submodules.
--
-- The tables below are the same shape as before; only the loop bodies
-- changed: they now generate explicit `vim.keymap.set` calls that invoke
-- the new APIs, instead of stashing entries into an opts table.

local textobj_pairs = {
  -- -- not so common, usen in tsx, html, astro, etc
  -- y = { inner = "@attribute.inner",   outer = "@attribute.outer"   },

  -- maybe not so frequenly used
  -- y = { inner = "@block.inner",       outer = "@block.outer"       },
  -- maybe not so frequenly used commented out for now
  -- (you can you parenthesis btw, yi(, vi(, etc)
  -- -- K for kall (frequently used mapping)
  -- k = { inner = "@call.inner",        outer = "@call.outer"        },
  -- K for Klass (frequently used mapping)
  k = { inner = "@class.inner",       outer = "@class.outer"       },
  -- (frequently used mapping)
  g = { inner = "@comment.inner",     outer = "@comment.outer"     },
  -- f for Function call (matches mini.ai)
  f = { inner = "@call.inner",        outer = "@call.outer"        },
  -- m for Method/function (matches vim default)
  m = { inner = "@function.inner",    outer = "@function.outer"    },
  --  for the j we use in a for loop (frequently used mapping)
  v = { inner = "@loop.inner",        outer = "@loop.outer"        },
  -- r for parameter
  r = { inner = "@parameter.inner",   outer = "@parameter.outer"   },
  -- j for Jump/conditional (if/else statements)
  j = { inner = "@conditional.inner", outer = "@conditional.outer" },
}

-- Non-paired textobjects.
-- Here the original select mappings used more than one character.
local nonpaired = {
  z = "@assignment.inner",
  -- e = "@assignment.lhs",
  -- r = "@assignment.rhs",
  u = "@number.inner",
}

return {
  "sergioahp/nvim-treesitter-textobjects",
  branch = "main",
  lazy = false,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function ()
    -- Preserve the previous lookahead/lookbehind behavior from the master
    -- config; main defaults both to `false` and `set_jumps` to `true`.
    require("nvim-treesitter-textobjects").setup {
      select = { lookahead = true, lookbehind = true },
      move   = { set_jumps = true },
    }

    local select         = require "nvim-treesitter-textobjects.select"
    local swap           = require "nvim-treesitter-textobjects.swap"
    local move           = require "nvim-treesitter-textobjects.move"
    local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"

    -- Selection mappings. On master these were a `keymaps` table fed to
    -- the module options; on main we bind each one explicitly.
    -- For paired textobjects we generate `i<letter>` (inner) and
    -- `a<letter>` (outer). For non-paired we generate just `i<key>`.
    for letter, obj in pairs(textobj_pairs) do
      vim.keymap.set({ "x", "o" }, "i" .. letter, function ()
        select.select_textobject(obj.inner, "textobjects")
      end, { silent = true, desc = "Select " .. obj.inner })
      vim.keymap.set({ "x", "o" }, "a" .. letter, function ()
        select.select_textobject(obj.outer, "textobjects")
      end, { silent = true, desc = "Select " .. obj.outer })
    end
    for key, capture in pairs(nonpaired) do
      vim.keymap.set({ "x", "o" }, "i" .. key, function ()
        select.select_textobject(capture, "textobjects")
      end, { silent = true, desc = "Select " .. capture })
    end

    -- Swap mappings. Paired: inner via <leader>d/D and outer via
    -- <leader>s/S; non-paired: only <leader>s/S since there is no
    -- outer/inner distinction.
    for letter, obj in pairs(textobj_pairs) do
      vim.keymap.set("n", "<leader>d" .. letter, function ()
        swap.swap_next(obj.inner)
      end, { silent = true, desc = "Swap next "     .. obj.inner })
      vim.keymap.set("n", "<leader>D" .. letter, function ()
        swap.swap_previous(obj.inner)
      end, { silent = true, desc = "Swap previous " .. obj.inner })
      vim.keymap.set("n", "<leader>s" .. letter, function ()
        swap.swap_next(obj.outer)
      end, { silent = true, desc = "Swap next "     .. obj.outer })
      vim.keymap.set("n", "<leader>S" .. letter, function ()
        swap.swap_previous(obj.outer)
      end, { silent = true, desc = "Swap previous " .. obj.outer })
    end
    for key, capture in pairs(nonpaired) do
      vim.keymap.set("n", "<leader>s" .. key, function ()
        swap.swap_next(capture)
      end, { silent = true, desc = "Swap next "     .. capture })
      vim.keymap.set("n", "<leader>S" .. key, function ()
        swap.swap_previous(capture)
      end, { silent = true, desc = "Swap previous " .. capture })
    end

    -- Move mappings. Outer textobject moves only, using `]letter` /
    -- `[letter` for start and `]LETTER` / `[LETTER` for end. (The lower
    -- vs upper case end-vs-start convention is the textobjects default.)
    -- The move module sets up jumps automatically.
    for letter, obj in pairs(textobj_pairs) do
      vim.keymap.set({ "n", "x", "o" }, "]" .. letter, function ()
        move.goto_next_start(obj.outer, "textobjects")
      end, { silent = true, desc = "Next start "     .. obj.outer })
      vim.keymap.set({ "n", "x", "o" }, "[" .. letter, function ()
        move.goto_previous_start(obj.outer, "textobjects")
      end, { silent = true, desc = "Previous start " .. obj.outer })
      vim.keymap.set({ "n", "x", "o" }, "]" .. string.upper(letter), function ()
        move.goto_next_end(obj.outer, "textobjects")
      end, { silent = true, desc = "Next end "       .. obj.outer })
      vim.keymap.set({ "n", "x", "o" }, "[" .. string.upper(letter), function ()
        move.goto_previous_end(obj.outer, "textobjects")
      end, { silent = true, desc = "Previous end "   .. obj.outer })
    end
    for key, capture in pairs(nonpaired) do
      vim.keymap.set({ "n", "x", "o" }, "]" .. key, function ()
        move.goto_next_start(capture, "textobjects")
      end, { silent = true, desc = "Next start "     .. capture })
      vim.keymap.set({ "n", "x", "o" }, "[" .. key, function ()
        move.goto_previous_start(capture, "textobjects")
      end, { silent = true, desc = "Previous start " .. capture })
      vim.keymap.set({ "n", "x", "o" }, "]" .. string.upper(key), function ()
        move.goto_next_end(capture, "textobjects")
      end, { silent = true, desc = "Next end "       .. capture })
      vim.keymap.set({ "n", "x", "o" }, "[" .. string.upper(key), function ()
        move.goto_previous_end(capture, "textobjects")
      end, { silent = true, desc = "Previous end "   .. capture })
    end

    -- Add fold navigation keymaps
    vim.keymap.set({ "n", "x", "o" }, "]y", function ()
      move.goto_next_start("@fold", "folds")
    end, { silent = true, desc = "Next fold" })
    vim.keymap.set({ "n", "x", "o" }, "[y", function ()
      move.goto_previous_start("@fold", "folds")
    end, { silent = true, desc = "Previous fold" })

    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move,          { silent = true } )
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite, { silent = true })
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true, silent = true })
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true, silent = true })
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true, silent = true })
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true, silent = true })

    -- Setup custom textobjects for next/previous functions
    -- require("custom.textobjects").setup()
  end,
}
