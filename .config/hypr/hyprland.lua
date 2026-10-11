-- =============================================================================
-- HYPRLAND MAIN CONFIGURATION (Modular Lua Architecture)
-- System: Artix Linux (OpenRC) | GPU: AMD Radeon RX 6400
-- Theme: Autumn Kemono (Золотая Осень / Кемоно Момидзи)
-- =============================================================================

-- 1. Загрузка активной темы (Сезонный автодиспатчер)
local theme = require("themes.init").current

-- 2. Подключение аппаратных и базовых модулей
require("modules.monitors")
require("modules.env")
require("modules.animations")
require("modules.rules")
require("modules.binds")
require("modules.autoworkspace")

-- 3. Автостарт системных служб и фоновых демонов
hl.exec_cmd("/home/snaywart/.config/hypr/scripts/launch_daemons.sh")

-- 4. Главные параметры ядра Hyprland
hl.config({
    general = {
        gaps_in          = theme.decorations.gaps_in,
        gaps_out         = theme.decorations.gaps_out,
        border_size      = theme.decorations.border_size,
        col = {
            active_border   = theme.decorations.active_border,
            inactive_border = theme.decorations.inactive_border,
        },
        resize_on_border = true,
        hover_icon_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = theme.decorations.rounding,
        rounding_power = theme.decorations.rounding_power,

        active_opacity     = theme.decorations.active_opacity,
        inactive_opacity   = theme.decorations.inactive_opacity,
        fullscreen_opacity = theme.decorations.fullscreen_opacity,

        shadow = theme.decorations.shadow,
        blur   = theme.decorations.blur,
    },

    dwindle = {
        preserve_split = true,
        force_split    = 2,
    },

    master = {
        new_status = "master",
    },

    misc = {
        disable_hyprland_logo   = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
        vrr                     = 0,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms  = true,
        animate_manual_resizes  = true,
        animate_mouse_windowdragging = true,
        focus_on_activate       = true,
    },

    input = {
        kb_layout    = "us,ru",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "grp:alt_shift_toggle",
        kb_rules     = "",

        follow_mouse = 1,
        sensitivity  = 0,
        accel_profile = "flat",

        touchpad = {
            natural_scroll = true,
        },
    },

    cursor = {
        no_hardware_cursors = false,
        enable_hyprcursor   = true,
        hide_on_key_press   = false,
    },
})
