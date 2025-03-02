vim.loader.enable()

-- Define global variables that the next requires make use of
vim.g.mapleader = " "
vim.g.maplocalleader = " j"

require("config.lazy")
require("config.vanilla-nvim-config")
