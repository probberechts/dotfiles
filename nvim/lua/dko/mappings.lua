local dkobuffer = require("dko.utils.buffer")

local M = {}

---@param name 'fzf-lua'|'snacks'
---@param method string
---@param args? any
---@return function -- fun()
M.plugin = function(name, method, args)
  return function()
    return name == "snacks" and _G["Snacks"]["picker"][method](args)
      or require(name)[method](args)
  end
end

---Map and return with unbind function
---@return function # unbind
local function map(modes, lhs, rhs, opts)
  vim.keymap.set(modes, lhs, rhs, opts)
  return function()
    vim.keymap.del(modes, lhs, opts)
  end
end

M.map = map

---wrap handler with buffer assertions
---@return function # unbind
local function emap(modes, keys, handler, opts)
  return map(modes, keys, function()
    local is_in_floating_window = vim.api.nvim_win_get_config(0).relative ~= ""
    if is_in_floating_window then
      return ""
    end
    if vim.bo.buftype == "nofile" then
      return ""
    end
    if type(handler) == "function" then
      return handler()
    end
    return handler
  end, opts)
end

map("n", "<Esc><Esc>", function()
  vim.cmd.doautoall("User EscEscStart")

  -- Clear / search term
  vim.fn.setreg("/", "")
  -- Stop highlighting searches
  vim.cmd.nohlsearch()

  vim.cmd.doautoall("User EscEscEnd")
  vim.cmd.redraw({ bang = true })
end, { desc = "Clear UI" })

-- ===========================================================================
-- Window / Buffer manip
-- ===========================================================================

map("n", "]t", vim.cmd.tabn, { desc = "Next tab" })
map("n", "[t", vim.cmd.tabp, { desc = "Prev tab" })

map("n", "<BS>", function()
  -- only in non-floating
  if vim.api.nvim_win_get_config(0).relative == "" then
    return "<C-^>"
  end
end, {
  expr = true,
  desc = "Prev buffer with <BS> backspace in normal (C-^ is kinda awkward)",
})

local resizeOpts =
  { desc = "Resize window with Shift+DIR, can take a count #<S-Dir>" }
map("n", "<S-Up>", "<C-W>+", resizeOpts)
map("n", "<S-Down>", "<C-W>-", resizeOpts)
map("n", "<S-Left>", "<C-w><", resizeOpts)
map("n", "<S-Right>", "<C-w>>", resizeOpts)

map("n", "<Leader>x", function()
  dkobuffer.close()
end, { desc = "Remove buffer (try without closing window)" })

map("n", "<Leader>l", function()
  require("dko.utils.loclist").toggle()
end, { desc = "Toggle location list" })

-- ===========================================================================
-- Switch mode
-- ===========================================================================

map({ "c", "i" }, "jj", "<Esc>", { desc = "Back to normal mode" })

-- ===========================================================================
-- Visual mode tweaks
-- ===========================================================================

local visualArrowOpts = { desc = "Visual move by display lines" }
map("v", "<Down>", "gj", visualArrowOpts)
map("v", "<Up>", "gk", visualArrowOpts)

-- ===========================================================================
-- cd shortcuts
-- ===========================================================================

map("n", "<Leader>cd", "<Cmd>cd! %:h<CR>", {
  desc = "cd to current buffer path",
})

map("n", "<Leader>..", "<Cmd>cd! ..<CR>", { desc = "cd up a level" })

map("n", "<Leader>cr", function()
  local root = require("dko.utils.project").get_git_root()
  if root then
    if vim.uv.chdir(root) == 0 then
      vim.notify(root, vim.log.levels.INFO, { title = "Changed directory" })
    end
  end
end, { desc = "cd to current buffer's git root" })

-- ===========================================================================
-- :edit shortcuts
-- ===========================================================================

map("n", "<Leader>ecr", function()
  require("dko.utils.file").edit_closest("README.md")
end, { desc = "Edit closest README.md" })

map("n", "<Leader>epj", function()
  require("dko.utils.file").edit_closest("package.json")
end, { desc = "Edit closest package.json" })

map("n", "<Leader>evi", function()
  vim.cmd.edit(vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "Edit init.lua" })

map("n", "<Leader>evm", function()
  vim.cmd.edit(vim.fn.stdpath("config") .. "/lua/dko/mappings.lua")
end, { desc = "Edit mappings.lua" })

