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
  end,
}
