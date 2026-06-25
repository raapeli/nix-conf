return {
  "yanky.nvim",
  opts = {},
  keys = {
    { "p", function() require("yanky").put("p") end, desc = "Put after" },
    { "P", function() require("yanky").put("P") end, desc = "Put before" },
    { "<leader>p", function() require("yanky").cycle(1) end, desc = "Cycle forward" },
    { "<leader>P", function() require("yanky").cycle(-1) end, desc = "Cycle backward" },
  },
}
