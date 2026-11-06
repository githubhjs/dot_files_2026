-- Offline hardening for hosts with no internet access.
--
-- Without this file, opening any buffer makes LazyVim try to fetch things:
--   * nvim-treesitter downloads the ~23 grammars in its ensure_installed list
--     ("[nvim-treesitter/install/xml]: Downloading tree-sitter-xml...")
--   * mason downloads the LSP servers listed by lazyvim.plugins.lsp
-- Both block on the network and hang the editor.
--
-- The 7 parsers shipped with the Neovim build (c, lua, markdown, markdown_inline, query, vim,
-- vimdoc) are still used normally; only the attempt to fetch more is suppressed.
--
-- LSP servers are provided as unpacked binaries and are wired up directly (see lsp-offline.lua),
-- which is why mason is not needed here.

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- LazyVim declares opts_extend = { "ensure_installed" }, so a table override would be APPENDED to
    -- its list rather than replacing it. A function override receives the merged opts and can clear it.
    opts = function(_, opts)
      opts.ensure_installed = {}
      return opts
    end,
  },

  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
}
