-- General settings
vim.o.clipboard = "unnamedplus"
vim.o.number = true
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.termguicolors = true
vim.o.wrap = true
vim.o.syntax = "on"
vim.cmd("set noswapfile")
vim.cmd("set undofile")

-- Syntax & loader
vim.cmd('syntax on')
vim.loader.enable()

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" }, { "\nPress any key to exit..." } }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {
    {"nvim-treesitter/nvim-treesitter", config = true},
    {"norcalli/nvim-colorizer.lua"},
    {'numToStr/Comment.nvim', opts = {}},
    {"folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {}},
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})

-- Setup colorscheme
vim.cmd[[colorscheme tokyonight]]