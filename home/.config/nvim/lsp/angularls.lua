local root_markers = {
    "angular.json",
    ".git",
}
local root_dir = vim.fs.root(0, root_markers)

---@type vim.lsp.Config
return {
    cmd = {
        "ngserver",
        "--stdio",
        "--tsProbeLocations",
        root_dir,
        "--ngProbeLocations",
        root_dir,
    },
    filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" },
    root_markers = root_markers,
}
