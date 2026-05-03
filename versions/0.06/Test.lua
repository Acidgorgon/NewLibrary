--!nocheck
--!nolint

-- ============================================================
--  NEXTLEVEL  —  Complete Feature Example
--  Demonstrates every widget, method, and utility available.
--  Updated for version 0.06 - Visually Unique Update
-- ============================================================

-- Load the library (for local testing, assuming Lib.lua is required or loaded via readfile)
-- Example for external executors:
-- local Library = loadstring(game:HttpGet(".../0.06/Lib.lua"))()
-- For local executor testing if Lib.lua is in workspace:
local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/Acidgorgon/2c0654b99a77b27e801ca6eb952a1e6c/raw/33f0a4f978d700fab58fd2b4374004cf7a87e560/UILib"))()


-- ──────────────────────────────────────────────────────────────
--  INIT LOAD SCREEN  (optional premium loader)
-- ──────────────────────────────────────────────────────────────
Library:InitLoad({
    Title       = "NextLevel",
    SubTitle    = "Premium Interface v0.06",
    Icon        = 10734914443,          -- rbxassetid
    Duration    = 2.5,
    AccentColor = Color3.fromRGB(255, 255, 255),
    Statuses    = {
        "Initializing NextLevel framework...",
        "Synchronizing cloud configurations...",
        "Validating premium license...",
        "Optimizing UI performance...",
        "Welcome back, Administrator.",
    },
})


-- ──────────────────────────────────────────────────────────────
--  CREATE WINDOW
-- ──────────────────────────────────────────────────────────────
local Window = Library.new(
    "NextLevel",                    -- title
    UDim2.new(0, 520, 0, 560),      -- size
    Enum.KeyCode.RightControl,      -- toggle key
    "Classic",                      -- UI Mode ("Sidebar" or "Classic")
    10734914443
)
Window:SetPanicKey(Enum.KeyCode.End)
-- Window:SetTheme({
--     AccentColor = Color3.fromRGB(255, 255, 255),
--     LineColor = Color3.fromRGB(255, 255, 255),
--     SelectedTab = Color3.fromRGB(255, 255, 255), -- Adds the white background box
-- })

-- Flags that should never be saved to configs
Window:IgnoreFlag("SensitiveFlag")


-- ══════════════════════════════════════════════════════════════
--  TAB 1 — BASIC CONTROLS
-- ══════════════════════════════════════════════════════════════
local MainTab = Window:Tab("Main", 10734914443)


-- ── Section: Buttons ──────────────────────────────────────────
local BtnSec = MainTab:Section("Buttons")

local myButton = BtnSec:Button("Click Me!", function()
    Window:Notify("Button Clicked", "You just pressed Click Me!", 3)
end)

BtnSec:Button("Save Config Example", function()
    Window:SaveConfig("MyProfile")
end)

BtnSec:Button("Load Config Example", function()
    Window:LoadConfig("MyProfile")
end)

-- Tooltip on any GuiObject
Window:AddTooltip(myButton, "This button fires a notification.")

BtnSec:CreateButtonRow(
    "Action A", function()
        Window:Notify("Action A", "Left button fired.", 2)
    end,
    "Action B", function()
        Window:Notify("Action B", "Right button fired.", 2)
    end
)


-- ── Section: Toggles & Switch ─────────────────────────────────
local ToggleSec = MainTab:Section("Toggles & Switch")

ToggleSec:Toggle(
    "Simple Toggle",   -- label
    false,             -- default state
    "SimpleToggle",    -- flag name
    function(enabled)
        print("SimpleToggle →", enabled)
    end
)

ToggleSec:ToggleBind(
    "Toggle + Keybind",
    false,
    Enum.KeyCode.G,
    "TBState",
    "TBKey",
    function(enabled, keyName)
        print("ToggleBind →", enabled, "key:", keyName)
    end
)

