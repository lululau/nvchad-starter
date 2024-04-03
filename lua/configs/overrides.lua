local M = {}

M.treesitter = {
  ensure_installed = {
    "vimdoc",
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "markdown",
    "markdown_inline",
    "ruby",
    "python",
    "java",
    "go",
    "rust",
    "bash",
    "json",
    "yaml",
    "vue"
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.mason = {
  ensure_installed = {
    "ansible-language-server",
    "ast-grep",
    "bash-language-server",
    "clang-format",
    "clangd",
    "css-lsp",
    "deno",
    "docker-compose-language-service",
    "dockerfile-language-server",
    "gopls",
    "gradle-language-server",
    "html-lsp",
    "java-language-server",
    "jinja-lsp",
    "json-lsp",
    "kotlin-language-server",
    "lua-language-server",
    "marksman",
    "nginx-language-server",
    "prettier",
    "pyright",
    "rubocop",
    "rust-analyzer",
    "solargraph",
    "sorbet",
    "sqls",
    "stylua",
    "terraform-ls",
    "typescript-language-server",
    "vetur-vls",
    "vim-language-server",
    "vue-language-server",
    "yaml-language-server",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
