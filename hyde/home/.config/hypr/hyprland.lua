-- Hyprland loads this file when it is started without a config, and it prefers
-- it over hyprland.conf. HyDE loads it too, last, as the override layer below.
-- The block keeps the two apart: hyde.lua sets `hyde` on its first line, so it
-- runs only when this file is the entry point and HyDE has not been loaded.
-- Removing it leaves a session with a cursor and nothing else.
if not hyde then
    local share = os.getenv("XDG_DATA_HOME") or (os.getenv("HOME") .. "/.local/share")
    local entry = share .. "/hypr/hyde.lua"
    local handle = io.open(entry, "r")
    if not handle then
        error("HyDE is not installed at " .. entry .. ". Run install.sh -r, or point Hyprland at your own config.")
    end
    handle:close()
    dofile(entry)
end

-- Your Hyprland configuration. HyDE never overwrites this file.
--
-- It loads after HyDE's own binds, so settings here take precedence. Replacing
-- a bind needs more than that: see below. HyDE's defaults live in
-- ~/.local/share/hypr/lua/ and are overwritten on every update, so edits there
-- do not survive.
--
-- Adding a keybind:
--
--     hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(hyde.sh.gamelauncher()), {
--         description = "[Utilities] game launcher",
--     })
--
-- Replacing one of HyDE's: bind the same combination again and yours takes
-- over, but copy its flags across as well. A bind counts as the same one only
-- when its flags match, and `description` is not a flag — miss one and both
-- binds stay live on that combination. Copy the whole options table from
-- ~/.local/share/hypr/lua/key_binds.lua and change only what you need:
--
--     hl.bind("F9", hl.dsp.exec_cmd(hyde.sh.volumecontrol("-o", "m")), {
--         locked = true,
--         description = "[Hardware Controls|Audio] un/mute output",
--     })
--
-- Press SUPER + / to see what is actually loaded, your own binds included.
-- The full reference is KEYBINDINGS.md in the HyDE repository.
--
-- Other Lua files next to this one can be pulled in with require("name").

----------------------------------------------------------------------
-------- HolyChowders ------------------------------------------------
----------------------------------------------------------------------

hl.config({
    input = {
        sensitivity = 1.00,
        repeat_rate = 40,
        repeat_delay = 200,
        kb_options = "caps:swapescape",
        touchpad = {
            natural_scroll = true,
        },
    },
    decoration = {
        shadow = {
            enabled = false,
        },
    },
    general = {
        gaps_in = 2,
        gaps_out = 0,
        border_size = 1,
        col = {
            active_border = "rgba(f0f0f0ff)",
            inactive_border = "rgba(00000000)",
        },
    },
})

---------------------------------------------------------------------------
-- Enable/disable laptop screen when lid opened/closed
---------------------------------------------------------------------------
hl.bind("switch:on:Lid Switch", function()
    hl.monitor({ output = "eDP-1", disabled = true })
end, { locked = true })
hl.bind("switch:off:Lid Switch", function()
    hl.monitor({ output = "eDP-1", disabled = false })
end, { locked = true })

---------------------------------------------------------------------------
-- Override default with correct backlight for device
---------------------------------------------------------------------------
hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl -d intel_backlight set 5%+"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl -d intel_backlight set 5%-"),
    { locked = true, repeating = true }
)

---------------------------------------------------------------------------
-- Vim-style keybinds
---------------------------------------------------------------------------
local WIN_ADJUST_INC = 30

-- Vim-style window focus
hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))
hl.unbind("SUPER + K")
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))

-- Preserve displaced HyDE shortcuts
hl.bind("SUPER + ALT + J", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + ALT + K", hl.dsp.exec_cmd(hyde.sh.kb.switch()), { locked = true })
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd(hyde.sh.session.lock()))

-- Vim-style window resizing
hl.bind(
    "SUPER + SHIFT + H",
    hl.dsp.window.resize({ x = -WIN_ADJUST_INC, y = 0, relative = true }),
    { repeating = true }
)
hl.bind("SUPER + SHIFT + J", hl.dsp.window.resize({ x = 0, y = WIN_ADJUST_INC, relative = true }), { repeating = true })
hl.unbind("SUPER + SHIFT + K")
hl.bind(
    "SUPER + SHIFT + K",
    hl.dsp.window.resize({ x = 0, y = -WIN_ADJUST_INC, relative = true }),
    { repeating = true }
)
hl.bind("SUPER + SHIFT + L", hl.dsp.window.resize({ x = WIN_ADJUST_INC, y = 0, relative = true }), { repeating = true })
-- Rebind displaced calculator shortcut
hl.bind("SUPER + ALT + SHIFT + K", hl.dsp.exec_cmd(hyde.sh.menu.calculator()))

-- Vim-style tiled window repositioning
hl.bind("SUPER + CTRL + SHIFT + H", hl.dsp.window.move({ direction = "left" }), { repeating = true })
hl.bind("SUPER + CTRL + SHIFT + J", hl.dsp.window.move({ direction = "down" }), { repeating = true })
hl.bind("SUPER + CTRL + SHIFT + K", hl.dsp.window.move({ direction = "up" }), { repeating = true })
hl.bind("SUPER + CTRL + SHIFT + L", hl.dsp.window.move({ direction = "right" }), { repeating = true })

-- Vim-style floating window repositioning
hl.bind(
    "SUPER + CTRL + ALT + H",
    hl.dsp.window.move({ x = -WIN_ADJUST_INC, y = 0, relative = true }),
    { repeating = true }
)
hl.bind(
    "SUPER + CTRL + ALT + J",
    hl.dsp.window.move({ x = 0, y = WIN_ADJUST_INC, relative = true }),
    { repeating = true }
)
hl.bind(
    "SUPER + CTRL + ALT + K",
    hl.dsp.window.move({ x = 0, y = -WIN_ADJUST_INC, relative = true }),
    { repeating = true }
)
hl.bind(
    "SUPER + CTRL + ALT + L",
    hl.dsp.window.move({ x = WIN_ADJUST_INC, y = 0, relative = true }),
    { repeating = true }
)
