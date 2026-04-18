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
- [Toggle Binds](#toggle-binds)
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
local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/Acidgorgon/2c0654b99a77b27e801ca6eb952a1e6c/raw/f74476423b05cc2bc120433091937263f6a5feee/UILib"))()

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
- Title bar minimize button
- Top bar FPS and ping monitor
- Tab strip with horizontal scrolling
- Global search box for registered elements
- Draggable watermark overlay
- Draggable active keybind overlay
- Theme tweening for themed controls
- Config folder creation at startup

### Notes

- The main UI toggle accepts either an `Enum.KeyCode` or `Enum.UserInputType`
- The library protects GUIs with `syn.protect_gui` or `protectgui` when available
- File, clipboard, and input executor helpers use safe fallbacks when the executor does not expose them

## Window

The object returned by `Library.new` is your main API surface.

### Basic example

```lua
local MainTab = Window:Tab("Main")
local Combat = MainTab:Section("Combat")
```

### Window methods

#### `Window:Notify(title, text, duration?)`

Shows an animated notification in the notification stack.

```lua
Window:Notify("Loaded", "UI is ready.", 3)
```

#### `Window:SetTheme(overrides)`

Overrides values in the internal theme table and refreshes themed controls.

```lua
Window:SetTheme({
    MainColor = Color3.fromRGB(20, 20, 20),
    LineColor = Color3.fromRGB(255, 120, 120),
    SelectedTab = Color3.fromRGB(255, 120, 120),
})
```

Theme keys exposed in `0.04`:

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

Returns the current value stored for a flag.

```lua
local walkSpeed = Window:GetFlag("walk_speed")
```

#### `Window:IgnoreFlag(flag)`

Excludes a flag from config save and load operations.

```lua
Window:IgnoreFlag("session_only")
```

#### `Window:AddTooltip(element, tipText)`

Adds a floating tooltip to any returned `GuiObject`.

```lua
local btn = Combat:Button("Aimbot", function() end)
Window:AddTooltip(btn, "Locks onto the nearest target.")
```

#### `Window:Unload()`

Cleans up tracked connections, instances, threads, and the created GUIs.

#### `Window:SetPanicKey(key)`

Unloads the UI when the key is pressed.

```lua
Window:SetPanicKey(Enum.KeyCode.End)
```

#### `Window:BuildMacroTab()`

Adds the built-in `Macros` tab.

#### `Window:BuildSettingsTab()`

Adds the built-in `Settings` tab.

## Utility

### Flags

Most interactive controls can write into `Window.Flags[flag]`.

```lua
print(Window.Flags.aimbot_enabled)
```

### Setters

Flagged elements usually register a live setter in `Window.Setters[flag]`.

```lua
if Window.Setters["fov"] then
    Window.Setters["fov"](180)
end
```

### Search

Every section element registers search text. The top search box filters elements and hides sections with no visible matches.

### Watermark

The watermark is enabled by default and shows:

- Window name
- FPS
- Ping

It is draggable and can be toggled from the built-in settings tab.

### Active Keybinds overlay

The active keybind panel is enabled by default, draggable, and auto-resizes to its content.

It reflects enabled states tracked through:

- `Toggle`
- `ToggleBind`
- `Switch`

### Cleanup model

Tracked cleanup data is stored in:

```lua
getgenv()._Heartkiss_Garbage[windowName]
```

## Tabs

Tabs split the UI into main categories.

```lua
local MainTab = Window:Tab("Main")
local VisualsTab = Window:Tab("Visuals")
```

### Notes

- Tabs are horizontal
- The tab bar scrolls if needed
- The first tab is selected automatically
- Each tab creates its own scrolling page

## Sections

Sections are element containers inside tabs.

```lua
local Combat = MainTab:Section("Combat")
local Movement = MainTab:Section("Movement")
```

### Notes

- Sections alternate between left and right columns
- Sections auto-resize from their content
- Elements are ordered in creation order

## Buttons

### `Section:Button(text, callback?)`

Creates a standard button.

```lua
Combat:Button("Kill All", function()
    print("Triggered")
end)
```

### `Section:CreateButtonRow(text1, callback1, text2, callback2)`

Creates two side-by-side buttons.

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

### Notes

- Writes boolean state to the flag when provided
- Updates the active keybind overlay
- Registers a setter when flagged

## Toggle Binds

### `Section:ToggleBind(text, defaultState?, defaultKey?, flagState?, flagKey?, callback?)`

Creates a toggle with a keybind picker on the right.

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

### Notes

- Clicking the bind button enters binding mode
- `Backspace` or `Escape` clears the key to `Unknown`
- Pressing the bound key toggles the state
- Stores state and key in separate flags when both are supplied

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

- Value is clamped between `min` and `max`
- Value is rounded to the requested decimal precision
- Setter updates both the fill and the text value

## Steppers

### `Section:Stepper(text, min, max, default?, step?, flag?, callback?)`

Creates a numeric stepper with `-` and `+` buttons.

```lua
Movement:Stepper("Max Targets", 1, 20, 5, 1, "max_targets", function(value)
    print(value)
end)
```

### Notes

- Value is clamped between `min` and `max`
- Setter updates the shown numeric label

## Inputs

### `Section:Input(text, placeholder?, flag?, callback?)`

Creates a text input box.

Callback fires when the box loses focus.

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

```lua
dropdown:Refresh(newOptions)
```

### Notes

- Single-select closes after selection
- Multi-select stays open and returns a table of selected values
- Flag setter can update the current selection directly

## Searchable Dropdowns

### `Section:SearchableDropdown(text, options, default, flag?, callback?)`

Creates a dropdown with an inline search box.

```lua
Main:SearchableDropdown("Teleport To", {"Spawn", "Shop", "Arena"}, "", "teleport", function(value)
    print(value)
end)
```

### Returns

```lua
dropdown:Refresh(newOptions)
```

### Notes

- Search filters options live as text is typed
- Selecting an entry clears the search text

## Player Dropdowns

### `Section:PlayerDropdown(text, includeSelf?, flag?, callback?)`

Creates a searchable player list powered by `Players:GetPlayers()`.

```lua
PlayersSection:PlayerDropdown("Target Player", false, "target_player", function(playerName)
    print(playerName)
end)
```

### Notes

- Starts empty and populates immediately
- Sorts names alphabetically
- Refreshes on `PlayerAdded`
- Refreshes on `PlayerRemoving`

## Radio Groups

### `Section:RadioGroup(label, options, default, flag?, callback?)`

Creates a vertical radio-button group.

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

### Notes

- Clicking the bind enters binding mode
- `Backspace` or `Escape` clears the key to `Unknown`
- Setter updates the shown key text

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

```lua
{
    R = 1,
    G = 0,
    B = 0,
    A = 1
}
```

### Notes

- Uses HSV internally
- Includes saturation/value area, hue bar, and alpha bar
- Setter accepts a table containing `R`, `G`, `B`, and `A`

## Labels

### `Section:Label(text)`

Creates a centered label.

```lua
Main:Label("Ready")
```

## Paragraphs

### `Section:Paragraph(text)`

Creates wrapped descriptive text with automatic height.

```lua
Main:Paragraph("This section controls movement and target selection.")
```

## Separators

### `Section:Separator(label?)`

Creates a divider line, optionally with centered text.

```lua
Main:Separator()
Main:Separator("Movement")
```

## Spacers

### `Section:Spacer(height?)`

Creates empty vertical space.

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

### Notes

- Setter updates the visual fill and numeric label
- Stored flag holds the current numeric value

## Status Indicators

### `Section:StatusIndicator(label, initialText?, initialColor?)`

Creates a label with a colored dot and status text.

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

Creates a scrolling in-UI log console.

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

### Notes

- Printed lines are timestamped with `os.date("%H:%M:%S")`
- Auto-scrolls to the latest line

## Macro Tab

`Window:BuildMacroTab()` adds a built-in `Macros` tab with a `Macro Recorder` section.

### Included controls

- `Record Macro` toggle bind with default key `F3`
- `Loop Playback` toggle
- `Play Macro` toggle bind with default key `F4`
- `Clear Macro` button
- Status label showing idle, recording, and playback state

### Recorded input behavior

- Records keyboard `InputBegan`
- Records keyboard `InputEnded`
- Records mouse button 1 and 2 events
- Skips the main window toggle key while recording

### Playback behavior

- Replays the original delays between events
- Supports looped playback
- Refuses to record while already playing
- Refuses to play while already recording
- Releases recorded keyboard keys when playback is stopped manually

## Settings Tab

`Window:BuildSettingsTab()` adds a built-in `Settings` tab.

### Configuration section

- Config name input
- Searchable config picker
- Save config
- Load config
- Delete config
- Set autoload
- Export to clipboard
- Import from clipboard
- Refresh list

### UI Elements section

- `Show Watermark`
- `Show Active Keybinds`

### About section

- Library title label
- Usage label
- Decorative separator
- Active status indicator

### Config behavior

- Config folder defaults to `<WindowName>_Configs`
- Config files are saved as JSON
- Ignored flags are skipped on save and load
- Autoload is stored in `<WindowName>_Configs/autoload.txt`
- Autoload config is applied shortly after startup

## Example Layout

```lua
local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/Acidgorgon/2c0654b99a77b27e801ca6eb952a1e6c/raw/f74476423b05cc2bc120433091937263f6a5feee/UILib"))()

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
