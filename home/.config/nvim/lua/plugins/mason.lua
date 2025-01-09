return {
    {
        "williamboman/mason.nvim",
        opts = {
            ui = {
                border = "rounded",
                width = 0.5,
                height = 0.5,
            },
        },
    },

    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                "ts_ls",
                "html",
                "cssls",
                "angularls",
                "powershell_es",
            },
        },
    },
}
