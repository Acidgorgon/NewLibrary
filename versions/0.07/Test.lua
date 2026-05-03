--!nocheck
--!nolint
-- ============================================================
--  NextLevel v0.07 — Ease API (shorter than 0.06 test; feature coverage kept tight)
--  • Window:Ease() → E:N(...) for Notify; still use E:Tab, E:SaveConfig, …
--  • Window:Vars() → V.flagName reads / writes Flags + Setters
--  • Table-style widgets: Section:Button { text=, flag=, callback= … } (0.06 signatures still work)
-- ============================================================

-- Remote (replace with your hosted 0.07/Lib.lua raw URL when published):
-- local Library = loadstring(game:HttpGet("https://gist.../Lib.lua"))()

-- From this repo on your machine (executor readfile):
local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/Acidgorgon/2c0654b99a77b27e801ca6eb952a1e6c/raw/9bb469e89663376e9379eb6aeaab54c896ba3131/UILib"))()

Library:InitLoad({
    Title       = "NextLevel",
    SubTitle    = "v0.07 — Ease",
    Icon        = 10734914443,
    Duration    = 2,
    AccentColor = Color3.fromRGB(255, 255, 255),
    Statuses    = { "Loading widgets…", "Binding Vars…", "Ready." },
})

local ICON = 10734914443

local Window = Library.new({
    Title   = "NextLevel",
    Size    = UDim2.fromOffset(500, 520),
    KeyBind = Enum.KeyCode.RightControl,
    Mode    = "Classic",
    Icon    = ICON,
})
Window:SetPanicKey(Enum.KeyCode.End)

local E = Window:Ease()
local V = Window:Vars()
Window:IgnoreFlag("SensitiveDemo")

------------------------------------------------------------
-- Main
------------------------------------------------------------
local Main = Window:Tab("Main", ICON)
local Btn = Main:Section("Buttons")
Btn:Button { text = "Notify", callback = function() E:N("Clicked", "Ease :N()", 3) end }
Btn:CreateButtonRow {
    left    = "Save",
    right   = "Load",
    onLeft  = function() Window:SaveConfig("demo07") end,
    onRight = function() Window:LoadConfig("demo07") end,
}

local Tg = Main:Section("Toggles")
Tg:Toggle { text = "One", default = false, flag = "T1", changed = function(on) print("[T1]", on) end }

Tg:ToggleBind {
    text         = "Toggle + key",
    defaultState = false,
    defaultKey   = Enum.KeyCode.G,
    flagState    = "TBst",
    flagKey      = "TBkey",
    callback     = function(en, kn) print("Bind", en, kn) end,
}

Tg:Switch { text = "Pill", default = true, flag = "Sw1", callback = function(s) print("Sw", s) end }

local Sl = Main:Section("Sliders")
local Players = game:GetService("Players")
Sl:Slider {
    text     = "Walk",
    min      = 0,
    max      = 100,
    default  = 16,
    decimals = 0,
    flag     = "WalkSpeed",
    callback = function(v)
        local h = Players.LocalPlayer and Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = v end
    end,
}

Sl:Stepper {
    text     = "Jump",
    min      = 0,
    max      = 200,
    default  = 50,
    step     = 5,
    flag     = "JumpPower",
    callback = function(v)
        local h = Players.LocalPlayer and Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.JumpPower = v end
    end,
}

local Bn = Main:Section("Keybind / hop")
Bn:Bind {
    text       = "To spawn",
    defaultKey = Enum.KeyCode.T,
    flag       = "SpawnBind",
    callback   = function()
        local ch = Players.LocalPlayer and Players.LocalPlayer.Character
        if ch then ch:MoveTo(Vector3.new(0, 5, 0)); E:N("Moved", "(0, 5, 0)", 2) end
    end,
}
Bn:Button("Rejoin", function() E:N("Hop", "Finding server…", 2); Window:ServerHop(game.PlaceId) end)

------------------------------------------------------------
-- Input / Visual / Data / Grid (condensed)
------------------------------------------------------------
local InputT = Window:Tab("Input", 10734944524)
local Visual = Window:Tab("Visual", 10734946327)
local DataT  = Window:Tab("Data", 10734945415)
local GridT  = Window:Tab("Grid", 10723380158)

