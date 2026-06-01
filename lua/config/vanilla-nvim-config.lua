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
