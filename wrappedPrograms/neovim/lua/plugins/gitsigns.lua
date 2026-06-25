return {
  "gitsigns.nvim",
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    on_attach = function(bufnr)
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end
      map("n", "<leader>gb", require("gitsigns").blame_line, "Blame line")
      map("n", "<leader>gp", require("gitsigns").preview_hunk, "Preview hunk")
    end,
  },
}
