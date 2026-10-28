local globalOptions = {
  hidden = true,
  scrolloff = 2,
  hlsearch = false,
  title = true,
  timeoutlen = 8000,
  -- 😔 Preview mode in mini.align needs this when working with lsp
  -- https://github.com/nvim-mini/mini.nvim/issues/1875
  showmode = false,
}

local windowOptions = {
  signcolumn = "number",
  number = true,
  relativenumber = true,
  list = true,
  foldmethod = "expr",
  foldlevel = 20,
}

local bufferOptions = {
  expandtab = true,
  softtabstop = 4,
  shiftwidth = 4,
  textwidth = 80,
}

for name, val in pairs(globalOptions) do
  vim.api.nvim_set_option_value(name, val, { scope="global" })
end

for name, val in pairs(windowOptions) do
  vim.api.nvim_set_option_value(name, val, { scope="global" })
  vim.api.nvim_set_option_value(name, val, { win=0 })
end
for name, val in pairs(bufferOptions) do
  vim.api.nvim_set_option_value(name, val, { scope="global" })
  vim.api.nvim_set_option_value(name, val, { buf=0 })
end

-- for name, val in pairs(globalVariables) do
--     vim.api.nvim_set_var(name, val)
-- end

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight on yanking',
  group = vim.api.nvim_create_augroup('custom-highlight-yank', { clear = true }),
  callback = function ()
    vim.highlight.on_yank()
  end,
})

local maps = {
  {
    "v",
    "gs",
    ":s/\\%V/g<left><left>",
  },
  {
    "n",
    "gs",
    ":s//g<left><left>",
  },
  {
    "",
    "gz",
    'gi<c-r>"',
  },
  {
    "",
    "g<leader>",
    "`",
  },
  -- TODO: Enalbe alacritty's expended keys
  {
    "",
    "<C-BS>",
    "<C-w>",
  },
}


for c, name in pairs { m="manual", i="indent", e="expr", d="diff", r="marker" } do
  vim.keymap.set("", "<leader>o" .. c, function () vim.api.nvim_set_option_value("foldmethod", name, { win=0 }) end)
end
for _, v in ipairs(maps) do
  local mode = v[1]
  local lhs = v[2]
  local rhs = v[3]
  local _opts = v[4]
  _opts = vim.tbl_deep_extend(
    'keep',
    _opts or {},
    { noremap = true }
  )
  vim.keymap.set(mode, lhs, rhs, _opts)
end

vim.diagnostic.config({
  update_in_insert = true,
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '●',
      [vim.diagnostic.severity.WARN ] = '●',
      [vim.diagnostic.severity.HINT ] = '●',
      [vim.diagnostic.severity.INFO ] = '●',
    },
  },
})

-- require('vim._core.ui2').enable()

-- -- ui2 + nvim-cmp `:` cmdline preview-on-select bug:
-- -- when cmp.select_next_item runs in `:` cmdline, it calls vim.fn.setcmdline()
-- -- to preview the selected entry. CmdlineChanged fires and getcmdline() reflects
-- -- the new content, but the cmdline_show ui event never fires, so ui2's cmd
-- -- buffer stays out of sync until the entry is confirmed. /? are unaffected.
-- -- Manually re-emit cmdline_show on CmdlineChanged to keep ui2 in sync.
-- vim.api.nvim_create_autocmd('CmdlineChanged', {
--   group = vim.api.nvim_create_augroup('ui2-cmdline-sync', { clear = true }),
--   callback = function()
--     local ui2 = require('vim._core.ui2')
--     if not vim.api.nvim_buf_is_valid(ui2.bufs.cmd) then return end
--     local cmdline = vim.fn.getcmdline()
--     require('vim._core.ui2.cmdline').cmdline_show(
--       { { 0, cmdline, 0 } },
--       vim.fn.getcmdpos() - 1,
--       vim.fn.getcmdtype(),
--       '', 0, 1, 0)
--   end,
-- })
