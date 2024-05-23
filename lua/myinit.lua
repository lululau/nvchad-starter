-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.title = true
vim.o.titlestring = "%{fnamemodify(getcwd(), ':p:h:t') .. '        ' .. expand('%:p:~')}"

vim.api.nvim_set_keymap('i', '<C-x>@S ', '<ESC><leader>', {noremap = false, silent = true})
vim.api.nvim_set_keymap('n', '<C-x>@S ', '<ESC><leader>', {noremap = false, silent = true})

-- gui font
vim.o.guifont = "JetBrainsMono\\ Nerd\\ Font:h13"

if vim.g.neovide then
    -- vim.g.neovide_transparency = 0.8
    -- vim.g.transparency = 0.8
    -- vim.g.neovide_background_color = string.format("#272c36%x", math.floor(255 * vim.g.transparency))
    vim.g.neovide_input_macos_option_key_is_meta = "both"
end

if vim.g.started_by_firenvim then
  vim.api.nvim_set_keymap('i', '«', '<Plug>(copilot-suggest)', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('i', '‘', '<Plug>(copilot-next)', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('i', '“', '<Plug>(copilot-previous)', {noremap = true, silent = true})

  vim.g.firenvim_config = {
    globalSettings = { alt = "all" },
    localSettings = {
      [".*"] = {
        cmdline  = "neovim",
        content  = "text",
        priority = 0,
        selector = "nothing",
        takeover = "always"
      },

      ["https://jenkins."] = {
        cmdline  = "neovim",
        content  = "text",
        priority = 99,
        selector = "textarea",
        takeover = "always"
      }
    }

  }
end

require "misc"
require "space"
