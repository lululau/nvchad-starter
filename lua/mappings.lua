require "nvchad.mappings"

local map = vim.keymap.set

map("v", "<D-q>", "<ESC>", { desc = "Enter normal mode" })
map("v", ">", ">gv", { desc = "indent" })
map("v", "<", "<gv", { desc = "indent" })
map("v", "<C-z>", "<esc>", { desc = "Escape to normal mode" })
map("n", "<D-q>", "i", { desc = "Enter insert mode" })
map("n", "<Esc>", ":noh <CR>", { desc = "Clear highlights" })
map("n", "<A-h>", "<C-w>h", { desc = "Window left" })
map("n", "<A-l>", "<C-w>l", { desc = "Window right" })
map("n", "<A-j>", "<C-w>j", { desc = "Window down" })
map("n", "<A-k>", "<C-w>k", { desc = "Window up" })
map("n", "<leader>tn", "<cmd> set nu! <CR>", { desc = "Toggle line number" })
map("n", "<leader>bn", "<cmd> enew <CR>", { desc = "New buffer" })
map("n", "<leader>bs", "<cmd> enew <CR>", { desc = "New buffer" })
map("n", "<leader>bm", ":messages <CR>", { desc = "Show messages" })
map("n", "<leader>hc", "<cmd> NvCheatsheet <CR>", { desc = "Mapping cheatsheet" })
map("n", "<leader>qq", "<ESC>:qa!<CR>", { desc = "Force quit all" })
map("n", "<leader>bd", "<ESC>:bd!<CR>", { desc = "Close current buffer" })
map({"n", "i"}, "<D-S-w>", "<ESC>:bd!<CR>", { desc = "Close current buffer" })
map("n", "<leader>bh", "<cmd> Nvdash<CR>", { desc = "Open Dashboard" })
map("n", "<leader>en", "<cmd> lua vim.diagnostic.goto_next()<CR>", { desc = "Next Error" })
map("n", "<leader>ep", "<cmd> lua vim.diagnostic.goto_prev()<CR>", { desc = "previous Error" })
map("n", "]e", "<cmd> lua vim.diagnostic.goto_next()<CR>", { desc = "Next Error" })
map("n", "[e", "<cmd> lua vim.diagnostic.goto_prev()<CR>", { desc = "previous Error" })
map("n", "<leader>el", "<cmd> Telescope diagnostics<CR>", { desc = "All Errors" })
map("n", "<leader>fW", "<cmd> w !sudo tee % > /dev/null<CR>", { desc = "Write as root" })
map("n", "<leader>ac", "<cmd> ChatGPT<CR>", { desc = "Open ChatGPT", silent = true})
map("n", "<leader>'", function() require("nvterm.terminal").toggle "horizontal" end, { desc = "Open terminal" })
map("n", "<D-'>", function() require("nvterm.terminal").toggle "horizontal" end, { desc = "Open terminal" })
map("n", "<A-'>", function() require("nvterm.terminal").toggle "horizontal" end, { desc = "Open terminal" })
map("n", "<leader>rr", function() vim.lsp.buf.rename() end, { desc = "LSP refactor -> rename", nowait = true, silent = true})
map("n", "<leader>=", function() vim.lsp.buf.format { async = true } end, { desc = "LSP formatting"})
map("n", "<D-j>", "10j", { desc = "Move down 10 lines" })
map("n", "<C-x><C-s>", "<ESC>:w<CR>", { desc = "Save" })
map("n", "<c-x><c-z>", "<C-z>", { desc = "Let vim go background" })
map("n", "<C-z>", "i", { desc = "Enter insert mode" })
map("n", "<C-a>", "^", { desc = "Move to first character" })
map("n", "<D-t>", ":belowright vsplit | wincmd w<CR>", { desc = "Split window vertically", silent = true})
map("n", "<D-w>", ":call Close_win_or_buf()<CR>", { desc = "Close window", silent = true})
map("n", "<C-x>@sw", ":call Close_win_or_buf()<CR>", { desc = "Close window", silent = true})
map("n", "<C-CR>", function() vim.lsp.buf.definition() end, { desc = "LSP definition"})
map("n", "<D-CR>", function() vim.lsp.buf.declaration() end, { desc = "LSP declaration"})
map({"n", "i"}, "<S-CR>", function() require('telescope.builtin').lsp_references() end, { desc = "LSP references"})
map("n", "<c-x><c-o><c-e>", function() vim.lsp.buf.definition() end, { desc = "LSP definition"})
map("n", "<c-x><c-o><c-a>", function() vim.lsp.buf.declaration() end, { desc = "LSP declaration"})
map({"n", "i"}, "<c-x><c-o><c-b>", function() require('telescope.builtin').lsp_references() end, { desc = "LSP references"})
map("n", "<C-x>@sg", function() require("neogit").open({kind = "auto"}) end, { desc = "Open Neogit", silent = true})
map("n", "<leader>?", function() require('telescope.builtin').keymaps() end, { desc = "Show Keymaps"})
map("i", "<D-q>", "<ESC>l", { desc = "Enter normal mode" })
map("i", "<C-k>", "<End>", { desc = "Move to end of line" })
map("i", "<D-j>", "<C-o>10j", { desc = "Move down 10 lines" })
map("i", "<D-k>", "<C-o>10k", { desc = "Move up 10 lines" })
map("i", "<C-x><C-s>", "<C-o>:w<CR>", { desc = "Save" })
map("i", "<C-n>", "<C-j>", { desc = "Move to next line" })
map("i", "<C-p>", "<C-k>", { desc = "Move to previous line" })
map("i", "<C-z>", "<esc>l", { desc = "Escape to normal mode" })
map("i", "<C-a>", "<C-o>^", { desc = "Move to first character" })
map("i", "<C-e>", "<C-o>A", { desc = "Move to end of line" })
map("i", "<C-f>", "<Right>", { desc = "Move to right" })
map("i", "<C-b>", "<Left>", { desc = "Move to left" })
map("i", "<C-d>", "<Del>", { desc = "Delete character" })
map("i", "<A-f>", "<C-o>e", { desc = "Move to next word" })
map("i", "<A-b>", "<C-o>b", { desc = "Move to previous word" })
map("i", "<A-<>", "<C-o>gg<C-o>0", { desc = "Move to first line" })
map("i", "<A->>", "<C-o>G<C-o>$", { desc = "Move to last line" })
map("i", "<A-bs>", "<ESC><ESC>caw", { desc = "Delete word" })
map("i", "<A-tab>", "<C-o>:b#<CR>", { desc = "Switch to previous buffer" })
map("v", "<A-tab>", "<esc>:b#<CR>", { desc = "Switch to previous buffer" })
map("n", "<A-tab>", ":b#<CR>", { desc = "Switch to previous buffer" })
map("i", "<D-t>", "<C-o>:belowright vsplit | wincmd w<CR>", { desc = "Split window vertically" })
map("i", "<D-w>", "<C-o>:call Close_win_or_buf()<CR>", { desc = "Close window", silent = true})
map("i", "<C-x>@sw", "<C-o>:call Close_win_or_buf()<CR>", { desc = "Close window", silent = true})
map("i", "<C-CR>", function() vim.lsp.buf.definition() end, { desc = "LSP definition" })
map("i", "<D-CR>", function() vim.lsp.buf.declaration() end, { desc = "LSP declaration" })
map("i", "<c-x><c-o><c-e>", function() vim.lsp.buf.definition() end, { desc = "LSP definition" })
map("i", "<c-x><c-o><c-a>", function() vim.lsp.buf.declaration() end, { desc = "LSP declaration" })
map("c", "<D-q>", "<ESC>", { desc = "Enter normal mode" })
map("c", "<C-n>", "<C-j>", { desc = "Move to next line" })
map("c", "<C-p>", "<C-k>", { desc = "Move to previous line" })
map("c", "<A-f>", "<S-Right>", { desc = "Move to right" })
map("c", "<A-b>", "<S-Left>", { desc = "Move to left" })
map("c", "<A-bs>", "cw", { desc = "Delete word" })
map("c", "<C-b>", "<Left>", { desc = "Move to left" })
map("c", "<C-f>", "<Right>", { desc = "Move to right" })
map("c", "<C-a>", "<C-b>", { desc = "Move to left" })
map("c", "<C-p>", "<Up>", { desc = "Move to previous line" })
map("c", "<C-n>", "<Down>", { desc = "Move to next line" })
map("s", "<C-x><C-s>", "<C-o>:w<CR>", { desc = "Save" })
map("t", "<D-'>", function() require("nvterm.terminal").toggle "horizontal" end, { desc = "Toggle terminal" })
map("t", "<A-'>", function() require("nvterm.terminal").toggle "horizontal" end, { desc = "Toggle terminal" })
map("t", "<A-h>", "<C-\\><C-n><C-w>h", { desc = "Move to left window" })
map("t", "<A-j>", "<C-\\><C-n><C-w>j", { desc = "Move to down window" })
map("t", "<A-k>", "<C-\\><C-n><C-w>k", { desc = "Move to up window" })
map("t", "<A-l>", "<C-\\><C-n><C-w>l", { desc = "Move to right window" })
map({"n", "v", "i"}, "<D-j>", "10j", { desc = "Move down 10 lines" })
map({"n", "v", "i"}, "<D-k>", "10k", { desc = "Move up 10 lines" })
map({"n", "v", "i"}, "<F1>", '<cmd> exec "NvimTreeToggle " . getcwd()<CR>', { desc = "Toggle file explorer", silent = true, nowait = true })
map({"n", "v", "i"}, "<C-c>", "<ESC>", { desc = "ESC" })
map({"n", "v", "i"}, "<C-x><C-x>", "<ESC>:qa!<CR>", { desc = "Force quit all" })
map({"n", "v", "i"}, "<C-x><C-s>", "<ESC>:w<CR>", { desc = "Save" })
map({"n", "v", "i"}, "<A-w>", "<C-w>", { desc = "Move to previous window" })
map({"n", "v", "i"}, "<C-x><C-c>", "<ESC>:qa<CR>", { desc = "Quit all" })
map({"n", "v", "i"}, "<A-h>", "<C-w>h", { desc = "Move to left window" })
map({"n", "v", "i"}, "<A-j>", "<C-w>j", { desc = "Move to down window" })
map({"n", "v", "i"}, "<A-k>", "<C-w>k", { desc = "Move to up window" })
map({"n", "v", "i"}, "<A-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<D-s>", ":w<CR>", { desc = "save", nowait = true })
map("n", "<D-c><D-c>", '"+yy', { desc = "copy line", nowait = true })
map("n", "<D-c>p", '"+yip', { desc = "copy paragraph", nowait = true })
map("n", "<D-v>", '"+P', { desc = "paste normal mode", nowait = true })
map("v", "<D-c>", '"+y', { desc = "copy", nowait = true })
map("v", "<D-v>", '"+P', { desc = "paste visual mode", nowait = true })
map("c", "<D-v>", "<C-R>+", { desc = "paste command mode", nowait = true })
map("i", "<D-v>", "<C-o>\"+P", { desc = "paste insert mode", nowait = true })
map("n", "<leader>ff", function()
   require'telescope.builtin'.find_files({find_command = {'rg', '--files', '--hidden', '-g', '!.git', '-g', '!.github', '-g', '!node_modules' }, cwd = vim.fn.expand('%:p:h')})
end, { desc = "Find files", nowait = true, silent = true })
map("n", "<D-f>", function()
   require'telescope.builtin'.find_files({find_command = {'rg', '--files', '--hidden', '-g', '!.git', '-g', '!.github', '-g', '!node_modules' }, cwd = vim.fn.expand('%:p:h')})
end, { desc = "Find files", nowait = true, silent = true })
map("n", "<C-x>@sf", function()
   require'telescope.builtin'.find_files({find_command = {'rg', '--files', '--hidden', '-g', '!.git', '-g', '!.github', '-g', '!node_modules' }, cwd = vim.fn.expand('%:p:h')})
end, { desc = "Find files", nowait = true, silent = true })
map("n", "<C-x><C-f>", function()
   require'telescope.builtin'.find_files({find_command = {'rg', '--files', '--hidden', '-g', '!.git', '-g', '!.github', '-g', '!node_modules' }, cwd = vim.fn.expand('%:p:h')})
end, { desc = "Find files", nowait = true, silent = true })
map("n", "<leader>fa", function()
   require'telescope.builtin'.find_files({find_command = {'rg', '--files', '--hidden', '-g', '!.git', '-g', '!.github', '-g', '!node_modules' }})
end, { desc = "Find all", nowait = true, silent = true })
map("n", "<leader>pf", function()
   require'telescope.builtin'.find_files({find_command = {'rg', '--files', '--hidden', '-g', '!.git', '-g', '!.github', '-g', '!node_modules' }})
end, { desc = "Find all", nowait = true, silent = true })
map("n", "<D-o>", function()
   require'telescope.builtin'.find_files({find_command = {'rg', '--files', '--hidden', '-g', '!.git', '-g', '!.github', '-g', '!node_modules' }})
end, { desc = "Find all", nowait = true, silent = true })
map("n", "<C-x>@so", function()
   require'telescope.builtin'.find_files({find_command = {'rg', '--files', '--hidden', '-g', '!.git', '-g', '!.github', '-g', '!node_modules' }})
end, { desc = "Find all", nowait = true, silent = true })
map("n", "<leader>/", "<cmd> Telescope live_grep <CR>", { desc = "Live grep" , nowait = true, silent = true })
map("n", "<leader>*", "<cmd> Telescope grep_string <CR>", { desc = "Grep string" , nowait = true, silent = true })
map("n", "<leader>bb", "<cmd> Telescope buffers <CR>", { desc = "Find buffers" , nowait = true, silent = true })
map("n", "<D-b>", "<cmd> Telescope buffers <CR>", { desc = "Find buffers" , nowait = true, silent = true })
map("n", "<C-x>@sb", "<cmd> Telescope buffers <CR>", { desc = "Find buffers" , nowait = true, silent = true })
map("n", "<C-x><C-b>", "<cmd> Telescope buffers <CR>", { desc = "Find buffers" , nowait = true, silent = true })
map("n", "<leader>fh", "<cmd> Telescope help_tags <CR>", { desc = "Help page" , nowait = true, silent = true })
map("n", "<leader>fr", "<cmd> Telescope oldfiles <CR>", { desc = "Find oldfiles" , nowait = true, silent = true })
map("n", "<leader>ss", "<cmd> Telescope current_buffer_fuzzy_find <CR>", { desc = "Find in current buffer" , nowait = true, silent = true })
map("n", "<leader>fyy", function()
   local path = vim.fn.expand "%:p"
   vim.fn.setreg("+", path)
   vim.notify("Copied path to clipboard: " .. path)
end, { desc = "Copy path to clipboard" })
map("n", "<leader>fyn", function()
   local path = vim.fn.expand "%:t"
   vim.fn.setreg("+", path)
   vim.notify("Copied base name to clipboard: " .. path)
end, { desc = "Copy base name to clipboard" })
map("n", "<leader>gl", "<cmd> Telescope git_commits <CR>", { desc = "Git commits" , nowait = true, silent = true })
map("n", "<leader>gc", "<cmd> Telescope git_branches <CR>", { desc = "Git branches" , nowait = true, silent = true })
map("n", "<leader>gs", function() require("neogit").open({kind = "auto"}) end, { desc = "Git status" , nowait = true, silent = true })
map("n", "<D-g>", function() require("neogit").open({kind = "auto"}) end, { desc = "Git status" , nowait = true, silent = true })
map("n", "<leader>sl", "<cmd> Telescope resume <CR>", { desc = "Resume Telescope dialog" , nowait = true, silent = true })
map("n", "<leader>rl", "<cmd> Telescope resume <CR>", { desc = "Resume Telescope dialog" , nowait = true, silent = true })
map("n", "<leader>pt", "<cmd> Telescope terms <CR>", { desc = "Pick hidden term" , nowait = true, silent = true })
map("n", "<leader>th", "<cmd> Telescope themes <CR>", { desc = "Nvchad themes" , nowait = true, silent = true })
map("n", "<leader>re", function() require("telescope.builtin").registers() end, { desc = "Show all registers" , nowait = true, silent = true })
-- map("n", "<leader>fb", "<cmd> Telescope marks <CR>", { desc = "telescope bookmarks" , nowait = true, silent = true })
-- map("n", "<D-i><D-b>", "<cmd> Telescope marks <CR>", { desc = "telescope bookmarks" , nowait = true, silent = true })
map("n", "<leader>w|", "<C-o>:belowright vsplit | wincmd w<CR>", { desc = "Split window vertically", nowait = true, silent = true })
map("n", "<leader>w-", "<C-o>:belowright split | wincmd w<CR>", { desc = "Split window horizontally", nowait = true, silent = true })
map("n", "<leader>ji", "<cmd> Telescope lsp_document_symbols<CR>", { desc = "Jump to ctags outline", nowait = true, silent = true })
map("v", "<leader>*", "<cmd> Telescope grep_string <CR>", { desc = "Grep string" , nowait = true, silent = true })
map("n", "<leader><leader>", "<cmd> HopChar2<CR>", { desc = "Jump to char", silent = true, nowait = true})
map("n", "<leader>jl", "<cmd> HopLine<CR>", { desc = "Jump to char", silent = true, nowait = true})
map("n", "<D-l>", "<cmd> HopLine<CR>", { desc = "Jump to char", silent = true, nowait = true})
map("n", "<C-x>@sl", "<cmd> HopLine<CR>", { desc = "Jump to char", silent = true, nowait = true})
map("n", "<leader>x", "")

