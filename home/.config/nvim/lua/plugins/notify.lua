return {
    {
        "rcarriga/nvim-notify",
        cond = not vim.g.vscode,
        opts = {
            fps = 120,
            render = "simple",
            stages = "slide",
        },
    },
}
