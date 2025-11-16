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
        cmd = {
            "Mason",
            "MasonLog",
            "MasonUpdate",
            "MasonInstall",
            "MasonUninstall",
            "MasonUninstallAll",
        },
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        opts = {
            automatic_enable = false,
            ensure_installed = {
                "angularls",
                "cssls",
                "html",
                "omnisharp",
                "powershell_es",
                "ts_ls",
            },
        },
    },
}
