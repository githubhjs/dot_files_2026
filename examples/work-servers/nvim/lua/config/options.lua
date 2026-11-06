-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- ---------------------------------------------------------------------------
-- GUI front ends. Two different mechanisms, both needed.
--
--  * goneovim / neovide read Neovim's own 'guifont' and 'linespace'.
--    goneovim sets g:goneovim itself, visible in the child it spawns.
--
--  * nvim-qt ignores 'guifont' entirely. It ships a runtime plugin (nvim_gui_shim.vim) defining
--    :GuiFont and :GuiLinespace, which notify the UI over RPC. The font is applied on UIEnter,
--    because :GuiFont needs an attached UI channel to send to.
-- ---------------------------------------------------------------------------
local GUI_FONT, GUI_LINESPACE = "MesloLGS NF:h12", 2

if vim.g.goneovim or vim.g.neovide or vim.g.nvy then
  vim.o.guifont = GUI_FONT
  vim.opt.linespace = GUI_LINESPACE
end

-- The nvim-qt shim is deliberately NOT added to runtimepath here. It registers an unguarded autocmd
-- that rpcnotify(0, ...)-broadcasts a 'CursorMoved' Gui event to every attached channel, which goneovim
-- does not implement and logs on every keystroke. nvim-qt injects the shim itself when it spawns nvim,
-- so only sessions that actually use nvim-qt pay for it.

vim.api.nvim_create_autocmd("UIEnter", {
  desc = "apply the GUI font to nvim-qt, which does not use 'guifont'",
  callback = function()
    -- optional escape hatch: set JH_SKIP_GUIFONT in the environment to leave the font alone
    if vim.env.JH_SKIP_GUIFONT then return end
    if vim.fn.exists(":GuiFont") == 2 then
      vim.cmd("silent! GuiFont! " .. GUI_FONT)
      vim.cmd("silent! GuiLinespace " .. GUI_LINESPACE)
    end
  end,
})

-- Language providers. None is used here: no installed plugin requires them, so :checkhealth's warning is
-- noise. Turning them off also skips the provider probe during startup.
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
