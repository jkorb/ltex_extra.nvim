# Neovim - Code actions docs

```lua
-- Selects a code action available at the current cursor position.
vim.lsp.buf.code_action({options})*
```

- {options} (table|nil):           Optional table which holds the following optional fields:
    - context (table|nil):         Corresponds to `CodeActionContext` of the LSP specification:
        - diagnostics (table|nil): LSP`Diagnostic[]`. Inferred from the current position if not provided.
        - only (table|nil):        List of LSP `CodeActionKind`s used to filter the code actions. Most language servers support values like `refactor` or `quickfix`.
    - filter (function|nil):       Predicate taking a `CodeAction` and returning a boolean.
    - apply (boolean|nil):         When set to `true`, and there is just one remaining action (after filtering), the action is applied without user query.
    - range (table|nil):           Range for which code actions should be requested. If in visual mode this defaults to the active selection. Table must contain `start` and `end` keys with {row, col} tuples using mark-like indexing. See |api-indexing|

# LTeX - VScode ltex settings

```json
{ "key": "ctrl+alt+p",
    "command": "editor.action.codeAction",
    "args": {
        "kind": "quickfix.ltex.acceptSuggestions"
    }
}
```

# LTeX - List of code actions
- quickfix.ltex.acceptSuggestions:  Replace the text of the diagnostic with the specified suggestion.
- quickfix.ltex.addToDictionary:    Trigger the _ltex.addToDictionary command.
- quickfix.ltex.disableRules:       Trigger the _ltex.disableRules command.
- quickfix.ltex.hideFalsePositives: Trigger the _ltex.hideFalsePositives command.


# Testeando

```lua
vim.lsp.buf.code_action {
    contex = {
        diagnostics = {},
        only = { "quickfix.ltex.acceptSuggestions" }
    },
    filter = {},
    apply = true,
    range = {}
}

ldo lua vim.lsp.buf.code_action { contex={only={"quickfix.ltex.acceptSuggestions"}}, apply= true }
```
