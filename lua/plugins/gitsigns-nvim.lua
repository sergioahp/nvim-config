return {
  "https://github.com/lewis6991/gitsigns.nvim",
  opts = {
    on_attach = function(bufnr)
      local gitsigns = require('gitsigns')

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({']c', bang = true})
        else
          gitsigns.nav_hunk('next')
        end
      end, { desc = 'Gitsigns: next hunk' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({'[c', bang = true})
        else
          gitsigns.nav_hunk('prev')
        end
      end, { desc = 'Gitsigns: previous hunk' })

      -- Actions
      map('n', '<leader>hs', gitsigns.stage_hunk,
        { desc = 'Gitsigns: stage hunk' })
      map('n', '<leader>hr', gitsigns.reset_hunk,
        { desc = 'Gitsigns: reset hunk' })

      map('v', '<leader>hs', function()
        gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end,
        { desc = 'Gitsigns: stage selected hunk' })

      map('v', '<leader>hr', function()
        gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end,
        { desc = 'Gitsigns: reset selected hunk' })

      map('n', '<leader>hS', gitsigns.stage_buffer,
        { desc = 'Gitsigns: stage buffer' })
      map('n', '<leader>hR', gitsigns.reset_buffer,
        { desc = 'Gitsigns: reset buffer' })
      map('n', '<leader>hp', gitsigns.preview_hunk,
        { desc = 'Gitsigns: preview hunk' })
      map('n', '<leader>hi', gitsigns.preview_hunk_inline,
        { desc = 'Gitsigns: preview hunk inline' })

      map('n', '<leader>hb', function()
        gitsigns.blame_line({ full = true })
      end,
        { desc = 'Gitsigns: blame line (full)' })

      map('n', '<leader>hd', gitsigns.diffthis,
        { desc = 'Gitsigns: diff against index' })

      map('n', '<leader>hD', function()
        gitsigns.diffthis('~')
      end,
        { desc = 'Gitsigns: diff against last commit' })

      map('n', '<leader>hQ', function()
        gitsigns.setqflist('all')
      end,
        { desc = 'Gitsigns: quickfix all hunks' })
      map('n', '<leader>hq', gitsigns.setqflist,
        { desc = 'Gitsigns: quickfix buffer hunks' })

      -- Toggles (moved from <leader>t* to <leader>h*)
      map('n', '<leader>ht', gitsigns.toggle_current_line_blame,
        { desc = 'Gitsigns: toggle current line blame' })
      map('n', '<leader>hw', gitsigns.toggle_word_diff,
        { desc = 'Gitsigns: toggle word diff' })

      -- Text object
      map({'o', 'x'}, 'ih', gitsigns.select_hunk,
        { desc = 'Gitsigns: select hunk' })
    end
  }
}
