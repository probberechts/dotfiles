for ft, parser in pairs({
  dotenv = "bash",
  javascriptreact = "jsx",
  typescriptreact = "tsx",
}) do
  vim.treesitter.language.register(parser, ft)
end
