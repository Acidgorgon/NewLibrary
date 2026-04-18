--[[
    Heartkiss UI Library — Full Feature Example Script
    Demonstrates every element type available in the library.

    Toggle UI visibility: Right Shift
--]]

local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/Acidgorgon/2c0654b99a77b27e801ca6eb952a1e6c/raw/ec7c17921c7e59347f92d6c00a0ceea98ae22527/UILib"))()
-- OR if testing locally:
-- local Library = require(path.to.Heartkiss)

local LocalPlayer = game:GetService("Players").LocalPlayer

local Window = Library.new(
    "NextLevel",               -- window title
    UDim2.fromOffset(888, 818),     -- size (can be omitted for default)
    Enum.KeyCode.RightShift         -- toggle keybind
)

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB 1 — INFO  (text elements, alerts, separators)
-- ═══════════════════════════════════════════════════════════════════════════════
local InfoTab = Window:Tab("Info")

-- LEFT COLUMN ─────────────────────────────────────────────────────────────────
local AlertSection = InfoTab:Section("Alerts & Banners")

AlertSection:Alert("Everything is running smoothly.", "success")
AlertSection:Alert("Connected to game server.", "info")
AlertSection:Alert("High ping detected — latency may spike.", "warn")
AlertSection:Alert("Failed to reach remote endpoint.", "error")

local TextSection = InfoTab:Section("Text Elements")

TextSection:Label("This is a centered label")
TextSection:Separator()
TextSection:Paragraph(
    "Paragraphs support longer, wrapped text. Great for descriptions, " ..
    "changelogs, tooltips, or any extended info you want to show the user " ..
    "without cluttering a section label."
)
TextSection:Spacer(4)
TextSection:Separator("— divider with label —")
TextSection:Spacer(4)
TextSection:Label("Labels auto-center, paragraphs left-align.")

-- RIGHT COLUMN ────────────────────────────────────────────────────────────────
local StatsSection = InfoTab:Section("Live Stats Table")

-- KeyValueTable: alternating-row display, returns :SetValue(key, val)
local statsTable = StatsSection:KeyValueTable({
    { "Player",     LocalPlayer.Name },
    { "User ID",    tostring(LocalPlayer.UserId) },
    { "Account Age","? days" },
    { "Ping",       "? ms" },
    { "Server Age", "0s" },
    { "FPS",        "?" },
})

-- Update live stats in a background loop
task.spawn(function()
    local Stats = game:GetService("Stats")
    local startTime = tick()
    while task.wait(1) do
        statsTable:SetValue("Server Age", string.format("%.0fs", tick() - startTime))
        statsTable:SetValue("Ping",       string.format("%.0f ms", Stats.Network.ServerStatsItem["Data Ping"]:GetValue()))
        statsTable:SetValue("FPS",        string.format("%.0f", 1 / game:GetService("RunService").Heartbeat:Wait()))
    end
end)

local ServerSection = InfoTab:Section("Status Indicators")

-- StatusIndicator: dot + colored text, returns :Set(text, color)
local connStatus   = ServerSection:StatusIndicator("Connection", "Online",      Color3.fromRGB(80, 220, 120))
local scriptStatus = ServerSection:StatusIndicator("Script",     "Running",     Color3.fromRGB(80, 220, 120))
local serverStatus = ServerSection:StatusIndicator("Anti-Cheat", "Bypassed",   Color3.fromRGB(255, 190, 50))
local pingStatus   = ServerSection:StatusIndicator("Latency",    "Good",        Color3.fromRGB(80, 220, 120))

ServerSection:Separator()
ServerSection:CreateButtonRow(
    "Simulate Error", function()
        connStatus:Set("Timed Out",   Color3.fromRGB(255, 80, 80))
        pingStatus:Set("Critical",    Color3.fromRGB(255, 80, 80))
    end,
    "Simulate OK", function()
        connStatus:Set("Online",      Color3.fromRGB(80, 220, 120))
        pingStatus:Set("Good",        Color3.fromRGB(80, 220, 120))
    end
)

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB 2 — CONTROLS  (toggles, switches, buttons)
-- ═══════════════════════════════════════════════════════════════════════════════
local ControlTab = Window:Tab("Controls")

-- LEFT COLUMN ─────────────────────────────────────────────────────────────────
local ToggleSection = ControlTab:Section("Toggles  (checkbox style)")

