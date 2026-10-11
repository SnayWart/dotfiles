-- =============================================================================
-- THEME: AUTUMN KEMONO (Золотая Осень / Кемоно Момидзи)
-- Автор: snaywart & Antigravity
-- Сезон: Осень (Сентябрь - Ноябрь)
-- Описание: Уютная янтарно-золотая палитра с кленовыми и древесными акцентами
-- =============================================================================
local M = {}

M.meta = {
    name        = "Autumn Kemono",
    author      = "snaywart & Antigravity",
    season      = "Autumn",
    palette     = "Momiji Warm Amber",
    description = "Теплая янтарно-золотая палитра с багряными кленовыми акцентами в стиле фурри-кемоно",
    version     = "2.0.0",
}

-- -----------------------------------------------------------------------------
-- 1. ЦВЕТОВАЯ ПАЛИТРА (HEX & RGBA)
-- -----------------------------------------------------------------------------
M.colors = {
    -- Глубокие древесные и угольные фоны (Backgrounds)
    bg_solid       = "#140f0c",
    bg_pure        = "#0d0a08",
    bg             = "rgba(140f0cee)",
    bg_glass       = "rgba(1f1714cc)",
    bg_alt         = "#241a15",
    bg_card        = "#2e211b",
    bg_hover       = "#3d2b23",

    -- Текстовые градации (Foreground & Typography)
    fg             = "#fcefe6",
    fg_dim         = "#cfb29e",
    fg_subtle      = "#8f7665",
    fg_muted       = "#5a483d",

    -- Теплые осенние акценты (Seasonal Accents)
    gold           = "#e6a73c",
    gold_glow      = "rgba(e6a73cee)",
    amber          = "#d86b27",
    amber_glow     = "rgba(d86b27ee)",
    crimson        = "#be382f",
    crimson_glow   = "rgba(be382fee)",
    moss           = "#8ea559",
    river          = "#688ca6",
    plum           = "#b8647c",
    sunset         = "#f5bc56",

    -- Границы активных и неактивных окон (Borders)
    active_border_1   = "rgba(e6a73cff)",
    active_border_2   = "rgba(d86b27ff)",
    active_border_3   = "rgba(be382fff)",
    inactive_border   = "rgba(382820aa)",
    
    -- Тени (Shadows)
    shadow_color      = 0x770a0705,
}

-- -----------------------------------------------------------------------------
-- 2. ГЕОМЕТРИЯ И ДЕКОРАЦИИ ОКОН
-- -----------------------------------------------------------------------------
M.decorations = {
    -- Отступы
    gaps_in        = 6,
    gaps_out       = 14,
    border_size    = 2,

    -- Скругления
    rounding       = 16,
    rounding_power = 2,

    -- Границы
    active_border = {
        colors = { M.colors.active_border_1, M.colors.active_border_2, M.colors.active_border_3 },
        angle  = 45,
    },
    inactive_border = M.colors.inactive_border,

    -- Прозрачности
    active_opacity     = 0.97,
    inactive_opacity   = 0.88,
    fullscreen_opacity = 1.0,

    -- Аппаратное размытие (Dual-Kawase Blur)
    blur = {
        enabled           = true,
        size              = 8,
        passes            = 3,
        vibrancy          = 0.25,
        vibrancy_darkness = 0.15,
        new_optimizations = true,
        xray              = false,
        noise             = 0.015,
        special           = true,
        popups            = true,
    },

    -- Глубокие тени
    shadow = {
        enabled      = true,
        range        = 22,
        render_power = 4,
        color        = M.colors.shadow_color,
    },
}

-- -----------------------------------------------------------------------------
-- 3. ПАРАМЕТРЫ СТОРОННИХ УТИЛИТ (Rofi, Waybar, Mako, Cava)
-- -----------------------------------------------------------------------------
M.apps = {
    rofi = {
        font          = "JetBrainsMono Nerd Font 11",
        border_radius = 20,
        icon_theme    = "Papirus",
    },
    waybar = {
        width         = 66,
        margin_left   = 10,
        margin_top    = 12,
        margin_bottom = 12,
        border_radius = 22,
    },
    mako = {
        font          = "JetBrainsMono Nerd Font 10",
        border_radius = 16,
        timeout       = 5000,
    },
    kitty = {
        font_size     = 11.5,
        opacity       = 0.88,
        padding       = 14,
    }
}

-- Обои по умолчанию
M.wallpaper = "/home/snaywart/.config/hypr/wallpapers/autumn_kemono.jpg"

return M