-- =============================================================================
-- doctor
-- =============================================================================

map("n", "<A-\\>", function()
  require("dko.doctor").toggle_float()
end, { desc = "Toggle dko.doctor float" })

-- ===========================================================================
-- Buffer: Reading
-- ===========================================================================

map({ "i", "n" }, "<F1>", "<NOP>", { desc = "Disable help shortcut key" })

map("n", "<F1>", function()
  local help = require("dko.utils.help")
  local cexpr = vim.fn.expand("<cexpr>")
  local res = help.cexpr(cexpr)
  if vim.env.NVIM_DEV ~= nil then
    vim.print({ cexpr, res })
  end
  if res and pcall(vim.cmd.help, res.match) then
    return
  end

  local line = vim.api.nvim_get_current_line()
  res = help.line(line)
  if vim.env.NVIM_DEV ~= nil then
    vim.print({ line, res })
  end
  if res then
    vim.cmd.help(res.match)
  end
end, { desc = "Show vim help for <cexpr> or current line" })

map("n", "<Leader>yn", function()
  local res = vim.fn.expand("%:t", false, false)
  if type(res) ~= "string" then
    return
  end
  if res == "" then
    vim.notify(
      "Buffer has no filename",
      vim.log.levels.ERROR,
      { title = "Failed to yank filename", render = "wrapped-compact" }
    )
    return
  end
  vim.fn.setreg("+", res)
  vim.notify(res, vim.log.levels.INFO, { title = "Yanked filename" })
end, { desc = "Yank the filename of current buffer" })

map("n", "<Leader>yp", function()
  local res = vim.fn.expand("%:p", false, false)
  if type(res) ~= "string" then
    return
  end
  res = res == "" and vim.uv.cwd() or res
  if res:len() then
    vim.fn.setreg("+", res)
    vim.notify(res, vim.log.levels.INFO, { title = "Yanked filepath" })
  end
end, { desc = "Yank the full filepath of current buffer" })

-- ===========================================================================
-- Buffer: Movement
-- ===========================================================================

map("n", "<Leader>mm", function()
  require("dko.utils.movemode").toggle()
end, { desc = "Toggle move mode" })

map("", "H", "^", { desc = "Change H to alias ^" })
map("", "L", "g_", { desc = "Change L to alias g_" })

-- https://stackoverflow.com/questions/4256697/vim-search-and-highlight-but-do-not-jump#comment91750564_4257175
map("n", "*", "m`<Cmd>keepjumps normal! *``<CR>", {
  desc = "Don't jump on first * -- simpler vim-asterisk",
})

-- ===========================================================================
-- Buffer: Edit contents
-- ===========================================================================

map("n", "<A-=>", function()
  require("dko.utils.format").run_pipeline({ async = false })
end, {
  desc = "Fix and format buffer with dko.utils.format.run_pipeline",
})

map("n", "<Leader>uf", function()
  vim.b.enable_format_on_save = not vim.b.enable_format_on_save
end, {
  desc = "Toggle format on save",
})

local visualTabOpts = {
  desc = "<Tab> indents selected lines in Visual",
  remap = true,
}
map("v", "<Tab>", ">", visualTabOpts)
map("v", "<S-Tab>", "<", visualTabOpts)

map("n", "<Leader>q", "@q", { desc = "Quickly apply macro q" })

local reselectOpts = { desc = "Reselect visual block after indent" }
map("x", "<", "<gv", reselectOpts)
map("x", ">", ">gv", reselectOpts)

map("n", "<Leader>,", "$r,", {
  desc = "Replace last character with a comma",
})
map("n", "<Leader>;", "$r;", {
  desc = "Replace last character with a semi-colon",
})

for _, v in pairs({ "=", "-", "." }) do
  map({ "n", "i" }, "<Leader>f" .. v, function()
    require("dko.utils.hr").fill(v)
  end, { desc = ("Append horizontal rule of %s up to &textwidth"):format(v) })
end

map("x", "<Leader>C", function()
  -- @TODO replace with https://github.com/neovim/neovim/pull/13896
  vim.api.nvim_feedkeys("y", "nx", false)
  local selection = vim.fn.getreg('"')
  if type(selection) ~= "string" then
    return
  end
  local converted = require("dko.utils.string").smallcaps(selection)
  vim.fn.setreg('"', converted)
  vim.api.nvim_feedkeys('gv""P', "nx", false)
end, { desc = "Convert selection to smallcaps" })

