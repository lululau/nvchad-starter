-- Recognize PEP 723 inline-script shebangs (uv run --script, uvx) as Python.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("ShebangFiletype", { clear = true }),
  callback = function(args)
    local first_line = vim.api.nvim_buf_get_lines(args.buf, 0, 1, false)[1] or ""
    if first_line:match("^#!/usr/bin/env") and first_line:match("uv[x]?") then
      vim.bo[args.buf].filetype = "python"
    end
  end,
})

-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

vim.diagnostic.config({ virtual_text = false, signs = false, underline = false, update_in_insert = false })
vim.diagnostic.hide()

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.title = true
vim.o.titlestring = "%{fnamemodify(getcwd(), ':p:h:t') .. '        ' .. expand('%:p:~')}"

vim.g.neovide_show_border = true

vim.api.nvim_set_keymap('i', '<S- >', '<ESC><leader>', {noremap = false, silent = true})
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

------------------------------------------------------------------------------
-- Markdown 代码块 / 内联代码背景色
--
-- markview.nvim 默认会把代码块/内联代码背景往“亮处”混合(Oklab L *= 1.15/1.2)，
-- 在 palenight 这类深色主题上会泛出灰白雾霾感。这里改用比默认背景色更深的通透色
-- (#1e2030)，让代码区像一块沉下去的深色面板，视觉上更清爽。
--
-- 关键点：markview.highlights.set_hl() 在目标高亮组已有值时会跳过覆盖，因此只要在
-- markview 生成完高亮后再写入一次即可“锁定”住，且不会被它的 ColorScheme 回调改回去。
-- 这里用 vim.schedule 把覆盖推迟到 markview 同步处理之后执行，从而保留它为内联代码
-- 设置的 fg(取自 @markup.raw)，只替换背景。
------------------------------------------------------------------------------
local MD_CODE_BG = "#1e2030"

local function apply_md_code_bg()
  if vim.o.background ~= "dark" then
    return
  end

  -- 代码块：markview 默认就只设 bg，这里同样只改 bg
  vim.api.nvim_set_hl(0, "MarkviewCode", { bg = MD_CODE_BG })

  -- 内联代码：保留 markview 计算出的 fg，仅替换 bg
  local ic = vim.api.nvim_get_hl(0, { name = "MarkviewInlineCode", link = false, create = false }) or {}
  local raw = vim.api.nvim_get_hl(0, { name = "@markup.raw", link = false, create = false }) or {}
  local fg = ic.fg or raw.fg
  local spec = { bg = MD_CODE_BG }
  if fg then
    spec.fg = fg
  end
  vim.api.nvim_set_hl(0, "MarkviewInlineCode", spec)

  -- nvim-hl-mdcodeblock.lua：编辑态/未渲染时的兜底背景，保持一致
  vim.api.nvim_set_hl(0, "MDCodeBlock", { bg = MD_CODE_BG })
end

vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
  group = vim.api.nvim_create_augroup("MdCodeBg", { clear = true }),
  callback = function()
    -- 等 markview 先生成高亮，再覆盖背景
    vim.schedule(apply_md_code_bg)
  end,
})

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

-- Read OPENAI_API_KEY from ~/.authinfo
local function set_api_keys()
  local home = os.getenv("HOME")
  local authinfo_path = home .. "/.authinfo"
  local file = io.open(authinfo_path, "r")
  
  if file then
    for line in file:lines() do
      -- Look for dashscope.aliyuncs.com entry
      if line:match("dashscope%.aliyuncs%.com") then
        -- Extract password field which contains the API key
        local api_key = line:match("password ([^ ]+)")
        if api_key then
          vim.env.OPENAI_API_KEY = api_key
        end
      end

      if line:match("moonshot%.cn") then
        -- Extract password field which contains the API key
        local api_key = line:match("password ([^ ]+)")
        if api_key then
          vim.env.MOONSHOT_API_KEY = api_key
        end
      end

      if line:match("bigmodel%.cn") then
        -- Extract password field which contains the API key
        local api_key = line:match("password ([^ ]+)")
        if api_key then
          vim.env.GLM_API_KEY = api_key
        end
      end

    end
    file:close()
  end
end

set_api_keys()
