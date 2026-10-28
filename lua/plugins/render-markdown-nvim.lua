-- Pretty in-buffer markdown rendering for markdown + the Avante chat buffer
-- (headings, code blocks, lists, ...). LaTeX math rendering is deliberately OFF:
-- the math here is typst, and render-markdown treats every $...$ as LaTeX and runs
-- it through latex2text, which mangles typst into garbage. Instead the model is told
-- (avante `unicode_math = true`) to write math as Unicode in its replies, so there
-- is nothing to "render". The `latex` treesitter parser and the `pylatexenc`
-- package are now unused -- harmless to leave, removable later if desired.
return {
  enabled = false,
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "Avante" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    file_types = { "markdown", "Avante" },
    latex = { enabled = false },
  },
}
