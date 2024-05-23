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
    keys = {
      { "<leader>ni", "<cmd>NvimTreeFindFile<cr>", desc = "Find file in NvimTree" },
      { ",ni", "<cmd>NvimTreeFindFile<cr>", desc = "Find file in NvimTree" },
    }
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
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
      local M = require("project_nvim.utils.history")
      return require("configs.project_overrides").override(M)
    end
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
    "hrsh7th/nvim-cmp",
    opts = function()
      local cmp = require "cmp"
      local options = require("nvchad.configs.cmp")
      options.sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "path" },
        { name = "crates" },
      }
      options.mapping["<S-Tab>"] = nil

      options.mapping["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }
        elseif require("luasnip").expand_or_jumpable() then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
        else
          fallback()
        end
      end, { "i", "s" })

      return options
    end,
    keys = {
      {"<M-/>", function() require("cmp").complete() end, mode = "i" },
      {"<M-/>", function() require("cmp").complete() end, mode = "n" }
    },
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
    "niuiic/git-log.nvim",
    keys = {
      {"<leader>gl", function() require("git-log").check_log() end, desc = "Show Git Log", mode = {"n"}},
      {"gl", function() require("git-log").check_log() end, desc = "Show Git Log", mode = {"x"}},
    },
    dependencies = {
      "niuiic/core.nvim",
    },
  },


  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        prompt_prefix = " 󰍉  ",
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
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      return{
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "󰍵" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "│" },
        },

        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function opts(desc)
            return { buffer = bufnr, desc = desc }
          end

          local map = vim.keymap.set

          map("n", "<leader>rh", gs.reset_hunk, opts "Reset Hunk")
          map("n", "<leader>ph", gs.preview_hunk, opts "Preview Hunk")
          map("n", "<leader>gb", gs.blame_line, opts "Blame Line")

          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
          map({'o', 'x'}, 'ah', ':<C-U>Gitsigns select_hunk<CR>')

        end,
      } 
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "git")
      require("gitsigns").setup(opts)
    end,
  },

  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "<D-/>", function()
        local api = require("Comment.api")
        api.toggle.linewise.current()
        vim.api.nvim_feedkeys("j", "n", false)
      end, mode = {"n", "i"}, desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
      { "<D-/>", function() 
        local api = require("Comment.api")
        local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
        vim.api.nvim_feedkeys(esc, "nx", false)
        api.toggle.linewise(vim.fn.visualmode())
      end, mode = "x", desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n", desc = "Comment toggle current block" },
      { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    },
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },
}

return plugins