map("n", "dd", function()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end, { desc = "Smart dd, don't yank empty lines", expr = true })

-- ===========================================================================
-- <Tab> behavior
-- ===========================================================================

--[[ " <Tab> space or real tab based on line contents and cursor position
  " The PUM is closed and characters before the cursor are not all whitespace
  " so we need to insert alignment spaces (always spaces)
  " Calc how many spaces, support for negative &sts values
  let l:sts = (&softtabstop <= 0) ? shiftwidth() : &softtabstop
  let l:sp = (virtcol('.') % l:sts)
  if l:sp == 0 | let l:sp = l:sts | endif
  return repeat(' ', 1 + l:sts - l:sp)
endfunction ]]

map("i", "<Tab>", function()
  -- If characters all the way back to start of line were all whitespace,
  -- insert whatever expandtab setting is set to do.
  local current_line = dkobuffer.get_cursorline_contents()
  local all_spaces_regex = "^%s*$"
  if current_line:match(all_spaces_regex) then
    return "<Tab>"
  end

  -- Insert appropriate amount of spaces instead of real tabs
  local sts = vim.bo.softtabstop <= 0 and vim.fn.shiftwidth()
    or vim.bo.softtabstop
  -- How many spaces to insert after the current cursor to get to the next sts
  local spaces_from_cursor_to_next_sts = vim.fn.virtcol(".") % sts
  if spaces_from_cursor_to_next_sts == 0 then
    spaces_from_cursor_to_next_sts = sts
  end

  -- Insert whitespace to next softtabstop
  -- E.g. sts = 4, cursor at _,
  --          1234123412341234
  -- before   abc_
  -- after    abc _
  -- before   abc _
  -- after    abc     _
  -- before   abc    _
  -- after    abc     _
  return (" "):rep(1 + sts - spaces_from_cursor_to_next_sts)
end, { expr = true, desc = "Tab should insert spaces" })

map("i", "<S-Tab>", "<C-d>", {
  desc = "Tab inserts a tab, shift-tab should remove it",
})

-- ===========================================================================
-- Diagnostic mappings
-- ===========================================================================

-- @TODO start using <c-w><c-d> as of https://github.com/neovim/neovim/commit/73034611c25d16df5e87c8afb2d339a03a91bd0d/
map("n", "<C-W>d", function()
  vim.diagnostic.open_float()
end, { desc = "Open diagnostic float at cursor" })
map("n", "<C-W><C-D>", "<C-W>d", {
  desc = "Open diagnostic float at cursor",
  remap = true,
})

-- ===========================================================================
-- Tree-sitter utils
-- ===========================================================================

map("n", "ss", function()
  vim.print(vim.treesitter.get_captures_at_cursor())
end, { desc = "Print treesitter captures under cursor" })

map("n", "sy", function()
  local captures = vim.treesitter.get_captures_at_cursor()
  if #captures == 0 then
    vim.notify(
      "No treesitter captures under cursor",
      vim.log.levels.ERROR,
      { title = "Yank failed", render = "wrapped-compact" }
    )
    return
  end

  local parsedCaptures = vim
    .iter(captures)
    :map(function(capture)
      return ("@%s"):format(capture)
    end)
    :totable()
  local resultString = vim.inspect(parsedCaptures)
  vim.fn.setreg("+", resultString .. "\n")
  vim.notify(
    resultString,
    vim.log.levels.INFO,
    { title = "Yanked capture", render = "wrapped-compact" }
  )
end, { desc = "Copy treesitter captures under cursor" })

-- =============================================================================
-- External mappings
-- =============================================================================

