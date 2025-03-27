local dkosettings = require("dko.settings")

local M = {}

local function plugin(name, method)
  return function()
    return require(name)[method]
  end
end

local function snacks(method)
  return function()
    return require("snacks").picker[method]
  end
end

local features = {
  code_action = {
    -- gra is default in 0.11, can use either
    shortcut = "<Leader><Leader>",
    providers = {
      coc = "<Plug>(coc-codeaction-cursor)",
      default = vim.lsp.buf.code_action,
    },
  },
  lsp_declarations = {
    shortcut = "gD",
    providers = {
      coc = "<Plug>(coc-declaration)",
      default = vim.lsp.buf.declaration,
      fzf = plugin("fzf-lua", "lsp_declarations"),
      snacks = plugin("snacks", "lsp_declarations"),
    },
  },
  lsp_definitions = {
    shortcut = "gd",
    providers = {
      coc = "<Plug>(coc-definition)",
      default = vim.lsp.buf.definition,
      fzf = plugin("fzf-lua", "lsp_definitions"),
      snacks = plugin("snacks", "lsp_definitions"),
    },
  },
  lsp_definitions_tagfunc = {
    shortcut = "<C-]>",
    providers = {
      coc = "<Plug>(coc-definition)",
      default = vim.lsp.buf.definition,
      fzf = plugin("fzf-lua", "lsp_definitions"),
      snacks = plugin("snacks", "lsp_definitions"),
    },
  },
  lsp_implementations = {
    shortcut = "gri",
    providers = {
      coc = "<Plug>(coc-implementation)",
      default = vim.lsp.buf.implementation,
      fzf = plugin("fzf-lua", "lsp_implementations"),
      snacks = plugin("snacks", "lsp_implementations"),
    },
  },
  lsp_references = {
    shortcut = "grr",
    providers = {
      coc = "<Plug>(coc-references)",
      default = vim.lsp.buf.references,
      fzf = plugin("fzf-lua", "lsp_references"),
      snacks = plugin("snacks", "lsp_references"),
    },
  },
  symbol_rename = {
    shortcut = "grn",
    providers = {
      coc = "<Plug>(coc-rename)",
      default = vim.lsp.buf.rename,
    },
  },
  type_definition = {
    shortcut = "<Leader>D",
    providers = {
      coc = "<Plug>(coc-type-definition)",
      default = vim.lsp.buf.type_definition,
      fzf = plugin("fzf-lua", "lsp_typedefs"),
      snacks = plugin("snacks", "lsp_type_definitions"),
    },
  },
}

---List of unbind functions, keyed by "b"..bufnr
---@type table<string, table<'coc'|'lsp', fun()[]>>
M.bound = {
  lsp = {},
  coc = {},
}

---Run all the unbind functions for the bufnr
---@param bufnr number
---@param group 'coc'|'lsp'
M.unbind_lsp = function(bufnr, group)
  local key = "b" .. bufnr
  for _, unbind in ipairs(M.bound[group][key]) do
    unbind()
  end
  M.bound[group][key] = nil
  vim.b.did_bind_lsp = false
end

---@param bufnr number
M.bind_lsp = function(bufnr, group)
  if vim.b.did_bind_lsp then -- First LSP attached
    return
  end

  group = group or "lsp"
  vim.b.did_bind_lsp = group

  local function lspmap(modes, lhs, rhs, opts)
    opts.silent = true
    opts.buffer = bufnr
    local unbind = require("dko.mappings").map(modes, lhs, rhs, opts)
    local key = "b" .. bufnr
    M.bound[group][key] = M.bound[group][key] or {}
    table.insert(M.bound[group][key], unbind)
  end

  for feature, config in pairs(features) do
    local provider_key = group == "coc" and "coc" or dkosettings.get("finder")
    provider_key = config.providers[provider_key] and provider_key or "default"
    local provider = config.providers[provider_key]
    if provider then
      lspmap("n", config.shortcut, provider, {
        desc = ("%s [%s]"):format(feature, provider_key),
      })
    end
  end

  --map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  --map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  --[[ map('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts) ]]
end

-- =============================================================================
-- Buffer: LSP integration
-- Mix of https://github.com/neovim/nvim-lspconfig#suggested-configuration
-- and :h lsp
-- =============================================================================

-- Bindings for coc.nvim. Conflicts with bind_lsp.
-- opts = {
--   buf = 1,
--   event = "FileType",
--   file = "app/components/Navigation.tsx",
--   id = 26,
--   match = "typescriptreact"
-- }
M.bind_coc = function(opts)
  if vim.b.did_bind_lsp then
    vim.notify(
      "Tried to bind_coc but bind_lsp was already called",
      vim.log.levels.ERROR,
      { title = "[COC]", render = "wrapped-compact" }
    )
    return
  end
  -- make sure bind_lsp doesn't overwrite mappings later
  vim.b.did_bind_coc = true
  M.bind_lsp(opts.buf, "coc")
end

return M
