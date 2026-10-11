-- =============================================================================
-- MODULE: AUTO WORKSPACE ENFORCER (1 Window = 1 Workspace Rule)
-- =============================================================================
-- Если на рабочем столе появляется второе окно (попытка сплита),
-- модуль автоматически переносит его на первый свободный рабочий стол (1..10).

hl.on("window.open", function(new_win)
    if not new_win or not new_win.workspace then return end
    
    -- Плавающие окна (диалоги, настройки, pop-up) не делят экран - оставляем их
    if new_win.floating then return end

    local current_ws_id = new_win.workspace.id
    -- Работаем только с обычными рабочими столами 1..10
    if not current_ws_id or current_ws_id < 1 or current_ws_id > 10 then return end

    -- Проверяем, сколько окон сейчас на этом столе
    local wins_on_ws = {}
    for _, w in ipairs(hl.get_windows()) do
        if w.workspace and w.workspace.id == current_ws_id and not w.floating then
            table.insert(wins_on_ws, w)
        end
    end

    -- Если на столе больше 1 окна - предотвращаем сплит!
    if #wins_on_ws > 1 then
        -- Ищем первый свободный рабочий стол среди 1..10
        local target_ws = nil
        for candidate = 1, 10 do
            local count = 0
            for _, w in ipairs(hl.get_windows()) do
                if w.workspace and w.workspace.id == candidate and not w.floating then
                    count = count + 1
                end
            end
            if count == 0 then
                target_ws = candidate
                break
            end
        end

        -- Если найден свободный стол - мгновенно изолируем новое окно на него
        if target_ws then
            hl.dispatch(hl.dsp.focus({ window = new_win }))
            hl.dispatch(hl.dsp.window.move({ workspace = target_ws }))
            hl.dispatch(hl.dsp.focus({ workspace = target_ws }))
        end
    end
end)
