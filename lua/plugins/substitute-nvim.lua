return {
  "gbprod/substitute.nvim",
  opts = {
    exchange = {
      use_esc_to_cancel = false,
      preserve_cursor_position = true,
    },
  },
  keys = {
    {
      "cx",
      function()
        require("substitute.exchange").operator()
      end,
      mode = "n",
      desc = "Exchange text object",
      noremap = true,
      silent = true,
    },
    {
      "cxx",
      function()
        require("substitute.exchange").line()
      end,
      mode = "n",
      desc = "Exchange entire line",
      noremap = true,
      silent = true,
    },
    {
      "X",
      function()
        require("substitute.exchange").visual()
      end,
      mode = "x",
      desc = "Exchange visual selection",
      noremap = true,
      silent = true,
    },
    {
      "cxc",
      function()
        require("substitute.exchange").cancel()
      end,
      mode = "n",
      desc = "Cancel exchange operation",
      noremap = true,
      silent = true,
    },
    -- {
    --   "cxm",
    --   function()
    --     require("substitute.exchange").operator({ motion = "iw" })
    --   end,
    --   mode = "n",
    --   desc = "Exchange current word",
    --   noremap = true,
    --   silent = true,
    -- },
  },
}