ToggleSection:Toggle("ESP Enabled", false, "espEnabled", function(val)
    print("[Toggle] ESP Enabled:", val)
end)
ToggleSection:Toggle("Aimbot Enabled", false, "aimbotEnabled", function(val)
    print("[Toggle] Aimbot:", val)
end)
ToggleSection:Toggle("No Clip", false, "noClip", function(val)
    print("[Toggle] No Clip:", val)
end)
ToggleSection:Toggle("Auto Parry", true, "autoParry", function(val)
    print("[Toggle] Auto Parry:", val)
end)
ToggleSection:Toggle("Infinite Stamina", false, "infStamina", function(val)
    print("[Toggle] Infinite Stamina:", val)
end)

local SwitchSection = ControlTab:Section("Switches  (iOS pill style)")

SwitchSection:Switch("Auto-Farm", false, "autoFarm", function(val)
    print("[Switch] Auto-Farm:", val)
end)
SwitchSection:Switch("Silent Aim", false, "silentAim", function(val)
    print("[Switch] Silent Aim:", val)
end)
SwitchSection:Switch("Speed Hack", false, "speedHack", function(val)
    print("[Switch] Speed Hack:", val)
end)
SwitchSection:Switch("Godmode", false, "godMode", function(val)
    print("[Switch] Godmode:", val)
end)

-- RIGHT COLUMN ────────────────────────────────────────────────────────────────
local ButtonSection = ControlTab:Section("Buttons")

ButtonSection:Button("Teleport to Spawn", function()
    print("[Button] Teleporting to spawn...")
    Window:Notify("Teleport", "Teleporting to spawn...", 2)
end)

ButtonSection:Button("Kill All NPCs", function()
    print("[Button] Kill All NPCs")
    Window:Notify("Action", "Eliminated all NPCs.", 2)
end)

ButtonSection:Button("Reset Character", function()
    LocalPlayer.Character:FindFirstChild("Humanoid").Health = 0
end)

ButtonSection:Separator("── batch controls ──")

-- CreateButtonRow: two side-by-side buttons
ButtonSection:CreateButtonRow(
    "Enable All", function()
        for _, flag in {"espEnabled","aimbotEnabled","autoParry","autoFarm","silentAim"} do
            if Window.Setters[flag] then Window.Setters[flag](true) end
        end
        Window:Notify("Batch", "All features enabled.", 2)
    end,
    "Disable All", function()
        for _, flag in {"espEnabled","aimbotEnabled","autoParry","autoFarm","silentAim","noClip","speedHack","godMode","infStamina"} do
            if Window.Setters[flag] then Window.Setters[flag](false) end
        end
        Window:Notify("Batch", "All features disabled.", 2)
    end
)

ButtonSection:CreateButtonRow(
    "Save Flags", function()
        Window:Notify("Flags", "Current flags printed to console.", 2)
        for k, v in pairs(Window.Flags) do print(k, "=", v) end
    end,
    "Print Version", function()
        Window:Notify("Heartkiss", "Version 2.0.0 — Extended Edition", 3)
    end
)

local NotifSection = ControlTab:Section("Notifications")

