return {
  enabled = true,
  "kndndrj/nvim-dbee",
  cmd = "Dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
    -- "MattiasMTS/cmp-dbee",
  },
  ft = "sql",
  opts = {
    editor = {
      -- see drawer comment.
      window_options = {},
      buffer_options = {},

      -- directory where to store the scratchpads.
      --directory = "path/to/scratchpad/dir",

      -- mappings for the buffer
      mappings = {
        -- run what's currently selected on the active connection
        { key = "<leader>x", mode = "v", action = "run_selection" },
        -- run the whole file on the active connection
        { key = "<leader>x", mode = "n", action = "run_file" },
      },
    },
  }, -- needed
  build = function ()
    -- Install tries to automatically detect the install method.
    -- if it fails, try calling it with one of these parameters:
    --    "curl", "wget", "bitsadmin", "go"
    require("dbee").install()
  end,
}
