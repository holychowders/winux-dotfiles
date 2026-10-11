return {
    'saghen/blink.cmp',
    version = '*',
    opts = {
        keymap = { preset = 'default' },
        appearance = {
            nerd_font_variant = 'none',
        },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
            providers = {
                path = {
                    opts = { show_hidden_files_by_default = true },
                },
            },
        },
        completion = {
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
            },
        },
    },
}
