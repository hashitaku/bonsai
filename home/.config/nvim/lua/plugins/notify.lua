return {
    {
        "rcarriga/nvim-notify",
        enabled = not vim.g.vscode,
        opts = {
            fps = 120,
            render = "simple",
            stages = "slide",
        },
    },
}
