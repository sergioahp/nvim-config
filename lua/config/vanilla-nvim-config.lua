local globalOptions = {
  hidden = true,
  scrolloff = 2,
  hlsearch = false,
  title = true,
  timeoutlen = 8000,
}

local windowOptions = {
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

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight on yanking',
  group = vim.api.nvim_create_augroup('custom-highlight-yank', { clear = true }),
  callback = function ()
    vim.highlight.on_yank()
  end,
})

for c, name in pairs { m="manual", i="indent", e="expr", d="diff", r="marker" } do
  vim.keymap.set({"n", "v"}, "<leader>o" .. c, function() vim.api.nvim_set_option_value("foldmethod", name, { win=0 }) end)
end
