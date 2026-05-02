-- Replace this with the actual URL to your raw library code (e.g., your GitHub Gist)
local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/Acidgorgon/2c0654b99a77b27e801ca6eb952a1e6c/raw/162284edcedc25fe994a6e53b283cda613afd279/UILib"))()

-- 1. Initialize the Window
-- Name, Size, Toggle KeyBind
local Window = Library.new("Heartkiss Premium", UDim2.fromScale(700, 750), Enum.KeyCode.RightControl)

-- ==========================================
-- TAB 1: COMBAT
-- ==========================================
local CombatTab = Window:Tab("Combat")
local AimbotSection = CombatTab:Section("Aimbot")

AimbotSection:Toggle("Enable Aimbot", false, "Combat_AimbotEnabled", function(state)
    print("Aimbot state:", state)
end)

-- Notice the '1' for decimals, allowing values like 90.5
AimbotSection:Slider("FOV Radius", 0, 360, 90, 1, "Combat_FOV", function(value)
    print("FOV changed to:", value)
end)

-- Single-select Dropdown
AimbotSection:Dropdown("Target Part", {"Head", "Torso", "HumanoidRootPart"}, false, "Head", "Combat_TargetPart", function(selected)
    print("Targeting:", selected)
end)

local GunSection = CombatTab:Section("Weapon Mods")

-- Multi-select Dropdown (returns a table of selections)
GunSection:Dropdown("Weapon Overrides", {"No Recoil", "No Spread", "Rapid Fire", "Infinite Ammo"}, true, {"No Recoil"}, "Combat_WeaponMods", function(selectedTable)
    print("Active mods:", table.concat(selectedTable, ", "))
end)

GunSection:Button("Reload Current Weapon", function()
    print("Manual reload triggered!")
end)

-- ==========================================
-- TAB 2: VISUALS
-- ==========================================
local VisualsTab = Window:Tab("Visuals")
local EspSection = VisualsTab:Section("ESP Settings")

EspSection:Toggle("Enable ESP", true, "Visuals_ESPEnabled", function(state)
    print("ESP Active:", state)
end)

-- ColorPicker with default Red and 0.5 transparency (Alpha)
EspSection:ColorPicker("Enemy Color", Color3.fromRGB(255, 50, 50), 0.5, "Visuals_EnemyColor", function(color, alpha)
    print("Enemy color updated. R:", color.R, "Alpha:", alpha)
end)

EspSection:ColorPicker("Team Color", Color3.fromRGB(50, 255, 50), 1, "Visuals_TeamColor", function(color, alpha)
    print("Team color updated.")
end)

local WorldSection = VisualsTab:Section("World Options")

WorldSection:CreateButtonRow("Day Time", function()
    print("Time set to Day")
end, "Night Time", function()
    print("Time set to Night")
end)

WorldSection:Slider("Ambient Lighting", 0, 100, 50, 0, "Visuals_Ambient", function(value)
    print("Lighting intensity:", value)
end)

-- ==========================================
-- TAB 3: MISCELLANEOUS
-- ==========================================
local MiscTab = Window:Tab("Misc")
local InfoSection = MiscTab:Section("Information")

InfoSection:Label("Welcome to Heartkiss!")

-- InfoSection:Paragraph("How to use", "Use the RightControl key to hide or show this menu.\n\nAll your settings in the Combat and Visuals tabs will automatically be saved when you use the UI Settings tab.")

local UtilitySection = MiscTab:Section("Utilities")

UtilitySection:Input("Chat Spam Text", "Type message here...", "Misc_ChatSpam", function(text)
    print("Spam text set to:", text)
end)

UtilitySection:Bind("Panic Key (Unload)", Enum.KeyCode.End, "Misc_UnloadBind", function()
    print("Panic key pressed! Unloading UI...")
    Window:Unload()
end)

-- ==========================================
-- FINIALIZATION
-- ==========================================

-- 2. Automatically generate the JSON saving/loading tab
Window:BuildSettingsTab()

-- 3. Send a welcome notification
Window:Notify("Heartkiss Loaded", "Script initialized successfully. Press RightControl to toggle the UI.", 5)