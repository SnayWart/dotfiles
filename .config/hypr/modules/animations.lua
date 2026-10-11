-- =============================================================================
-- MODULE: ANIMATIONS & EASING CURVES
-- =============================================================================
-- Кинематографичные кривые Безье
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("overshot",       { type = "bezier", points = { {0.05, 0.9},  {0.1, 1.05} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1} } })
hl.curve("smooth",         { type = "bezier", points = { {0.25, 0.1},  {0.25, 1} } })

-- Физическая пружина для естественного всплытия окон
hl.curve("springPop",      { type = "spring", mass = 1, stiffness = 220, dampening = 23 })
hl.curve("springSmooth",   { type = "spring", mass = 1, stiffness = 160, dampening = 20 })

-- Анимации компонентов
hl.animation({ leaf = "global",        enabled = true,  speed = 7,    bezier = "easeOutQuint" })

-- Окна: динамичный всплывающий popin со сглаженным затуханием
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.2,  spring = "springPop" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.0,  spring = "springPop",    style = "popin 82%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 2.5,  bezier = "quick",        style = "popin 85%" })
hl.animation({ leaf = "windowsMove",   enabled = true,  speed = 4.0,  bezier = "easeOutQuint" })

-- Осенний переливающийся градиент рамок
hl.animation({ leaf = "border",        enabled = true,  speed = 8.0,  bezier = "smooth" })
hl.animation({ leaf = "borderangle",   enabled = true,  speed = 25.0, bezier = "smooth",       style = "loop" })

-- Плавное затухание (Fades)
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.2,  bezier = "quick" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 2.5,  bezier = "easeOutQuint" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 2.0,  bezier = "quick" })

-- Слои интерфейса (Waybar, Rofi, Mako, Wlogout)
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.8,  bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 3.5,  bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 2.0,  bezier = "quick",        style = "fade" })

-- Рабочие столы: горизонтальный скользящий переход (Mac/iOS-style slide)
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 4.6,  bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 4.6,  bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 4.6,  bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4.0, spring = "springPop",    style = "slidevert" })
