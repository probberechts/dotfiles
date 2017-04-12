#  (n)vim config

## Installation
Best used with rest of dotfiles. Should self-install plugins via curl and vim-plug on first load.

### Python settings

* Using pyenv install python 3+.
* Set up a virtualenv using pyenv-virtualenv: `pyenv virtualenv neovim3`
* Activate the virtualenv: `pyenv activate neovim3`
* `pip install neovim` in the virtualenv
* `pip install jedi` for python completion in the virtualenv
*  You can now switch back to whatever python (pyenv deactivate) you want, init.vim for neovim startup is already configured to find the neovim3 virtualenv
* `:UpdateRemotePlugins` if installing/upgrading python-based plugins like deoplete
* `:CheckHealth` to see if the python3 setup and plugins are working. iTerm should use xterm-256color-italic terminfo if the backspace message is there.