ToggleSec:Switch(
    "Pill Switch",
    true,
    "PillSwitch",
    function(enabled)
        print("PillSwitch →", enabled)
    end
)


-- ── Section: Sliders & Steppers ───────────────────────────────
local SliderSec = MainTab:Section("Sliders & Steppers")

SliderSec:Slider(
    "Walk Speed",      -- label
    0,                 -- min
    100,               -- max
    16,                -- default
    0,                 -- decimals
    "WalkSpeed",       -- flag
    function(v)
        local lp = game:GetService("Players").LocalPlayer
        if lp and lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = v
        end
    end
)

SliderSec:Slider("Opacity (float)", 0, 1, 0.75, 2, "Opacity", function(v)
    print("Opacity:", v)
end)

SliderSec:Stepper(
    "Jump Power",      -- label
    0,                 -- min
    200,               -- max
    50,                -- default
    5,                 -- step
    "JumpPower",       -- flag
    function(v)
        local lp = game:GetService("Players").LocalPlayer
        if lp and lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.JumpPower = v
        end
    end
)


-- ── Section: Keybinds ─────────────────────────────────────────
local BindSec = MainTab:Section("Keybind")

BindSec:Bind(
    "Teleport to Spawn",
    Enum.KeyCode.T,
    "TeleportBind",
    function()
        local lp = game:GetService("Players").LocalPlayer
        if lp and lp.Character then
            lp.Character:MoveTo(Vector3.new(0, 5, 0))
            Window:Notify("Teleported", "Moved to spawn (0, 5, 0).", 2)
        end
    end
)

BindSec:Button("Server Hop (Rejoin)", function()
    Window:Notify("Server Hop", "Finding a new server...", 3)
    Window:ServerHop(game.PlaceId)
end)

-- ══════════════════════════════════════════════════════════════
--  TAB 2 — INPUT & TEXT
-- ══════════════════════════════════════════════════════════════
local InputTab = Window:Tab("Input", 10734944524) -- Gear/Input icon
local VisualTab = Window:Tab("Visual", 10734946327) -- Eye/Visual icon
local DataTab = Window:Tab("Data", 10734945415) -- Database icon
local GridTab = Window:Tab("Grid", 10723380158) -- Grid icon

-- ── Section: Text Inputs ──────────────────────────────────────
local TextSec = InputTab:Section("Text Input")

TextSec:Input(
    "Single-line Input",
    "Type something...",
    "SingleInput",
    function(text)
        print("Input value:", text)
    end
)

-- NEW: Multi-line text box
TextSec:MultilineInput(
    "Notes / Multiline",
    "Enter multiple lines here...",
    4,               -- visible line count
    "NotesText",
    function(text)
        print("Notes updated:", text)
    end
)


-- ── Section: Tag Input ────────────────────────────────────────
local TagSec = InputTab:Section("Tag Input")

local tagObj = TagSec:TagInput(
    "Player Tags",
    {"VIP", "Admin"},   -- initial tags
    8,                  -- max tags
    "PlayerTags",
    function(tags)
        print("Tags:", table.concat(tags, ", "))
    end
)

TagSec:Button("Add 'Staff' programmatically", function()
    tagObj:AddTag("Staff")
end)


-- ── Section: Selection ────────────────────────────────────────
local SelectSec = InputTab:Section("Dropdowns")

-- Standard dropdown (single-select)
local singleDrop = SelectSec:Dropdown(
    "Single Select",
    {"Option A", "Option B", "Option C", "Option D"},
    false,          -- multi = false
    "Option A",
    "SingleDrop",
    function(selected)
        print("Selected:", selected)
    end
)

-- Multi-select dropdown
SelectSec:Dropdown(
    "Multi Select",
    {"Red", "Green", "Blue", "Yellow", "Purple"},
    true,           -- multi = true
    {"Red", "Blue"},
    "MultiDrop",
    function(selected)
        print("Multi selected:", table.concat(selected, ", "))
    end
)

