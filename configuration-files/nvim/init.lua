vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = ","

vim.opt.termguicolors = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

local set = vim.opt
set.tabstop = 2
set.softtabstop = 2
set.shiftwidth = 2
set.expandtab = true
set.number = true
set.encoding = "utf-8"
set.fileencoding = "utf-8"

require("lazy").setup({
  spec = {
    {
      "catppuccin/nvim",
      priority = 1000,
      config = function()
        require("catppuccin").setup({
          flavour = "macchiato"
        })
        require("catppuccin").load()
      end
    },
    {
      "nvim-tree/nvim-tree.lua",
      lazy = false,
      dependencies = {
        "nvim-tree/nvim-web-devicons"
      },
      config = function()
        require("nvim-tree").setup({
          view = {
            width = 40
          },
      })
      end
    },
    {
      "nvim-tree/nvim-web-devicons"
    },
    {
      "romgrk/barbar.nvim",
      init = function()
        vim.g.barbar_auto_setup = false
      end,
      opts = {},
    },
    {
      "nvim-lua/plenary.nvim"
    },
    {
      "nvim-telescope/telescope.nvim",
      dependencies =
      {
        "nvim-lua/plenary.nvim"
      }
    },
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "master",
      lazy = false,
      build = ":TSUpdate"
    }
  },
})

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map("n", "<Tab>", "<Cmd>BufferNext<CR>", opts)
map("n", "<S-Tab>", "<Cmd>BufferPrevious<CR>", opts)
map("n", "<Leader>e", "<Cmd>NvimTreeToggle<CR>", opts)

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.live_grep)
vim.keymap.set("n", "<leader>fb", builtin.buffers)
vim.keymap.set("n", "<leader>fh", builtin.help_tags)

vim.cmd("NvimTreeToggle")
