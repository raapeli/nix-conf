return {
  "persistence.nvim",
  opts = {},
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore session" },
  },
}