-- Searchable dropdown
local searchDrop = SelectSec:SearchableDropdown(
    "Searchable",
    {"Apple","Banana","Cherry","Date","Elderberry","Fig","Grape","Honeydew"},
    "Apple",
    "FruitDrop",
    function(sel)
        print("Fruit:", sel)
    end
)

-- Refresh the dropdown list on demand
SelectSec:Button("Refresh Dropdown List", function()
    singleDrop:Refresh({"New A", "New B", "New C", "New D", "New E"})
    Window:Notify("Refreshed", "Dropdown list updated.", 2)
end)

-- Player dropdown (auto-updates when players join/leave)
SelectSec:PlayerDropdown(
    "Select Player",
    false,           -- includeSelf
    "TargetPlayer",
    function(name)
        print("Target player:", name)
    end
)

-- Radio group
SelectSec:RadioGroup(
    "Team",
    {"Red Team", "Blue Team", "Spectator"},
    "Blue Team",
    "TeamChoice",
    function(sel)
        print("Team:", sel)
    end
)


-- ══════════════════════════════════════════════════════════════
--  TAB 3 — VISUAL / DISPLAY
-- ══════════════════════════════════════════════════════════════
-- ── Section: Labels & Text ────────────────────────────────────
local LabelSec = VisualTab:Section("Labels & Layout")

LabelSec:Label("This is a centered Label")

LabelSec:Paragraph(
    "Paragraphs use SubTextColor and wrap automatically across multiple lines. "
    .. "Great for descriptions, help text, or disclaimers."
)

LabelSec:Separator()                    -- plain line
LabelSec:Separator("── or with text ──") -- labelled separator
LabelSec:Spacer(8)                      -- empty vertical space

LabelSec:Alert("This is an info alert.",    "info")
LabelSec:Alert("This is a warning.",        "warn")
LabelSec:Alert("Something went wrong!",     "error")
LabelSec:Alert("Operation successful.",     "success")


-- ── Section: Color Picker ─────────────────────────────────────
local ColorSec = VisualTab:Section("Color Picker")

ColorSec:ColorPicker(
    "Accent Color",
    Color3.fromRGB(0, 200, 145),
    1.0,             -- alpha
    "AccentCol",
    function(color, alpha)
        print(string.format("RGB(%.0f, %.0f, %.0f) A=%.2f",
            color.R * 255, color.G * 255, color.B * 255, alpha))
    end
)

ColorSec:ColorPicker(
    "Background (with alpha)",
    Color3.fromRGB(30, 30, 30),
    0.85,
    "BgCol",
    function(color, alpha)
        print("BG color updated, alpha =", alpha)
    end
)


-- ── Section: Image ────────────────────────────────────────────
local ImgSec = VisualTab:Section("Image")

ImgSec:Image(89738140174311, 80)    -- assetId, optional height in px
ImgSec:Label("Asset ID: ")


-- ══════════════════════════════════════════════════════════════
--  TAB 4 — DATA WIDGETS
-- ══════════════════════════════════════════════════════════════
-- ── Section: Progress Bars ────────────────────────────────────
local ProgressSec = DataTab:Section("Progress Bars")

local hpBar = ProgressSec:ProgressBar("Health",   0, 100, 80,  "HP")
local mpBar = ProgressSec:ProgressBar("Mana",     0, 100, 55,  "MP")
local xpBar = ProgressSec:ProgressBar("EXP",      0, 1000, 340, "XP")

ProgressSec:Button("Simulate Damage", function()
    local hp = Window:GetFlag("HP") or 80
    hpBar:Set(math.max(0, hp - math.random(5, 20)))
end)
ProgressSec:Button("Heal to Full", function()
    hpBar:Set(100)
    Window:Notify("Healed", "HP restored to 100.", 2)
end)


