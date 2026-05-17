-- nvim-treesitter-textobjects `main` branch.
-- master is frozen (Oct 2025). On main the keymap-table config is gone:
-- every keymap is set explicitly by calling functions from the
-- `select` / `swap` / `move` / `repeatable_move` submodules.
--
-- This file declares the plugin on the right branch. The actual keymap
-- bindings are set up below; if/when this file grows, consider moving
-- the keymaps into a config function or a separate module.

return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  lazy = false,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  -- keymaps come in a follow-up step (see TREESITTER_MIGRATION.md).
}