-- Bind <C-Space> to open nvim-cmp
-- Bind <C-n> <C-p> to pick based on coc or nvim-cmp open
-- Bind <C-j> <C-k> to scroll coc or nvim-cmp attached docs window
M.bind_completion = function(opts)
  local _, cmp = pcall(require, "cmp")

  map("n", "<C-Space>", function()
    vim.cmd.startinsert({ bang = true })
    vim.schedule(cmp.complete)
  end, { desc = "In normal mode, `A`ppend and start nvim-cmp completion" })

  map("i", "<C-Space>", function()
    cmp.complete()
  end, { desc = "In insert mode, start nvim-cmp completion" })

  map("i", "<Plug>(DkoCmpNext)", function()
    cmp.select_next_item()
  end)
  map("i", "<Plug>(DkoCmpPrev)", function()
    cmp.select_prev_item()
  end)
  map("i", "<C-n>", function()
    if cmp.visible() then
      return "<Plug>(DkoCmpNext)"
    end
  end, { expr = true, buffer = opts.buf, remap = true, silent = true })
  map("i", "<C-p>", function()
    if cmp.visible() then
      return "<Plug>(DkoCmpPrev)"
    end
  end, { expr = true, buffer = opts.buf, remap = true, silent = true })

  map("i", "<Plug>(DkoCmpScrollUp)", function()
    cmp.mapping.scroll_docs(-4)
  end)
  map("i", "<Plug>(DkoCmpScrollDown)", function()
    cmp.mapping.scroll_docs(4)
  end)
  map("i", "<C-k>", function()
    if cmp.visible() then
      return "<Plug>(DkoCmpScrollUp)"
    end
  end, {
    expr = true,
    buffer = opts.buf,
    nowait = true,
    remap = true,
    silent = true,
  })
  map("i", "<C-j>", function()
    if cmp.visible() then
      return "<Plug>(DkoCmpScrollDown)"
    end
  end, {
    expr = true,
    buffer = opts.buf,
    nowait = true,
    remap = true,
    silent = true,
  })
  map("n", "<C-j>", function() end, {
    expr = true,
    buffer = opts.buf,
    nowait = true,
    remap = true,
    silent = true,
  })
  map("n", "<C-k>", function() end, {
    expr = true,
    buffer = opts.buf,
    nowait = true,
    remap = true,
    silent = true,
  })
end

-- =============================================================================
-- ts_ls
-- =============================================================================

-- on_attach binding for ts_ls
---@param client table
---@param bufnr integer
---@diagnostic disable-next-line: unused-local
M.bind_ts_ls_lsp = function(client, bufnr)
  -- Use TypeScript's Go To Source Definition so we don't end up in the
  -- type declaration files.
  map("n", "gd", function()
    -- typescript-tools.nvim
    if vim.fn.exists(":TSToolsGoToSourceDefinition") ~= 0 then
      vim.cmd.TSToolsGoToSourceDefinition()
      return
    end

    -- vtsls
    if vim.tbl_contains(require("dko.tools").get_mason_lsps(), "vtsls") then
      if
        require("dko.utils.typescript").go_to_source_definition(
          "vtsls",
          "typescript.goToSourceDefinition"
        )
      then
        return
      end

    -- ts_ls
    elseif
      require("dko.utils.typescript").go_to_source_definition(
        "ts_ls",
        "_typescript.goToSourceDefinition"
      )
    then
      return
    end

    -- fallback to default lsp definitions
    return handle_lsp_defintions()
  end, {
    desc = "Go To Source Definition (typescript.nvim)",
    silent = true,
    buffer = bufnr,
  })

  -- For typescript only (i.e. not JSON files)
  -- use go to def for gf, lazy way of getting it to map import dir/ to
  -- dir/index.ts automatically
  if vim.startswith(vim.bo.filetype, "t") then
    map("n", "gf", "gd", { remap = true })
  end
end

-- ===========================================================================
-- Plugin: Comment.nvim
-- ===========================================================================

---@param tbl table
---@return table
M.with_commentnvim_mappings = function(tbl)
  ---LHS of operator-pending mappings in NORMAL and VISUAL mode
  tbl.opleader = {
    ---Line-comment keymap (default gc)
    line = "<Tab>",
    ---Block-comment keymap (gb is my blame command)
    block = "<Leader>b",
  }
  tbl.toggler = {
    ---Line-comment toggle keymap
    line = "<Tab><Tab>",
    ---Block-comment toggle keymap
    block = "<Leader>B",
  }
  return tbl
end

-- ===========================================================================
-- Plugin: cybu.nvim
-- ===========================================================================

M.cybu = {
  prev = "[b",
  next = "]b",
}
M.bind_cybu = function()
  map("n", M.cybu.prev, "<Plug>(CybuPrev)", {
    desc = "Previous buffer with cybu popup",
  })
  map("n", M.cybu.next, "<Plug>(CybuNext)", {
    desc = "Next buffer with cybu popup",
  })
end

