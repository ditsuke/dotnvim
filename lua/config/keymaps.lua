-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local api = vim.api
-- local default_opts = { noremap = true, silent = true }
-- local keymap = vim.keymap

pcall(function()
  api.nvim_del_keymap("n", "<")
  api.nvim_del_keymap("n", ">")
  api.nvim_del_keymap("v", "<")
  api.nvim_del_keymap("v", ">")
end)
