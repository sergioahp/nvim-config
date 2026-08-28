return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    transparent = true,
    on_highlights = function(hl)
      for _, severity in ipairs({"Error", "Warn", "Info", "Hint"}) do
        local group = "DiagnosticUnderline" .. severity
        hl[group].undercurl = false
        hl[group].underline = true
      end
    end,
  },
  config = function (_, opts)
    require("tokyonight").setup(opts)
    vim.cmd[[colorscheme tokyonight]]
  end,
}