-- ===========================================================================
-- Plugin: gitsigns.nvim
-- ===========================================================================

M.bind_gitsigns = function(bufnr)
  local function bufmap(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    map(mode, l, r, opts)
  end

  -- Navigation
  bufmap("n", "]h", function()
    if vim.wo.diff then
      return "]h"
    end
    vim.schedule_wrap(require("gitsigns").next_hunk)
    return "<Ignore>"
  end, { expr = true, desc = "Next hunk" })

  bufmap("n", "[h", function()
    if vim.wo.diff then
      return "[h"
    end
    vim.schedule_wrap(require("gitsigns").prev_hunk)
    return "<Ignore>"
  end, { expr = true, desc = "Prev hunk" })

  -- Action
  bufmap("n", "gb", function()
    require("gitsigns").blame_line()
  end, { desc = "Popup blame for line" })
  bufmap("n", "gB", function()
    require("gitsigns").blame_line({ full = true })
  end, { desc = "Popul full blame for line" })

  -- Text object
  bufmap({ "o", "x" }, "ih", "<Cmd>Gitsigns select_hunk<CR>", {
    desc = "Select hunk",
  })
end

-- ===========================================================================
-- Plugin: inspecthi
-- ===========================================================================

M.bind_inspecthi = function()
  map("n", "zs", "<Cmd>Inspecthi<CR>", {
    desc = "Show highlight groups under cursor",
    silent = true,
  })
end

-- =============================================================================
-- Plugin: tadmccorkle/markdown.nvim
-- =============================================================================

M.bind_markdown = function(bufnr)
  map("n", "<c-x>", "<Cmd>MDTaskToggle<CR>", {
    buffer = bufnr,
    desc = "Toggle checkbox",
  })
end

-- ===========================================================================
-- Plugin: nvim-cmp + cmp-snippy
-- ===========================================================================

M.bind_snippy = function()
  local snippy_ok, snippy = pcall(require, "snippy")
  if not snippy_ok then
    return
  end
  local cmp_ok, cmp = pcall(require, "cmp")
  if not cmp_ok then
    return
  end
  map({ "i", "s" }, "<C-b>", function()
    if snippy.can_jump(-1) then
      snippy.previous()
    end
    -- DO NOT FALLBACK (i.e. do not insert ^B)
  end, { desc = "snippy: previous field" })

  map({ "i", "s" }, "<C-f>", function()
    -- If a snippet is highlighted in PUM, expand it
    if cmp.confirm({ select = false }) then
      return
    end
    -- If in a snippet, jump to next field
    if snippy.can_expand_or_advance() then
      snippy.expand_or_advance()
      return
    end
  end, {
    desc = "snippy: expand or next field",
  })
end

-- =============================================================================
-- Plugin: nvim-window
-- =============================================================================

M.nvim_window = {
  "<Leader>w",
  "<C-w>e",
  "<C-w><C-e>",
}

M.bind_nvim_window = function()
  vim.iter(M.nvim_window):each(function(k)
    map("n", k, function()
      require("nvim-window").pick()
    end, { desc = "nvim-window picker" })
  end)
end

-- ===========================================================================
-- Plugin: nvim-various-textobjs
-- ===========================================================================

M.bind_nvim_various_textobjs = function()
  -- Note: use <Cmd> mapping format for dot-repeatability
  -- https://github.com/chrisgrieser/nvim-various-textobjs/commit/363dbb7#diff-b335630551682c19a781afebcf4d07bf978fb1f8ac04c6bf87428ed5106870f5R5

  map({ "o", "x" }, "ai", function()
    ---@type "inner"|"outer" exclude the startline
    local START = "outer"
    ---@type "inner"|"outer" exclude the endline
    local END = "outer"
    ---@type "withBlanks"|"noBlanks"
    require("various-textobjs").indentation(START, END)
    vim.cmd.normal("$") -- jump to end of line like vim-textobj-indent
  end, { desc = "textobj: indent" })

  map({ "o", "x" }, "ii", function()
    ---@type "inner"|"outer" exclude the startline
    local START = "inner"
    ---@type "inner"|"outer" exclude the endline
    local END = "inner"
    ---@type "withBlanks"|"noBlanks"
    require("various-textobjs").indentation(START, END)
    vim.cmd.normal("$") -- jump to end of line like vim-textobj-indent
  end, { desc = "textobj: indent" })

  map("n", "<Leader>s", function()
    if vim.fn.indent(".") == 0 then
      return "vapk:!sort<CR>"
    else
      --- uses various-textobjs ii .indentation
      return "vii:!sort<CR>"
    end
  end, {
    desc = "Auto select indent and sort",
    expr = true,
    remap = true, -- since ii is a mapping too
  })

  map("v", "<Leader>s", function()
    return ":!sort<CR>"
  end, {
    desc = "Sort selection",
    expr = true,
    remap = true, -- since ii is a mapping too
  })

  map(
    { "o", "x" },
    "ik",
    "<Cmd>lua require('various-textobjs').key(true)<CR>",
    { desc = "textobj: object key" }
  )

  -- last yank or paste
  map(
    { "o", "x" },
    "iP",
    "<Cmd>lua require('various-textobjs').lastChange()<CR>",
    { desc = "textobj: last paste" }
  )

  map(
    { "o", "x" },
    "iv",
    "<Cmd>lua require('various-textobjs').value(true)<CR>",
    { desc = "textobj: object value" }
  )

  map(
    { "o", "x" },
    "is",
    "<Cmd>lua require('various-textobjs').subword(true)<CR>",
    { desc = "textobj: camel-_Snake" }
  )

  map(
    { "o", "x" },
    "iu",
    "<Cmd>lua require('various-textobjs').url()<CR>",
    { desc = "textobj: url" }
  )

  -- replaces netrw's gx
  map("n", "gx", function()
    if require("dko.utils.lsp").follow_documentLink() then
      return
    end

    if require("dko.utils.url").select_nearest() then
      local url = require("dko.utils.selection").get()
      if url then
        vim.ui.open(url)
        return
      end
    end

    -- -------------------------------------------------------------------------
    -- Popup menu of all urls in buffer
    -- -------------------------------------------------------------------------
    if vim.fn.exists(":UrlView") then
      vim.cmd.UrlView("buffer")
    end
  end, { desc = "Smart URL Opener" })
end

-- =============================================================================
-- Plugin: oil.nvim
-- =============================================================================

M.bind_oil = function()
  map("n", "\\\\", function()
    local _, oil = pcall(require, "oil")
    if oil then
      oil.toggle_float()
    end
  end, { desc = "Toggle floating oil.nvim" })
end

-- =============================================================================
-- picker / finder
-- =============================================================================

M.picker = {
  buffers = "<A-b>",
  code_actions = "<A-a>",
  files = "<A-c>",
  git_files = "<A-f>",
  git_status = "<A-s>",
  grep = "<A-g>",
  mru = "<A-m>",
  project = "<A-p>",
  vim = "<A-v>",
}

-- ===========================================================================
-- Plugin: fzf-lua
-- ===========================================================================

M.bind_fzf_terminal_mappings = function()
  for _, mapping in pairs(M.picker) do
    map("t", mapping, function()
      vim.cmd.close()
    end, {
      buffer = true,
      desc = "Use any picker mapping to close active picker",
    })
  end
end

-- =============================================================================
-- Plugin: snacks.nvim
-- =============================================================================

M.bind_snacks_notifier = function()
  map("n", "<A-n>", function()
    _G["Snacks"].notifier.show_history()
  end, {
    desc = "Open the snacks notifier history window",
    nowait = true,
  })
end

-- ===========================================================================
-- Plugin: toggleterm.nvim
-- ===========================================================================

M.toggleterm = {
  --- Hide active toggleterm window
  hide = "<A-i>",
  --- Enter to normal mode in terminal window
  mode = "<A-x>",
}

local common_winbar = {
  enabled = true,
  ---@diagnostic disable-next-line: unused-local
  name_formatter = function(term)
    return "<A-x>"
  end,
}

local toggleterm_modes = {
  horizontal = {
    keybind = "<A-i>",
    count = 88888,
    name = "common",
    winbar = common_winbar,
  },
  vertical = {
    keybind = "<A-C-i>",
    count = 88888,
    name = "common",
    sizefn = function()
      return math.max(vim.o.columns * 0.4, 20)
    end,
    winbar = common_winbar,
  },
  float = {
    keybind = "<A-S-i>",
    count = 99999,
    name = "floating",
  },
}

M.toggleterm_all_keys = {
  toggleterm_modes.horizontal.keybind,
  toggleterm_modes.vertical.keybind,
  toggleterm_modes.float.keybind,
}

M.bind_toggleterm = function()
  local original
  local terms = {}
  for mode, settings in pairs(toggleterm_modes) do
    -- in ANY terminal, if you press ANY toggleterm keybind, term will close
    -- and refocus prev win if possible
    map("t", settings.keybind, function()
      vim.cmd.close()
      -- on_close fires
    end, { desc = "Close terminal and restore focus" })

    -- =======================================================================

    terms[settings.name] = terms[settings.name]
      or require("toggleterm.terminal").Terminal:new({
        count = settings.count,
        direction = mode,
        display_name = "", -- using winbar for name
        on_close = vim.schedule_wrap(function()
          if original then
            vim.api.nvim_set_current_win(original)
            original = nil
          end
          vim.cmd.doautocmd("WinLeave")
        end),
        winbar = settings.winbar,
      })

    emap("n", settings.keybind, function()
      if vim.bo.buftype ~= "terminal" then
        original = vim.api.nvim_get_current_win()
      end
      local size = settings.sizefn and settings.sizefn() or 15
      terms[settings.name]:toggle(size, mode)
    end, { desc = "Open a " .. mode .. " terminal" })
  end
end

-- ===========================================================================
-- Plugin: treesj
-- ===========================================================================

M.treesj = "gs"
M.bind_treesj = function()
  map("n", M.treesj, function()
    require("treesj").toggle()
  end, { desc = "Toggle treesitter split / join", silent = true })
end

-- =============================================================================
-- Plugin: treewalker
-- =============================================================================

M.bind_treewalker = function()
  local tw = require("treewalker")
  map("n", "<A-Down>", tw.move_down, { noremap = true })
  map("n", "<A-Left>", tw.move_out, { noremap = true })
  map("n", "<A-Right>", tw.move_in, { noremap = true })
  map("n", "<A-Up>", tw.move_up, { noremap = true })
end

-- ===========================================================================
-- Plugin: tw-values.nvim
-- ===========================================================================

M.twvalues = "<Leader>tw"
M.bind_twvalues = function()
  map("n", M.twvalues, "<Cmd>TWValues<CR>", {
    desc = "Show tailwind CSS values",
  })
end

-- ===========================================================================
-- Plugin: urlview.nvim
-- ===========================================================================

M.urlview = {
  menu = "<A-u>",
  prev = "[u",
  next = "]u",
}

M.bind_urlview = function()
  require("urlview").setup({
    jump = {
      prev = M.urlview.prev,
      next = M.urlview.next,
    },
  })
  map("n", M.urlview.menu, "<Cmd>UrlView<CR>", { desc = "Open URLs" })
end

-- ===========================================================================
-- Plugin: yanky.nvim
-- ===========================================================================

M.bind_yanky = function()
  map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", {
    desc = "yanky put after",
  })
  map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", {
    desc = "yanky put before",
  })
  map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", {
    desc = "yanky gput after",
  })
  map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", {
    desc = "yanky gput before",
  })
  map("n", "<c-n>", "<Plug>(YankyPreviousEntry)", {
    desc = "yanky previous entry",
  })
  map("n", "<c-p>", "<Plug>(YankyNextEntry)", {
    desc = "yanky next entry backward",
  })
end

-- ===========================================================================
-- Plugin: zoomwintab.vim
-- ===========================================================================

M.zoomwintab = {
  "<C-w>o",
  "<C-w><C-o>",
}

-- ===========================================================================

-- ===========================================================================
-- Plugin: neotest.vim
-- ===========================================================================

M.bind_neotest = function()
  local neotest = require("neotest")

  map("n", "<leader>tfr", function()
    neotest.run.run(vim.fn.expand("%"))
  end, { desc = "Run test file" })

  map("n", "<leader>tr", function()
    neotest.run.run()
    neotest.summary.open()
  end, { desc = "Run all tests" })

  map("n", "<leader>to", function()
    neotest.output.open({ last_run = true, enter = true })
  end, { desc = "Open test output" })

  map("n", "<leader>tt", function()
    neotest.summary.toggle()
  end, { desc = "Toggle test summary" })

  map("n", "<leader>tl", function()
    neotest.run.run_last({ enter = true })
    neotest.output.open({ last_run = true, enter = true })
  end, { desc = "Run last test and open output" })
end

-- ===========================================================================-

return M
