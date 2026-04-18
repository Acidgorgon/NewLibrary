# Heartkiss UI Library `0.04`

Reference documentation for the `0.04` API.

## Navigation

### Introduction

- [Loading](#loading)
- [Window](#window)
- [Utility](#utility)

### Structure

- [Tabs](#tabs)
- [Sections](#sections)

### UI Elements

- [Buttons](#buttons)
- [Toggles](#toggles)
- [Switches](#switches)
- [Sliders](#sliders)
- [Steppers](#steppers)
- [Inputs](#inputs)
- [Dropdowns](#dropdowns)
- [Searchable Dropdowns](#searchable-dropdowns)
- [Player Dropdowns](#player-dropdowns)
- [Radio Groups](#radio-groups)
- [Binds](#binds)
- [Color Pickers](#color-pickers)
- [Labels](#labels)
- [Paragraphs](#paragraphs)
- [Separators](#separators)
- [Spacers](#spacers)
- [Progress Bars](#progress-bars)
- [Status Indicators](#status-indicators)
- [Alerts](#alerts)
- [Images](#images)
- [Key-Value Tables](#key-value-tables)
- [Console](#console)

### Built-In Tabs

- [Macro Tab](#macro-tab)
- [Settings Tab](#settings-tab)

## Loading

Create a window with `Library.new`.

```lua
local Library = loadstring(game:HttpGet("YOUR_URL_HERE"))()

local Window = Library.new(
    "Heartkiss UI",
    UDim2.fromOffset(520, 560),
    Enum.KeyCode.RightControl
)
```

### Signature

```lua
Library.new(name: string?, size: UDim2?, keybind: Enum.KeyCode | Enum.UserInputType?)
```

### Built in automatically

- Draggable main window
- Minimize button
- Search bar for the active tab layout
- FPS and ping monitor in the title bar
- Draggable watermark overlay
- Draggable active keybind overlay
- Global flag storage with setter callbacks
- Theme tweening across themed elements

## Window

The window object returned by `Library.new` is the main entry point for the rest of the API.

### Example

```lua
local MainTab = Window:Tab("Main")
local Combat = MainTab:Section("Combat")
```

### Window methods

#### `Window:Notify(title, text, duration?)`

Shows an animated notification on the right side of the screen.

```lua
Window:Notify("Loaded", "UI is ready.", 3)
```

#### `Window:SetTheme(overrides)`

Overrides theme keys in the internal `THEMES` table and refreshes themed elements.

```lua
Window:SetTheme({
    MainColor = Color3.fromRGB(20, 20, 20),
    LineColor = Color3.fromRGB(255, 120, 120),
    SelectedTab = Color3.fromRGB(255, 120, 120),
})
```

Common keys in `0.04`:

- `MainColor`
- `FrameColor`
- `TabColor`
- `LineColor`
- `BorderColor`
- `DarkColor`
- `SelectedTab`
- `TextColor`
- `ButtonBorderColor`
- `SubTextColor`
- `SuccessColor`
- `WarningColor`
- `ErrorColor`
- `InfoColor`
- `TextSize`
- `BaseHeight`

#### `Window:GetFlag(flag)`

Reads the current stored value for a flagged element.

```lua
local walkSpeed = Window:GetFlag("walk_speed")
```

#### `Window:IgnoreFlag(flag)`

Prevents a flag from being included in config saves and loads.

```lua
Window:IgnoreFlag("debug_only")
```

#### `Window:AddTooltip(element, text)`

Attaches a floating tooltip to any returned `GuiObject`.

```lua
local button = Combat:Button("Aimbot", function() end)
Window:AddTooltip(button, "Locks onto the nearest target.")
```

#### `Window:Unload()`

Disconnects tracked connections, destroys tracked instances, and removes the UI.

#### `Window:SetPanicKey(key)`

Unloads the library when the key is pressed.

```lua
Window:SetPanicKey(Enum.KeyCode.End)
```

#### `Window:BuildMacroTab()`

Adds the built-in macro recorder tab.

#### `Window:BuildSettingsTab()`

Adds the built-in settings and config tab.

## Utility

### Flags and setters

Most interactive elements can write to `Window.Flags[flag]`.

Flagged elements also register a setter function in `Window.Setters[flag]`, which lets you update the UI element from code.

```lua
if Window.Setters["fov"] then
    Window.Setters["fov"](180)
end
```

### Search

Every section element registers searchable text. Typing in the window search box filters matching elements and hides empty sections.

### Active keybind list

Enabled `Toggle`, `Switch`, and `ToggleBind` states are mirrored into the active keybind overlay.

### Cleanup model

The library tracks connections and instances inside `getgenv()._Heartkiss_Garbage[windowName]` so `Unload()` can cleanly tear everything down.

## Tabs

Tabs split the UI into top-level categories.

```lua
local MainTab = Window:Tab("Main")
local VisualsTab = Window:Tab("Visuals")
```

### Notes

- Tabs are shown in a horizontal scrolling strip
- The first tab is selected automatically
- Each tab creates a scrolling content page
- Each tab page uses a two-column layout

## Sections

Sections are containers inside a tab.

```lua
local Combat = MainTab:Section("Combat")
local Movement = MainTab:Section("Movement")
```

### Notes

- Sections alternate between the left and right columns
- Elements are added vertically in the order they are created
- Each section auto-resizes to fit its contents

## Buttons

### `Section:Button(text, callback?)`

Creates a standard button.

```lua
Combat:Button("Kill All", function()
    print("Triggered")
end)
```

### `Section:CreateButtonRow(text1, callback1, text2, callback2)`

Creates two side-by-side buttons in one row.

```lua
Combat:CreateButtonRow(
    "Enable",
    function() end,
    "Disable",
    function() end
)
```

## Toggles

### `Section:Toggle(text, default?, flag?, callback?)`

Creates a checkbox-style toggle.

```lua
Combat:Toggle("ESP", false, "esp_enabled", function(state)
    print(state)
end)
```

### `Section:ToggleBind(text, defaultState?, defaultKey?, flagState?, flagKey?, callback?)`

Creates a toggle with a bind button on the right.

Callback receives `(state, keyName)`.

```lua
Combat:ToggleBind(
    "Aim Assist",
    false,
    Enum.KeyCode.F,
    "aim_assist_enabled",
    "aim_assist_key",
    function(state, key)
        print(state, key)
    end
)
```

## Switches

### `Section:Switch(text, default?, flag?, callback?)`

Creates an iOS-style pill switch.

```lua
Combat:Switch("Silent Aim", false, "silent_aim", function(state)
    print(state)
end)
```

## Sliders

### `Section:Slider(text, min, max, default?, decimals?, flag?, callback?)`

Creates a draggable numeric slider.

```lua
Movement:Slider("WalkSpeed", 16, 200, 16, 0, "walk_speed", function(value)
    print(value)
end)
```

### Notes

- Values are clamped between `min` and `max`
- Values are rounded to the requested decimal precision
- Setter updates the fill and the value label

## Steppers

### `Section:Stepper(text, min, max, default?, step?, flag?, callback?)`

Creates a numeric stepper with `-` and `+` controls.

```lua
Movement:Stepper("Max Targets", 1, 20, 5, 1, "max_targets", function(value)
    print(value)
end)
```

## Inputs

### `Section:Input(text, placeholder?, flag?, callback?)`

Creates a text input box.

Callback fires on `FocusLost`.

```lua
Main:Input("Webhook URL", "https://...", "webhook", function(value)
    print(value)
end)
```

## Dropdowns

### `Section:Dropdown(text, options, multi, default, flag?, callback?)`

Creates a dropdown selector.

```lua
Main:Dropdown(
    "Hitbox",
    {"Head", "Torso", "Legs"},
    false,
    "Head",
    "hitbox",
    function(value)
        print(value)
    end
)
```

### Multi-select example

```lua
Main:Dropdown(
    "ESP Parts",
    {"Box", "Name", "Health"},
    true,
    {"Box", "Name"},
    "esp_parts",
    function(values)
        print(table.concat(values, ", "))
    end
)
```

### Returns

`Dropdown` returns an object with:

```lua
dropdown:Refresh(newOptions)
```

## Searchable Dropdowns

### `Section:SearchableDropdown(text, options, default, flag?, callback?)`

Creates a dropdown with a built-in search box.

```lua
Main:SearchableDropdown("Teleport To", {"Spawn", "Shop", "Arena"}, "", "teleport", function(value)
    print(value)
end)
```

### Returns

`SearchableDropdown` returns an object with:

```lua
dropdown:Refresh(newOptions)
```

## Player Dropdowns

### `Section:PlayerDropdown(text, includeSelf?, flag?, callback?)`

Creates a searchable dropdown that auto-populates from `Players:GetPlayers()`.

```lua
PlayersSection:PlayerDropdown("Target Player", false, "target_player", function(playerName)
    print(playerName)
end)
```

### Notes

- Refreshes initially
- Updates automatically on `PlayerAdded`
- Updates automatically on `PlayerRemoving`

## Radio Groups

### `Section:RadioGroup(label, options, default, flag?, callback?)`

Creates a vertical radio-button selection group.

```lua
Main:RadioGroup("Mode", {"Legit", "Blatant"}, "Legit", "mode", function(value)
    print(value)
end)
```

## Binds

### `Section:Bind(text, defaultKey?, flag?, callback?)`

Creates a standalone keybind picker.

Callback fires when the bound key is pressed.

```lua
Main:Bind("Panic", Enum.KeyCode.P, "panic_key", function()
    print("panic")
end)
```

## Color Pickers

### `Section:ColorPicker(text, defaultColor?, defaultAlpha?, flag?, callback?)`

Creates an expandable HSV color picker with alpha control.

Callback receives `(color, alpha)`.

```lua
Visuals:ColorPicker(
    "ESP Color",
    Color3.fromRGB(255, 0, 0),
    1,
    "esp_color",
    function(color, alpha)
        print(color, alpha)
    end
)
```

### Stored flag format

Color picker flags are saved as:

```lua
{
    R = 1,
    G = 0,
    B = 0,
    A = 1
}
```

## Labels

### `Section:Label(text)`

Creates a centered one-line label.

```lua
Main:Label("Ready")
```

## Paragraphs

### `Section:Paragraph(text)`

Creates wrapped descriptive text that auto-expands vertically.

```lua
Main:Paragraph("This section controls movement and target selection.")
```

## Separators

### `Section:Separator(label?)`

Creates a divider line, optionally with centered label text.

```lua
Main:Separator()
Main:Separator("Movement")
```

## Spacers

### `Section:Spacer(height?)`

Creates empty vertical spacing.

```lua
Main:Spacer(12)
```

## Progress Bars

### `Section:ProgressBar(text, min?, max?, default?, flag?)`

Creates a display-only progress bar.

```lua
local bar = Main:ProgressBar("EXP", 0, 1000, 300, "exp")
bar:Set(500)
```

### Returns

```lua
bar:Set(value)
```

## Status Indicators

### `Section:StatusIndicator(label, initialText?, initialColor?)`

Creates a text status with a colored dot.

```lua
local status = Main:StatusIndicator("Connection", "Online", Color3.fromRGB(80, 220, 120))
status:Set("Offline", Color3.fromRGB(255, 80, 80))
```

### Returns

```lua
status:Set(text, color)
```

## Alerts

### `Section:Alert(text, type?)`

Creates an inline alert banner.

Supported types:

- `info`
- `warn`
- `error`
- `success`

```lua
Main:Alert("High ping detected.", "warn")
```

## Images

### `Section:Image(assetId, height?)`

Creates an `ImageLabel` using `rbxassetid://`.

```lua
Main:Image(1234567890, 140)
```

## Key-Value Tables

### `Section:KeyValueTable(rows)`

Creates a two-column key/value display.

```lua
local tableObj = Main:KeyValueTable({
    {"Kills", 0},
    {"Deaths", 0},
})

tableObj:SetValue("Kills", 10)
```

### Returns

```lua
tableObj:SetValue(key, value)
```

## Console

### `Section:Console(height?)`

Creates a scrolling in-UI log box.

```lua
local console = Main:Console(150)
console:Print("Injected successfully!")
console:Clear()
```

### Returns

```lua
console:Print(message, color?)
console:Clear()
```

## Macro Tab

`Window:BuildMacroTab()` adds a fully built macro recorder tab named `Macros`.

### Included controls

- `Record Macro` toggle bind on `F3` by default
- `Play Macro` toggle bind on `F4` by default
- `Loop Playback` toggle
- `Clear Macro` button
- Live status label showing idle, recording, or playback state

### Recorded input types

- Keyboard began
- Keyboard ended
- Mouse button 1 began
- Mouse button 2 began

### Playback behavior

- Replays the stored delays between events
- Supports looping
- Refuses to record while playing
- Refuses to play while recording

## Settings Tab

`Window:BuildSettingsTab()` adds a built-in `Settings` tab with config management and UI controls.

### Configuration section

- Config name input
- Searchable config picker
- Save config
- Load config
- Delete config
- Set autoload
- Export current config to clipboard
- Import config from clipboard
- Refresh config list

### UI elements section

- `Show Watermark`
- `Show Active Keybinds`

### About section

- Library label
- Usage reminder
- Status indicator

### Config behavior

- Config folder defaults to `<WindowName>_Configs`
- Configs are saved as JSON
- Ignored flags are skipped
- Autoload reads from `autoload.txt` inside the config folder

## Example Layout

```lua
local Library = loadstring(game:HttpGet("YOUR_URL_HERE"))()

local Window = Library.new("Heartkiss", UDim2.fromOffset(520, 560), Enum.KeyCode.RightControl)
Window:SetPanicKey(Enum.KeyCode.End)

local Main = Window:Tab("Main")
local Combat = Main:Section("Combat")
local Visuals = Main:Section("Visuals")

Combat:Toggle("ESP", false, "esp", function(state)
    print("ESP:", state)
end)

Combat:Slider("WalkSpeed", 16, 100, 16, 0, "walk_speed", function(value)
    print("WalkSpeed:", value)
end)

Visuals:ColorPicker("ESP Color", Color3.fromRGB(255, 0, 0), 1, "esp_color", function(color, alpha)
    print(color, alpha)
end)

Window:BuildSettingsTab()
Window:Notify("Loaded", "Heartkiss 0.04 ready.", 3)
```
