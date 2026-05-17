# nvim-treesitter master -> main migration

Tracking the migration from the archived `master` branch of `nvim-treesitter`
and `nvim-treesitter-textobjects` to their `main` branches.

Why: nvim-treesitter master is archived (May 2025). On nvim 0.12 the
`set-lang-from-info-string!` directive in the master branch breaks because
`match[capture_id]` now returns `TSNode[]` rather than `TSNode`, which makes
markdown files with fenced code blocks throw
`attempt to call method 'range' (a nil value)` from the treesitter highlighter.

Legend:
- [x] confirmed working after migration
- [ ] yet to check, but known to exist in current config
- [N/A] feature removed or no longer applicable
- [?] uncertain / needs investigation

## Core nvim-treesitter

- [x] CLAUDE.md (markdown with fenced code blocks) opens without error
- [x] parser install (`require('nvim-treesitter').install({...})`) -- 22 parsers
  built into `~/.local/share/nvim/site/parser/` via headless run
- [x] highlight on opened buffers (`vim.treesitter.start` via FileType autocmd)
- [ ] indent (`vim.bo.indentexpr = ... 'nvim-treesitter'.indentexpr() ...`)
- [ ] `:TSUpdate` works (requires `tree-sitter` cli on PATH; cli added to
  home-manager, parsers download succeeds; rebuild flow not yet exercised
  end-to-end)
- [ ] foldexpr via `v:lua.vim.treesitter.foldexpr()` (builtin, untouched)
- [x] `vim.treesitter.language.register("markdown", "octo")` (kept in
  nvim-treesitter.lua)
- [N/A] `incremental_selection` module -- replaced by builtin keymaps `[n`,
  `]n`, `an`, `in` (visual/operator pending mode). Custom mappings
  `<leader>i` / `<leader>I` / `<leader>ts` are lost; re-bind if wanted by
  calling `vim.treesitter._select.select_parent/child/next/prev`.
- [N/A] `auto_install`, `sync_install`, `additional_vim_regex_highlighting`
  toggle (config knobs no longer exist on main)

## nvim-treesitter-textobjects

Select (visual + operator pending):
- [ ] `ik` / `ak` -> @class.inner / @class.outer
- [ ] `ig` / `ag` -> @comment.inner / @comment.outer
- [ ] `if` / `af` -> @call.inner / @call.outer
- [ ] `im` / `am` -> @function.inner / @function.outer
- [ ] `iv` / `av` -> @loop.inner / @loop.outer
- [ ] `ir` / `ar` -> @parameter.inner / @parameter.outer
- [ ] `ij` / `aj` -> @conditional.inner / @conditional.outer
- [ ] `iz`       -> @assignment.inner
- [ ] `iu`       -> @number.inner

Swap (with `<leader>d` next inner, `<leader>D` prev inner,
       `<leader>s` next outer, `<leader>S` prev outer; plus z/u nonpaired):
- [ ] all paired letters (k g f m v r j)
- [ ] nonpaired (z, u)

Move:
- [ ] `]<letter>` / `[<letter>`  next/prev start (outer textobject)
- [ ] `]<LETTER>` / `[<LETTER>`  next/prev end (outer textobject)
- [ ] `]y` / `[y`                next/prev fold (folds query)

Repeatable move (built into textobjects, must keep working):
- [ ] `;` repeat last move
- [ ] `,` repeat last move opposite
- [ ] `f` / `F` / `t` / `T` repeatable variants

## Related

- [ ] `mini.ai` (`lua/plugins/mini-ai.lua`) still resolves treesitter queries
  via `mini_ai.gen_spec.treesitter({...})` (uses nvim-treesitter-textobjects
  queries indirectly)
- [ ] avante.nvim still loads (declares `nvim-treesitter` as a dependency
  in `lua/plugins/avante-nvim.lua`)

## Notes / decisions

- Existing compiled parsers under
  `~/.local/share/nvim/lazy/nvim-treesitter/parser/` remain on `runtimepath`
  so highlight keeps working during the migration without reinstalling.
- `tree-sitter` cli is needed for `:TSUpdate` and fresh installs; not in
  $PATH yet. `nix shell nixpkgs#tree-sitter` for ad-hoc use; permanent fix
  is to add it to home-manager / configuration.nix (not done here).
