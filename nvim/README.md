# nvim config

nvim config, crafted for **nightly builds only**! Configured in lua.

| Tool              | Link                          |
| ----------------- | ----------------------------- |
| Plugin manager    | [lazy.nvim]                   |
| Colorscheme       | [onedark]                     |
| Status/tab/winbar | [heirline]                    |
| LSP/tool manager  | [mason.nvim]                  |
| Local LSP         | [efm-langserver]              |
| File finder       | [telescope]                   |

## custom things

- all mappings in mappings.lua
- if using my wezterm config, `<C-S-t>` will toggle the terminal and neovim
  theme between light and dark mode.
- lsp/tool config is done in [dko/tools/](/nvim/lua/dko/tools)
  - lspconfig, efm, and null-ls all handled in one place
- formatting is handled in [dko/format.lua](/nvim/lua/dko/format.lua)
  - of note is a pipeline that can run eslint only, eslint and then
    prettier, or prettier only as needed

---

[lazy.nvim]: https://github.com/folke/lazy.nvim
[onedark]: https://github.com/davidosomething/vim-colors-meh
[mason.nvim]: https://github.com/williamboman/mason.nvim
[efm-langserver]: https://github.com/mattn/efm-langserver
[telescope]: https://github.com/nvim-telescope/telescope.nvim
[heirline]: https://github.com/rebelot/heirline.nvim
[zenbones]: https://github.com/mcchrish/zenbones.nvim
