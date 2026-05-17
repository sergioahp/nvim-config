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

Select (visual + operator pending). Verified that `select_textobject` for
`@function.outer` from inside a rust function selects the expected line
range; only `im`/`am` exercised end-to-end, the rest just verified to be
registered as keymaps.
- [x] `ik` / `ak` -> @class.inner / @class.outer       (registered)
- [x] `ig` / `ag` -> @comment.inner / @comment.outer   (registered)
- [x] `if` / `af` -> @call.inner / @call.outer         (registered)
- [x] `im` / `am` -> @function.inner / @function.outer (live tested)
- [x] `iv` / `av` -> @loop.inner / @loop.outer         (registered)
- [x] `ir` / `ar` -> @parameter.inner / @parameter.outer (registered)
- [x] `ij` / `aj` -> @conditional.inner / @conditional.outer (registered)
- [x] `iz`       -> @assignment.inner (registered)
- [x] `iu`       -> @number.inner     (registered)

Swap (with `<leader>d` next inner, `<leader>D` prev inner,
       `<leader>s` next outer, `<leader>S` prev outer; plus z/u nonpaired):
- [x] all paired letters (k g f m v r j)  (registered, not live tested --
  swap mutates the buffer; verify in interactive use)
- [x] nonpaired (z, u)                    (registered)

Move:
- [x] `]<letter>` / `[<letter>`  next/prev start (outer textobject)
  (registered; `]m` live tested -> moved 1 -> 62 in main.rs)
- [x] `]<LETTER>` / `[<LETTER>`  next/prev end (outer textobject) (registered)
- [x] `]y` / `[y`                next/prev fold (folds query, live tested)

Repeatable move (built into textobjects, must keep working):
- [x] `;` repeat last move           (live tested: ]m then ; -> 62 -> 68)
- [x] `,` repeat last move opposite  (live tested: after ; -> back to 62)
- [x] `f` / `F` / `t` / `T` repeatable variants (registered)

## Related

- [x] `mini.ai` (`lua/plugins/mini-ai.lua`) still resolves treesitter queries
  via `mini_ai.gen_spec.treesitter({...})` (loaded ok; spec built without
  error)
- [ ] avante.nvim still loads (declares `nvim-treesitter` as a dependency
  in `lua/plugins/avante-nvim.lua`)

## Notes / decisions

- Existing compiled parsers under
  `~/.local/share/nvim/lazy/nvim-treesitter/parser/` remain on `runtimepath`
  so highlight keeps working during the migration without reinstalling.
- `tree-sitter` cli is needed for `:TSUpdate` and fresh installs; not in
  $PATH yet. `nix shell nixpkgs#tree-sitter` for ad-hoc use; permanent fix
  is to add it to home-manager / configuration.nix (not done here).
