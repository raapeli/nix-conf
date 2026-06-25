return {
  "nvim-lspconfig",
  lazy = false,

  before = function()
    local on_attach = function(_, bufnr)
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end
      map("n", "F", vim.lsp.buf.format, "Format")
      map("n", "gd", vim.lsp.buf.definition, "Goto definition")
      map("n", "gr", vim.lsp.buf.references, "References")
      map("n", "K", vim.lsp.buf.hover, "Hover")
      map("n", "<leader>k", vim.diagnostic.open_float, "Line diagnostics")
    end

    vim.lsp.config('*', {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
      on_attach = on_attach,
    })
  end,
}
