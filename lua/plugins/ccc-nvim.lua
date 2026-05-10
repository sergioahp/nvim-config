return {
  "uga-rosa/ccc.nvim",
  -- event = "BufEnter",
  opts = {
    highlighter = {
    }
  },
  keys = {
    {
      "<leader>C",
      function ()
        local bufnr = vim.api.nvim_get_current_buf()
        bufnr = require("ccc.utils").ensure_bufnr(bufnr)
        local h = require("ccc.highlighter")
        -- h:init()
        if h.attached_buffer[bufnr] then
          h:disable(bufnr)
          vim.api.nvim_echo({{ "ccc h off" }}, false, {})
        else
          h:enable(bufnr)
          vim.api.nvim_echo({{ "ccc h on" }}, false, {})
        end
      end,
      ""
    },
    {
      "<leader>cp",
      "<cmd>CccPick<cr>",
      desc = "Pick/edit color under cursor"
    },
  },
  init = function ()
    local editorconfig = require('editorconfig')
    editorconfig.properties.color_highlighting = function (bufnr, val)
      bufnr = require("ccc.utils").ensure_bufnr(bufnr)
      local h = require("ccc.highlighter")
      if val == "true" then
        h:enable(bufnr)
      elseif val == "false" then
        h:disable(bufnr)
      else
        error('color_highlighting bust be "true" or "false"', 0)
      end
    end

  end,
  cmd = {
    "CccPick",
    "CccConvert",
    "CccHighlighterEnable",
    "CccHighlighterDisable",
    "CccHighlighterToggle",
  },
}