NotifSection:Button("Info Notify", function()
    Window:Notify("Information", "This is an info-style notification.", 3)
end)
NotifSection:Button("Warning Notify", function()
    Window:Notify("Warning", "High memory usage detected! Consider restarting.", 4)
end)
NotifSection:Button("Error Notify", function()
    Window:Notify("Error", "Remote rejected: invalid argument #1 (string expected).", 5)
end)
NotifSection:Button("Long Notify", function()
    Window:Notify("Update Available", "Version 2.1.0 is available. New: SearchableDropdown, Switch, ProgressBar, Alert banners, KeyValueTable, and more.", 6)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB 3 — INPUTS  (sliders, steppers, text inputs, keybinds)
-- ═══════════════════════════════════════════════════════════════════════════════
local InputTab = Window:Tab("Inputs")

-- LEFT COLUMN ─────────────────────────────────────────────────────────────────
local SliderSection = InputTab:Section("Sliders")

SliderSection:Slider("FOV", 10, 360, 90, 0, "fov", function(val)
    print("[Slider] FOV:", val)
end)
SliderSection:Slider("Smoothness", 0.0, 1.0, 0.5, 2, "aimSmooth", function(val)
    print("[Slider] Smoothness:", val)
end)
SliderSection:Slider("ESP Distance", 100, 2000, 500, 0, "espDist", function(val)
    print("[Slider] ESP Distance:", val)
end)
SliderSection:Slider("Walk Speed", 16, 250, 16, 0, "walkSpeed", function(val)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = val
    end
end)
SliderSection:Slider("Jump Power", 7, 150, 7, 1, "jumpPower", function(val)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = val
    end
end)

local StepperSection = InputTab:Section("Steppers  (± step buttons)")

-- Stepper: integer-only, ± button controls, min/max clamped
StepperSection:Stepper("Max Targets", 1, 20, 5, 1, "maxTargets", function(val)
    print("[Stepper] Max Targets:", val)
end)
StepperSection:Stepper("Combo Delay (ms)", 50, 500, 100, 25, "comboDelay", function(val)
    print("[Stepper] Combo Delay:", val)
end)
StepperSection:Stepper("Farm Loops", 1, 100, 10, 5, "farmLoops", function(val)
    print("[Stepper] Farm Loops:", val)
end)
StepperSection:Stepper("Hit Offset", -10, 10, 0, 1, "hitOffset", function(val)
    print("[Stepper] Hit Offset:", val)
end)

-- RIGHT COLUMN ────────────────────────────────────────────────────────────────
local TextInputSection = InputTab:Section("Text Inputs")

-- Input: fires callback on FocusLost
TextInputSection:Input("Target Player", "Enter username...", "targetPlayer", function(val)
    print("[Input] Target:", val)
end)
TextInputSection:Input("Webhook URL", "https://discord.com/api/webhooks/...", "webhookUrl", function(val)
    print("[Input] Webhook URL set:", val ~= "" and "yes" or "no")
end)
TextInputSection:Input("Custom Title", "My Script", "customTitle", function(val)
    print("[Input] Title:", val)
end)
TextInputSection:Input("Notes", "Any text here...", "userNotes", function(val)
    print("[Input] Notes saved.")
end)

local BindSection = InputTab:Section("Keybinds")

-- Bind: click to rebind, fires callback on press
BindSection:Bind("Aimbot Toggle", Enum.KeyCode.E, "aimbotKey", function()
    print("[Bind] Aimbot toggled via keybind!")
    local current = Window:GetFlag("aimbotEnabled")
    if Window.Setters["aimbotEnabled"] then
        Window.Setters["aimbotEnabled"](not current)
    end
end)
BindSection:Bind("ESP Toggle", Enum.KeyCode.Z, "espKey", function()
    print("[Bind] ESP toggled via keybind!")
    local current = Window:GetFlag("espEnabled")
    if Window.Setters["espEnabled"] then
        Window.Setters["espEnabled"](not current)
    end
end)
BindSection:Bind("No Clip Key", Enum.KeyCode.V, "noClipKey", function()
    print("[Bind] No Clip triggered!")
end)
BindSection:Bind("Kill Aura", Enum.KeyCode.G, "killAuraKey", function()
    print("[Bind] Kill Aura triggered!")
end)
BindSection:Bind("Panic / Unload", Enum.KeyCode.Delete, "panicKey", function()
    Window:Notify("Unloading", "Goodbye!", 1)
    task.delay(1, function() Window:Unload() end)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB 4 — SELECTORS  (dropdowns, searchable, radio groups)
-- ═══════════════════════════════════════════════════════════════════════════════
local SelectTab = Window:Tab("Select")

-- LEFT COLUMN ─────────────────────────────────────────────────────────────────
local DropSection = SelectTab:Section("Dropdowns")

DropSection:Dropdown(
    "Aim Part",
    {"Head", "HumanoidRootPart", "Torso", "UpperTorso", "LeftUpperArm", "RightUpperArm"},
    false, "Head", "aimPart",
    function(val) print("[Dropdown] Aim part:", val) end
)

-- Multi-select dropdown
DropSection:Dropdown(
    "ESP Display",
    {"Box", "Name", "Health", "Distance", "Skeleton", "Tracers"},
    true, {"Box", "Name", "Health"}, "espDisplay",
    function(val) print("[Multi-Dropdown] ESP:", table.concat(val, ", ")) end
)

DropSection:Dropdown(
    "Notification Sound",
    {"None", "Chime", "Bell", "Ping", "Alert", "Custom"},
    false, "Chime", "notifSound",
    function(val) print("[Dropdown] Sound:", val) end
)

local RadioSection = SelectTab:Section("Radio Groups")

-- RadioGroup: single-select, displayed as a vertical radio list
RadioSection:RadioGroup(
    "Team Side",
    {"Blue Team", "Red Team", "Spectator"},
    "Blue Team", "teamSide",
    function(val) print("[Radio] Team:", val) end
)

RadioSection:Separator()

RadioSection:RadioGroup(
    "Priority Mode",
    {"Nearest", "Lowest HP", "Highest HP", "Random"},
    "Nearest", "priorityMode",
    function(val) print("[Radio] Priority:", val) end
)

RadioSection:Separator()

RadioSection:RadioGroup(
    "Render Quality",
    {"Low", "Medium", "High", "Ultra"},
    "High", "renderQuality",
    function(val) print("[Radio] Quality:", val) end
)

-- RIGHT COLUMN ────────────────────────────────────────────────────────────────
local SearchSection = SelectTab:Section("Searchable Dropdowns")

SearchSection:Paragraph(
    "Type to filter the list in real time. " ..
    "Useful for long lists like player names or game items."
)
SearchSection:Spacer(4)

-- SearchableDropdown: has a live search TextBox at the top of the open panel
local allPlayers = {
    "Alice", "Bob", "Charlie", "David", "Eve", "Frank",
    "Grace", "Henry", "Isabella", "Jack", "Karen", "Liam",
    "Mia", "Noah", "Olivia", "Peter", "Quinn", "Rachel",
    "Sam", "Tina", "Ursula", "Victor", "Wendy", "Xander",
    "Yara", "Zoe"
}
SearchSection:SearchableDropdown(
    "Target Player", allPlayers, nil, "searchTarget",
    function(val) print("[SearchDropdown] Target:", val) end
)

local weapons = {
    "Sword", "Katana", "Spear", "Axe", "Hammer",
    "Staff", "Wand", "Bow", "Crossbow", "Dagger",
    "Scythe", "Flail", "Trident", "Halberd", "Rapier"
}
SearchSection:SearchableDropdown(
    "Equip Weapon", weapons, "Sword", "equippedWeapon",
    function(val) print("[SearchDropdown] Weapon:", val) end
)

local zones = {}
for i = 1, 30 do table.insert(zones, "Zone " .. i) end
SearchSection:SearchableDropdown(
    "Teleport Zone", zones, nil, "teleportZone",
    function(val)
        print("[SearchDropdown] Teleporting to:", val)
        Window:Notify("Teleport", "Heading to " .. val .. "...", 2)
    end
)

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB 5 — DISPLAY  (progress bars, live data)
-- ═══════════════════════════════════════════════════════════════════════════════
local DisplayTab = Window:Tab("Display")

-- LEFT COLUMN ─────────────────────────────────────────────────────────────────
local ProgressSection = DisplayTab:Section("Progress Bars")

-- ProgressBar: display-only bar, returns { Set(val) }
local healthBar = ProgressSection:ProgressBar("Player Health",    0, 100,  75, "health")
local manaBar   = ProgressSection:ProgressBar("Mana",            0, 100,  50, "mana")
local xpBar     = ProgressSection:ProgressBar("Experience",      0, 1000, 430,"xp")
local loadBar   = ProgressSection:ProgressBar("Asset Load",      0, 100,  0,  "loadPct")
local farmBar   = ProgressSection:ProgressBar("Farm Progress",   0, 50,   0,  "farmProg")

ProgressSection:Separator()

ProgressSection:CreateButtonRow(
    "Take Damage", function()
        local cur = Window:GetFlag("health") or 75
        healthBar:Set(math.max(0, cur - 15))
        if (Window:GetFlag("health") or 0) <= 0 then
            Window:Notify("Died", "Character health reached zero.", 3)
        end
    end,
    "Heal", function()
        healthBar:Set(100)
        Window:Notify("Healed", "Health restored to full.", 2)
    end
)

ProgressSection:CreateButtonRow(
    "Gain XP", function()
        local cur = Window:GetFlag("xp") or 430
        local gained = math.random(30, 80)
        xpBar:Set(cur + gained)
        Window:Notify("XP", "+" .. gained .. " XP gained!", 2)
    end,
    "Simulate Load", function()
        task.spawn(function()
            for i = 0, 100, 5 do
                loadBar:Set(i)
                task.wait(0.05)
            end
            Window:Notify("Loaded", "Asset loading complete.", 2)
        end)
    end
)

-- Simulate mana drain & regen
task.spawn(function()
    while task.wait(2) do
        local cur = Window:GetFlag("mana") or 50
        manaBar:Set(math.min(100, cur + 8))
    end
end)

-- RIGHT COLUMN ────────────────────────────────────────────────────────────────
local FarmSection = DisplayTab:Section("Auto-Farm Monitor")

local farmedBar   = FarmSection:ProgressBar("Items Farmed", 0, 100, 0)
local goldBar     = FarmSection:ProgressBar("Gold",         0, 9999, 0)
local killBar     = FarmSection:ProgressBar("Kills",        0, 500,  0)

FarmSection:Separator()

local farmRunning = false
local farmConn

FarmSection:CreateButtonRow(
    "Start Farm", function()
        if farmRunning then return end
        farmRunning = true
        farmConn = task.spawn(function()
            local items, gold, kills = 0, 0, 0
            while farmRunning do
                task.wait(0.5)
                items = items + math.random(1, 3)
                gold  = gold  + math.random(10, 50)
                kills = kills + (math.random() > 0.7 and 1 or 0)
                farmedBar:Set(items)
                goldBar:Set(gold)
                killBar:Set(kills)
                farmBar:Set(items)
            end
        end)
        Window:Notify("Farm", "Auto-farm started.", 2)
    end,
    "Stop Farm", function()
        farmRunning = false
        if farmConn then task.cancel(farmConn) end
        Window:Notify("Farm", "Auto-farm stopped.", 2)
    end
)

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB 6 — COLORS  (color pickers)
-- ═══════════════════════════════════════════════════════════════════════════════
local ColorTab = Window:Tab("Colors")

-- LEFT COLUMN ─────────────────────────────────────────────────────────────────
local ESPColorSection = ColorTab:Section("ESP Colors")

ESPColorSection:ColorPicker(
    "ESP Box Color",
    Color3.fromRGB(255, 50, 50), 1,
    "espBoxColor",
    function(color, alpha)
        print(string.format("[Color] ESP Box: RGB(%.0f,%.0f,%.0f) A=%.2f",
            color.R*255, color.G*255, color.B*255, alpha))
    end
)

ESPColorSection:ColorPicker(
    "Name Tag Color",
    Color3.fromRGB(255, 255, 255), 1,
    "espNameColor",
    function(color, alpha)
        print("[Color] Name tag color changed")
    end
)

ESPColorSection:ColorPicker(
    "Health Bar Color",
    Color3.fromRGB(80, 220, 80), 0.9,
    "espHealthColor",
    function(color, alpha)
        print("[Color] Health bar color changed")
    end
)

ESPColorSection:ColorPicker(
    "Tracer Color",
    Color3.fromRGB(243, 117, 255), 0.8,
    "tracerColor",
    function(color, alpha)
        print("[Color] Tracer color changed")
    end
)

-- RIGHT COLUMN ────────────────────────────────────────────────────────────────
local AimColorSection = ColorTab:Section("Aimbot & UI Colors")

AimColorSection:ColorPicker(
    "FOV Circle Color",
    Color3.fromRGB(255, 255, 255), 0.7,
    "fovCircleColor",
    function(color, alpha)
        print("[Color] FOV circle color changed")
    end
)

AimColorSection:ColorPicker(
    "Crosshair Color",
    Color3.fromRGB(255, 80, 80), 1,
    "crosshairColor",
    function(color, alpha)
        print("[Color] Crosshair color changed")
    end
)

AimColorSection:Separator("── chams ──")

AimColorSection:ColorPicker(
    "Visible Chams",
    Color3.fromRGB(50, 100, 255), 0.6,
    "chamsVisColor",
    function(color, alpha)
        print("[Color] Visible chams changed")
    end
)

AimColorSection:ColorPicker(
    "Hidden Chams",
    Color3.fromRGB(255, 150, 50), 0.4,
    "chamsHidColor",
    function(color, alpha)
        print("[Color] Hidden chams changed")
    end
)

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB 7 — MISC  (tooltips, theme, everything else)
-- ═══════════════════════════════════════════════════════════════════════════════
local MiscTab = Window:Tab("Misc")

-- LEFT COLUMN ─────────────────────────────────────────────────────────────────
local ThemeSection = MiscTab:Section("Theme Customisation")

ThemeSection:Paragraph(
    "SetTheme() overrides THEMES values. Elements created after " ..
    "the call will use the new colors."
)
ThemeSection:Spacer(4)

ThemeSection:Dropdown(
    "Accent Color",
    {"Pink (default)", "Blue", "Green", "Orange", "Red", "White"},
    false, "Pink (default)", "accentPreset",
    function(val)
        local map = {
            ["Pink (default)"] = Color3.fromRGB(243, 117, 255),
            ["Blue"]           = Color3.fromRGB(80,  140, 255),
            ["Green"]          = Color3.fromRGB(80,  220, 120),
            ["Orange"]         = Color3.fromRGB(255, 160, 50),
            ["Red"]            = Color3.fromRGB(255, 80,  80),
            ["White"]          = Color3.fromRGB(220, 220, 220),
        }
        local color = map[val]
        if color then
            Window:SetTheme({
                LineColor   = color,
                SelectedTab = color,
            })
            Window:Notify("Theme", "Accent color changed to " .. val .. ".", 2)
        end
    end
)

local TooltipSection = MiscTab:Section("Tooltips  (hover elements)")

TooltipSection:Paragraph("Hover over the buttons below to see tooltips appear.")
TooltipSection:Spacer(4)

local btn1 = TooltipSection:Button("Button with Tooltip", function()
    Window:Notify("Tooltip Button", "You clicked the button!", 2)
end)
Window:AddTooltip(btn1, "Click me to trigger a notification.")

local btn2 = TooltipSection:Button("Another Tooltip Button", function()
    Window:Notify("Info", "Tooltips work on any GuiObject.", 2)
end)
Window:AddTooltip(btn2, "AddTooltip() works on any GuiObject returned by Section methods.")

-- RIGHT COLUMN ────────────────────────────────────────────────────────────────
local MinimizeSection = MiscTab:Section("Minimize & Unload")

MinimizeSection:Label("Click the '−' button on the title bar")
MinimizeSection:Label("to collapse the window.")
MinimizeSection:Separator()
MinimizeSection:Paragraph(
    "The minimize button is built into the library. " ..
    "It tweens the window height to 26px when collapsed."
)
MinimizeSection:Spacer(6)
MinimizeSection:Button("Unload Library", function()
    Window:Notify("Unloading", "Cleaning up and destroying UI...", 1)
    task.delay(1.2, function()
        Window:Unload()
    end)
end)

local FlagSection = MiscTab:Section("Flag Inspector")

FlagSection:Paragraph(
    "Flags are global state managed by the library. " ..
    "Every flagged element writes to Window.Flags[flag]."
)
FlagSection:Spacer(4)

FlagSection:Button("Print All Flags", function()
    print("\n=== Heartkiss Flags ===")
    for k, v in pairs(Window.Flags) do
        if type(v) == "table" then
            print(k, "=", "{", "R="..string.format("%.2f",v.R or 0), "G="..string.format("%.2f",v.G or 0), "B="..string.format("%.2f",v.B or 0), "}")
        else
            print(k, "=", tostring(v))
        end
    end
    print("=======================\n")
    Window:Notify("Flags", "All flags printed to output.", 3)
end)

FlagSection:CreateButtonRow(
    "GetFlag('fov')", function()
        Window:Notify("Flag", "FOV = " .. tostring(Window:GetFlag("fov")), 3)
    end,
    "GetFlag('aimPart')", function()
        Window:Notify("Flag", "Aim Part = " .. tostring(Window:GetFlag("aimPart")), 3)
    end
)

FlagSection:CreateButtonRow(
    "Set FOV to 180", function()
        if Window.Setters["fov"] then
            Window.Setters["fov"](180)
            Window:Notify("Setter", "FOV forced to 180.", 2)
        end
    end,
    "Set Team to Red", function()
        if Window.Setters["teamSide"] then
            Window.Setters["teamSide"]("Red Team")
            Window:Notify("Setter", "Team set to Red Team.", 2)
        end
    end
)

-- ═══════════════════════════════════════════════════════════════════════════════
-- BUILT-IN SETTINGS TAB  (config save/load, about)
-- ═══════════════════════════════════════════════════════════════════════════════
Window:BuildSettingsTab()

-- ═══════════════════════════════════════════════════════════════════════════════
-- STARTUP NOTIFICATION
-- ═══════════════════════════════════════════════════════════════════════════════
Window:Notify(
    "Heartkiss Loaded",
    "All features ready. Press RightShift to toggle UI.",
    5
)

print("[Heartkiss] UI loaded. Player:", LocalPlayer.Name)