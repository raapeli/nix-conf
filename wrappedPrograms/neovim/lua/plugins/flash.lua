return {
  "flash.nvim",
  opts = {},
  keys = {
    { "s", function() require("flash").jump() end, desc = "Flash", mode = { "n", "x", "o" } },
  },
}