-- ── Section: Status Indicators ───────────────────────────────
local StatusSec = DataTab:Section("Status Indicators")

local connectionStatus = StatusSec:StatusIndicator(
    "Server Connection",
    "Connected",
    Color3.fromRGB(80, 220, 120)
)
local scriptStatus = StatusSec:StatusIndicator(
    "Script State",
    "Idle",
    Color3.fromRGB(80, 140, 255)
)

StatusSec:CreateButtonRow(
    "Set Active", function()
        scriptStatus:Set("Active", Color3.fromRGB(80, 220, 120))
    end,
    "Set Error", function()
        scriptStatus:Set("Error", Color3.fromRGB(255, 80, 80))
    end
)


-- ── Section: Key-Value Table ──────────────────────────────────
local TableSec = DataTab:Section("Key-Value Table")

local kvTable = TableSec:KeyValueTable({
    {"Player",     game:GetService("Players").LocalPlayer.Name},
    {"Place ID",   tostring(game.PlaceId)},
    {"Server",     game.JobId ~= "" and "Active" or "Studio"},
    {"Ping",       "0 ms"},
    {"FPS",        "0"},
})

-- Keep the table live
game:GetService("RunService").Heartbeat:Connect(function()
    local ping = 0
    pcall(function()
        ping = math.round(
            game:GetService("Players").LocalPlayer:GetNetworkPing() * 1000)
    end)
    kvTable:SetValue("Ping", ping .. " ms")
end)


-- ── Section: Bar Chart ────────────────────────────────────────
local ChartSec = DataTab:Section("Bar Chart")

-- NEW: Chart widget
ChartSec:Chart("Monthly Scores", {
    {label = "Jan", value = 42},
    {label = "Feb", value = 78},
    {label = "Mar", value = 55},
    {label = "Apr", value = 91},
    {label = "May", value = 33},
    {label = "Jun", value = 67},
}, 90)  -- height in px

ChartSec:Chart("Server Population", {
    {label = "EU",  value = 120},
    {label = "NA",  value = 95},
    {label = "AS",  value = 74},
    {label = "SA",  value = 31},
}, 70)


-- ── Section: Timer ────────────────────────────────────────────
local TimerSec = DataTab:Section("Countdown Timer")

-- NEW: Timer widget
local myTimer = TimerSec:Timer(
    "Round Timer",
    120,             -- seconds
    false,           -- autoStart
    function()
        Window:Notify("Time's Up!", "The round has ended.", 4)
    end
)

TimerSec:Slider("Set Duration (sec)", 10, 600, 120, 0, nil, function(v)
    myTimer:Set(v)
end)


-- ── Section: Console ─────────────────────────────────────────
local ConsoleSec = DataTab:Section("Console Output")

local console = ConsoleSec:Console(110)  -- height in px

ConsoleSec:CreateButtonRow(
    "Log Info", function()
        console:Print("[INFO] Script is running normally.", Color3.fromRGB(80, 140, 255))
    end,
    "Log Warning", function()
        console:Print("[WARN] Low memory detected.", Color3.fromRGB(255, 190, 50))
    end
)
ConsoleSec:CreateButtonRow(
    "Log Error", function()
        console:Print("[ERROR] Connection timeout.", Color3.fromRGB(255, 80, 80))
    end,
    "Clear Log", function()
        console:Clear()
    end
)

-- Seed the console with a startup message
console:Print("[SYSTEM] NextLevel initialised.", Color3.fromRGB(0, 200, 145))


-- ══════════════════════════════════════════════════════════════
--  TAB 5 — GRID & DIALOG
-- ══════════════════════════════════════════════════════════════
-- ── Section: Button Grid ─────────────────────────────────────
local GridSec = GridTab:Section("Ability Grid")

