return {
  "snacks.nvim",
  opts = {
    picker = { enabled = true },
    notifier = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    quickfile = { enabled = true },
  },
  keys = {
    { "<leader>ff", function() require("snacks").picker.files() end, desc = "Find files" },
    { "<leader>fg", function() require("snacks").picker.grep() end, desc = "Grep" },
    { "<leader>fo", function() require("snacks").picker.recent() end, desc = "Recent" },
    { "gr", function() require("snacks").picker.references() end, desc = "References" },
    { "gd", function() require("snacks").picker.lsp_definitions() end, desc = "Definitions" },
  },
}