local InSec = InputT:Section("Fields")
InSec:Input {
    text        = "Line input",
    placeholder = "type…",
    flag        = "In1",
}

InSec:MultilineInput {
    text        = "Notes",
    placeholder = "blocks…",
    lines       = 4,
    flag        = "Notes",
}

local TagSec = InputT:Section("Tags")
local tagCtl = TagSec:TagInput {
    text    = "Tags",
    tags    = { "VIP" },
    maxTags = 8,
    flag    = "TagsF",
}
TagSec:Button("Add Staff tag", function() tagCtl:AddTag("Staff") end)

local Pulldown = InputT:Section("Pickers")
Pulldown:Dropdown {
    text     = "Single",
    options  = { "A", "B", "C" },
    multi    = false,
    default  = "A",
    flag     = "Dr1",
}

Pulldown:SearchableDropdown {
    text    = "Search",
    options = { "x", "y", "z" },
    default = "x",
    flag    = "SD1",
}

Pulldown:PlayerDropdown { text = "Player", includeSelf = false, flag = "PD1" }

Pulldown:RadioGroup {
    group   = "Pick",
    options = { "L", "R" },
    default = "L",
    flag    = "Rad1",
}

local Vis = Visual:Section("Looks")
Vis:ColorPicker {
    text         = "Color",
    defaultColor = Color3.fromRGB(40, 200, 140),
    alpha        = 1,
    flag         = "CP1",
}
Vis:Label("Labels / Paragraph / Separator work unchanged.")
Vis:Separator("…")

local DProg = DataT:Section("Progress")
local hpBar = DProg:ProgressBar("HP", 0, 100, 80, "HPdemo")
DProg:Button("Hit", function()
    hpBar:Set(math.max(0, (V.HPdemo or 80) - math.random(5, 20)))
end)

local Dst = DataT:Section("Status")
Dst:StatusIndicator("Run", "Idle", Color3.fromRGB(130, 200, 255))

DataT:Chart("Sample", {
    { label = "Jan", value = 10 },
    { label = "Feb", value = 22 },
}, 72)

local TmSec = DataT:Section("Timer · console")
local tmr = TmSec:Timer("Cooldown", 60, false, function() E:N("Timer", "Done", 2) end)
TmSec:Slider {
    text     = "Sec",
    min      = 5,
    max      = 300,
    default  = 60,
    decimals = 0,
    callback = function(sec) tmr:Set(sec) end,
}

local conSec = DataT:Section("Console")
local log = conSec:Console(96)
conSec:CreateButtonRow {
    texts     = { "Log line", "Clear" },
    callbacks = {
        function() log:Print("msg", Color3.fromRGB(100, 180, 255)) end,
        function() log:Clear() end,
    },
}
log:Print("[0.07] Ease + Vars()", Color3.fromRGB(0, 200, 145))

local Gsec = GridT:Section("Grid / dialog")
Gsec:Grid {
    text    = "Quick",
    items   = { { text = "α", id = "a" }, { text = "β", id = "b" }, { text = "γ", id = "c" } },
    columns = 3,
    callback = function(id) E:N("Grid", tostring(id), 2) end,
}

Gsec:Button("Modal", function()
    Window:Dialog("OK?", "Example dialog.", { "Yes", "No" }, function(ch) E:N("Choice", ch, 2) end)
end)

Main:Section("Extras"):Webhook("Discord URL", "WhF", function(u) print("webhook", u) end)

------------------------------------------------------------
-- Built-in tabs
------------------------------------------------------------
Window:BuildUtilityTab(10723374643)
Window:BuildThemeTab(10734947300)
Window:BuildSettingsTab(10734944524)
Window:BuildExecutorTab(10723415903)
Window:BuildNotificationLogTab(10734950056)
Window:BuildChangelogTab({
    Icon   = 10723403565,
    ["0.07"] = "• Table-style widget options (backward compatible).\n• Window:Ease() and Window:Vars().\n• Library.Version = \"0.07\"",
})

task.delay(0.5, function()
    E:N("NextLevel", "v0.07 — RightControl toggles UI.", 5)
end)

Window:OnUnload(function() print("NextLevel 0.07 unloaded") end)