-- NEW: Grid widget  (items can be plain strings or {text, id} tables)
GridSec:Grid(
    "Quick Actions",
    {
        {text = "⚡ Speed",   id = "speed"},
        {text = "🛡 Shield",  id = "shield"},
        {text = "🔥 Fire",    id = "fire"},
        {text = "❄ Ice",      id = "ice"},
        {text = "💨 Dash",    id = "dash"},
        {text = "💥 Blast",   id = "blast"},
        {text = "✨ Heal",    id = "heal"},
        {text = "🌀 Spin",    id = "spin"},
        {text = "📡 Scan",    id = "scan"},
    },
    3,               -- columns
    function(id)
        Window:Notify("Ability Used", "Fired: " .. id, 2)
        console:Print("[ABILITY] Activated → " .. id, Color3.fromRGB(0, 200, 145))
    end
)

GridSec:Separator()

GridSec:Grid(
    "Teleport Presets",
    {"Spawn", "Shop", "Arena", "Lobby"},
    2,
    function(name)
        Window:Notify("Teleport", "Moving to: " .. name, 2)
    end
)


-- ── Section: Dialog ───────────────────────────────────────────
local DialogSec = GridTab:Section("Dialog Popups")

-- NEW: Dialog (modal overlay)
DialogSec:Button("Simple Confirm Dialog", function()
    Window:Dialog(
        "Confirm Action",
        "Are you sure you want to reset all your settings? This cannot be undone.",
        {"Yes, Reset", "Cancel"},
        function(choice)
            if choice == "Yes, Reset" then
                Window:Notify("Reset", "Settings have been cleared.", 3)
                console:Print("[ACTION] Settings reset by user.", Color3.fromRGB(255, 190, 50))
            else
                Window:Notify("Cancelled", "No changes were made.", 2)
            end
        end
    )
end)

DialogSec:Button("Three-Option Dialog", function()
    Window:Dialog(
        "Save Changes?",
        "You have unsaved modifications. Would you like to save, discard, or keep editing?",
        {"Save", "Discard", "Cancel"},
        function(choice)
            Window:Notify("Dialog Result", "You chose: " .. choice, 3)
        end
    )
end)

DialogSec:Button("Info Dialog", function()
    Window:Dialog(
        "About NextLevel",
        "Version 0.06  ·  Complete Feature Showcase.\nDeveloped by Acidgorgon.",
        {"OK"},
        function() end
    )
end)


-- ── Section: Utility ──────────────────────────────────────────
local UtilSec = MainTab:Section("Utility")

UtilSec:Webhook("Discord Logger", "LoggerURL", function(url)
    print("New Webhook URL:", url)
end)


-- ══════════════════════════════════════════════════════════════
--  BUILT-IN TABS  (Utility + Settings + Advanced)
-- ══════════════════════════════════════════════════════════════
Window:BuildUtilityTab(10723374643) -- Tools icon
Window:BuildThemeTab(10734947300) -- Brush icon
Window:BuildSettingsTab(10734944524) -- Gear icon
Window:BuildExecutorTab(10723415903) -- Terminal icon
Window:BuildNotificationLogTab(10734950056) -- Bell icon
Window:BuildChangelogTab({ -- List icon
    Icon = 10723403565,
    ["0.06"] = "• Fixed Theme Persistence in Configs\n• Integrated Keybind HUD into core\n• Added Global Search\n• Added Theme Presets\n• Added Smart Scroll Console\n• Added Silent Mode\n• Added Notification History",
    ["0.05"] = "• Added Sidebar mode\n• Initial v0.05 release"
})

-- ══════════════════════════════════════════════════════════════
--  POST-INIT  — flag reads, notifications, programmatic setters
-- ══════════════════════════════════════════════════════════════

-- Read a flag value at any time
task.delay(0.5, function()

    Window:Notify(
        "NextLevel Ready",
        "Premium Interface v0.06 initialized.\nPress RightControl to toggle UI.",
        5
    )
end)

Window:OnUnload(function()
    print("UI Unloaded! Performing cleanup...")
end)
