# Heartkiss UI Library v0.06 — "NextLevel" Update

A professional, minimalist, and feature-rich UI library for Roblox, inspired by the sharp aesthetics of classic Windows/MS Paint but with a modern, high-contrast dark theme.

## 🚀 Quick Start

```lua
local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/Acidgorgon/2c0654b99a77b27e801ca6eb952a1e6c/raw/a887a7de559fc0fc6eb6542066f648a91f8b9e28/UILib"))()

-- Optional Boot Animation
Library:InitLoad({
    Title = "NextLevel",
    SubTitle = "v0.06",
    Icon = 89738140174311,
    Duration = 2,
    AccentColor = Color3.fromRGB(255, 0, 0),
    Statuses = {
        "Connecting...",
        "Loading components...",
        "Done!"
    }
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
- **Draggable & Resizable:** Fully interactive windows with a custom resize grip.
- **Minimizing:** Collapse the UI to the title bar.
- **Panic Key:** `Window:SetPanicKey(KeyCode)` to instantly destroy the UI and all connections.
- **Flag Management:** `Window:IgnoreFlag(Flag)` to exclude specific widgets from being saved to configs.
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
- **Webhook:** `Webhook` input field for Discord logging integration.

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
- **Connection Helper:** `Window:Connect(signal, callback)` for automatic garbage collection of connections on unload.
- **Unload Callback:** `Window:OnUnload(callback)` registers a function to run when the library is destroyed.
- **Theme Presets:** `Window:ApplyPreset(name)` to quickly switch between "Cyberpunk", "Midnight", "Toxic", etc.
- **Config Listing:** `Window:ListConfigs()` returns an array of all saved profile names.


## ⚙️ Automatic Tabs
- `Window:BuildUtilityTab()`: Includes a built-in Auto-Clicker and utility tools.
- `Window:BuildSettingsTab()`: Full config manager, Watermark toggle, Keybinds toggle, Background Blur, RGB mode, and Unload button.
- `Window:BuildThemeTab()`: Live editor for every color in the UI.
- `Window:BuildExecutorTab()`: A built-in code executor with clear/execute functionality.
- `Window:BuildNotificationLogTab()`: View a history of all notifications sent by the script.
- `Window:BuildChangelogTab(Data)`: Display version history and update notes.

---
*Developed with ❤️ for the community.*
