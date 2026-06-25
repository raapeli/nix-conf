local servers = {
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
      },
    },
  },
  nixd = {},
  clangd = {},
  pyright = {},
  cmake = {},
  ts_ls = {},
  ruff = {},
}

for name, config in pairs(servers) do
  if vim.lsp.config[name] then
    vim.lsp.config[name] = vim.tbl_deep_extend("keep", config, vim.lsp.config[name])
  end
  vim.lsp.enable(name)
end
