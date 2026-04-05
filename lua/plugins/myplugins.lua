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
    "nvchad/base46",
    branch = "v3.0",
    build = function()
      require("base46").load_all_highlights()
    end,
  },


  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- NOTE: null-ls.nvim 已停止维护，不兼容 Neovim 0.12
      -- 格式化已由 conform.nvim 接管，如需 lint 功能可用 nvim-lint 替代
      -- {
      --   "lululau/null-ls.nvim",
      --   config = function()
      --     require "configs.null-ls"
      --   end,
      -- },
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
    branch = "main",
    build = ":TSUpdate",
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
      require("better_escape").setup({
        mappings = {
          t = {
            j = {
              k = false,
              j = false,
            }
          }
        }
      })
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
    'lululau/project.nvim',
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
        require("nvterm.terminal").self_send("cd " .. vim.g.last_project_directory)
      end, mode = "t" },
      { "<C-x><C-o><C-a>", function()
        require("nvterm.terminal").self_send("cd " .. vim.g.last_project_directory)
      end, mode = "t" },
      { "<S-CR>", function()
        require("nvterm.terminal").self_send("cd " .. vim.g.last_file_directory)
      end, mode = "t"},
      { "<C-x><C-o><C-b>", function()
        require("nvterm.terminal").self_send("cd " .. vim.g.last_file_directory)
      end, mode = "t"},
      {"<D-w>", function() 
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_close(win, true)
      end, mode = "t"},
      {"<C-x>@sw", function() 
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_close(win, true)
      end, mode = "t"},
      {"<D-v>", function()
        local clipboard = vim.fn.getreg("+")
        clipboard = clipboard:gsub("\n*$", "")
        require("nvterm.terminal").self_send(clipboard)
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
    branch = "main",
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("nvim-treesitter-textobjects").setup {
        select = {
          lookahead = true,
          selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer'] = 'V',
            ['@class.outer'] = '<c-v>',
          },
          include_surrounding_whitespace = true,
        },
      }

      local select = require("nvim-treesitter-textobjects.select")
      vim.keymap.set({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "aa", function() select.select_textobject("@parameter.outer", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "ia", function() select.select_textobject("@parameter.inner", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end)
      vim.keymap.set({ "x", "o" }, "as", function() select.select_textobject("@local.scope", "locals") end)
    end
  },

  -- NOTE: indent-tools 依赖 textobjects，暂时禁用
  -- {
  --   "arsham/indent-tools.nvim",
  --   ...
  -- },

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

      -- Add copilot integration
      cmp.event:on("menu_opened", function()
        vim.b.copilot_suggestion_hidden = true
      end)

      cmp.event:on("menu_closed", function()
        vim.b.copilot_suggestion_hidden = false
      end)

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
      "folke/trouble.nvim",
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
  },

  -- {
  --   'girishji/devdocs.vim',
  --   keys = {
  --     {"<leader>dd", "<cmd>DevdocsFind<cr>", desc = "Open DevDocs"},
  --     {"<leader>dI", "<cmd>DevdocsInstall<cr>", desc = "Install DevDocs"},
  --     {"<leader>dU", "<cmd>DevdocsUninstall<cr>", desc = "Uninstall DevDocs"},
  --   }
  -- },


  {
    "mikavilpas/yazi.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    event = "VeryLazy",
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        "<leader>-",
        function()
          require("yazi").yazi()
        end,
        desc = "open the file manager",
      },
      {
        "<leader>jd",
        function()
          require("yazi").yazi()
        end,
        desc = "Open the file manager",
      },
      {
        -- Open in the current working directory
        "<leader>jD",
        function()
          require("yazi").yazi(nil, vim.fn.getcwd())
        end,
        desc = "Open the file manager in nvim's working directory" ,
      },
    },
    ---@type YaziConfig
    opts = {
      open_for_directories = false,
    },
  },

  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Oil",
  },

  {
    "luckasRanarison/nvim-devdocs",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      {"<leader>dd", "<cmd>DevdocsOpen<cr>", desc = "Open DevDocs"},
      {"<leader>dI", "<cmd>DevdocsInstall<cr>", desc = "Install DevDocs"},
      {"<leader>dU", "<cmd>DevdocsUninstall<cr>", desc = "Uninstall DevDocs"},
      {"<leader>dF", "<cmd>DevdocsFetch<cr>", desc = "Fetch DevDocs Metadata"},
    },
    opts = {}
  },


  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- 永远不要将此值设置为 "*"！永远不要！
    opts = {
      -- 在此处添加任何选项
      -- 例如
      acp_providers = {
        ["opencode"] = {
          command = "opencode",
          args = { "acp" }
        }
      },
      provider = "glm",
      providers = {
        glm = {
          endpoint = "https://open.bigmodel.cn/api/coding/paas/v4",
          model = "GLM-4.7", -- 您想要的模型
          timeout = 30000, -- 超时时间（毫秒），增加此值以适应推理模型
        },
        moonshot = {
          endpoint = "https://api.moonshot.cn/v1",
          model = "kimi-k2-0711-preview",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 32768,
          },
        },
        qwen = {
          __inherited_from = "openai",
          endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1",
          model = "qwen-coder-plus-latest", -- 您想要的模型（或使用 gpt-4o 等）
          timeout = 30000, -- 超时时间（毫秒），增加此值以适应推理模型
          extra_request_body = {
            temperature = 0,
            max_tokens = 8192, -- 增加此值以包括推理模型的推理令牌
            --reasoning_effort = "medium", -- low|medium|high，仅用于推理模型
          }
        }
      },
      mappings = {
        ask = vim.g.neovide and "<D-S-i>" or "<leader>aa",
      },
    },
    -- 如果您想从源代码构建，请执行 `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- 对于 Windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- 以下依赖项是可选的，
      "echasnovski/mini.pick", -- 用于文件选择器提供者 mini.pick
      "nvim-telescope/telescope.nvim", -- 用于文件选择器提供者 telescope
      "hrsh7th/nvim-cmp", -- avante 命令和提及的自动完成
      "ibhagwan/fzf-lua", -- 用于文件选择器提供者 fzf
      "nvim-tree/nvim-web-devicons", -- 或 echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- 用于 providers='copilot'
      {
        -- 支持图像粘贴
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- 推荐设置
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- Windows 用户必需
            use_absolute_path = true,
          },
        },
      },
      {
        -- 如果您有 lazy=true，请确保正确设置
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },

  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `snacks` provider.
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    keys = {
      {"<C-a>", desc = "Ask opencode" },
      {"<C-x>", desc = "Execute opencode action…" },
      {"<D-i>", desc = "Toggle opencode" },
      {"go",  desc = "Add range to opencode" },
      {"goo", desc = "Add line to opencode" },
      {"<S-C-u>", desc = "opencode half page up" },
      {"<S-C-d>", desc = "opencode half page down" },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      -- Recommended/example keymaps.
      vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode" })
      vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
      vim.keymap.set({ "n", "t" }, "<D-i>", function() require("opencode").toggle() end,                          { desc = "Toggle opencode" })

      vim.keymap.set({ "n", "x" }, "go",  function() return require("opencode").operator("@this ") end,        { expr = true, desc = "Add range to opencode" })
      vim.keymap.set("n",          "goo", function() return require("opencode").operator("@this ") .. "_" end, { expr = true, desc = "Add line to opencode" })

      vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "opencode half page up" })
      vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "opencode half page down" })

      -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
      vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
      vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
    end,
  },

  -- {
  --   "coder/claudecode.nvim",
  --   dependencies = { "folke/snacks.nvim" },
  --   config = true,
  --   opts= {
  --     terminal_cmd = "claude --dangerously-skip-permissions"
  --   },
  --   keys = {
  --     { "<D-i><D-a>", nil, desc = "AI/Claude Code" },
  --     { "<D-i><D-a>c", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
  --     { "<D-i><D-a>f", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
  --     { "<D-i><D-a>r", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
  --     { "<D-i><D-a>C", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
  --     { "<D-i><D-a>m", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
  --     { "<D-i><D-a>b", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
  --     { "<D-i><D-a>s", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
  --     {"<D-i><D-a>s", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add file", ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" }, },
  --     -- Diff management
  --     { "<D-i><D-a>a", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
  --     { "<D-i><D-a>d", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  --     { "<leader>cc", nil, desc = "AI/Claude Code" },
  --     { "<leader>ccc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
  --     { "<leader>ccf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
  --     { "<leader>ccr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
  --     { "<leader>ccC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
  --     { "<leader>ccm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
  --     { "<leader>ccb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
  --     { "<leader>ccs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
  --     {"<leader>ccs", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add file", ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" }, },
  --     -- Diff management
  --     { "<leader>cca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
  --     { "<leader>ccd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  --   },
  -- },


  {

    -- 使用本地路径加载插件
    "lululau/neogit-ai-commit.nvim",
    event = "VeryLazy",
    cmd = "NeogitAICommit",
    config = function()
      require("neogit-ai-commit").setup({
        -- API key 将从环境变量 OPENAI_API_KEY 中读取
        api_url = "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions",
        model = "qwen-plus", -- 使用阿里云的 Qwen 模型
        -- model = "deepseek-r1-0528",
        max_tokens = 98304
      })
    end,
  },

  -- { import = "nvchad.blink.lazyspec" }

  {
    {
      "hrsh7th/nvim-cmp",
      enabled = false,
    },

    {
      "saghen/blink.cmp",
      version = "1.*",
      event = { "InsertEnter", "CmdLineEnter" },

      dependencies = {
        "rafamadriz/friendly-snippets",
        {
          -- snippet plugin
          "L3MON4D3/LuaSnip",
          dependencies = "rafamadriz/friendly-snippets",
          opts = { history = true, updateevents = "TextChanged,TextChangedI" },
          config = function(_, opts)
            require("luasnip").config.set_config(opts)
            require "nvchad.configs.luasnip"
          end,
        },

        {
          "windwp/nvim-autopairs",
          opts = {
            fast_wrap = {},
            disable_filetype = { "TelescopePrompt", "vim" },
          },
        },
      },

      opts_extend = { "sources.default" },

      opts = function()
        return {
          snippets = { preset = "luasnip" },
          cmdline = { enabled = true },
          appearance = { nerd_font_variant = "normal" },
          fuzzy = { implementation = "prefer_rust" },
          sources = { default = { "lsp", "snippets", "buffer", "path" } },

          keymap = {
            preset = "default",
            ["<CR>"] = { "accept", "fallback" },
            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },
            ["<C-n>"] = { "select_next", "snippet_forward", "fallback" },
            ["<C-p>"] = { "select_prev", "snippet_backward", "fallback" },
          },

          completion = {
            ghost_text = { enabled = true },
            documentation = {
              auto_show = true,
              auto_show_delay_ms = 200,
              window = { border = "single" },
            },

            -- from nvchad/ui plugin
            -- exporting the ui config of nvchad blink menu
            -- helps non nvchad users
            menu = require("nvchad.blink").menu,
          },
        }
      end,
    },
  }

  -- { 'augmentcode/augment.vim', lazy = false }
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
          -- hide_during_completion = true,
          debounce = 75,
          trigger_on_accept = true,
          keymap = {
            accept = "<Tab>", accept_word = "<M-f>", accept_line = "<M-n>", next = "<M-\\>", prev = "<M-[>", dismiss = "<C-g>",
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
