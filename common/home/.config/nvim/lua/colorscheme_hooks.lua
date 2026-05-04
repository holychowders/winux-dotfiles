local transparent = {
    ["couleurs"]                  = true,
    ["desert-night"]              = true,

    ["friffle"]                   = true,
    ["srcery"]                    = true,

    ["gruvbox-material"]          = true,
    ["mine-pine"]                 = true,
    ["mine-pine-main"]            = true,
    ["gruvbox"]                   = true,

    ["endarkened"]                = true,
    ["mfd-flir"]                  = true,
    ["mfd-blackout"]              = true,
    ["quiet"]                     = true,

    ["mfd-amber"]                 = true,
    ["mfd-lumon"]                 = true,
    ["mfd-scarlet"]               = true,
}

local function apply_transparency()
    vim.api.nvim_set_hl(0, "Normal",      { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC",    { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn",  { bg = "none" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function(args)
        if transparent[args.match] then
            apply_transparency()
        end
    end,
})
