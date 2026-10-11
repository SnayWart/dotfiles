-- =============================================================================
-- MODULE: WINDOW & LAYER RULES (Правила окон и слоев)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. СИСТЕМНЫЕ ПРАВИЛА И ОПТИМИЗАЦИИ
-- -----------------------------------------------------------------------------
-- Подавление запросов максимизации от сторонних приложений
hl.window_rule({
    name = "suppress-maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Исправление перетаскивания и всплывающих подсказок в XWayland
hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- -----------------------------------------------------------------------------
-- 2. ПЛАВАЮЩИЕ ОКНА (FLOAT RULES)
-- -----------------------------------------------------------------------------
local floating_apps = {
    -- Управление звуком и сетью
    "org.pulseaudio.pavucontrol",
    "pavucontrol",
    "nm-connection-editor",
    "blueman-manager",

    -- Утилиты файлов и дисков
    "thunar-progress",
    "file-roller",
    "isoimagewriter",

    -- Просмотрщики медиа
    "imv",
    "feh",
    "mpv",

    -- Настройки тем и шрифтов
    "qt6ct",
    "qt5ct",
    "kvantummanager",
    "nwg-look",

    -- Системные лаунчеры
    "hyprland-run",
    "xdg-desktop-portal-gtk",
}

for _, cls in ipairs(floating_apps) do
    hl.window_rule({
        name = "float-" .. cls,
        match = { class = cls },
        float = true,
    })
end

-- Диалоговые окна открытия, сохранения и подтверждения (EN & RU)
hl.window_rule({
    name = "float-dialog-windows",
    match = {
        title = "^(Open|Save|Choose|Select|Confirm|File Operation|Открыть|Сохранить|Выбрать|Подтверждение).*",
    },
    float = true,
    center = true,
})

-- Экранный пикер захвата Hyprland
hl.window_rule({
    name = "float-share-picker",
    match = { class = "^hyprland-share-picker$" },
    float = true,
    center = true,
})

-- Диалоги настроек и свойств OBS
hl.window_rule({
    name = "float-obs-dialogs",
    match = {
        class = "^com.obsproject.Studio$",
        title = "^(Properties|Filter|Filters|Select|Settings|Свойства|Фильтры|Настройки).*",
    },
    float = true,
    center = true,
})

-- Центрирование плавающих окон настроек
hl.window_rule({
    name = "center-floating-settings",
    match = {
        class = "pavucontrol|nm-connection-editor|nwg-look|qt6ct|blueman-manager",
    },
    center = true,
})

-- -----------------------------------------------------------------------------
-- 3. СПЕЦИАЛЬНЫЕ ПРАВИЛА ДЛЯ ПРИЛОЖЕНИЙ
-- -----------------------------------------------------------------------------
-- Терминал Kitty: четкий текст при сохранении нативной полупрозрачности фона
hl.window_rule({
    name = "kitty-opacity",
    match = { class = "^kitty$" },
    opacity = 1.0,
})

-- Видеопроигрыватель MPV: предотвращение сна экрана во время просмотра
hl.window_rule({
    name = "mpv-inhibit-idle",
    match = { class = "^mpv$" },
    idle_inhibit = "focus",
})

-- Браузер Firefox: отключение сна экрана при просмотре полноэкранного видео
hl.window_rule({
    name = "firefox-fullscreen-idle",
    match = { class = "^firefox$", fullscreen = true },
    idle_inhibit = "always",
})

-- Roblox (Sober): предотвращение сна экрана во время игры
hl.window_rule({
    name = "sober-idle-inhibit",
    match = { class = "org.vinegarhq.Sober" },
    idle_inhibit = "focus",
})

-- -----------------------------------------------------------------------------
-- 4. LAYER RULES (Аппаратный блюр и тени для слоев интерфейса)
-- -----------------------------------------------------------------------------
-- Панель Waybar
hl.layer_rule({
    name = "blur-waybar",
    match = { namespace = "^waybar$" },
    blur = true,
    blur_popups = true,
    ignore_alpha = 0.2,
})

-- Меню приложений Rofi
hl.layer_rule({
    name = "blur-rofi",
    match = { namespace = "^rofi$" },
    blur = true,
    ignore_alpha = 0.2,
})

-- Уведомления Mako
hl.layer_rule({
    name = "blur-mako",
    match = { namespace = "^mako$" },
    blur = true,
    ignore_alpha = 0.2,
})

-- Меню питания Wlogout
hl.layer_rule({
    name = "blur-wlogout",
    match = { namespace = "^wlogout$" },
    blur = true,
})
