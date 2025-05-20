# Prerequisites

0. Install [nvim](https://github.com/neovim/neovim/blob/master/INSTALL.md) *>= 0.11.x* version
1. Install [ripgrep](https://www.linode.com/docs/guides/ripgrep-linux-installation/) (for telescope)
2. Install [nvm](https://github.com/nvm-sh/nvm) (for dap installation, tested on node@22)
3. [Optional, if you use wayland] Sync nvim clipboard with OS `sudo apt install wl-clipboard` (use ':check clipboard' for more information)
4. Install lsp servers (or just remove unused lsp from lsp folder):
    - npm i -g typescript-language-server typescript
    - brew install lua-language-server (or download binary from [here](https://github.com/LuaLS/lua-language-server/releases))
> All lsp servers located [here](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md)
