return {
    {
        "folke/flash.nvim",
        keys = {
            {
                "<Leader>f",
                mode = {
                    "n",
                },
                function()
                    require("flash").jump({
                        search = {
                            multi_window = false,
                            forward = true,
                            wrap = false,
                        },
                    })
                end,
            },

            {
                "<Leader>F",
                mode = {
                    "n",
                },
                function()
                    require("flash").jump({
                        search = {
                            multi_window = false,
                            forward = false,
                            wrap = false,
                        },
                    })
                end,
            },
        },
        opts = {
            modes = {
                search = {
                    enabled = false,
                },

                char = {
                    enabled = false,
                    jump_labels = true,
                },
            },
        },
    },
}
