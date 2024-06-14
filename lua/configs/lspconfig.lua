local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = {
  "ansiblels", "ast_grep", "docker_compose_language_service", "dockerls", "ruby_lsp",
  "gradle_ls", "jinja_lsp", "jsonls", "kotlin_language_server", "nginx_language_server",
  "sqls", "terraform_lsp", "vuels", "vimls", "volar",
  "html", "cssls", "tsserver", "clangd", "lua_ls", "vimls", 
  "denols", "pyright", "solargraph", "rubocop",
  "gopls", "rust_analyzer", "bashls", "marksman"
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.java_language_server.setup {
  cmd = { "java-language-server" },
  on_attach = on_attach,
  capabilities = capabilities,
}

-- 
-- lspconfig.pyright.setup { blabla}
