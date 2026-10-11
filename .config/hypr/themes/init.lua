-- =============================================================================
-- SEASONAL THEME MANAGER
-- =============================================================================
local M = {}

-- Автоопределение по календарю:
-- Зима:  12, 1, 2
-- Весна: 3, 4, 5
-- Лето:  6, 7, 8
-- Осень: 9, 10, 11 (сейчас Сентябрь)
local month = os.date("*t").month
local active_name = "autumn"

if month >= 9 and month <= 11 then
    active_name = "autumn"
elseif month >= 3 and month <= 5 then
    active_name = "spring"
elseif month >= 6 and month <= 8 then
    active_name = "summer"
else
    active_name = "winter"
end

-- Пробуем загрузить выбранную тему или фоллбек на autumn
local ok, theme = pcall(require, "themes." .. active_name)
if not ok then
    theme = require("themes.autumn")
end

M.current = theme
M.name = active_name

return M
