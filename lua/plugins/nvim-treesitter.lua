-- nvim-treesitter `main` branch.
-- master is archived; main has a different API: no `setup()` modules system,
-- no `ensure_installed`, no `highlight`/`indent` config. Everything is
-- explicit: install parsers with `require('nvim-treesitter').install`, enable
-- highlight/indent/folds per-buffer via FileType autocmd. Lazy-loading is
-- explicitly unsupported -> `lazy = false`.

local parsers = {
  "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "tsx",
  "html", "typst", "bash", "luadoc", "markdown", "markdown_inline",
  "requirements", "toml", "yaml", "python", "nix", "yuck", "rust", "sql",
}

-- Filetypes -> parser map. Used by the FileType autocmd's pattern. We can't
-- just enable for every filetype because some have no parser and
-- `vim.treesitter.start` would error; we want quiet no-ops for filetypes we
-- don't care about.
local ts_filetypes = {
  "c", "lua", "vim", "help", "query", "javascript", "typescript",
  "typescriptreact", "html", "typst", "bash", "sh", "zsh", "markdown",
  "requirements", "toml", "yaml", "python", "nix", "yuck", "rust", "sql",
  -- via vim.treesitter.language.register below
  "octo",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    -- Octo issue/PR buffers reuse the markdown parser.
    vim.treesitter.language.register("markdown", "octo")

    -- Ensure parsers are installed (async; no-op if already present).
    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = ts_filetypes,
      group = vim.api.nvim_create_augroup("nvim-treesitter-start", { clear = true }),
      callback = function(args)
        -- start() errors if no parser; guard with pcall for safety in case a
        -- parser failed to install.
        pcall(vim.treesitter.start, args.buf)
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldmethod = "expr"
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    -- Incremental selection. The previous master config had
    --   init_selection    = "<leader>i"
    --   node_incremental  = "<leader>i"
    --   scope_incremental = "<leader>ts"
    --   node_decremental  = "<leader>I"
    -- nvim 0.12 ships builtin `an` / `in` keys for parent/child node, but
    -- those would block mini.ai's `vin(`, `van[`, `vil{`, ... target
    -- prefixes (mini.ai reads the char after `i` / `a` as a "next" /
    -- "last" modifier). So we keep the leader-style bindings.
    -- `bang = true` on vim.cmd.normal makes the inner `v` un-remappable.
    -- The selection helpers live in vim/treesitter/_select.lua but are
    -- not exposed on the `vim.treesitter` table; load via require.
    local ts_select = require "vim.treesitter._select"

    vim.keymap.set("n", "<leader>i", function ()
      -- Enter visual char mode at cursor, then expand to the smallest
      -- node containing it. Same effect as master's init_selection.
      vim.cmd.normal({ "v", bang = true })
      ts_select.select_parent(1)
    end, { silent = true, desc = "Start incremental node selection" })

    vim.keymap.set("x", "<leader>i",  function () ts_select.select_parent(vim.v.count1) end, { silent = true, desc = "Expand to parent node" })
    vim.keymap.set("x", "<leader>I",  function () ts_select.select_child (vim.v.count1) end, { silent = true, desc = "Shrink to child node" })
    -- scope_incremental on master picked the next named scope from the
    -- `locals` query; there is no direct equivalent in vim.treesitter._select.
    -- Aliased to a parent-expand here; redundant with <leader>i but
    -- preserved so muscle memory still works.
    vim.keymap.set("x", "<leader>ts", function () ts_select.select_parent(vim.v.count1) end, { silent = true, desc = "Expand to parent node (was scope_incremental)" })
  end,
}
