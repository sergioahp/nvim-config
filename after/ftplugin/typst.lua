vim.api.nvim_set_option_value("shiftwidth",  2, { buf = 0 })
vim.api.nvim_set_option_value("softtabstop", 2, { buf = 0 })

-- Keep `gq` wrapping prose to textwidth instead of letting tinymist hijack it.
--
-- tinymist dynamically registers textDocument/rangeFormatting a moment after it
-- attaches (that's why wrapping works at first and only "breaks after a bit").
-- When that capability registers, Neovim core (vim/lsp.lua _set_defaults, run
-- again from the client/registerCapability handler) sets
--   formatexpr = v:lua.vim.lsp.formatexpr()
-- so `gq` then asks tinymist's formatter (typstyle), which does not reflow
-- markup text to textwidth at all -> the long line is left untouched.
--
-- _set_defaults only overrides formatexpr when it is empty or was last set by a
-- $VIMRUNTIME file (is_empty_or_default). Setting it here, from a user ftplugin,
-- makes it skip both the attach and the registerCapability paths. The value is
-- an expression that always returns non-zero, which per :help formatexpr means
-- "fall back to the internal format function" -- i.e. plain textwidth `gq`.
-- This is NOT a treesitter issue; it reproduces with zero plugins.
-- Still possible to run typstyle explicitly with :lua vim.lsp.buf.format().
vim.api.nvim_set_option_value("formatexpr", "1", { buf = 0 })

-- ftplugin/typst.lua
--
-- This setup detects a main.typ file and compiles it

local root_files = { 'main.typ' }
local paths = vim.fs.find(root_files, {
  upward = true,
  stop = vim.env.HOME,
  path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
})
local root_dir = vim.fs.dirname(paths[1])

if root_dir then
  vim.lsp.start({
    cmd = { 'typst-languagetool-lsp' },
    filetype = { 'typst' },
    root_dir = root_dir,
    init_options = {
      backend = "jar",
      jar_location = vim.env.LANGUAGETOOL_JAR,
      -- host = "http://127.0.0.1",
      -- port = "8081",
      root = root_dir,
      main = root_dir .. "/main.typ",
      languages = { de = "de-DE", en = "en-US" }
    },
  })
end
