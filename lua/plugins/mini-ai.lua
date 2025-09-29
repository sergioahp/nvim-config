return {
  "nvim-mini/mini.ai",
  version = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    local mini_ai = require('mini.ai')
    mini_ai.setup({
      n_lines = 2000,
      custom_textobjects = {
        -- Treesitter textobjects to match our treesitter config
        v = mini_ai.gen_spec.treesitter({ a = '@loop.outer', i = '@loop.inner' }),
        j = mini_ai.gen_spec.treesitter({ a = '@conditional.outer', i = '@conditional.inner' }),
        k = mini_ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
        m = mini_ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
        r = mini_ai.gen_spec.treesitter({ a = '@parameter.outer', i = '@parameter.inner' }),
        g = mini_ai.gen_spec.treesitter({ a = '@comment.outer', i = '@comment.inner' }),
        z = mini_ai.gen_spec.treesitter({ a = '@assignment.outer', i = '@assignment.inner' }),
        u = mini_ai.gen_spec.treesitter({ a = '@number.outer', i = '@number.inner' }),
      },
    })
  end,
}