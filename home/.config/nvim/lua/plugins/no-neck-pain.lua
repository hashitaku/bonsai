return {
    "shortcuts/no-neck-pain.nvim",
    cond = not vim.g.vscode,
    cmd = {
        "NoNeckPain",
        "NoNeckPainResize",
        "NoNeckPainToggleLeftSide",
        "NoNeckPainToggleRightSide",
        "NoNeckPainWidthUp",
        "NoNeckPainWidthDown",
        "NoNeckPainScratchPad",
    },
    opts = {
        -- コードが表示されている幅が100であってほしいため少し大きい数を指定
        width = 105,
    },
}
