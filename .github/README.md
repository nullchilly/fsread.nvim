# fsread.nvim

Flow state reading in neovim

https://user-images.githubusercontent.com/56817415/203623326-b12af198-e1ec-49d2-a170-c314241a8864.mp4

## Installation

```lua
use "nullchilly/fsread.nvim"
```

## Usage

```vim
:FSRead " Flow state visual range
:FSClear " Clear all flow states
:FSToggle " Toggle flow state
```

## Config

```lua
vim.g.flow_strength = 0.7 -- low: 0.3, middle: 0.5, high: 0.7 (default)
vim.g.skip_flow_default_hl = true -- If you want to override default highlights
vim.api.nvim_set_hl(0, "FSPrefix", { fg = "#cdd6f4" })
vim.api.nvim_set_hl(0, "FSSuffix", { fg = "#6C7086" })
```

## Thanks to

[thatvegandev/fsrx](https://github.com/thatvegandev/fsrx)
[bionic-reading.com](https://bionic-reading.com/)
