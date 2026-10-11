-- =============================================================================
-- MODULE: ENVIRONMENT VARIABLES
-- =============================================================================
-- Wayland / XDG
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_DATA_DIRS", "/home/snaywart/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share")

-- Курсоры
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Тулкиты (GTK / Qt / Electron / Java)
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("GTK_THEME", "Adwaita:dark")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Mozilla / Firefox
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- Драйвер AMD (Radeon RX 6400)
hl.env("LIBVA_DRIVER_NAME", "radeonsi")
hl.env("VDPAU_DRIVER", "radeonsi")
hl.env("MESA_LOADER_DRIVER_OVERRIDE", "radeonsi")
