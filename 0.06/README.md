# Heartkiss UI Library v0.06 — "NextLevel" Update

A professional, minimalist, and feature-rich UI library for Roblox, inspired by the sharp aesthetics of classic Windows/MS Paint but with a modern, high-contrast dark theme.

## 🚀 Quick Start

```lua
local Library = loadstring(game:HttpGet("https://your-link-here/Lib.lua"))()

-- Optional Boot Animation
Library:InitLoad({
    Title = "NextLevel",
    SubTitle = "v0.06",
    Icon = 89738140174311,
    Duration = 2
})

-- Create Window
local Window = Library.new("NextLevel", UDim2.fromOffset(540, 580), Enum.KeyCode.RightControl, "Sidebar", 89738140174311)

-- Create Tab
local MainTab = Window:Tab("Main", 3926307971)

-- Create Section
local MySection = MainTab:Section("Controls")

-- Add Widget
MySection:Button("Hello World", function()
    Window:Notify("Greeted", "Hello from Heartkiss!", 3)
end)
```

## ✨ New in v0.06
- **Sharp Aesthetics:** Removed rounded corners from main containers for a crisp, professional look.
- **Built-in Theme Editor:** `Window:BuildThemeTab()` automatically creates a tab to customize all 14 library colors live.
- **Silent Mode:** Support for invisible execution that bypasses startup popups and defaults to hidden.
- **Improved Sidebar:** Better icon rendering and clear active-tab highlighting.
- **Advanced Widgets:** Added Grid, Timer, Bar Charts, Multiline Input, and Tag Inputs.

## 🛠 Features & Widgets

### Window Management
- **Draggable & Resizable:** Fully interactive windows.
- **Minimizing:** Collapse the UI to the title bar.
- **Panic Key:** Set a key to instantly destroy the UI and all connections.
- **Global Search:** Built-in search bar to filter every element across all tabs.

### Interactive Widgets
- **Buttons:** Single buttons or horizontal `ButtonRows`.
- **Toggles:** Standard `Toggle`, `ToggleBind` (state + keybind), and `Switch` (pill-style).
- **Sliders & Steppers:** Precise value control with decimal support.
- **Inputs:** `Input` (single line), `MultilineInput`, and `TagInput` (chips).
- **Dropdowns:** `Dropdown` (single/multi), `SearchableDropdown`, and `PlayerDropdown` (auto-updating list).
- **Keybinds:** Simple `Bind` widget for one-tap actions.
- **Selection:** `RadioGroup` for exclusive selection lists.
- **Grid:** `Grid` widget for ability icons or quick-action grids.

### Display & Data Widgets
- **Console:** Draggable log output with multi-color support and clearing.
- **Charts:** `Chart` widget for visualizing data with bar graphs.
- **Timer:** `Timer` widget for countdowns with completion callbacks.
- **Progress:** `ProgressBar` with programmatic setting.
- **Status:** `StatusIndicator` for live state display (e.g., Connection: Active).
- **Tables:** `KeyValueTable` for structured data like FPS, Ping, or Stats.
- **Visuals:** `Label`, `Paragraph`, `Separator` (labeled), `Spacer`, `Image`.
- **Alerts:** Colored status boxes (`info`, `warn`, `error`, `success`).

### Utility Features
- **Notifications:** Sleek, animated notifications in the top-right corner.
- **Dialogs:** Modal popups for confirmations or multi-choice info.
- **Tooltips:** Add hover-to-view descriptions to any button.
- **Theme System:** High-contrast dark theme with customizable accent colors.
- **Config System:** Robust JSON-based saving/loading/autoloading for all flags.
- **Server Hop:** Built-in teleporting utility that saves your UI state across servers.

## ⚙️ Automatic Tabs
- `Window:BuildUtilityTab()`: Includes a built-in Auto-Clicker.
- `Window:BuildSettingsTab()`: Full config manager, Watermark toggle, Keybinds toggle, Background Blur, RGB mode, and Unload button.
- `Window:BuildThemeTab()`: Live editor for every color in the UI.

---
*Developed with ❤️ for the community.*
