-- =============================================================================
-- MODULE: KEYBINDINGS & SHORTCUTS
-- =============================================================================
local mainMod = "SUPER"
local terminal = "kitty"
local fileManager = "thunar"
local menu = "rofi -show drun"
local scripts = "/home/snaywart/.config/hypr/scripts"

-- -----------------------------------------------------------------------------
-- БАЗОВЫЕ ПРИЛОЖЕНИЯ (С разделением по столам: 1 стол = 1 окно)
-- -----------------------------------------------------------------------------
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(scripts .. "/launch_app.sh " .. terminal))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(scripts .. "/launch_app.sh " .. terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(scripts .. "/launch_app.sh " .. fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(scripts .. "/launch_app.sh firefox"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(scripts .. "/launch_app.sh codium"))

-- Закрытие и управление активным окном
hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + BackSpace", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- -----------------------------------------------------------------------------
-- МЕНЮ И ЛОНЧЕРЫ (Rofi & Wlogout)
-- -----------------------------------------------------------------------------
-- Меню приложений (Rofi drun)
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + space", hl.dsp.exec_cmd(menu))

-- Центр управления и быстрых настроек (Super + I, end-4 style)
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd(scripts .. "/control_center.sh"))

-- Меню питания и выхода (Компактный выпадающий попап)
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(scripts .. "/power_menu.sh"))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd(scripts .. "/power_menu.sh"))

-- Экран блокировки (hyprlock)
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

-- -----------------------------------------------------------------------------
-- TASK SWITCHER (Сетка 5x2 окон / воркспейсов по Tab в стиле end-4)
-- -----------------------------------------------------------------------------
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd(scripts .. "/overview.sh"))
hl.bind("ALT + Tab", hl.dsp.exec_cmd(scripts .. "/overview.sh"))

-- -----------------------------------------------------------------------------
-- СКРИНШОТЫ & БУФЕР ОБМЕНА
-- -----------------------------------------------------------------------------
-- Выделенная область в буфер
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(scripts .. "/screenshot.sh area"))
-- Полный экран в файл и буфер
hl.bind("Print", hl.dsp.exec_cmd(scripts .. "/screenshot.sh full"))
-- Менеджер буфера обмена (Rofi + cliphist)
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(scripts .. "/clipmanager.sh"))

-- -----------------------------------------------------------------------------
-- НАВИГАЦИЯ МЕЖДУ ОКНАМИ И СТОЛАМИ
-- -----------------------------------------------------------------------------
-- Фокус стрелками
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Быстрое переключение на столы 1..10 (Super + 1..0)
-- Перемещение окна на стол 1..10 (Super + Shift + 1..0)
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Скролл рабочих столов колесом мыши над панелью/экраном
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Перетаскивание и изменение размера окна мышью (LMB / RMB)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- -----------------------------------------------------------------------------
-- МУЛЬТИМЕДИА И УПРАВЛЕНИЕ АППАРАТУРОЙ
-- -----------------------------------------------------------------------------
-- Громкость (wpctl)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.3 @DEFAULT_AUDIO_SINK@ 5%+ && " .. scripts .. "/volume_osd.sh"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && " .. scripts .. "/volume_osd.sh"),       { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && " .. scripts .. "/volume_osd.sh"),      { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),                                       { locked = true })

-- Яркость экрана (brightnessctl)
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })

-- Управление плеером (playerctl)
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