map("n", "<leader>fo", function() vim.fn.jobstart("open " .. vim.fn.expand "%:p", {detach = true}) end, { desc = "Open file with system default application" })

map({"n", "v"}, "<leader>xa#", "<cmd> Tabularize /#<CR>", { desc = "Align by #", silent = true, nowait = true })
map({"n", "v"}, "<leader>xa:", "<cmd> Tabularize /:<CR>", { desc = "Align by :", silent = true, nowait = true })
map({"n", "v"}, "<leader>xa=", "<cmd> Tabularize /=<CR>", { desc = "Align by =", silent = true, nowait = true })
map({"n", "v"}, "<leader>xa,", "<cmd> Tabularize /,<CR>", { desc = "Align by ,", silent = true, nowait = true })
map({"n", "v"}, "<leader>xa|", "<cmd> Tabularize /|<CR>", { desc = "Align by |", silent = true, nowait = true })
map({"n", "v"}, "<leader>xa:", "<cmd> Tabularize /:<CR>", { desc = "Align by :", silent = true, nowait = true })
map({"n", "v"}, "<leader>xa.", "<cmd> Tabularize /.<CR>", { desc = "Align by .", silent = true, nowait = true })
map({"n", "v"}, "<leader>xa;", "<cmd> Tabularize /;<CR>", { desc = "Align by ;", silent = true, nowait = true })
map({"n", "v"}, "<leader>xa-", "<cmd> Tabularize /-<CR>", { desc = "Align by -", silent = true, nowait = true })
map({"n", "v"}, "<leader>xa_", "<cmd> Tabularize /_<CR>", { desc = "Align by _", silent = true, nowait = true })
map({"n", "v"}, "<leader>xa+", "<cmd> Tabularize /+<CR>", { desc = "Align by +", silent = true, nowait = true })
map({"n", "v"}, "<leader>xa*", "<cmd> Tabularize /*<CR>", { desc = "Align by *", silent = true, nowait = true })
map({"n", "v"}, "<leader>xa/", "<cmd> Tabularize //\\zs<CR>", { desc = "Align by /", silent = true, nowait = true })
map({"n", "v"}, "<leader>xa ", "<cmd> Tabularize /\\s\\ze\\S/l0<CR>", { desc = "Align by space", silent = true, nowait = true })
map({"n", "v"}, "<leader>xa\\", "<cmd> Tabularize /\\\\<CR>", { desc = "Align by \\", silent = true, nowait = true })
vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile"}, {
                              pattern = "*",
                              callback = function()
                                if not vim.bo.readonly and vim.bo.modifiable and vim.bo.buftype ~= 'quickfix' then
                                  map("n", "<cr>", "o<esc>", { desc = "Insert newline below", silent = true, nowait = false, buffer = true })
                                  vim.cmd.echom("'" .. vim.bo.buftype .. "'")
                                end
                              end,
})
map("n", "<M-x>", "<cmd>Telescope commands<cr>", { desc = "Show all commands", silent = true, nowait = false })
map("n", "<leader>ss", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "search current buffer", silent = true, nowait = false })
map("n", "<D-a>", "ggVG", { desc = "Select all", silent = true, nowait = true })

local diagnostics_active = true
local toggle_diagnostics = function()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
end

map('n', '<leader>ts', toggle_diagnostics, {desc = "Toggle Diagnostics", silent = true})
map({"n", "x", "o"}, "]h", function()
  local gs = require("gitsigns")
  gs.next_hunk()
end, { desc = "Next Hunk" })


map({"n", "x", "o"}, "[h", function()
  local gs = require("gitsigns")
  gs.prev_hunk()
end, { desc = "Prev Hunk" })

map("n", "<D-r><D-u>", "<cmd>Lazy sync<CR>", { desc = "Update packages (Lazy sync)" })
