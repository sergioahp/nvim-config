return {
  enabled = true,
  "kndndrj/nvim-dbee",
  -- cmd = "Dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
    -- "MattiasMTS/cmp-dbee",
  },
  ft = "sql",
  opts = {}, -- needed
  build = function()
    -- Install tries to automatically detect the install method.
    -- if it fails, try calling it with one of these parameters:
    --    "curl", "wget", "bitsadmin", "go"
    require("dbee").install()
  end,
}
