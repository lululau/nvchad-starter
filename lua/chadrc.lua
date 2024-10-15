---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "highlights"

M.base46 = {
  theme = "palenight",
  theme_toggle = { "palenight", "material-lighter" },

  hl_override = highlights.override,
  hl_add = highlights.add,
}

M.ui = {
  tabufline = {
    show_numbers = true,
  },
}

M.nvdash = {
  load_on_startup = true,
  buttons = {
    { txt = "󰍉  Find File", keys = "Spc f f", cmd = "Telescope find_files" },
    { txt = "󰈚  Recent Files", keys = "Spc f r", cmd = "Telescope oldfiles" },
    { txt = "󰈭  Find Word", keys = "Spc /", cmd = "Telescope live_grep" },
    { txt = "  Bookmarks", keys = "Spc f b", cmd = "Telescope marks" },
    { txt = "  Themes", keys = "Spc t h", cmd = "Telescope themes" },
    { txt = "  Mappings", keys = "Spc h c", cmd = "NvCheatsheet" },
  },
  header = {
    "                            ",
    "     ▄▄         ▄ ▄▄▄▄▄▄▄   ",
    "   ▄▀███▄     ▄██ █████▀    ",
    "   ██▄▀███▄   ███           ",
    "   ███  ▀███▄ ███           ",
    "   ███    ▀██ ███           ",
    "   ███      ▀ ███           ",
    "   ▀██ █████▄▀█▀▄██████▄    ",
    "     ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀   ",
    "                            ",
    "     Powered By Neovim    ",
    "                            ",
  },

}


-- autogroups
local chadrc_group = vim.api.nvim_create_augroup("Chadrc", { clear = true })
vim.api.nvim_create_autocmd("BufLeave", {
  group = chadrc_group,
  pattern = "*",
  callback = function()
    -- if file buffer
    if vim.bo.buftype == "" then
      vim.g.last_file_directory = vim.fn.expand "%:p:h"
    end
    if vim.bo.buftype ~= "terminal" then
      vim.g.last_project_directory = vim.fn.getcwd()
    end
  end,
})


-- M.plugins = "plugins"

-- check core.mappings for table structure
-- M.mappings = require "mappings"

return M
