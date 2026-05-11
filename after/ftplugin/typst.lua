vim.api.nvim_set_option_value("shiftwidth",  2, { buf = 0 })
vim.api.nvim_set_option_value("softtabstop", 2, { buf = 0 })

-- ftplugin/typst.lua
--
-- This setup detects a main.typ file and compiles it

local root_files = { 'main.typ' }
local paths = vim.fs.find(root_files, { stop = vim.env.HOME })
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
