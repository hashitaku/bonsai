return {
    {
        "ray-x/lsp_signature.nvim",
        enabled = not vim.g.vscode,
        opts = {
            -- どれぐらいのsignature_helpの大きさになると困るのか不明なため大きな値にする
            max_width = 1000,
            max_height = 1000,
            wrap = false,
            hint_enable = false,
            hint_prefix = {
                above = "󱞢 ", -- f17a2
                current = "󰜱 ", -- f0731
                below = "󱞾 ", -- f17be
            },
        },
    },
}
