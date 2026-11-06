-- LSP servers for hosts with no internet.
--
-- mason.nvim is disabled (see offline.lua), so nothing is auto-installed. The servers are plain unpacked
-- binaries, and each one is pointed at by an explicit `cmd`, so lspconfig never has to search PATH or
-- ask mason.
--
-- Two possible locations: a shared tree that some hosts mount, and a per-user tree for hosts that do
-- not see the mount. The first one that exists wins.

local candidates = {
  "/opt/shared/nvim/lsp",
  vim.fn.expand("~/.local/nvim/lsp"),
}

local root = nil
for _, dir in ipairs(candidates) do
  if (vim.uv or vim.loop).fs_stat(dir) then
    root = dir
    break
  end
end

if not root then
  vim.schedule(function()
    vim.notify("lsp-offline.lua: no LSP tree found in " .. table.concat(candidates, " or "), vim.log.levels.WARN)
  end)
  return {}
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- SystemVerilog / Verilog. Statically linked, so it runs on old glibc (RHEL 8.6).
        verible = {
          mason = false,
          cmd = { root .. "/verible/bin/verible-verilog-ls", "--rules_config_search" },
          filetypes = { "systemverilog", "verilog" },
          root_markers = { "verible.filelist", ".git" },
        },

        -- Lua, for editing this configuration itself.
        lua_ls = {
          mason = false,
          cmd = { root .. "/lua-language-server/bin/lua-language-server" },
        },

        -- svls is a second SystemVerilog server. Running two of them on the same buffer duplicates every
        -- diagnostic, so it stays off until verible has been judged. It needs a .svls.toml listing the
        -- filelist.
        svls = {
          enabled = false,
          mason = false,
          cmd = { root .. "/svls/svls" },
          filetypes = { "systemverilog", "verilog" },
        },
      },
    },
  },
}
