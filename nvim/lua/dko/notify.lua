local dkoescesc = require("dko.behaviors.escesc")
local dkosettings = require("dko.settings")

-- =====================================================================
-- Override vim.notify builtin
-- known special titles
-- mason ones should not go to fidget because mason window will cover it
-- - "mason.nvim"
-- - "mason-lspconfig.nvim"
-- - "nvim-treesitter"
-- =====================================================================

---@param msg string
---@param level? number vim.log.levels.*
---@param opts? table
local override = function(msg, level, opts)
  opts = opts or {}

  if opts.title == "package-info.nvim" then
    return
  end

  if opts.title == "nvim-treesitter" then
    local fok, fidget = pcall(require, "fidget")
    if fok then
      fidget.notify(msg, level, opts)
    else
      vim.print(msg)
    end
    return
  end

  if not opts.title then
    if vim.startswith(msg, "[LSP]") then
      local client, found_client = msg:gsub("^%[LSP%]%[(.-)%] .*", "%1")
      if found_client > 0 then
        opts.title = ("[LSP] %s"):format(client)
      else
        opts.title = "[LSP]"
      end
      msg = msg:gsub("^%[.*%] (.*)", "%1")
    elseif msg == "No code actions available" then
      -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#LL629C39-L629C39
      opts.title = "[LSP]"
    end
  end

  if dkosettings.get("notify") == "snacks" then
    vim.schedule(function()
      _G["Snacks"].notifier.notify(msg, level, opts)
    end)
  else
    vim.print(("%s: %s"):format(opts.title, msg))
  end

  vim.print(("%s: %s"):format(opts.title, msg))
end
vim.notify = override

if dkosettings.get("notify") == "snacks" then
  dkoescesc.add(function()
    _G["Snacks"].notifier.hide()
  end, "Dismiss notifications on <Esc><Esc>")
  require("dko.mappings").bind_snacks_notifier()
end
