---@type vim.lsp.Config
return {
    cmd = {
        "deno",
        "lsp",
    },
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },
    root_markers = {
        "deno.json",
        "deno.jsonc",
    },
    settings = {
        deno = {
            enable = true,
            suggest = {
                imports = {
                    hosts = {
                        ["https://deno.land"] = true,
                    },
                },
            },
            inlayHints = {
                parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = true },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true, suppressWhenTypeMatchesName = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enable = true },
                enumMemberValues = { enabled = true },
            },
        },
    },
}
