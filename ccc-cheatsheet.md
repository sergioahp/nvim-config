# CCC.nvim Cheat Sheet

**C**reate **C**olor **C**ode - Color picker and highlighter for Neovim

## Commands

| Command | Description |
|---------|-------------|
| `:CccPick` | Pick/replace color under cursor (or insert if none detected) |
| `:CccConvert` | Convert color format directly without UI |
| `:CccHighlighterEnable` | Enable color highlighting in current buffer |
| `:CccHighlighterDisable` | Disable color highlighting |
| `:CccHighlighterToggle` | Toggle color highlighting |

## Your Custom Keymaps

| Keymap | Action |
|--------|--------|
| `<leader>C` | Toggle color highlighter on/off |

## UI Keymaps (Inside Color Picker)

### Basic Actions

| Key | Action | Description |
|-----|--------|-------------|
| `<CR>` | Complete | Accept and apply color |
| `q` | Quit | Cancel without applying |

### Mode Toggles

| Key | Action | Description |
|-----|--------|-------------|
| `i` | Cycle input mode | RGB → HSL → CMYK → ... |
| `o` | Cycle output mode | Change output format |
| `r` | Reset mode | Reset to defaults, hide alpha/prev colors |
| `a` | Toggle alpha | Show/hide transparency slider |
| `g` | Toggle prev colors | Show/hide previous colors palette |

### Slider Navigation (Vim-style)

| Key | Action | Description |
|-----|--------|-------------|
| `j` | Down | Move to next slider |
| `k` | Up | Move to previous slider |

### Value Adjustment

#### Increase Value
| Key | Amount | Description |
|-----|--------|-------------|
| `l` | +1 | Small increment |
| `d` | +5 | Medium increment |
| `,` | +10 | Large increment |

#### Decrease Value
| Key | Amount | Description |
|-----|--------|-------------|
| `h` | -1 | Small decrement |
| `s` | -5 | Medium decrement |
| `m` | -10 | Large decrement |

#### Set Absolute Value (Percentage)
| Key | Value | Description |
|-----|-------|-------------|
| `H` | 0% | Set to minimum |
| `M` | 50% | Set to middle |
| `L` | 100% | Set to maximum |
| `1`-`9` | 10%-90% | Set to specific percentage |

### Previous Colors Navigation

| Key | Action | Description |
|-----|--------|-------------|
| `w` | Next color | Go to next (right) color |
| `b` | Previous color | Go to previous (left) color |
| `W` | Last color | Jump to last color |
| `B` | First color | Jump to first color |

## Color Spaces Supported

- **RGB** - Red, Green, Blue
- **HSL** - Hue, Saturation, Lightness
- **HWB** - Hue, Whiteness, Blackness
- **Lab** - Lightness, a*, b*
- **LCH** - Lightness, Chroma, Hue
- **OKLab** - Improved Lab
- **OKLCH** - Improved LCH
- **CMYK** - Cyan, Magenta, Yellow, Key (Black)
- **HSLuv** - Human-friendly HSL
- **OKHSL** - Improved HSL

## Features

- ✨ Dynamic highlighting of color sliders
- 🎨 Live preview of color changes
- 📝 Supports CSS Color Module Level 4 formats
- 🔄 Seamless input/output mode switching
- 📜 Color history (previous colors palette)
- 🌈 Transparency (alpha) support
- 🔍 LSP integration for `textDocument/documentColor`

## Tips

- Use `j`/`k` to navigate sliders, `h`/`l` to adjust values (Vim-style)
- Press `i` repeatedly to cycle through different color spaces
- Press `g` to see your recently used colors
- Use numbers `1`-`9` for quick percentage jumps
- Press `a` to add/remove transparency control
