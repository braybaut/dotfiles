local opt = vim.opt

local M = {}

M.nvimtree = {
   n = {
   ["<C-d>"] = { "<cmd> NvimTreeToggle <CR>", "   toggle nvimtree" },
   },
}

opt.colorcolumn = "80"
opt.list = true
opt.number = true
opt.relativenumber = true

return M
