---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "highlights"

M.ui = {
  theme = "palenight",
  theme_toggle = { "palenight", "material-lighter" },

  hl_override = highlights.override,
  hl_add = highlights.add,

  tabufline = {
    show_numbers = true,
  },

  nvdash = {
    load_on_startup = true,
    buttons = {
      { "󰍉  Find File", "Spc f f", "Telescope find_files" },
      { "󰈚  Recent Files", "Spc f r", "Telescope oldfiles" },
      { "󰈭  Find Word", "Spc /", "Telescope live_grep" },
      { "  Bookmarks", "Spc f b", "Telescope marks" },
      { "  Themes", "Spc t h", "Telescope themes" },
      { "  Mappings", "Spc h c", "NvCheatsheet" },
    },
  }
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
