local overrides = require("configs.overrides")

local function nvim_tree_attach(bufnr)
  local api = require "nvim-tree.api"
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end
  api.config.mappings.default_on_attach(bufnr)
  vim.keymap.set('n', '-', api.tree.change_root_to_parent,        opts('Up'))
  vim.keymap.set('n', 'u', api.tree.change_root_to_parent,        opts('Up'))
  vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
end

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "configs.null-ls"
        end,
      },
    },
    config = function()
      require "nvchad.configs.lspconfig"
      require "configs.lspconfig"
      require"lspconfig".lua_ls.setup {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      }
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
    config = function()
      require("nvim-tree").setup {
        on_attach = nvim_tree_attach,
    }
    end,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }

  {
    "github/copilot.vim",
    cmd = "Copilot",
    event = "InsertEnter"
  },

  {
    'ahmedkhalf/project.nvim',
    lazy = false,
    config = function()
      require("project_nvim").setup {
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "Cargo.toml", ".projectile", "Gemfile", "pyproject.toml", "poetry.lock" },
        ignore_lsp = { "efm", "null-ls" },
        silent_chdir = false,
      }
    end
  },

  {
    'glacambre/firenvim',
    lazy = false,
    build = function()
      vim.fn["firenvim#install"](0)
    end
  },

  {
    'X3eRo0/dired.nvim',
    cmd = "Dired",
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require("dired").setup {
        path_separator = "/",
        show_banner = true,
        show_hidden = true,
        show_dot_dirs = true,
        show_colors = true,
      }
    end
  },

  {
    "NvChad/nvterm",
    config = function ()
      require("nvterm").setup({
          terminals = {
            shell = "/bin/bash",
            type_opts = {
              float = {
                relative = 'editor',
                row = 0.3,
                col = 0.25,
                width = 0.5,
                height = 0.4,
                border = "single",
              },
              horizontal = { location = "rightbelow", split_ratio = .3, },
              vertical = { location = "rightbelow", split_ratio = .5 },
            }
          },
          behavior = {
            autoclose_on_quit = {
              enabled = false,
              confirm = true,
            },
            close_on_exit = true,
            auto_insert = true,
          },
      })
    end,
  },

  {
    "lululau/vim-textobj-variable-segment",
    lazy = false,
    dependencies = {
      "kana/vim-textobj-user",
    },
  },

  {
    "sgur/vim-textobj-parameter",
    lazy = false,
    dependencies = {
      "kana/vim-textobj-user",
    },
  },

  {
    "kana/vim-textobj-line",
    lazy = false,
    dependencies = {
      "kana/vim-textobj-user",
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require'nvim-treesitter.configs'.setup {
        textobjects = {
          select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["ac"] = "@class.outer",
              -- You can optionally set descriptions to the mappings (used in the desc parameter of
              -- nvim_buf_set_keymap) which plugins like which-key display
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              -- You can also use captures from other query groups like `locals.scm`
              ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
            },
            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V', -- linewise
              ['@class.outer'] = '<c-v>', -- blockwise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true of false
            include_surrounding_whitespace = true,
          },
        },
      }
    end
  },

  {
    "arsham/indent-tools.nvim",
    dependencies = {
      "arsham/arshlib.nvim",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = true,
    lazy = false,
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end
  },

  {
    "phaazon/hop.nvim",
    config = function()
      require'hop'.setup { keys = 'asdjklwop' }
    end,
    cmd = {"HopLine", "HopChar2"}
  },

  {
    "fcying/telescope-ctags-outline.nvim",
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function()
      return require("nvchad.configs.cmp")
    end,
  },

  {
    'mg979/vim-visual-multi',
    keys = { "<A-J>", "<A-n>", "<A-m>" },
  },

  {
    'godlygeek/tabular',
    cmd = "Tabularize",
  },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim",        -- optional
    },
    cmd = "Neogit",
    opts = {
      signs = {
        hunk = { "", "" },
        item = { "", "" },
        section = { "", "" },
      },
      integrations = {
        telescope = true,
        diffview = true,
      },
      mappings = {
        popup = {
          ["F"] = "PullPopup",
        },
      },
    },
    config = function(_, opts)
      require("neogit").setup(opts)
      local Color = require("neogit.lib.color").Color
      vim.api.nvim_set_hl(0, "NeogitDiffDelete", {
                            fg = Color.from_hex("#E06C75"):shade(-0.18):to_css(),
                            bg = Color.from_hex("#E06C75"):shade(-0.6):set_saturation(0.4):to_css()
      })

      vim.api.nvim_set_hl(0, "NeogitDiffDeleteHighlight", {
                            fg = Color.from_hex("#E06C75"):to_css(),
                            bg = Color.from_hex("#E06C75"):shade(-0.6):set_saturation(0.4):to_css()
      })

      vim.api.nvim_set_hl(0, "NeogitDiffAdd", {
                            fg = Color.from_hex("#C3E88D"):shade(-0.18):to_css(),
                            bg = Color.from_hex("#C3E88D"):shade(-0.72):set_saturation(0.2):to_css()
      })

      vim.api.nvim_set_hl(0, "NeogitDiffAddHighlight", {
                            fg = Color.from_hex("#C3E88D"):to_css(),
                            bg = Color.from_hex("#C3E88D"):shade(-0.72):set_saturation(0.2):to_css()
      })
    end,
  },

  {
    "f-person/git-blame.nvim",
    cmd = "GitBlameToggle",
    keys = {
      {"<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Toggle Git Blame"},
    }
  },

  {
    "gennaro-tedesco/nvim-jqx",
    ft = { "json", "yaml" },
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        mappings = {
          n = {
            ["<C-f>"] = 'results_scrolling_down',
            ["<C-b>"] = 'results_scrolling_up',
            ["<D-w>"] = 'close',
            ["<C-x>@sw"] = 'close',
          },

          i = {
            ["<C-f>"] = 'results_scrolling_down',
            ["<C-b>"] = 'results_scrolling_up',
            ["<D-w>"] = 'close',
            ["<C-x>@sw"] = 'close',
          },
        },
      },
    }
  },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      require("chatgpt").setup(opts)
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    },
    opts = {
      api_key_cmd = "/bin/cat /Users/liuxiang/.config/secrets/.openai_api_key",
      edit_with_instructions = {
        keymaps = {
          close = { "<C-c>", "<D-w>", "<C-x>@sw" },
        }
      },
      chat = {
        keymaps = {
          close = { "<C-c>", "<D-w>", "<C-x>@sw" },
        }
      },
      popup_input = {
        submit = { "<C-Enter>", "<c-x><c-o><c-e>"}
      }
    }
  }

}

return plugins
