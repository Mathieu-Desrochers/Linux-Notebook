vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "

vim.opt.termguicolors = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

local vim = vim
local Plug = vim.fn["plug#"]

vim.call("plug#begin")

Plug("folke/tokyonight.nvim")
Plug("nvim-tree/nvim-web-devicons")
Plug("romgrk/barbar.nvim")
Plug("nvim-tree/nvim-tree.lua")
Plug("nvim-lua/plenary.nvim")
Plug("nvim-telescope/telescope.nvim", { ["tag"] = "0.1.8" })
Plug("nvim-lualine/lualine.nvim")
Plug("sindrets/diffview.nvim")
Plug("stevearc/conform.nvim")
Plug("neovim/nvim-lspconfig")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/cmp-cmdline")
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-vsnip")
Plug("hrsh7th/vim-vsnip")
Plug("mfussenegger/nvim-dap")
Plug("leoluz/nvim-dap-go")

vim.call("plug#end")

vim.cmd("silent! colorscheme tokyonight")

require("nvim-tree").setup({
  view = {
    width = 50,
  },
})

require("lualine").setup()

require("conform").setup({
  formatters_by_ft = {
    go = { "gofmt" },
  },
})

vim.lsp.enable("gopls")

local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "vsnip" },
    }, {
      { name = "buffer" },
    })
})

require("dap-go").setup()

local map = vim.keymap.set

map("n", "<Tab>", "<Cmd>BufferNext<CR>", opts)
map("n", "<S-Tab>", "<Cmd>BufferPrevious<CR>", opts)
map("n", "<Leader>p", "<Cmd>BufferPin<CR>", opts)
map("n", "<Leader>x", "<Cmd>bd<CR>", opts)
map("n", "<Leader>ff", "<Cmd>Telescope find_files<CR>")
map("n", "<Leader>fg", "<Cmd>Telescope live_grep<CR>")
map("n", "<Leader>e", "<Cmd>NvimTreeToggle<CR>")
map("n", "<Leader>e", "<Cmd>NvimTreeToggle<CR>")
map("n", "<Leader>d", "<Cmd>DiffviewOpen<CR>")
