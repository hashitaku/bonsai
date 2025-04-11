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
        -- dependencies = {
        --     "williamboman/mason.nvim",
        -- },
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
