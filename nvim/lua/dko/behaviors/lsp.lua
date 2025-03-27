local dkosettings = require("dko.settings")
local dkolspmappings = require("dko.mappings.lsp")
local dkomappings = require("dko.mappings")
local dkoformat = require("dko.utils.format")
local augroup = require("dko.utils.autocmd").augroup
local autocmd = vim.api.nvim_create_autocmd
local Methods = vim.lsp.protocol.Methods

---@class LspAutocmdArgs
---@field buf number
---@field data { client_id: number }
---@field event "LspAttach"|"LspDetach"
---@field file string e.g. "/home/davidosomething/.dotfiles/nvim/lua/dko/behaviors.lua"

-- https://github.com/neovim/neovim/blob/7a44231832fbeb0fe87553f75519ca46e91cb7ab/runtime/lua/vim/lsp.lua#L1529-L1533
-- LspAttach happens before on_attach, so can still use on_attach to do more stuff or
-- override this

autocmd("LspAttach", {
  desc = "Bind LSP related mappings",

  ---@param args LspAutocmdArgs
  callback = function(args)
    --[[
  {
    buf = 1,
    data = {
      client_id = 1
    },
    event = "LspAttach",
    file = "/home/davidosomething/.dotfiles/nvim/lua/dko/behaviors.lua",
    group = 11,
    id = 13,
    match = "/home/davidosomething/.dotfiles/nvim/lua/dko/behaviors.lua"
  }
  ]]
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then -- just to shut up type checking
      dkolspmappings.bind_lsp(bufnr)
    end
  end,
  group = augroup("dkolsp"),
})

autocmd("LspAttach", {
  desc = "Add capable LSP as formatter when attaches to buffer",
  callback = function(args)
    local bufnr = args.buf
    local clients = vim.lsp.get_clients({
      id = args.data.client_id,
      bufnr = bufnr,
      method = Methods.textDocument_formatting,
    })
    if #clients == 0 then -- just to shut up type checking
      return
    end

    -- Track formatters, non-exclusively, non-LSPs might add to this table
    -- or fire the autocmd
    local name = clients[1].name
    dkoformat.add_formatter(bufnr, name)
  end,
  group = augroup("dkolsp"),
})

autocmd("LspDetach", {
  desc = "Unbind LSP related mappings on last client detach",
  --[[
    {
      buf = 1,
      data = {
        client_id = 4
      },
      event = "LspDetach",
      file = "/home/davidosomething/.dotfiles/README.md",
      group = 13,
      id = 23,
      match = "/home/davidosomething/.dotfiles/README.md"
    }
  ]]
  callback = function(args)
    local bufnr = args.buf
    local key = "b" .. bufnr

    -- No mappings on buffer
    if dkolspmappings.bound.lsp[key] == nil then
      vim.b.did_bind_lsp = false -- just in case
      return
    end

    -- check for clients with definition support, since that's one of the primary
    -- purposes of keybinding...
    local clients = vim.lsp.get_clients({
      bufnr = bufnr,
      method = Methods.textDocument_definition,
    })
    if #clients == 0 then -- Last LSP attached
      if vim.fn.bufwinnr(bufnr) > -1 then
        vim.notify(
          ("No %s providers remaining."):format(Methods.textDocument_definition),
          vim.log.levels.INFO,
          { title = "[LSP]", render = "wrapped-compact" }
        )
        dkolspmappings.unbind_lsp(bufnr, "lsp")
      end
    end
  end,
  group = augroup("dkolsp"),
})

autocmd("LspDetach", {
  desc = "Unset flag to format on save IF last formatter detaches from buffer",
  callback = function(args)
    -- was already disabled manually?
    if not vim.b.enable_format_on_save then
      return
    end

    local bufnr = args.buf
    local detached_client_id = args.data.client_id

    -- Unregister the client from formatters (and update heirline)
    local detached_client = vim.lsp.get_client_by_id(detached_client_id)
    if detached_client ~= nil then
      local name = detached_client.name
      dkoformat.remove_formatter(bufnr, name)
    end
  end,
  group = augroup("dkolsp"),
})

autocmd("FileType", {
  desc = "Set mappings/format on save for specific filetypes if coc.nvim is enabled",
  callback = function(opts)
    dkomappings.bind_snippy()
    dkomappings.bind_completion(opts)
    dkomappings.bind_hover(opts)
  end,
  group = augroup("dkolsp"),
})

-- ===========================================================================
-- Formatting
-- ===========================================================================

autocmd("User", {
  pattern = "FormattersChanged",
  desc = "Notify neovim a formatter has been added for the buffer",
  callback = vim.schedule_wrap(function()
    vim.cmd.redrawstatus({ bang = true })
  end),
  group = augroup("dkolsp"),
})

autocmd({ "BufWritePre", "FileWritePre" }, {
  desc = "Format with LSP on save",
  callback = function()
    -- callback gets arg
    -- {
    --   buf = 1,
    --   event = "BufWritePre",
    --   file = "nvim/lua/dko/behaviors.lua",
    --   id = 127,
    --   match = "/home/davidosomething/.dotfiles/nvim/lua/dko/behaviors.lua"
    -- }
    if not vim.b.enable_format_on_save then
      return
    end
    dkoformat.run_pipeline({ async = false })
  end,
  group = augroup("dkolsp"),
})
