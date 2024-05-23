
vim.api.nvim_set_keymap("n", "<leader>pp", "<cmd> Telescope projects<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<D-p>", "<cmd> Telescope projects<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<D-p>", "<cmd> Telescope projects<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-x>@sp", "<cmd> Telescope projects<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-x>@sp", "<cmd> Telescope projects<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "gp", "`[V`]", { noremap = true, silent = true })

vim.api.nvim_set_keymap("", "<C-g>", "<C-c>:nohlsearch<CR>", { noremap = true, silent = true })
