return {
  "noice.nvim",
  opts = {
    lsp = {
      override = {
        "vim.lsp.util.convert_input_to_markdown",
        "vim.lsp.util.stylize_markdown",
      },
    },
    presets = {
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
  },
}
