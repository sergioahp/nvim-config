return {
  'tummetott/unimpaired.nvim',
  opts = {
    default_keymaps = false,
    keymaps = {
      -- Line manipulation
      blank_above = {
        mapping = '[<Space>',
        description = 'Add [count] blank lines above',
        dot_repeat = true,
      },
      blank_below = {
        mapping = ']<Space>',
        description = 'Add [count] blank lines below',
        dot_repeat = true,
      },

      -- Option toggling
      toggle_background = {
        mapping = 'yob',
        description = 'Toggle background',
        dot_repeat = false,
      },
      toggle_cursorline = {
        mapping = 'yoc',
        description = 'Toggle cursorline',
        dot_repeat = false,
      },
      toggle_diff = {
        mapping = 'yod',
        description = 'Toggle diff',
        dot_repeat = false,
      },
      toggle_hlsearch = {
        mapping = 'yoh',
        description = 'Toggle hlsearch',
        dot_repeat = false,
      },
      toggle_ignorecase = {
        mapping = 'yoi',
        description = 'Toggle ignorecase',
        dot_repeat = false,
      },
      toggle_list = {
        mapping = 'yol',
        description = 'Toggle invisible characters (listchars)',
        dot_repeat = false,
      },
      toggle_number = {
        mapping = 'yon',
        description = 'Toggle line numbers',
        dot_repeat = false,
      },
      toggle_relativenumber = {
        mapping = 'yor',
        description = 'Toggle relative numbers',
        dot_repeat = false,
      },
      toggle_spell = {
        mapping = 'yos',
        description = 'Toggle spell check',
        dot_repeat = false,
      },
      toggle_colorcolumn = {
        mapping = 'yot',
        description = 'Toggle colorcolumn',
        dot_repeat = false,
      },
      toggle_cursorcolumn = {
        mapping = 'you',
        description = 'Toggle cursorcolumn',
        dot_repeat = false,
      },
      toggle_virtualedit = {
        mapping = 'yov',
        description = 'Toggle virtualedit',
        dot_repeat = false,
      },
      toggle_wrap = {
        mapping = 'yow',
        description = 'Toggle line wrapping',
        dot_repeat = false,
      },
      toggle_cursorcross = {
        mapping = 'yox',
        description = 'Toggle cursorcross',
        dot_repeat = false,
      },

      -- Enable/disable variants for completeness
      enable_background = {
        mapping = '[ob',
        description = 'Set background to light',
        dot_repeat = false,
      },
      disable_background = {
        mapping = ']ob',
        description = 'Set background to dark',
        dot_repeat = false,
      },
      enable_cursorline = {
        mapping = '[oc',
        description = 'Enable cursorline',
        dot_repeat = false,
      },
      disable_cursorline = {
        mapping = ']oc',
        description = 'Disable cursorline',
        dot_repeat = false,
      },
      enable_diff = {
        mapping = '[od',
        description = 'Enable diff',
        dot_repeat = false,
      },
      disable_diff = {
        mapping = ']od',
        description = 'Disable diff',
        dot_repeat = false,
      },
      enable_hlsearch = {
        mapping = '[oh',
        description = 'Enable hlsearch',
        dot_repeat = false,
      },
      disable_hlsearch = {
        mapping = ']oh',
        description = 'Disable hlsearch',
        dot_repeat = false,
      },
      enable_ignorecase = {
        mapping = '[oi',
        description = 'Enable ignorecase',
        dot_repeat = false,
      },
      disable_ignorecase = {
        mapping = ']oi',
        description = 'Disable ignorecase',
        dot_repeat = false,
      },
      enable_list = {
        mapping = '[ol',
        description = 'Show invisible characters (listchars)',
        dot_repeat = false,
      },
      disable_list = {
        mapping = ']ol',
        description = 'Hide invisible characters (listchars)',
        dot_repeat = false,
      },
      enable_number = {
        mapping = '[on',
        description = 'Enable line numbers',
        dot_repeat = false,
      },
      disable_number = {
        mapping = ']on',
        description = 'Disable line numbers',
        dot_repeat = false,
      },
      enable_relativenumber = {
        mapping = '[or',
        description = 'Enable relative numbers',
        dot_repeat = false,
      },
      disable_relativenumber = {
        mapping = ']or',
        description = 'Disable relative numbers',
        dot_repeat = false,
      },
      enable_spell = {
        mapping = '[os',
        description = 'Enable spell check',
        dot_repeat = false,
      },
      disable_spell = {
        mapping = ']os',
        description = 'Disable spell check',
        dot_repeat = false,
      },
      enable_colorcolumn = {
        mapping = '[ot',
        description = 'Enable colorcolumn',
        dot_repeat = false,
      },
      disable_colorcolumn = {
        mapping = ']ot',
        description = 'Disable colorcolumn',
        dot_repeat = false,
      },
      enable_cursorcolumn = {
        mapping = '[ou',
        description = 'Enable cursorcolumn',
        dot_repeat = false,
      },
      disable_cursorcolumn = {
        mapping = ']ou',
        description = 'Disable cursorcolumn',
        dot_repeat = false,
      },
      enable_virtualedit = {
        mapping = '[ov',
        description = 'Enable virtualedit',
        dot_repeat = false,
      },
      disable_virtualedit = {
        mapping = ']ov',
        description = 'Disable virtualedit',
        dot_repeat = false,
      },
      enable_wrap = {
        mapping = '[ow',
        description = 'Enable line wrapping',
        dot_repeat = false,
      },
      disable_wrap = {
        mapping = ']ow',
        description = 'Disable line wrapping',
        dot_repeat = false,
      },
      enable_cursorcross = {
        mapping = '[ox',
        description = 'Enable cursorcross',
        dot_repeat = false,
      },
      disable_cursorcross = {
        mapping = ']ox',
        description = 'Disable cursorcross',
        dot_repeat = false,
      },
    },
  },
}
