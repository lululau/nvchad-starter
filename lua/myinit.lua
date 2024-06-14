-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

vim.diagnostic.config({ virtual_text = false, signs = false, underline = false, update_in_insert = false })
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

  local handle = io.popen("system_profiler SPDisplaysDataType | grep -E '5120|Retina'")
  local result = handle:read("*a")
  handle:close()
  if result ~= "" then
    vim.cmd "set guifont=JetBrainsMono\\ Nerd\\ Font:h18"
  else
    vim.cmd "set guifont=JetBrainsMono\\ Nerd\\ Font:h11"
  end
end

function _G.map_q_for_neogit()
  -- Get the current buffer name
  local bufname = vim.fn.expand('%:t')
  
  -- Check if the buffer name ends with 'NeogitStatus'
  if bufname:match('NeogitStatus$') then
    -- Set the key mapping for the current buffer
    vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':qa!<CR>', { noremap = true, silent = true })
  end
end

require "misc"
require "space"
