vim.keymap.set("n", "<Esc><Esc>", function()
    vim.api.nvim_command("nohlsearch")
end, {})

vim.keymap.set("n", "<Leader>n", function()
    vim.api.nvim_command("setlocal relativenumber!")
end, {})

vim.keymap.set("n", "<C-k>", "<cmd>new +term<cr><cmd>resize 10<cr>", {})

vim.keymap.set("n", "<C-S-k>", "<cmd>tabnew +term<cr>", {})

vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, {})
