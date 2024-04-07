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

  -- {
  --   "github/copilot.vim",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   config = function()
  --     vim.cmd [[
  --        imap <script><silent><nowait><expr> <S-Tab> copilot#Accept()
  --     ]]
  --   end,
  -- },


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

  -- {
  --   'lululau/telescope-files.nvim',
  --   event = "FileType dired",
  --   config = function()
  --     local group = vim.api.nvim_create_augroup("dired-telescope-files", {})
  --     vim.api.nvim_create_autocmd("FileType", {
  --       pattern = "dired",
  --       group = group,
  --       callback = function()
  --         vim.keymap.set('n', 'f', '<cmd>Telescope files<cr>', { buffer = true, noremap = true, silent = true })
  --       end
  --     })
  --   end
  -- },

  {
    "lululau/nvterm",
    config = function ()
      local shell = "/bin/zsh"
      if vim.fn.has("mac") == 1 and vim.fn.expand("$USER") == "liuxiang" then
        vim.env.ZDOTDIR = vim.fn.expand("$HOME") .. "/.config/light-zsh.d"
      end
      require("nvterm").setup({
          terminals = {
            shell = shell,
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

    keys = {
      { "<D-CR>", function()
        require("nvterm.terminal").self_send("cd " .. vim.g.last_project_directory .. "\n")
      end, mode = "t" },
      { "<C-x><C-o><C-a>", function()
        require("nvterm.terminal").self_send("cd " .. vim.g.last_project_directory .. "\n")
      end, mode = "t" },
      { "<S-CR>", function()
        require("nvterm.terminal").self_send("cd " .. vim.g.last_file_directory .. "\n")
      end, mode = "t"},
      { "<C-x><C-o><C-b>", function()
        require("nvterm.terminal").self_send("cd " .. vim.g.last_file_directory .. "\n")
      end, mode = "t"},
      {"<D-w>", function() 
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_close(win, true)
      end, mode = "t"},
      {"<C-x>@sw", function() 
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_close(win, true)
      end, mode = "t"},
    }
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
    "niuiic/git-log.nvim",
    keys = {
      {"<leader>gl", function() require("git-log").check_log() end, desc = "Show Git Log", mode = {"n"}},
      {"gl", function() require("git-log").check_log() end, desc = "Show Git Log", mode = {"x"}},
    },
    dependencies = {
      "niuiic/core.nvim",
    },
  },


  -- {
  --   "aaronhallaert/advanced-git-search.nvim",
  --   keys = {
  --     { "<leader>g/", "<cmd>AdvancedGitSearch<cr>", desc = "Advanced Git Search" }
  --   },
  --   config = function()
  --     -- optional: setup telescope before loading the extension
  --     require("telescope").setup{
  --       -- move this to the place where you call the telescope setup function
  --       extensions = {
  --         advanced_git_search = {
  --           -- fugitive or diffview
  --           diff_plugin = "diffview",
  --           -- customize git in previewer
  --           -- e.g. flags such as { "--no-pager" }, or { "-c", "delta.side-by-side=false" }
  --           git_flags = {},
  --           -- customize git diff in previewer
  --           -- e.g. flags such as { "--raw" }
  --           git_diff_flags = {},
  --           -- Show builtin git pickers when executing "show_custom_functions" or :AdvancedGitSearch
  --           show_builtin_git_pickers = false,
  --           entry_default_author_or_date = "author", -- one of "author" or "date"
  --           keymaps = {
  --             -- following keymaps can be overridden
  --             toggle_date_author = "<C-w>",
  --             open_commit_in_browser = "<C-o>",
  --             copy_commit_hash = "<C-y>",
  --           }
  --         }
  --       }
  --     }
  --
  --     require("telescope").load_extension("advanced_git_search")
  --   end,
  --   dependencies = {
  --     --- See dependencies
  --     "nvim-telescope/telescope.nvim",
  --     -- to show diff splits and open commits in browser
  --     "tpope/vim-fugitive",
  --     -- to open commits in browser with fugitive
  --     "tpope/vim-rhubarb",
  --     -- optional: to replace the diff from fugitive with diffview.nvim
  --     -- (fugitive is still needed to open in browser)
  --     "sindrets/diffview.nvim",
  --   }, 
  -- },



  {
    'saecki/crates.nvim',
    event = { "BufRead Cargo.toml" },
    config = function()
      require('crates').setup()
    end,
  },

  {
    'Vigemus/iron.nvim',
    config = function ()
      local iron = require("iron.core")

      iron.setup {
        config = {
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Your repl definitions come here
          repl_definition = {
            sh = { command = {"zsh"} },
            python = { command = {"ipython"} },
            ruby = { command = {"pry"} },
            javascript = { command = {"node"} },
            lua = { command = {"lua"} },
            java = { command = {"jshell"} },
          },
          -- How the repl window will be displayed
          -- See below for more information
          repl_open_cmd = require('iron.view').right("40%"),
        },
        -- Iron doesn't set keymaps by default anymore.
        -- You can set them here or manually add keymaps to the functions in iron.core
        keymaps = {
          send_motion = ",ss",
          visual_send = ",sc",
          send_file = ",sb",
          send_line = ",sl",
          send_until_cursor = ",su",
          send_mark = ",sm",
          mark_motion = ",mc",
          mark_visual = ",mc",
          remove_mark = ",md",
          cr = ",s<cr>",
          interrupt = ",s,",
          exit = ",sq",
          clear = ",cl",
        },
        -- If the highlight is on, you can change how it looks
        -- For the available options, check nvim_set_hl
        highlight = {
          italic = true
        },
        ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
      }

      -- iron also has a list of commands, see :h iron-commands for all available commands
      vim.keymap.set('n', ',rs', '<cmd>IronRepl<cr>')
      vim.keymap.set('n', ',rr', '<cmd>IronRestart<cr>')
      vim.keymap.set('n', ',rf', '<cmd>IronFocus<cr>')
      vim.keymap.set('n', ",'", '<cmd>IronFocus<cr>')
      vim.keymap.set('n', ',rh', '<cmd>IronHide<cr>')
    end,
    keys = {
      {",ss", mode = "n", desc = "Send Motion"},
      {",sc", mode = "v", desc = "Send Visual"},
      {",sb", mode = "n", desc = "Send File"},
      {",sl", mode = "n", desc = "Send Line"},
      {",su", mode = "n", desc = "Send Until Cursor"},
      {",sm", mode = "n", desc = "Send Mark"},
      {",mc", mode = "n", desc = "Mark Motion"},
      {",mc", mode = "v", desc = "Mark Visual"},
      {",md", mode = "n", desc = "Remove Mark"},
      {",s<cr>", mode = "n", desc = "Send Current Line"},
      {",s,", mode = "n", desc = "Interrupt"},
      {",sq", mode = "n", desc = "Exit"},
      {",cl", mode = "n", desc = "Clear"},
      {",rs", mode = "n", desc = "Open REPL"},
      {",rr", mode = "n", desc = "Restart REPL"},
      {",rf", mode = "n", desc = "Focus REPL"},
      {",'", mode = "n", desc = "Focus REPL"},
      {",rh", mode = "n", desc = "Hide REPL"},
      {"<D-w>", function() 
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_close(win, true)
      end, mode = "t"},
      {"<C-x>@sw", function() 
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_close(win, true)
      end, mode = "t"},
    }

  },


  {
    "gennaro-tedesco/nvim-jqx",
    ft = { "json", "yaml" },
    keys = {
      {"<leader>ajl", "<cmd>JqxList<cr>", desc = "List JSON elements"},
      {"<leader>ajq", "<cmd>JqxQuery<cr>", desc = "Query JSON elements"},
    }
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
  },

  {
    "lululau/telescope-autojump.nvim",
    keys = {
      {"<leader>oj", "<cmd>Telescope autojump<cr>", desc = "Find autojump directories"},
    },
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

  {
    "cuducos/yaml.nvim",
    ft = { "yaml" }, -- optional
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- optional
    },
    keys = {
      {"<leader>ay", "<cmd>YAMLTelescope<cr>", desc = "List YAML elements"},
    }
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    keys = {
      {",cp", "<cmd>MarkdownPreview<cr>", desc = "Markdown Preview"},
    }
  },

  {
    'yaocccc/nvim-hl-mdcodeblock.lua',
    after = 'nvim-treesitter',
    config = function ()
      require('hl-mdcodeblock').setup({})
    end
  },

  {
    "LintaoAmons/bookmarks.nvim",
    dependencies = {
      {"stevearc/dressing.nvim"} -- optional: to have the same UI shown in the GIF
    },
    keys = {
      {"<leader>mm", "<cmd>BookmarksMark<cr>", desc = "Make bookmark"},
      {"<leader>ml", "<cmd>BookmarksGoto<cr>", desc = "List bookmarks"},
      {"<leader>fb", "<cmd>BookmarksGoto<cr>", desc = "List bookmarks"},
      {"<D-i><D-b>", "<cmd>BookmarksGoto<cr>", desc = "List bookmarks"},
    },
    config = function ()
      require("bookmarks").setup( {
        json_db_path = vim.fs.normalize(vim.fn.stdpath("data") .. "/bookmarks.db.json"),
      })
    end
  },

  { 
    "folke/neodev.nvim",
    event = "BufEnter *.lua"
  },


  {
    'gelguy/wilder.nvim',
    event = "CmdlineEnter",
    config = function()
      local wilder = require('wilder')
      wilder.setup {
        modes = {':', '/', '?'},
        next_key = '<Tab>',
        previous_key = '<S-Tab>',
        accept_key = '<Down>',
        reject_key = '<Up>',
      }

      wilder.set_option('renderer', wilder.popupmenu_renderer(
        wilder.popupmenu_border_theme({
          highlights = {
            border = 'Normal', -- highlight to use for the border
          },
          -- 'single', 'double', 'rounded' or 'solid'
          -- can also be a list of 8 characters, see :h wilder#popupmenu_border_theme() for more details
          border = 'rounded',
        })
      ))

    end,
  }

}

if vim.fn.has("mac") == 1 then
  table.insert(plugins, {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = { jump_prev = "k", jump_next = "j", accept = "<CR>", refresh = "gr", open = "<M-S-CR>" },
          layout = {
            position = "right", -- | top | left | right
            ratio = 0.3
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<S-Tab>", accept_word = "<M-f>", accept_line = "<M-n>", next = "<M-\\>", prev = "<M-[>", dismiss = "<C-g>",
          },
        },
      })
    end,
  })
else
  table.insert(plugins, {
    'Exafunction/codeium.vim',
    config = function ()
      vim.g.codeium_enabled = true
      vim.g.codeium_filetypes_disabled_by_default = false
      vim.cmd('highlight CodeiumSuggestion guifg=#24ead9 ctermfg=6')
      vim.keymap.set('i', '<S-Tab>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
      vim.keymap.set('i', '<M-]>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
      vim.keymap.set('i', '<M-[>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-g>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
    end,
    keys = {
      {"<M-\\>", function ()
        vim.cmd.CodeiumEnable()
        vim.fn['codeium#Complete']()
      end, silent = true, desc = "Trigger Codium Complete", mode = "i"},
    }
  })
end


return plugins
