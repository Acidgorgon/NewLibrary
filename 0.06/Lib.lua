--!nocheck
--!nolint

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

export type DropdownController = {
    Refresh: (self: DropdownController, newList: {string}) -> (),
}

export type ProgressBarController = {
    Set: (self: ProgressBarController, value: number) -> (),
}

export type StatusIndicatorController = {
    Set: (self: StatusIndicatorController, statusText: string, color: Color3?) -> (),
}

export type KeyValueTableController = {
    SetValue: (self: KeyValueTableController, key: string, value: any) -> (),
}

export type ConsoleController = {
    Print: (self: ConsoleController, msg: string, color: Color3?) -> (),
    Clear: (self: ConsoleController) -> (),
}

export type Section = {
    Button: (self: Section, text: string, callback: (() -> ())?) -> TextButton,
    CreateButtonRow: (self: Section, text1: string, callback1: (() -> ())?, text2: string, callback2: (() -> ())?) -> (TextButton, TextButton),
    Toggle: (self: Section, text: string, default: boolean?, flag: string?, callback: ((enabled: boolean) -> ())?) -> (),
    ToggleBind: (self: Section, text: string, defaultState: boolean?, defaultKey: Enum.KeyCode?, flagState: string?, flagKey: string?, callback: ((enabled: boolean, keyName: string) -> ())?) -> (),
    Switch: (self: Section, text: string, default: boolean?, flag: string?, callback: ((enabled: boolean) -> ())?) -> (),
    Slider: (self: Section, text: string, min: number, max: number, default: number?, decimals: number?, flag: string?, callback: ((value: number) -> ())?) -> (),
    Stepper: (self: Section, text: string, min: number, max: number, default: number?, step: number?, flag: string?, callback: ((value: number) -> ())?) -> (),
    Bind: (self: Section, text: string, defaultKey: Enum.KeyCode?, flag: string?, callback: (() -> ())?) -> (),
    Input: (self: Section, text: string, placeholder: string?, flag: string?, callback: ((text: string) -> ())?) -> (),
    Dropdown: (self: Section, text: string, options: {string}, multi: boolean?, default: any?, flag: string?, callback: ((selected: any) -> ())?) -> DropdownController,
    SearchableDropdown: (self: Section, text: string, options: {string}, default: string?, flag: string?, callback: ((selected: string) -> ())?) -> DropdownController,
    PlayerDropdown: (self: Section, text: string, includeSelf: boolean?, flag: string?, callback: ((selected: string) -> ())?) -> DropdownController,
    RadioGroup: (self: Section, label: string, options: {string}, default: string?, flag: string?, callback: ((selected: string) -> ())?) -> (),
    ColorPicker: (self: Section, text: string, defaultColor: Color3?, defaultAlpha: number?, flag: string?, callback: ((color: Color3, alpha: number) -> ())?) -> (),
    Label: (self: Section, text: string) -> TextLabel,
    Paragraph: (self: Section, text: string) -> TextLabel,
    Separator: (self: Section, label: string?) -> (),
    Spacer: (self: Section, height: number?) -> (),
    ProgressBar: (self: Section, text: string, min: number?, max: number?, default: number?, flag: string?) -> ProgressBarController,
    StatusIndicator: (self: Section, label: string, initialText: string?, initialColor: Color3?) -> StatusIndicatorController,
    Alert: (self: Section, alertText: string, alertType: ("info" | "warn" | "error" | "success")?) -> (),
    Image: (self: Section, assetId: number | string, height: number?) -> ImageLabel,
    KeyValueTable: (self: Section, rows: {{any}}) -> KeyValueTableController,
    Console: (self: Section, height: number?) -> ConsoleController,
}

export type Tab = {
    Section: (self: Tab, title: string) -> Section,
}

export type Window = {
    Name: string,
    Size: UDim2,
    KeyBind: Enum.UserInputType | Enum.KeyCode,
    Flags: {[string]: any},
    Setters: {[string]: (any) -> ()},
    Tab: (self: Window, text: string, iconId: (string|number)?) -> Tab,
    Notify: (self: Window, title: string, text: string, duration: number?) -> (),
    SetTheme: (self: Window, overrides: {[string]: any}) -> (),
    ServerHop: (self: Window, placeId: number, jobId: string?, scriptToQueue: string?) -> (),
    GetFlag: (self: Window, flag: string) -> any,
    IgnoreFlag: (self: Window, flag: string) -> (),
    AddTooltip: (self: Window, element: GuiObject, tipText: string) -> (),
    Unload: (self: Window) -> (),
    SetPanicKey: (self: Window, key: Enum.KeyCode) -> (),
    SaveConfig: (self: Window, name: string) -> (),
    LoadConfig: (self: Window, name: string) -> (),
    ListConfigs: (self: Window) -> {string},

    BuildUtilityTab: (self: Window, iconId: (string|number)?) -> (),
    BuildSettingsTab: (self: Window, iconId: (string|number)?) -> (),
    BuildThemeTab: (self: Window, iconId: (string|number)?) -> (),
}

export type LibraryModule = {
    new: (Name: string?, Size: UDim2?, KeyBind: (Enum.UserInputType | Enum.KeyCode)?, Mode: string?, Icon: (string|number)?) -> Window,
    Notify: (self: any, title: string, text: string, duration: number?) -> (),
    SetTheme: (self: any, overrides: {[string]: any}) -> (),
    ServerHop: (self: any, placeId: number, jobId: string?, scriptToQueue: string?) -> (),
    GetFlag: (self: any, flag: string) -> any,
    IgnoreFlag: (self: any, flag: string) -> (),
    AddTooltip: (self: any, element: GuiObject, tipText: string) -> (),
    Unload: (self: any) -> (),
    SetPanicKey: (self: any, key: Enum.KeyCode) -> (),
    SaveConfig: (self: any, name: string) -> (),
    LoadConfig: (self: any, name: string) -> (),
    ListConfigs: (self: any) -> {string},

    BuildUtilityTab: (self: Window, iconId: (string|number)?) -> (),
    BuildSettingsTab: (self: Window, iconId: (string|number)?) -> (),
    BuildThemeTab: (self: Window, iconId: (string|number)?) -> (),
}

local isfolder = isfolder or function() return false end
local makefolder = makefolder or function() end
local writefile = writefile or function() end
local readfile = readfile or function() return "{}" end
local listfiles = listfiles or function() return {} end
local isfile = isfile or function() return false end
local delfile = delfile or function() end
local setclipboard = setclipboard or function(text) print("Clipboard:", text) end
local getclipboard = getclipboard or function() return "" end
local kpress = keypress or function() end
local krelease = keyrelease or function() end
local m1click = mouse1click or function() end
local m2click = mouse2click or function() end
local queue_on_teleport = queue_on_teleport or syn and syn.queue_on_teleport or fluxus and fluxus.queue_on_teleport or function() end

local Library: LibraryModule = {} :: any
Library.__index = Library

if not getgenv()._NextLevel_Garbage then
    getgenv()._NextLevel_Garbage = {}
end

local function CleanID(id: string)
    if not getgenv()._NextLevel_Garbage[id] then return end
    for _, item in getgenv()._NextLevel_Garbage[id] do
        if typeof(item) == "RBXScriptConnection" then item:Disconnect()
        elseif typeof(item) == "Instance" then item:Destroy()
        elseif type(item) == "function" then task.spawn(item)
        elseif type(item) == "thread" then task.cancel(item) end
    end
    getgenv()._NextLevel_Garbage[id] = nil
end

local THEMES = {
    MainColor        = Color3.fromRGB(15, 15, 15),
    FrameColor       = Color3.fromRGB(20, 20, 20),
    TabColor         = Color3.fromRGB(18, 18, 18),
    LineColor        = Color3.fromRGB(78, 78, 78),
    AccentColor      = Color3.fromRGB(78, 78, 78),
    BorderColor      = Color3.fromRGB(40, 40, 40),
    DarkColor        = Color3.fromRGB(10, 10, 10),
    SelectedTab      = Color3.fromRGB(78, 78, 78),
    TextColor        = Color3.fromRGB(245, 245, 245),
    ButtonBorderColor= Color3.fromRGB(35, 35, 35),
    SubTextColor     = Color3.fromRGB(150, 150, 150),
    SuccessColor     = Color3.fromRGB(255, 255, 255),
    WarningColor     = Color3.fromRGB(255, 175, 50),
    ErrorColor       = Color3.fromRGB(255, 70, 90),
    InfoColor        = Color3.fromRGB(255, 255, 255),
    TextSize         = 13,
    BaseHeight       = 26,
}

local ThemeEvent = Instance.new("BindableEvent")

local function CreateGradient(Parent: any, Rotation)
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(220, 220, 225))
    }
    UIGradient.Rotation = Rotation or 45
    UIGradient.Parent = Parent
end

local function RoundCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 6)
    c.Parent = parent
    return c
end

local function ProtectGui(gui)
    if syn and syn.protect_gui then syn.protect_gui(gui)
    elseif protectgui then protectgui(gui) end
end

function Library:Notify(title: string, text: string, duration: number)
    if self and self.NotificationHistory then
        table.insert(self.NotificationHistory, {
            Title = title,
            Text = text,
            Time = os.date("%H:%M:%S")
        })
        if #self.NotificationHistory > 100 then table.remove(self.NotificationHistory, 1) end
    end

    if Library.IsSilent then return end
    duration = duration or 3

    local layout = self.NotifyLayout or Library._GlobalNotifyLayout

    if not layout then
        local NotifyGui = Instance.new("ScreenGui")
        NotifyGui.Name = "NextLevel_Standalone_Notifications"
        NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        ProtectGui(NotifyGui)
        NotifyGui.Parent = CoreGui

        layout = Instance.new("Frame")
        layout.Name = "Layout"
        layout.BackgroundTransparency = 1
        layout.Size = UDim2.new(0, 260, 1, -40)
        layout.Position = UDim2.new(1, -270, 0, 20)
        layout.Parent = NotifyGui

        local NotifyList = Instance.new("UIListLayout")
        NotifyList.SortOrder = Enum.SortOrder.LayoutOrder
        NotifyList.VerticalAlignment = Enum.VerticalAlignment.Top
        NotifyList.Padding = UDim.new(0, 10)
        NotifyList.Parent = layout

        Library._GlobalNotifyLayout = layout
    end

    local Holder = Instance.new("Frame")
    Holder.BackgroundTransparency = 1
    Holder.Size = UDim2.new(1, 0, 0, 60)
    Holder.Parent = layout

    local Notif = Instance.new("Frame")
    Notif.Size = UDim2.new(1, 0, 1, 0)
    Notif.BackgroundColor3 = THEMES.MainColor
    Notif.BorderColor3 = THEMES.LineColor
    Notif.Position = UDim2.new(1, 30, 0, 0)
    Notif.BackgroundTransparency = 1
    CreateGradient(Notif)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -10, 0, 20)
    Title.Position = UDim2.new(0, 5, 0, 2)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = THEMES.LineColor
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.Code
    Title.TextSize = THEMES.TextSize + 1
    Title.TextTransparency = 1
    Title.Parent = Notif

    local Desc = Instance.new("TextLabel")
    Desc.Size = UDim2.new(1, -10, 0, 30)
    Desc.Position = UDim2.new(0, 5, 0, 24)
    Desc.BackgroundTransparency = 1
    Desc.Text = text
    Desc.TextColor3 = THEMES.TextColor
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.TextYAlignment = Enum.TextYAlignment.Top
    Desc.TextWrapped = true
    Desc.Font = Enum.Font.Code
    Desc.TextSize = THEMES.TextSize
    Desc.TextTransparency = 1
    Desc.Parent = Notif

    Notif.Parent = Holder

    local tweenIn = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(Notif, tweenIn, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0}):Play()
    TweenService:Create(Title, tweenIn, {TextTransparency = 0}):Play()
    TweenService:Create(Desc, tweenIn, {TextTransparency = 0}):Play()

    task.delay(duration, function()
        local tweenOut = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        TweenService:Create(Notif, tweenOut, {Position = UDim2.new(1.1, 0, 0, 0), BackgroundTransparency = 1}):Play()
        TweenService:Create(Title, tweenOut, {TextTransparency = 1}):Play()
        TweenService:Create(Desc, tweenOut, {TextTransparency = 1}):Play()
        task.delay(0.25, function() Holder:Destroy() end)
    end)
end

function Library:SetTheme(overrides: table)
    for k, v in overrides do
        if THEMES[k] ~= nil then THEMES[k] = v end
    end
    ThemeEvent:Fire() 
end

function Library:ServerHop(placeId, jobId, scriptToQueue)
    if not self.ConfigFolder then return end

    local dataToSave = {}
    for flag, val in self.Flags do
        if not self.IgnoredFlags[flag] then dataToSave[flag] = val end
    end
    
    pcall(function() 
        writefile(self.ConfigFolder .. "/teleport_state.json", HttpService:JSONEncode(dataToSave)) 
        writefile(self.ConfigFolder .. "/autoload.txt", "teleport_state")
    end)

    if scriptToQueue then
        queue_on_teleport(scriptToQueue)
    end

    self:Notify("Teleporting...", "Saving state and moving to new server...", 5)
    task.wait(1)
    
    if jobId then
        TeleportService:TeleportToPlaceInstance(placeId, jobId, Players.LocalPlayer)
    else
        TeleportService:Teleport(placeId, Players.LocalPlayer)
    end
end

function Library:GetFlag(flag: string) return self.Flags and self.Flags[flag] end

function Library:IgnoreFlag(flag: string)
    if self.IgnoredFlags then
        self.IgnoredFlags[flag] = true
    end
end

function Library:AddTooltip(element: GuiObject, tipText: string)
    local garbage = getgenv()._NextLevel_Garbage[self.Name]
    local TipFrame = Instance.new("Frame")
    TipFrame.Size = UDim2.new(0, 180, 0, THEMES.BaseHeight + 4)
    TipFrame.BackgroundColor3 = THEMES.MainColor
    TipFrame.BorderColor3 = THEMES.LineColor
    TipFrame.ZIndex = 100
    TipFrame.Visible = false
    TipFrame.Parent = self.Frames.MainFrame

    local TipLbl = Instance.new("TextLabel")
    TipLbl.Size = UDim2.new(1, -8, 1, 0)
    TipLbl.Position = UDim2.new(0, 4, 0, 0)
    TipLbl.BackgroundTransparency = 1
    TipLbl.Text = tipText
    TipLbl.TextColor3 = THEMES.SubTextColor
    TipLbl.Font = Enum.Font.Code
    TipLbl.TextSize = THEMES.TextSize - 1
    TipLbl.TextWrapped = true
    TipLbl.ZIndex = 101
    TipLbl.Parent = TipFrame

    table.insert(garbage, element.MouseEnter:Connect(function() TipFrame.Visible = true end))
    table.insert(garbage, element.MouseLeave:Connect(function() TipFrame.Visible = false end))
    table.insert(garbage, UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and TipFrame.Visible then
            local mf = self.Frames.MainFrame
            TipFrame.Position = UDim2.new(0, input.Position.X - mf.AbsolutePosition.X + 12, 0, input.Position.Y - mf.AbsolutePosition.Y + 12)
        end
    end))
    table.insert(garbage, TipFrame)
end

function Library:Unload() CleanID(self.Name) end

function Library:SetPanicKey(key: Enum.KeyCode)
    self:Connect(UserInputService.InputBegan, function(input, gpe)
        if not gpe and input.KeyCode == key then
            self:Unload()
        end
    end)
end

function Library:SaveConfig(name: string)
    if not self.ConfigFolder then return end
    local dataToSave = {}
    for flag, val in self.Flags do
        if not self.IgnoredFlags[flag] then dataToSave[flag] = val end
    end
    dataToSave["__WindowPosition"] = {
        X = self.Frames.MainFrame.Position.X.Offset,
        Y = self.Frames.MainFrame.Position.Y.Offset
    }
    local ok, err = pcall(function() 
        writefile(self.ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(dataToSave)) 
    end)
    if ok then
        self:Notify("Config Saved", "Saved profile: " .. name, 3)
    else
        self:Notify("Save Error", "Failed to save: " .. tostring(err), 5)
    end
end

function Library:LoadConfig(name: string)
    if not self.ConfigFolder then return end
    local path = self.ConfigFolder .. "/" .. name .. ".json"
    if isfile(path) then
        local data = HttpService:JSONDecode(readfile(path))
        for flag, val in data do
            if flag == "__WindowPosition" then
                pcall(function()
                    self.Frames.MainFrame.Position = UDim2.new(0.5, val.X, 0.5, val.Y)
                end)
            elseif self.Setters[flag] then
                pcall(function() self.Setters[flag](val) end)
            else
                self.Flags[flag] = val
            end
        end
        self:Notify("Config Loaded", "Loaded profile: " .. name, 3)
    end
end

function Library:ListConfigs()
    if not self.ConfigFolder then return {} end
    local configs = {}
    if isfolder(self.ConfigFolder) then
        for _, file in listfiles(self.ConfigFolder) do
            if file:sub(-5) == ".json" and not file:find("teleport_state") then
                local filename = file:match("([^/\\]+)%.json$")
                if filename then table.insert(configs, filename) end
            end
        end
    end
    return configs
end

function Library.new(Name: string?, Size: UDim2?, KeyBind: (Enum.UserInputType | Enum.KeyCode)?, Mode: string?, Icon: (string|number)?): Window
    local options = (type(Name) == "table") and Name or {}
    local self = setmetatable({}, Library) :: any
    local WindowRoot = self
    local isSidebar = (Mode == "Sidebar")

    self.Name         = options.Title or options.Name or Name or "NextLevel"
    self.Size         = options.Size or Size or UDim2.fromOffset(520, 560)
    self.CurrentWidth = self.Size.X.Offset
    self.CurrentHeight= self.Size.Y.Offset
    self.Tabs         = {}
    self.KeyBind      = options.KeyBind or KeyBind or Enum.KeyCode.RightControl
    self.Flags        = {}
    self.Setters      = {}
    self.SearchData     = {}
    self.BoundElements  = {}
    self.IgnoredFlags   = {}
    self.IsSilent       = Library.IsSilent or false
    
    self.Presets = {
        ["Cyberpunk"] = { MainColor = Color3.fromRGB(5, 5, 5), AccentColor = Color3.fromRGB(0, 255, 255), LineColor = Color3.fromRGB(255, 0, 255) },
        ["Midnight"]  = { MainColor = Color3.fromRGB(10, 10, 15), AccentColor = Color3.fromRGB(120, 80, 255), LineColor = Color3.fromRGB(150, 100, 255) },
        ["Toxic"]     = { MainColor = Color3.fromRGB(5, 5, 5), AccentColor = Color3.fromRGB(170, 255, 0), LineColor = Color3.fromRGB(150, 200, 0) },
        ["Ocean"]     = { MainColor = Color3.fromRGB(10, 15, 20), AccentColor = Color3.fromRGB(0, 180, 255), LineColor = Color3.fromRGB(0, 150, 255) },
        ["Classic"]   = { MainColor = Color3.fromRGB(10, 10, 10), AccentColor = Color3.fromRGB(255, 0, 0), LineColor = Color3.fromRGB(200, 0, 0) },
        ["Ghost"]     = { MainColor = Color3.fromRGB(15, 15, 15), AccentColor = Color3.fromRGB(255, 255, 255), LineColor = Color3.fromRGB(180, 180, 180) }
    }
    self.NotificationHistory = {}

    CleanID(self.Name)
    getgenv()._NextLevel_Garbage[self.Name] = {}

    function self:Connect(signal, callback)
        local connection = signal:Connect(callback)
        table.insert(getgenv()._NextLevel_Garbage[self.Name], connection)
        return connection
    end

    function self:OnUnload(callback: () -> ())
        table.insert(getgenv()._NextLevel_Garbage[self.Name], callback)
    end

    function self:Theme(instance, prop, key)
        instance[prop] = THEMES[key]
        self:Connect(ThemeEvent.Event, function()
            if instance.Parent then
                TweenService:Create(instance, TweenInfo.new(0.2), {[prop] = THEMES[key]}):Play()
            end
        end)
    end

    function self:SetTheme(themeData)
        for key, value in themeData do
            if THEMES[key] ~= nil then
                THEMES[key] = value
                -- Update the flag if it exists so configs can save it
                local flag = "Theme_" .. key
                if self.Setters[flag] then
                    self.Setters[flag](value)
                else
                    self.Flags[flag] = value
                end
            end
        end
        ThemeEvent:Fire()
    end

    function self:ApplyPreset(name)
        local colors = self.Presets[name]
        if colors then
            self:SetTheme(colors)
            self:Notify("Theme Applied", "Switched to " .. name .. " preset.", 2)
        end
    end

    local ClickSound = Instance.new("Sound")
    ClickSound.SoundId = "rbxassetid://6895079853" -- Subtle click sound
    ClickSound.Volume = 0.5
    ClickSound.Parent = game:GetService("SoundService")
    self.ClickSound = ClickSound

    local function PlayClick()
        if not Library.IsSilent then ClickSound:Play() end
    end

    local function CreateButton()
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight)
        Btn.AutoButtonColor = false
        Btn.BorderSizePixel = 0
        RoundCorner(Btn, 6)
        
        WindowRoot:Theme(Btn, "BackgroundColor3", "FrameColor")
        WindowRoot:Theme(Btn, "TextColor3", "TextColor")
        
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = THEMES.ButtonBorderColor
        Stroke.Thickness = 1
        Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        Stroke.Parent = Btn
        WindowRoot:Theme(Stroke, "Color", "ButtonBorderColor")
        
        Btn.Font = Enum.Font.GothamMedium
        Btn.TextSize = THEMES.TextSize
        CreateGradient(Btn)
        
        Btn.MouseEnter:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = THEMES.BorderColor}):Play()
        end)
        Btn.MouseLeave:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = THEMES.FrameColor}):Play()
        end)
        
        return Btn
    end

    self.ConfigFolder = self.Name .. "_Configs"
    
    local SafeFolderName = string.gsub(self.Name, "[<>:\"/\\|?*]", "")
    local BaseFolder = SafeFolderName .. "_Configs"

    local PlaceId = tostring(game.PlaceId)
    self.ConfigFolder = BaseFolder .. "/" .. PlaceId
    
    if not isfolder(BaseFolder) then makefolder(BaseFolder) end
    if not isfolder(self.ConfigFolder) then makefolder(self.ConfigFolder) end

    local garbage = getgenv()._NextLevel_Garbage[self.Name]

    -- CORE GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = self.Name
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.Enabled = not Library.IsSilent
    ProtectGui(ScreenGui)
    ScreenGui.Parent = CoreGui
    table.insert(garbage, ScreenGui)

    -- NOTIFICATIONS
    local NotifyGui = Instance.new("ScreenGui")
    NotifyGui.Name = self.Name .. "_Notifications"
    NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ProtectGui(NotifyGui)
    NotifyGui.Parent = CoreGui
    table.insert(garbage, NotifyGui)

    local NotifyLayout = Instance.new("Frame")
    NotifyLayout.Name = "Layout"
    NotifyLayout.BackgroundTransparency = 1
    NotifyLayout.Size = UDim2.new(0, 260, 1, -40)
    NotifyLayout.Position = UDim2.new(1, -270, 0, 20)
    NotifyLayout.Parent = NotifyGui
    self.NotifyLayout = NotifyLayout

    local NotifyList = Instance.new("UIListLayout")
    NotifyList.SortOrder = Enum.SortOrder.LayoutOrder
    NotifyList.VerticalAlignment = Enum.VerticalAlignment.Top
    NotifyList.Padding = UDim.new(0, 10)
    NotifyList.Parent = NotifyLayout

    -- MAIN WINDOW
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    WindowRoot:Theme(MainFrame, "BackgroundColor3", "MainColor")
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2)
    MainFrame.Size = UDim2.new(0, self.CurrentWidth, 0, self.CurrentHeight)
    MainFrame.ClipsDescendants = true
    MainFrame.ZIndex = 1
    MainFrame.Parent = ScreenGui
    CreateGradient(MainFrame)

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = THEMES.LineColor
    MainStroke.Thickness = 2
    MainStroke.Parent = MainFrame
    WindowRoot:Theme(MainStroke, "Color", "LineColor")
    
    local DropShadow = Instance.new("ImageLabel")
    DropShadow.Name = "Shadow"
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0, -15, 0, -15)
    DropShadow.Size = UDim2.new(1, 30, 1, 30)
    DropShadow.ZIndex = 0
    DropShadow.Image = "rbxassetid://5554236805"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.5
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(23, 23, 277, 277)
    DropShadow.Parent = MainFrame

    local DragFrame = Instance.new("TextButton")
    DragFrame.Size = UDim2.new(1, -150, 0, 30)
    DragFrame.BackgroundTransparency = 1
    DragFrame.Text = ""
    DragFrame.ZIndex = 10
    DragFrame.Parent = MainFrame

    local dragging, dragInput, dragStart, startPos
    self:Connect(DragFrame.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        end
    end)
    self:Connect(DragFrame.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    self:Connect(UserInputService.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    
    -- RESIZE GRIP (Bottom Right)
    local ResizeGrip = Instance.new("TextButton")
    ResizeGrip.Size = UDim2.new(0, 15, 0, 15)
    ResizeGrip.Position = UDim2.new(1, -15, 1, -15)
    ResizeGrip.BackgroundTransparency = 1
    ResizeGrip.Text = ""
    ResizeGrip.ZIndex = 50
    ResizeGrip.Parent = MainFrame

    local GripIcon = Instance.new("TextLabel")
    GripIcon.Size = UDim2.new(1, 0, 1, 0)
    GripIcon.BackgroundTransparency = 1
    GripIcon.Text = "◢"
    WindowRoot:Theme(GripIcon, "TextColor3", "SubTextColor")
    GripIcon.Font = Enum.Font.Code
    GripIcon.TextSize = 12
    GripIcon.ZIndex = 50
    GripIcon.Parent = ResizeGrip

    local resizing = false
    local resizeStart, startSize
    self:Connect(ResizeGrip.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            startSize = MainFrame.AbsoluteSize
        end
    end)
    self:Connect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end
    end)
    
    self:Connect(RunService.RenderStepped, function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    self:Connect(UserInputService.InputChanged, function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStart
            local newWidth = math.max(400, startSize.X + delta.X)
            local newHeight = math.max(300, startSize.Y + delta.Y)
            self.CurrentWidth = newWidth
            self.CurrentHeight = newHeight
            MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)

    local Sidebar
    local SidebarLine
    if isSidebar then
        Sidebar = Instance.new("Frame")
        Sidebar.Name = "Sidebar"
        Sidebar.Size = UDim2.new(0, 140, 1, 0)
        WindowRoot:Theme(Sidebar, "BackgroundColor3", "MainColor")
        Sidebar.BorderSizePixel = 0
        Sidebar.ZIndex = 2
        Sidebar.Parent = MainFrame

        SidebarLine = Instance.new("Frame")
        SidebarLine.Size = UDim2.new(0, 1, 1, 0)
        SidebarLine.Position = UDim2.new(1, 0, 0, 0)
        WindowRoot:Theme(SidebarLine, "BackgroundColor3", "BorderColor")
        SidebarLine.BorderSizePixel = 0
        SidebarLine.ZIndex = 3
        SidebarLine.Parent = Sidebar
    end
    
    local Title = Instance.new("TextLabel")
    if Icon then
        local MainIcon = Instance.new("ImageLabel")
        MainIcon.Size = UDim2.new(0, 16, 0, 16)
        MainIcon.BackgroundTransparency = 1
        MainIcon.Image = type(Icon) == "number" and "rbxassetid://" .. Icon or Icon
        MainIcon.ZIndex = 5
        
        if isSidebar then
            MainIcon.Position = UDim2.new(0, 8, 0, 8)
            MainIcon.Parent = Sidebar
            
            Title.Size = UDim2.new(1, -34, 0, 32)
            Title.Position = UDim2.new(0, 30, 0, 0)
            Title.Parent = Sidebar
        else
            MainIcon.Position = UDim2.new(0, 8, 0, 7)
            MainIcon.Parent = MainFrame
            
            Title.Size = UDim2.new(1, -34, 0, 30)
            Title.Position = UDim2.new(0, 30, 0, 0)
            Title.Parent = MainFrame
        end
    else
        if isSidebar then
            Title.Size = UDim2.new(1, -20, 0, 32)
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.Parent = Sidebar
        else
            Title.Size = UDim2.new(1, -10, 0, 30)
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.Parent = MainFrame
        end
    end
    Title.BackgroundTransparency = 1
    Title.Text = Name
    WindowRoot:Theme(Title, "TextColor3", "TextColor")
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = THEMES.TextSize + 2
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 5

    local minimized = false

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 20, 0, 20)
    MinBtn.Position = UDim2.new(1, -26, 0, 5)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "-"
    WindowRoot:Theme(MinBtn, "TextColor3", "LineColor")
    MinBtn.Font = Enum.Font.Code
    MinBtn.TextSize = 18
    MinBtn.ZIndex = 10
    MinBtn.Parent = MainFrame

    local PerfMonitor = Instance.new("TextLabel")
    PerfMonitor.Size = UDim2.new(0, 100, 0, 20)
    PerfMonitor.Position = UDim2.new(1, -135, 0, 5)
    PerfMonitor.BackgroundTransparency = 1
    PerfMonitor.Text = "0 FPS | 0 ms"
    WindowRoot:Theme(PerfMonitor, "TextColor3", "SubTextColor")
    PerfMonitor.Font = Enum.Font.Code
    PerfMonitor.TextSize = THEMES.TextSize - 1
    PerfMonitor.TextXAlignment = Enum.TextXAlignment.Right
    PerfMonitor.ZIndex = 5
    PerfMonitor.Parent = MainFrame

    self:Connect(RunService.RenderStepped, function(dt)
        local fps = math.round(1 / dt)
        local ping = 0
        if Players.LocalPlayer then
            local s, res = pcall(function() return Players.LocalPlayer:GetNetworkPing() * 1000 end)
            if s then ping = math.round(res) end
        end
        PerfMonitor.Text = string.format("%d FPS | %d ms", fps, ping)
    end)

    local Line = Instance.new("Frame")
    Line.Size = isSidebar and UDim2.new(0, 140, 0, 1) or UDim2.new(1, 0, 0, 1)
    Line.Position = isSidebar and UDim2.new(0, 0, 0, 32) or UDim2.new(0, 0, 0, 30)
    WindowRoot:Theme(Line, "BackgroundColor3", "LineColor")
    Line.BorderSizePixel = 0
    Line.ZIndex = 2
    Line.Parent = isSidebar and Sidebar or MainFrame
    Line.Visible = not isSidebar 

    local InnerBg
    if not isSidebar then
        InnerBg = Instance.new("Frame")
        InnerBg.Size = UDim2.new(1, -16, 1, -46)
        InnerBg.Position = UDim2.new(0, 8, 0, 38)
        WindowRoot:Theme(InnerBg, "BackgroundColor3", "FrameColor")
        WindowRoot:Theme(InnerBg, "BorderColor3", "BorderColor")
        InnerBg.ZIndex = 0
        InnerBg.Parent = MainFrame
        CreateGradient(InnerBg)
    end

    local Tabs = Instance.new("Frame")
    if isSidebar then
        Tabs.Size = UDim2.new(1, 0, 1, -40)
        Tabs.Position = UDim2.new(0, 0, 0, 40)
        Tabs.BackgroundTransparency = 1
        Tabs.BorderSizePixel = 0
        Tabs.ZIndex = 2
        Tabs.Parent = Sidebar
    else
        Tabs.Size = UDim2.new(1, -182, 0, 28) 
        Tabs.Position = UDim2.new(0, 12, 0, 44)
        WindowRoot:Theme(Tabs, "BackgroundColor3", "TabColor")
        WindowRoot:Theme(Tabs, "BorderColor3", "BorderColor")
        Tabs.ZIndex = 2
        Tabs.Parent = MainFrame
    end

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Active = true
    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.Always
    ScrollingFrame.ScrollingDirection = isSidebar and Enum.ScrollingDirection.Y or Enum.ScrollingDirection.X
    ScrollingFrame.AutomaticCanvasSize = isSidebar and Enum.AutomaticSize.Y or Enum.AutomaticSize.X
    ScrollingFrame.ScrollBarThickness = 0
    ScrollingFrame.ZIndex = 3
    ScrollingFrame.Parent = Tabs

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.FillDirection = isSidebar and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    if isSidebar then TabListLayout.Padding = UDim.new(0, 2) end
    TabListLayout.Parent = ScrollingFrame

    local SearchBox = Instance.new("TextBox")
    if isSidebar then
        SearchBox.Size = UDim2.new(1, -300, 0, 28)
        SearchBox.Position = UDim2.new(0, 150, 0, 8)
    else
        SearchBox.Size = UDim2.new(0, 158, 0, 28)
        SearchBox.Position = UDim2.new(1, -170, 0, 44) -- Matched with Tabs Y and Height
    end
    WindowRoot:Theme(SearchBox, "BackgroundColor3", "TabColor")
    WindowRoot:Theme(SearchBox, "BorderColor3", "BorderColor")
    SearchBox.Text = ""
    SearchBox.PlaceholderText = "Search features..."
    WindowRoot:Theme(SearchBox, "TextColor3", "TextColor")
    WindowRoot:Theme(SearchBox, "PlaceholderColor3", "SubTextColor")
    SearchBox.Font = Enum.Font.Code
    SearchBox.TextSize = THEMES.TextSize - 1
    SearchBox.ZIndex = 3
    SearchBox.Parent = MainFrame
    CreateGradient(SearchBox)

    self:Connect(SearchBox:GetPropertyChangedSignal("Text"), function()
        local query = SearchBox.Text:lower()
        local hasQuery = query ~= ""
        
        for _, tabObj in self.Tabs do
            local tabHasMatch = false
            for _, secData in self.SearchData do
                local isChild = (secData.Section.Parent.Parent == tabObj.Page)
                if isChild then
                    local secMatches = false
                    for _, elemData in secData.Elements do
                        local match = elemData.SearchText:find(query)
                        elemData.Element.Visible = (not hasQuery or match ~= nil)
                        if match then secMatches = true end
                    end
                    secData.Section.Visible = (not hasQuery or secMatches)
                    if secMatches then tabHasMatch = true end
                end
            end
            if hasQuery then
                tabObj.Button.BackgroundTransparency = tabHasMatch and 0 or 0.7
            else
                tabObj.Button.BackgroundTransparency = 0
            end
        end
    end)

    local FrameHolder = Instance.new("Frame")
    if isSidebar then
        FrameHolder.Size = UDim2.new(1, -160, 1, -78)
        FrameHolder.Position = UDim2.new(0, 150, 0, 48)
        FrameHolder.BackgroundTransparency = 1
    else
        FrameHolder.Size = UDim2.new(1, -24, 1, -94)
        FrameHolder.Position = UDim2.new(0, 12, 0, 84) -- Pushed down to prevent overlap
        WindowRoot:Theme(FrameHolder, "BackgroundColor3", "TabColor")
        WindowRoot:Theme(FrameHolder, "BorderColor3", "BorderColor")
        CreateGradient(FrameHolder)
    end
    FrameHolder.ZIndex = 2
    FrameHolder.Parent = MainFrame

    local BottomBar
    if isSidebar then
        BottomBar = Instance.new("Frame")
        BottomBar.Size = UDim2.new(1, 0, 0, 20)
        BottomBar.Position = UDim2.new(0, 0, 1, -20)
        WindowRoot:Theme(BottomBar, "BackgroundColor3", "FrameColor")
        WindowRoot:Theme(BottomBar, "BorderColor3", "BorderColor")
        BottomBar.ZIndex = 5
        BottomBar.Parent = MainFrame

        local BLine = Instance.new("Frame")
        BLine.Size = UDim2.new(1, 0, 0, 1)
        WindowRoot:Theme(BLine, "BackgroundColor3", "BorderColor")
        BLine.BorderSizePixel = 0
        BLine.ZIndex = 5
        BLine.Parent = BottomBar

        local BottomLabel = Instance.new("TextLabel")
        BottomLabel.Size = UDim2.new(1, -20, 1, 0)
        BottomLabel.Position = UDim2.new(0, 5, 0, 0)
        BottomLabel.BackgroundTransparency = 1
        BottomLabel.Text = "version: " .. (Name or "example")
        WindowRoot:Theme(BottomLabel, "TextColor3", "SubTextColor")
        BottomLabel.Font = Enum.Font.Code
        BottomLabel.TextSize = THEMES.TextSize - 2
        BottomLabel.TextXAlignment = Enum.TextXAlignment.Right
        BottomLabel.ZIndex = 6
        BottomLabel.Parent = BottomBar
    end

    self.Frames = {
        MainFrame   = MainFrame,
        Tabs        = Tabs,
        FrameHolder = FrameHolder
    }

    self:Connect(MinBtn.MouseButton1Click, function()
        minimized = not minimized
        if InnerBg then InnerBg.Visible = not minimized end
        Tabs.Visible = not minimized
        FrameHolder.Visible = not minimized
        if ResizeGrip then ResizeGrip.Visible = not minimized end
        if isSidebar then
            if SearchBox then SearchBox.Visible = not minimized end
            if BottomBar then BottomBar.Visible = not minimized end
        end
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, self.CurrentWidth, 0, minimized and 32 or self.CurrentHeight)}):Play()
        MinBtn.Text = minimized and "+" or "-"
    end)
    
    self:Connect(UserInputService.InputBegan, function(Input, GPE)
        if GPE then return end
        if Input.KeyCode == self.KeyBind or Input.UserInputType == self.KeyBind then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    -- WATERMARK
    local WatermarkGui = Instance.new("ScreenGui")
    WatermarkGui.Name = "NextLevel_Watermark"
    WatermarkGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    WatermarkGui.Enabled = not Library.IsSilent
    ProtectGui(WatermarkGui)
    WatermarkGui.Parent = CoreGui
    table.insert(garbage, WatermarkGui)
    self.WatermarkGui = WatermarkGui

    local WMMain = Instance.new("Frame")
    WMMain.Size = UDim2.new(0, 220, 0, 26)
    WMMain.Position = UDim2.new(0, 20, 0, 20)
    WindowRoot:Theme(WMMain, "BackgroundColor3", "MainColor")
    WindowRoot:Theme(WMMain, "BorderColor3", "LineColor")
    WMMain.Parent = WatermarkGui
    CreateGradient(WMMain)

    local WMText = Instance.new("TextLabel")
    WMText.Size = UDim2.new(1, -10, 1, 0)
    WMText.Position = UDim2.new(0, 5, 0, 0)
    WMText.BackgroundTransparency = 1
    WMText.Text = Name .. " | 0 FPS | 0 ms"
    WindowRoot:Theme(WMText, "TextColor3", "TextColor")
    WMText.Font = Enum.Font.Code
    WMText.TextSize = THEMES.TextSize
    WMText.TextXAlignment = Enum.TextXAlignment.Left
    WMText.Parent = WMMain

    local wmDragging, wmDragInput, wmDragStart, wmStartPos
    self:Connect(WMMain.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            wmDragging = true; wmDragStart = input.Position; wmStartPos = WMMain.Position
        end
    end)
    self:Connect(WMMain.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then wmDragging = false end
    end)
    self:Connect(UserInputService.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then wmDragInput = input end
    end)
    self:Connect(RunService.RenderStepped, function(dt)
        if wmDragging and wmDragInput then
            local delta = wmDragInput.Position - wmDragStart
            WMMain.Position = UDim2.new(wmStartPos.X.Scale, wmStartPos.X.Offset + delta.X, wmStartPos.Y.Scale, wmStartPos.Y.Offset + delta.Y)
        end
        local fps = math.round(1 / dt)
        local ping = 0
        if Players.LocalPlayer then pcall(function() ping = math.round(Players.LocalPlayer:GetNetworkPing() * 1000) end) end
        WMText.Text = string.format("%s | %d FPS | %d ms", Name, fps, ping)
    end)

    local KeybindGui = Instance.new("ScreenGui")
    KeybindGui.Name = "NextLevel_Keybinds"
    KeybindGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ProtectGui(KeybindGui)
    KeybindGui.Parent = CoreGui
    table.insert(garbage, KeybindGui)
    self.KeybindGui = KeybindGui

    local KBMain = Instance.new("Frame")
    KBMain.Size = UDim2.new(0, 180, 0, 30)
    KBMain.Position = UDim2.new(1, -200, 0.5, -100)
    KBMain.BackgroundColor3 = THEMES.MainColor
    KBMain.BorderColor3 = THEMES.AccentColor
    KBMain.Visible = false
    KBMain.Parent = KeybindGui
    CreateGradient(KBMain)
    RoundCorner(KBMain, 4)

    local KBStroke = Instance.new("UIStroke")
    KBStroke.Color = THEMES.AccentColor
    KBStroke.Thickness = 1
    KBStroke.Parent = KBMain

    local KBTitle = Instance.new("TextLabel")
    KBTitle.Size = UDim2.new(1, 0, 0, 24)
    KBTitle.Text = "  Active Keybinds"
    KBTitle.TextColor3 = THEMES.AccentColor
    KBTitle.BackgroundTransparency = 1
    KBTitle.Font = Enum.Font.Code
    KBTitle.TextSize = 12
    KBTitle.TextXAlignment = Enum.TextXAlignment.Left
    KBTitle.ZIndex = 5
    KBTitle.Parent = KBMain

    local KBContainer = Instance.new("Frame")
    KBContainer.Size = UDim2.new(1, -10, 1, -26)
    KBContainer.Position = UDim2.new(0, 5, 0, 24)
    KBContainer.BackgroundTransparency = 1
    KBContainer.Parent = KBMain

    local KBList = Instance.new("UIListLayout")
    KBList.Padding = UDim.new(0, 2)
    KBList.Parent = KBContainer

    self:Connect(KBList:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        KBMain.Size = UDim2.new(0, 180, 0, KBList.AbsoluteContentSize.Y + 30)
    end)

    local kbDragging, kbDragInput, kbDragStart, kbStartPos
    self:Connect(KBMain.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            kbDragging = true; kbDragStart = input.Position; kbStartPos = KBMain.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then kbDragging = false end end)
        end
    end)
    self:Connect(KBMain.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then kbDragInput = input end
    end)
    self:Connect(RunService.RenderStepped, function()
        if kbDragging and kbDragInput then
            local delta = kbDragInput.Position - kbDragStart
            KBMain.Position = UDim2.new(kbStartPos.X.Scale, kbStartPos.X.Offset + delta.X, kbStartPos.Y.Scale, kbStartPos.Y.Offset + delta.Y)
        end
    end)

    function self:UpdateKeybinds()
        for _, child in KBContainer:GetChildren() do if child:IsA("TextLabel") then child:Destroy() end end
        local count = 0
        for name, state in self.BoundElements do
            if state == true then
                count = count + 1
                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, 0, 0, 16)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = "[+] " .. name
                Lbl.TextColor3 = THEMES.TextColor
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 11
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.ZIndex = 5
                Lbl.Parent = KBContainer
            end
        end
        if count == 0 then
            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(1, 0, 0, 16)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = "None"
            Lbl.TextColor3 = THEMES.SubTextColor
            Lbl.Font = Enum.Font.Code
            Lbl.TextSize = 11
            Lbl.TextXAlignment = Enum.TextXAlignment.Center
            Lbl.ZIndex = 5
            Lbl.Parent = KBContainer
        end
        local show = (self.Flags["ShowKeybinds"] ~= false)
        KBMain.Visible = show
    end

    self:Connect(ThemeEvent.Event, function()
        self:UpdateKeybinds()
        -- Update HUD visuals to match theme
        KBMain.BackgroundColor3 = THEMES.MainColor
        KBMain.BorderColor3 = THEMES.AccentColor
        KBStroke.Color = THEMES.AccentColor
        KBTitle.TextColor3 = THEMES.AccentColor
    end)

    function self:Tab(text: string, iconId: (string|number)?): Tab
        local Tab = Instance.new("TextButton")
        local TabIcon = nil
        Tab.Name = text
        WindowRoot:Theme(Tab, "BorderColor3", "BorderColor")
        
        local Page = Instance.new("ScrollingFrame")
        local Highlight = Instance.new("Frame")

        if isSidebar then
            Tab.Size = UDim2.new(1, -10, 0, 30)
            Tab.Position = UDim2.new(0, 5, 0, 0)
            Tab.TextXAlignment = Enum.TextXAlignment.Left
            Tab.BackgroundTransparency = 1
            WindowRoot:Theme(Tab, "BackgroundColor3", "TabColor")
            WindowRoot:Theme(Tab, "TextColor3", "TextColor")
            
            local TabBg = Instance.new("Frame")
            TabBg.Name = "Bg"
            TabBg.Size = UDim2.new(1, 0, 1, 0)
            TabBg.BackgroundColor3 = THEMES.AccentColor
            TabBg.BackgroundTransparency = 1
            TabBg.BorderSizePixel = 0
            TabBg.ZIndex = 3
            TabBg.Parent = Tab
            WindowRoot:Theme(TabBg, "BackgroundColor3", "AccentColor")
            RoundCorner(TabBg, 4)
            
            if iconId then
                Tab.Text = "          " .. text -- Increased spacing from 8 to 10 spaces
                TabIcon = Instance.new("ImageLabel")
                TabIcon.Name = "TabIcon"
                TabIcon.Size = UDim2.new(0, 16, 0, 16)
                TabIcon.Position = UDim2.new(0, 10, 0.5, -8)
                TabIcon.BackgroundTransparency = 1
                TabIcon.Image = type(iconId) == "number" and "rbxassetid://"..tostring(iconId) or iconId
                WindowRoot:Theme(TabIcon, "ImageColor3", "SubTextColor")
                TabIcon.ZIndex = 5
                TabIcon.Parent = Tab
            else
                Tab.Text = "    " .. text
            end
            
            Highlight.Name = "Highlight"
            Highlight.Size = UDim2.new(0, 3, 0, 0)
            Highlight.Position = UDim2.new(0, 0, 0.5, 0)
            Highlight.BorderSizePixel = 0
            Highlight.ZIndex = 5
            Highlight.Parent = Tab
            WindowRoot:Theme(Highlight, "BackgroundColor3", "AccentColor")
            RoundCorner(Highlight, 2)
            WindowRoot:Theme(Highlight, "BackgroundColor3", "AccentColor")

            WindowRoot:Theme(Highlight, "BackgroundColor3", "AccentColor")

            local isHovering = false
            Tab.MouseEnter:Connect(function()
                isHovering = true
                if not Page.Visible then
                    TweenService:Create(Tab, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
                    TweenService:Create(TabBg, TweenInfo.new(0.2), {BackgroundTransparency = 0.9}):Play()
                    if TabIcon then TweenService:Create(TabIcon, TweenInfo.new(0.2), {ImageColor3 = THEMES.TextColor}):Play() end
                end
            end)
            Tab.MouseLeave:Connect(function()
                isHovering = false
                if not Page.Visible then
                    TweenService:Create(Tab, TweenInfo.new(0.2), {TextColor3 = THEMES.SubTextColor}):Play()
                    TweenService:Create(TabBg, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                    if TabIcon then TweenService:Create(TabIcon, TweenInfo.new(0.2), {ImageColor3 = THEMES.SubTextColor}):Play() end
                end
            end)
        else
            Tab.Size = UDim2.new(0, 0, 0.5, 0)
            Tab.AutomaticSize = Enum.AutomaticSize.X
            Tab.BackgroundTransparency = 1
            Tab.BorderSizePixel = 0
            WindowRoot:Theme(Tab, "TextColor3", "SubTextColor")
            
            if iconId then
                Tab.Text = "          " .. text .. "          " -- Equalized padding for centering
                TabIcon = Instance.new("ImageLabel")
                TabIcon.Name = "TabIcon"
                TabIcon.Size = UDim2.new(0, 14, 0, 14)
                TabIcon.Position = UDim2.new(0, 8, 0.5, -7)
                TabIcon.BackgroundTransparency = 1
                TabIcon.Image = type(iconId) == "number" and "rbxassetid://"..tostring(iconId) or iconId
                WindowRoot:Theme(TabIcon, "ImageColor3", "SubTextColor")
                TabIcon.ZIndex = 5
                TabIcon.Parent = Tab
            else
                Tab.Text = "      " .. text .. "      " -- Equalized padding
            end

            Highlight.Name = "Highlight"
            Highlight.Size = UDim2.new(1, 0, 0, 2)
            Highlight.Position = UDim2.new(0, 0, 1, -2)
            Highlight.BackgroundColor3 = THEMES.AccentColor
            Highlight.BorderSizePixel = 0
            Highlight.BackgroundTransparency = 1
            Highlight.ZIndex = 5
            Highlight.Parent = Tab
            RoundCorner(Highlight, 2)
            WindowRoot:Theme(Highlight, "BackgroundColor3", "AccentColor")
        end
        
        
        if isSidebar then
            Page.Size = UDim2.new(1, 0, 1, 0)
            Page.Position = UDim2.new(0, 0, 0, 0)
            Page.BackgroundTransparency = 1
        else
            Page.Size = UDim2.new(1, -8, 1, -8)
            Page.Position = UDim2.new(0, 4, 0, 4)
            WindowRoot:Theme(Page, "BackgroundColor3", "FrameColor")
            WindowRoot:Theme(Page, "BorderColor3", "BorderColor")
            CreateGradient(Page)
        end
        Page.ScrollBarThickness = 0
        Page.ScrollingDirection = Enum.ScrollingDirection.Y
        Page.Visible = false
        Page.ZIndex = 3
        Page.Parent = FrameHolder

        Tab.Font = Enum.Font.GothamMedium
        Tab.TextSize = THEMES.TextSize
        Tab.ZIndex = 4
        Tab.Parent = ScrollingFrame

        WindowRoot:Connect(ThemeEvent.Event, function()
            local isActive = Page.Visible
            if isSidebar then
                local targetColor = isActive and THEMES.TextColor or THEMES.SubTextColor
                local bgTrans = isActive and 0.5 or 1
                
                TweenService:Create(Tab, TweenInfo.new(0.2), {TextColor3 = targetColor}):Play()
                if Tab:FindFirstChild("Bg") then
                    TweenService:Create(Tab.Bg, TweenInfo.new(0.2), {BackgroundTransparency = bgTrans}):Play()
                end
                if TabIcon then
                    TweenService:Create(TabIcon, TweenInfo.new(0.2), {ImageColor3 = targetColor}):Play()
                end
                if Tab:FindFirstChild("Highlight") then
                    TweenService:Create(Tab.Highlight, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                        Size = isActive and UDim2.new(0, 3, 0.6, 0) or UDim2.new(0, 3, 0, 0),
                        Position = isActive and UDim2.new(0, 0, 0.2, 0) or UDim2.new(0, 0, 0.5, 0),
                        BackgroundTransparency = isActive and 0 or 1
                    }):Play()
                end
            else
                local targetColor = isActive and THEMES.TextColor or THEMES.SubTextColor
                TweenService:Create(Tab, TweenInfo.new(0.2), {TextColor3 = targetColor}):Play()
                if Tab:FindFirstChild("Highlight") then
                    TweenService:Create(Tab.Highlight, TweenInfo.new(0.3), {
                        BackgroundTransparency = isActive and 0 or 1,
                        Size = isActive and UDim2.new(1, 0, 0, 2) or UDim2.new(0, 0, 0, 2),
                        Position = isActive and UDim2.new(0, 0, 1, -2) or UDim2.new(0.5, 0, 1, -2)
                    }):Play()
                end
            end
        end)

        local LeftColumn = Instance.new("Frame")
        LeftColumn.Name = "LeftColumn"
        LeftColumn.Size = UDim2.new(0.5, -4, 1, 0)
        LeftColumn.Position = UDim2.new(0, 0, 0, 8)
        LeftColumn.BackgroundTransparency = 1
        LeftColumn.Parent = Page

        local LeftList = Instance.new("UIListLayout")
        LeftList.Padding = UDim.new(0, 8)
        LeftList.SortOrder = Enum.SortOrder.LayoutOrder
        LeftList.Parent = LeftColumn

        local RightColumn = Instance.new("Frame")
        RightColumn.Name = "RightColumn"
        RightColumn.Size = UDim2.new(0.5, -4, 1, 0)
        RightColumn.Position = UDim2.new(0.5, 4, 0, 8)
        RightColumn.BackgroundTransparency = 1
        RightColumn.Parent = Page

        local RightList = Instance.new("UIListLayout")
        RightList.Padding = UDim.new(0, 8)
        RightList.SortOrder = Enum.SortOrder.LayoutOrder
        RightList.Parent = RightColumn

        local function UpdateCanvas()
            Page.CanvasSize = UDim2.new(0, 0, 0, math.max(LeftList.AbsoluteContentSize.Y, RightList.AbsoluteContentSize.Y) + 20)
        end
        LeftList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)
        RightList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)

        self:Connect(Tab.MouseButton1Click, function()
            PlayClick()
            for _, tabObj in self.Tabs do
                tabObj.Page.Visible = false
                local t = tabObj.Button
                if isSidebar then
                    TweenService:Create(t, TweenInfo.new(0.2), {TextColor3 = THEMES.SubTextColor}):Play()
                    if t:FindFirstChild("Bg") then TweenService:Create(t.Bg, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() end
                    if t:FindFirstChild("TabIcon") then TweenService:Create(t.TabIcon, TweenInfo.new(0.2), {ImageColor3 = THEMES.SubTextColor}):Play() end
                    if t:FindFirstChild("Highlight") then 
                        TweenService:Create(t.Highlight, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                            Size = UDim2.new(0, 3, 0, 0),
                            Position = UDim2.new(0, 0, 0.5, 0),
                            BackgroundTransparency = 1
                        }):Play()
                    end
                else
                    TweenService:Create(t, TweenInfo.new(0.2), {TextColor3 = THEMES.SubTextColor}):Play()
                    if t:FindFirstChild("Highlight") then
                        TweenService:Create(t.Highlight, TweenInfo.new(0.3), {
                            BackgroundTransparency = 1,
                            Size = UDim2.new(0, 0, 0, 2),
                            Position = UDim2.new(0.5, 0, 1, -2)
                        }):Play()
                    end
                end
            end
            
            Page.Visible = true
            if isSidebar then
                TweenService:Create(Tab, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
                if Tab:FindFirstChild("Bg") then TweenService:Create(Tab.Bg, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() end
                if TabIcon then TweenService:Create(TabIcon, TweenInfo.new(0.2), {ImageColor3 = THEMES.TextColor}):Play() end
                if Tab:FindFirstChild("Highlight") then
                    TweenService:Create(Tab.Highlight, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                        Size = UDim2.new(0, 3, 0.6, 0),
                        Position = UDim2.new(0, 0, 0.2, 0),
                        BackgroundTransparency = 0
                    }):Play()
                end
            else
                TweenService:Create(Tab, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
                if Tab:FindFirstChild("Highlight") then
                    TweenService:Create(Tab.Highlight, TweenInfo.new(0.3), {
                        BackgroundTransparency = 0,
                        Size = UDim2.new(1, 0, 0, 2),
                        Position = UDim2.new(0, 0, 1, -2)
                    }):Play()
                end
            end
        end)

        if #self.Tabs == 0 then
            Page.Visible = true
            if isSidebar then
                Tab.TextColor3 = THEMES.TextColor
                if Tab:FindFirstChild("Bg") then Tab.Bg.BackgroundTransparency = 0.5 end
                if TabIcon then TabIcon.ImageColor3 = THEMES.TextColor end
                if Tab:FindFirstChild("Highlight") then
                    Tab.Highlight.Size = UDim2.new(0, 3, 0.6, 0)
                    Tab.Highlight.Position = UDim2.new(0, 0, 0.2, 0)
                    Tab.Highlight.BackgroundTransparency = 0
                end
            else
                Tab.TextColor3 = THEMES.TextColor
                if Tab:FindFirstChild("Highlight") then
                    Tab.Highlight.BackgroundTransparency = 0
                    Tab.Highlight.Size = UDim2.new(1, 0, 0, 2)
                    Tab.Highlight.Position = UDim2.new(0, 0, 1, -2)
                end
            end
        end
        table.insert(self.Tabs, {Button = Tab, Page = Page})

        local TabFunctions: Tab = {} :: any
        local SectionCount = 0

        function TabFunctions:Section(title: string): Section
            SectionCount = SectionCount + 1
            local ParentFrame = (SectionCount % 2 == 1) and LeftColumn or RightColumn

            local Section = Instance.new("Frame")
            Section.Name = title
            Section.Size = UDim2.new(1, 0, 0, 100)
            Section.BackgroundTransparency = 1
            Section.ZIndex = 3
            Section.Parent = ParentFrame

            local SectionStroke = Instance.new("UIStroke")
            SectionStroke.Color = THEMES.BorderColor
            SectionStroke.Thickness = 1
            SectionStroke.Parent = Section
            WindowRoot:Theme(SectionStroke, "Color", "BorderColor")

            local Label = Instance.new("TextLabel")
            Label.Text = "  " .. title .. "  "
            WindowRoot:Theme(Label, "TextColor3", "TextColor")
            WindowRoot:Theme(Label, "BackgroundColor3", "FrameColor")
            Label.BorderSizePixel = 0
            Label.Position = UDim2.new(0, 12, 0, -8)
            Label.Size = UDim2.new(0, 0, 0, 16)
            Label.AutomaticSize = Enum.AutomaticSize.X
            Label.Font = Enum.Font.GothamMedium
            Label.TextSize = THEMES.TextSize
            Label.ZIndex = 4
            Label.Parent = Section

            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1, -12, 1, -20)
            Container.Position = UDim2.new(0, 6, 0, 15)
            Container.BackgroundTransparency = 1
            Container.ZIndex = 4
            Container.Parent = Section

            local List = Instance.new("UIListLayout")
            List.Padding = UDim.new(0, 6)
            List.SortOrder = Enum.SortOrder.LayoutOrder
            List.Parent = Container

            List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Section.Size = UDim2.new(1, 0, 0, List.AbsoluteContentSize.Y + 25)
            end)

            local SectionData = { Section = Section, Elements = {} }
            table.insert(WindowRoot.SearchData, SectionData)

            local SectionFunctions: Section = {} :: any
            local ElementCount = 0

            local function RegisterSearch(elem: Instance, searchText: any)
                searchText = tostring(searchText or "")
                table.insert(SectionData.Elements, { Element = elem, SearchText = searchText:lower() })
            end

            function SectionFunctions:Button(text, callback)
                ElementCount = ElementCount + 1
                callback = callback or function() end
                local Btn = CreateButton()
                Btn.Text = text
                Btn.LayoutOrder = ElementCount
                Btn.ZIndex = 4
                Btn.Parent = Container
                WindowRoot:Connect(Btn.MouseButton1Click, function()
                    PlayClick()
                    callback()
                end)
                RegisterSearch(Btn, text)
                return Btn
            end

            function SectionFunctions:CreateButtonRow(text1, callback1, text2, callback2)
                ElementCount = ElementCount + 1
                local RowFrame = Instance.new("Frame")
                RowFrame.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight)
                RowFrame.BackgroundTransparency = 1
                RowFrame.LayoutOrder = ElementCount
                RowFrame.ZIndex = 4
                RowFrame.Parent = Container

                local Btn1 = CreateButton()
                Btn1.Size = UDim2.new(0.5, -3, 1, 0)
                Btn1.Text = text1
                Btn1.ClipsDescendants = true
                Btn1.ZIndex = 4
                Btn1.Parent = RowFrame

                local Btn2 = CreateButton()
                Btn2.Size = UDim2.new(0.5, -3, 1, 0)
                Btn2.Position = UDim2.new(0.5, 3, 0, 0)
                Btn2.Text = text2
                Btn2.ClipsDescendants = true
                Btn2.ZIndex = 4
                Btn2.Parent = RowFrame

                WindowRoot:Connect(Btn1.MouseButton1Click, function() PlayClick(); callback1() end)
                WindowRoot:Connect(Btn2.MouseButton1Click, function() PlayClick(); callback2() end)
                RegisterSearch(RowFrame, text1 .. " " .. text2)
                return Btn1, Btn2
            end

            function SectionFunctions:Toggle(text: string, default: boolean, flag: string, callback)
                ElementCount = ElementCount + 1
                default = default or false
                callback = callback or function() end
                local enabled = default
                
                WindowRoot.Flags = WindowRoot.Flags or {}
                if flag then WindowRoot.Flags[flag] = enabled end

                local ToggleBtn = Instance.new("TextButton")
                ToggleBtn.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight)
                ToggleBtn.BackgroundTransparency = 1
                ToggleBtn.Text = ""
                ToggleBtn.LayoutOrder = ElementCount
                ToggleBtn.ZIndex = 4
                ToggleBtn.Parent = Container

                local boxSize = 16
                local CheckMark = Instance.new("Frame")
                CheckMark.Size = UDim2.new(0, boxSize, 0, boxSize)
                CheckMark.Position = UDim2.new(0, 0, 0.5, -(boxSize/2))
                CheckMark.BackgroundColor3 = enabled and THEMES.LineColor or THEMES.FrameColor
                CheckMark.BorderSizePixel = 0
                CheckMark.ZIndex = 4
                CheckMark.Parent = ToggleBtn
                RoundCorner(CheckMark, 4)

                local CheckStroke = Instance.new("UIStroke")
                CheckStroke.Color = THEMES.BorderColor
                CheckStroke.Thickness = 1
                CheckStroke.Parent = CheckMark
                WindowRoot:Theme(CheckStroke, "Color", "BorderColor")

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, -(boxSize + 8), 1, 0)
                Lbl.Position = UDim2.new(0, boxSize + 6, 0, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = THEMES.TextColor
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = THEMES.TextSize
                Lbl.ZIndex = 4
                Lbl.Parent = ToggleBtn

                local function UpdateVisuals(state)
                    enabled = state
                    if flag then WindowRoot.Flags[flag] = enabled end
                    
                    WindowRoot.BoundElements[text] = enabled
                    WindowRoot:UpdateKeybinds()

                    TweenService:Create(CheckMark, TweenInfo.new(0.2), {BackgroundColor3 = enabled and THEMES.LineColor or THEMES.FrameColor}):Play()
                    callback(enabled)
                end

                if flag then WindowRoot.Setters[flag] = UpdateVisuals end
                WindowRoot:Connect(ToggleBtn.MouseButton1Click, function() UpdateVisuals(not enabled) end)
                RegisterSearch(ToggleBtn, text)

                WindowRoot:Connect(ThemeEvent.Event, function()
                    TweenService:Create(CheckMark, TweenInfo.new(0.2), {
                        BackgroundColor3 = enabled and THEMES.LineColor or THEMES.FrameColor
                    }):Play()
                    TweenService:Create(CheckStroke, TweenInfo.new(0.2), {
                        Color = THEMES.BorderColor
                    }):Play()
                    TweenService:Create(Lbl, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
                end)
            end

            function SectionFunctions:ToggleBind(text: string, defaultState: boolean, defaultKey: Enum.KeyCode, flagState: string, flagKey: string, callback)
                ElementCount = ElementCount + 1
                defaultState = defaultState or false
                local enabled = defaultState
                local CurrentKey = defaultKey or Enum.KeyCode.Unknown
                local isBinding = false
                callback = callback or function() end

                WindowRoot.Flags = WindowRoot.Flags or {}
                if flagState then WindowRoot.Flags[flagState] = enabled end
                if flagKey then WindowRoot.Flags[flagKey] = CurrentKey.Name end

                local TBFrame = Instance.new("Frame")
                TBFrame.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight)
                TBFrame.BackgroundTransparency = 1
                TBFrame.LayoutOrder = ElementCount
                TBFrame.ZIndex = 4
                TBFrame.Parent = Container

                local ToggleBtn = Instance.new("TextButton")
                ToggleBtn.Size = UDim2.new(1, -70, 1, 0)
                ToggleBtn.BackgroundTransparency = 1
                ToggleBtn.Text = ""
                ToggleBtn.ZIndex = 4
                ToggleBtn.Parent = TBFrame

                local boxSize = 16
                local CheckMark = Instance.new("Frame")
                CheckMark.Size = UDim2.new(0, boxSize, 0, boxSize)
                CheckMark.Position = UDim2.new(0, 0, 0.5, -(boxSize/2))
                CheckMark.BackgroundColor3 = enabled and THEMES.LineColor or THEMES.FrameColor
                CheckMark.BorderSizePixel = 0
                CheckMark.ZIndex = 4
                CheckMark.Parent = ToggleBtn
                RoundCorner(CheckMark, 4)

                local CheckStroke = Instance.new("UIStroke")
                CheckStroke.Color = THEMES.BorderColor
                CheckStroke.Thickness = 1
                CheckStroke.Parent = CheckMark
                WindowRoot:Theme(CheckStroke, "Color", "BorderColor")

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, -(boxSize + 8), 1, 0)
                Lbl.Position = UDim2.new(0, boxSize + 6, 0, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = THEMES.TextColor
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = THEMES.TextSize
                Lbl.ZIndex = 4
                Lbl.Parent = ToggleBtn

                local BindBtn = Instance.new("TextButton")
                BindBtn.Size = UDim2.new(0, 65, 1, 0)
                BindBtn.Position = UDim2.new(1, -65, 0, 0)
                BindBtn.BackgroundColor3 = THEMES.FrameColor
                BindBtn.BorderColor3 = THEMES.BorderColor
                BindBtn.Text = "[" .. CurrentKey.Name .. "]"
                BindBtn.TextColor3 = THEMES.TextColor
                BindBtn.Font = Enum.Font.Code
                BindBtn.TextSize = THEMES.TextSize
                BindBtn.ZIndex = 4
                BindBtn.Parent = TBFrame
                CreateGradient(BindBtn)

                local function UpdateVisuals(state)
                    enabled = state
                    if flagState then WindowRoot.Flags[flagState] = enabled end
                    
                    WindowRoot.BoundElements[text] = enabled
                    WindowRoot:UpdateKeybinds()

                    TweenService:Create(CheckMark, TweenInfo.new(0.2), {BackgroundColor3 = enabled and THEMES.LineColor or THEMES.FrameColor}):Play()
                    callback(enabled, CurrentKey.Name)
                end

                local function SetBind(keyName)
                    CurrentKey = Enum.KeyCode[keyName] or Enum.KeyCode.Unknown
                    BindBtn.Text = "[" .. CurrentKey.Name .. "]"
                    if flagKey then WindowRoot.Flags[flagKey] = CurrentKey.Name end
                end

                if flagState then WindowRoot.Setters[flagState] = UpdateVisuals end
                if flagKey then WindowRoot.Setters[flagKey] = SetBind end

                WindowRoot:Connect(ToggleBtn.MouseButton1Click, function() UpdateVisuals(not enabled) end)
                WindowRoot:Connect(BindBtn.MouseButton1Click, function()
                    isBinding = true; BindBtn.Text = "[...]"; BindBtn.BorderColor3 = THEMES.LineColor
                end)

                WindowRoot:Connect(UserInputService.InputBegan, function(input, processed)
                    if isBinding then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            isBinding = false; BindBtn.BorderColor3 = THEMES.BorderColor
                            if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Escape then
                                SetBind("Unknown")
                            else SetBind(input.KeyCode.Name) end
                        end
                    elseif not processed and CurrentKey ~= Enum.KeyCode.Unknown and input.KeyCode == CurrentKey then
                        UpdateVisuals(not enabled)
                    end
                end)
                RegisterSearch(TBFrame, text)

                WindowRoot:Connect(ThemeEvent.Event, function()
                    TweenService:Create(CheckMark, TweenInfo.new(0.2), {
                        BackgroundColor3 = enabled and THEMES.LineColor or THEMES.FrameColor
                    }):Play()
                    TweenService:Create(CheckStroke, TweenInfo.new(0.2), {
                        Color = THEMES.BorderColor
                    }):Play()
                    TweenService:Create(Lbl, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
                    TweenService:Create(BindBtn, TweenInfo.new(0.2), {
                        BackgroundColor3 = THEMES.FrameColor,
                        BorderColor3 = isBinding and THEMES.LineColor or THEMES.BorderColor,
                        TextColor3 = THEMES.TextColor
                    }):Play()
                end)
            end

            function SectionFunctions:Switch(text: string, default: boolean, flag: string, callback)
                ElementCount = ElementCount + 1
                default = default or false
                callback = callback or function() end
                local enabled = default
                
                if flag then WindowRoot.Flags[flag] = enabled end

                local SwitchFrame = Instance.new("Frame")
                SwitchFrame.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight)
                SwitchFrame.BackgroundTransparency = 1
                SwitchFrame.LayoutOrder = ElementCount
                SwitchFrame.ZIndex = 4
                SwitchFrame.Parent = Container

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, -50, 1, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = THEMES.TextColor
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = THEMES.TextSize
                Lbl.ZIndex = 4
                Lbl.Parent = SwitchFrame

                local Track = Instance.new("TextButton")
                Track.Size = UDim2.new(0, 44, 0, THEMES.BaseHeight - 4)
                Track.Position = UDim2.new(1, -44, 0.5, -(THEMES.BaseHeight - 4)/2)
                Track.BackgroundColor3 = enabled and THEMES.LineColor or THEMES.FrameColor
                Track.BorderColor3 = THEMES.BorderColor
                Track.Text = ""
                Track.AutoButtonColor = false
                Track.ZIndex = 4
                Track.Parent = SwitchFrame
                CreateGradient(Track)
                RoundCorner(Track, 2)

                local knobSize = THEMES.BaseHeight - 8
                local Knob = Instance.new("Frame")
                Knob.Size = UDim2.new(0, knobSize, 0, knobSize)
                Knob.Position = enabled and UDim2.new(1, -(knobSize + 2), 0.5, -(knobSize/2)) or UDim2.new(0, 2, 0.5, -(knobSize/2))
                Knob.BackgroundColor3 = Color3.new(1, 1, 1)
                Knob.BorderSizePixel = 0
                Knob.ZIndex = 4
                Knob.Parent = Track
                RoundCorner(Knob, 2)

                local function UpdateSwitch(state)
                    enabled = state
                    if flag then WindowRoot.Flags[flag] = enabled end
                    
                    WindowRoot.BoundElements[text] = enabled
                    WindowRoot:UpdateKeybinds()

                    TweenService:Create(Track, TweenInfo.new(0.2), {BackgroundColor3 = enabled and THEMES.LineColor or THEMES.FrameColor}):Play()
                    TweenService:Create(Knob, TweenInfo.new(0.2), {Position = enabled and UDim2.new(1, -(knobSize + 2), 0.5, -(knobSize/2)) or UDim2.new(0, 2, 0.5, -(knobSize/2))}):Play()
                    callback(enabled)
                end

                if flag then WindowRoot.Setters[flag] = UpdateSwitch end
                WindowRoot:Connect(Track.MouseButton1Click, function() UpdateSwitch(not enabled) end)
                RegisterSearch(SwitchFrame, text)

                WindowRoot:Connect(ThemeEvent.Event, function()
                    TweenService:Create(Lbl, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
                    TweenService:Create(Track, TweenInfo.new(0.2), {
                        BackgroundColor3 = enabled and THEMES.LineColor or THEMES.FrameColor,
                        BorderColor3 = THEMES.BorderColor
                    }):Play()
                end)
            end

            function SectionFunctions:Slider(text: string, min: number, max: number, default: number, decimals: number, flag: string, callback)
                ElementCount = ElementCount + 1
                default = default or min
                decimals = decimals or 0
                callback = callback or function() end
                
                if flag then WindowRoot.Flags[flag] = default end

                local SliderFrame = Instance.new("Frame")
                SliderFrame.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight * 2)
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.LayoutOrder = ElementCount
                SliderFrame.ZIndex = 4
                SliderFrame.Parent = Container

                local TextLbl = Instance.new("TextLabel")
                TextLbl.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight)
                TextLbl.BackgroundTransparency = 1
                TextLbl.Text = text
                TextLbl.TextColor3 = THEMES.TextColor
                TextLbl.TextXAlignment = Enum.TextXAlignment.Left
                TextLbl.Font = Enum.Font.Code
                TextLbl.TextSize = THEMES.TextSize
                TextLbl.ZIndex = 4
                TextLbl.Parent = SliderFrame

                local ValueLbl = Instance.new("TextLabel")
                ValueLbl.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight)
                ValueLbl.BackgroundTransparency = 1
                ValueLbl.Text = tostring(default)
                ValueLbl.TextColor3 = THEMES.TextColor
                ValueLbl.TextXAlignment = Enum.TextXAlignment.Right
                ValueLbl.Font = Enum.Font.Code
                ValueLbl.TextSize = THEMES.TextSize
                ValueLbl.ZIndex = 4
                ValueLbl.Parent = SliderFrame

                local SlideBar = Instance.new("TextButton")
                SlideBar.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight - 10)
                SlideBar.Position = UDim2.new(0, 0, 0, THEMES.BaseHeight + 2)
                SlideBar.BackgroundColor3 = THEMES.FrameColor
                SlideBar.BorderColor3 = THEMES.BorderColor
                SlideBar.Text = ""
                SlideBar.AutoButtonColor = false
                SlideBar.ZIndex = 4
                SlideBar.Parent = SliderFrame
                CreateGradient(SlideBar)

                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                Fill.BackgroundColor3 = THEMES.LineColor
                Fill.BorderSizePixel = 0
                Fill.ZIndex = 4
                Fill.Parent = SlideBar

                local draggingSlider = false

                local function SetValue(val)
                    local clamped = math.clamp(val, min, max)
                    local mult = 10 ^ decimals
                    local rounded = math.floor(clamped * mult + 0.5) / mult
                    Fill.Size = UDim2.new((rounded - min) / (max - min), 0, 1, 0)
                    ValueLbl.Text = string.format("%." .. decimals .. "f", rounded)
                    if flag then WindowRoot.Flags[flag] = rounded end
                    callback(rounded)
                end

                local function Update(input)
                    local ratio = math.clamp((input.Position.X - SlideBar.AbsolutePosition.X) / SlideBar.AbsoluteSize.X, 0, 1)
                    SetValue(min + (max - min) * ratio)
                end

                if flag then WindowRoot.Setters[flag] = SetValue end

                WindowRoot:Connect(SlideBar.InputBegan, function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = true; Update(i) end
                end)
                WindowRoot:Connect(UserInputService.InputEnded, function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end
                end)
                WindowRoot:Connect(UserInputService.InputChanged, function(i)
                    if draggingSlider and i.UserInputType == Enum.UserInputType.MouseMovement then Update(i) end
                end)
                RegisterSearch(SliderFrame, text)

                WindowRoot:Connect(ThemeEvent.Event, function()
                    TweenService:Create(TextLbl, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
                    TweenService:Create(ValueLbl, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
                    TweenService:Create(SlideBar, TweenInfo.new(0.2), {
                        BackgroundColor3 = THEMES.FrameColor,
                        BorderColor3 = THEMES.BorderColor
                    }):Play()
                    TweenService:Create(Fill, TweenInfo.new(0.2), {BackgroundColor3 = THEMES.LineColor}):Play()
                end)
            end

            function SectionFunctions:Stepper(text: string, min: number, max: number, default: number, step: number, flag: string, callback)
                ElementCount = ElementCount + 1
                default = default or min
                step = step or 1
                callback = callback or function() end
                local value = default
                
                if flag then WindowRoot.Flags[flag] = value end

                local StepFrame = Instance.new("Frame")
                StepFrame.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight)
                StepFrame.BackgroundTransparency = 1
                StepFrame.LayoutOrder = ElementCount
                StepFrame.ZIndex = 4
                StepFrame.Parent = Container

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, -95, 1, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = THEMES.TextColor
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = THEMES.TextSize
                Lbl.ZIndex = 4
                Lbl.Parent = StepFrame

                local MinusBtn = Instance.new("TextButton")
                MinusBtn.Size = UDim2.new(0, 26, 1, 0)
                MinusBtn.Position = UDim2.new(1, -90, 0, 0)
                WindowRoot:Theme(MinusBtn, "BackgroundColor3", "FrameColor")
                WindowRoot:Theme(MinusBtn, "BorderColor3", "BorderColor")
                WindowRoot:Theme(MinusBtn, "TextColor3", "LineColor")
                MinusBtn.Text = "-"
                MinusBtn.Font = Enum.Font.Code
                MinusBtn.TextSize = THEMES.TextSize + 2
                MinusBtn.ZIndex = 4
                MinusBtn.Parent = StepFrame
                CreateGradient(MinusBtn)

                local ValueLbl = Instance.new("TextLabel")
                ValueLbl.Size = UDim2.new(0, 38, 1, 0)
                ValueLbl.Position = UDim2.new(1, -64, 0, 0)
                ValueLbl.BackgroundColor3 = THEMES.FrameColor
                ValueLbl.BorderColor3 = THEMES.BorderColor
                ValueLbl.Text = tostring(value)
                ValueLbl.TextColor3 = THEMES.TextColor
                ValueLbl.Font = Enum.Font.Code
                ValueLbl.TextSize = THEMES.TextSize - 1
                ValueLbl.ZIndex = 4
                ValueLbl.Parent = StepFrame
                CreateGradient(ValueLbl)

                local PlusBtn = Instance.new("TextButton")
                PlusBtn.Size = UDim2.new(0, 26, 1, 0)
                PlusBtn.Position = UDim2.new(1, -26, 0, 0)
                WindowRoot:Theme(PlusBtn, "BackgroundColor3", "FrameColor")
                WindowRoot:Theme(PlusBtn, "BorderColor3", "BorderColor")
                WindowRoot:Theme(PlusBtn, "TextColor3", "LineColor")
                PlusBtn.Text = "+"
                PlusBtn.Font = Enum.Font.Code
                PlusBtn.TextSize = THEMES.TextSize + 2
                PlusBtn.ZIndex = 4
                PlusBtn.Parent = StepFrame
                CreateGradient(PlusBtn)

                local function SetValue(v)
                    value = math.clamp(v, min, max)
                    ValueLbl.Text = tostring(value)
                    if flag then WindowRoot.Flags[flag] = value end
                    callback(value)
                end

                if flag then WindowRoot.Setters[flag] = SetValue end
                WindowRoot:Connect(MinusBtn.MouseButton1Click, function() SetValue(value - step) end)
                WindowRoot:Connect(PlusBtn.MouseButton1Click, function() SetValue(value + step) end)
                RegisterSearch(StepFrame, text)

                WindowRoot:Connect(ThemeEvent.Event, function()
                    TweenService:Create(Lbl, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
                    TweenService:Create(ValueLbl, TweenInfo.new(0.2), {
                        BackgroundColor3 = THEMES.FrameColor,
                        BorderColor3 = THEMES.BorderColor,
                        TextColor3 = THEMES.TextColor
                    }):Play()
                end)
            end

            function SectionFunctions:Bind(text: string, defaultKey: Enum.KeyCode, flag: string, callback)
                ElementCount = ElementCount + 1
                callback = callback or function() end
                local CurrentKey = defaultKey or Enum.KeyCode.Unknown
                local isBinding = false
                
                if flag then WindowRoot.Flags[flag] = CurrentKey.Name end

                local KeybindFrame = Instance.new("Frame")
                KeybindFrame.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight)
                KeybindFrame.BackgroundTransparency = 1
                KeybindFrame.LayoutOrder = ElementCount
                KeybindFrame.ZIndex = 4
                KeybindFrame.Parent = Container

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, -70, 1, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = THEMES.TextColor
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = THEMES.TextSize
                Lbl.ZIndex = 4
                Lbl.Parent = KeybindFrame

                local BindBtn = Instance.new("TextButton")
                BindBtn.Size = UDim2.new(0, 65, 1, 0)
                BindBtn.Position = UDim2.new(1, -65, 0, 0)
                BindBtn.BackgroundColor3 = THEMES.FrameColor
                BindBtn.BorderColor3 = THEMES.BorderColor
                BindBtn.Text = "[" .. CurrentKey.Name .. "]"
                BindBtn.TextColor3 = THEMES.TextColor
                BindBtn.Font = Enum.Font.Code
                BindBtn.TextSize = THEMES.TextSize
                BindBtn.ZIndex = 4
                BindBtn.Parent = KeybindFrame
                CreateGradient(BindBtn)

                local function SetBind(keyName)
                    CurrentKey = Enum.KeyCode[keyName] or Enum.KeyCode.Unknown
                    BindBtn.Text = "[" .. CurrentKey.Name .. "]"
                    if flag then WindowRoot.Flags[flag] = CurrentKey.Name end
                end

                if flag then WindowRoot.Setters[flag] = SetBind end

                WindowRoot:Connect(BindBtn.MouseButton1Click, function()
                    isBinding = true; BindBtn.Text = "[...]"; BindBtn.BorderColor3 = THEMES.LineColor
                end)
                WindowRoot:Connect(UserInputService.InputBegan, function(input, processed)
                    if isBinding then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            isBinding = false; BindBtn.BorderColor3 = THEMES.BorderColor
                            if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Escape then
                                SetBind("Unknown")
                            else SetBind(input.KeyCode.Name) end
                        end
                    elseif not processed and CurrentKey ~= Enum.KeyCode.Unknown and input.KeyCode == CurrentKey then
                        callback()
                    end
                end)
                RegisterSearch(KeybindFrame, text)

                WindowRoot:Connect(ThemeEvent.Event, function()
                    TweenService:Create(Lbl, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
                    TweenService:Create(BindBtn, TweenInfo.new(0.2), {
                        BackgroundColor3 = THEMES.FrameColor,
                        BorderColor3 = isBinding and THEMES.LineColor or THEMES.BorderColor,
                        TextColor3 = THEMES.TextColor
                    }):Play()
                end)
            end

            function SectionFunctions:Input(text: string, placeholder: string, flag: string, callback)
                ElementCount = ElementCount + 1
                callback = callback or function() end
                
                if flag then WindowRoot.Flags[flag] = "" end

                local InputFrame = Instance.new("Frame")
                InputFrame.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight * 2 + 4)
                InputFrame.BackgroundTransparency = 1
                InputFrame.LayoutOrder = ElementCount
                InputFrame.ZIndex = 4
                InputFrame.Parent = Container

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = THEMES.TextColor
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = THEMES.TextSize
                Lbl.ZIndex = 4
                Lbl.Parent = InputFrame

                local InputBox = Instance.new("TextBox")
                InputBox.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight + 2)
                InputBox.Position = UDim2.new(0, 0, 0, THEMES.BaseHeight)
                InputBox.BackgroundColor3 = THEMES.FrameColor
                InputBox.BorderColor3 = THEMES.BorderColor
                InputBox.Text = ""
                InputBox.PlaceholderText = placeholder or "..."
                InputBox.TextColor3 = THEMES.TextColor
                InputBox.Font = Enum.Font.Code
                InputBox.TextSize = THEMES.TextSize
                InputBox.ZIndex = 4
                InputBox.Parent = InputFrame
                CreateGradient(InputBox)

                local function SetText(txt)
                    InputBox.Text = txt
                    if flag then WindowRoot.Flags[flag] = txt end
                    callback(txt)
                end

                if flag then WindowRoot.Setters[flag] = SetText end

                WindowRoot:Connect(InputBox.FocusLost, function()
                    SetText(InputBox.Text)
                    local old = InputBox.BorderColor3
                    InputBox.BorderColor3 = THEMES.LineColor
                    task.wait(0.1)
                    InputBox.BorderColor3 = old
                end)
                RegisterSearch(InputFrame, text)

                WindowRoot:Connect(ThemeEvent.Event, function()
                    TweenService:Create(Lbl, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
                    TweenService:Create(InputBox, TweenInfo.new(0.2), {
                        BackgroundColor3 = THEMES.FrameColor,
                        BorderColor3 = THEMES.BorderColor,
                        TextColor3 = THEMES.TextColor
                    }):Play()
                end)
            end

            function SectionFunctions:Dropdown(text: string, options: table, multi: boolean, default, flag: string, callback)
                ElementCount = ElementCount + 1
                callback = callback or function() end
                local isDropped = false
                local dropdownOptions = options
                local selectedValues = multi and (default or {}) or (default or "")
                
                if flag then WindowRoot.Flags[flag] = selectedValues end

                local DropFrame = Instance.new("Frame")
                DropFrame.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight + 8)
                DropFrame.BackgroundTransparency = 1
                DropFrame.ClipsDescendants = true
                DropFrame.LayoutOrder = ElementCount
                DropFrame.ZIndex = 4
                DropFrame.Parent = Container

                local Header = CreateButton()
                Header.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight + 8)
                Header.Text = ""
                Header.ZIndex = 4
                Header.Parent = DropFrame

                local TitleLbl = Instance.new("TextLabel")
                TitleLbl.Size = UDim2.new(1, -20, 1, 0)
                TitleLbl.Position = UDim2.new(0, 5, 0, 0)
                TitleLbl.BackgroundTransparency = 1
                TitleLbl.Text = text .. " : Select..."
                TitleLbl.TextColor3 = THEMES.TextColor
                TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
                TitleLbl.Font = Enum.Font.Code
                TitleLbl.TextSize = THEMES.TextSize
                TitleLbl.ZIndex = 5
                TitleLbl.Parent = Header

                local Icon = Instance.new("TextLabel")
                Icon.Size = UDim2.new(0, 20, 1, 0)
                Icon.Position = UDim2.new(1, -20, 0, 0)
                Icon.BackgroundTransparency = 1
                Icon.Text = "+"
                Icon.TextColor3 = THEMES.LineColor
                Icon.Font = Enum.Font.Code
                Icon.TextSize = THEMES.TextSize + 2
                Icon.ZIndex = 5
                Icon.Parent = Header

                local OptionContainer = Instance.new("Frame")
                OptionContainer.Size = UDim2.new(1, 0, 0, 0)
                OptionContainer.Position = UDim2.new(0, 0, 0, THEMES.BaseHeight + 8)
                OptionContainer.BackgroundTransparency = 1
                OptionContainer.ZIndex = 5
                OptionContainer.Parent = DropFrame

                local OptionLayout = Instance.new("UIListLayout")
                OptionLayout.Padding = UDim.new(0, 2)
                OptionLayout.Parent = OptionContainer

                local function UpdateTitle()
                    if multi then
                        TitleLbl.Text = text .. (#selectedValues == 0 and " : Select..." or " : [" .. table.concat(selectedValues, ", ") .. "]")
                    else
                        TitleLbl.Text = text .. " : " .. (selectedValues == "" and "Select..." or selectedValues)
                    end
                end

                local function BuildOptions(newOptions)
                    for _, child in OptionContainer:GetChildren() do if child:IsA("TextButton") then child:Destroy() end end
                    dropdownOptions = newOptions
                    for _, opt in dropdownOptions do
                        local OptBtn = CreateButton()
                        OptBtn.Text = opt
                        OptBtn.ZIndex = 5
                        OptBtn.Parent = OptionContainer
                        
                        if multi and table.find(selectedValues, opt) then OptBtn.TextColor3 = THEMES.LineColor
                        elseif not multi and selectedValues == opt then OptBtn.TextColor3 = THEMES.LineColor end

                        WindowRoot:Connect(OptBtn.MouseButton1Click, function()
                            if multi then
                                local idx = table.find(selectedValues, opt)
                                if idx then table.remove(selectedValues, idx); OptBtn.TextColor3 = THEMES.TextColor
                                else table.insert(selectedValues, opt); OptBtn.TextColor3 = THEMES.LineColor end
                            else
                                selectedValues = opt
                                for _, btn in OptionContainer:GetChildren() do
                                    if btn:IsA("TextButton") then btn.TextColor3 = THEMES.TextColor end
                                end
                                OptBtn.TextColor3 = THEMES.LineColor
                                isDropped = false; Icon.Text = "+"
                                DropFrame.ZIndex = 4; Header.ZIndex = 4; OptionContainer.ZIndex = 5; TitleLbl.ZIndex = 5; Icon.ZIndex = 5
                                TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, THEMES.BaseHeight + 8)}):Play()
                            end
                            UpdateTitle()
                            if flag then WindowRoot.Flags[flag] = selectedValues end
                            callback(selectedValues)
                        end)
                    end
                end

                if flag then
                    WindowRoot.Setters[flag] = function(val)
                        selectedValues = val
                        if flag then WindowRoot.Flags[flag] = selectedValues end
                        UpdateTitle(); BuildOptions(dropdownOptions); callback(selectedValues)
                    end
                end

                BuildOptions(options); UpdateTitle()

                WindowRoot:Connect(Header.MouseButton1Click, function()
                    isDropped = not isDropped
                    Icon.Text = isDropped and "-" or "+"
                    if isDropped then
                        DropFrame.ZIndex = 50; Header.ZIndex = 50; TitleLbl.ZIndex = 51; Icon.ZIndex = 51; OptionContainer.ZIndex = 51
                        for _, btn in OptionContainer:GetChildren() do if btn:IsA("TextButton") then btn.ZIndex = 52 end end
                    else
                        DropFrame.ZIndex = 4; Header.ZIndex = 4; TitleLbl.ZIndex = 5; Icon.ZIndex = 5; OptionContainer.ZIndex = 5
                    end

                    local openH = isDropped and (THEMES.BaseHeight + 8 + (#dropdownOptions * (THEMES.BaseHeight + 2))) or (THEMES.BaseHeight + 8)
                    TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, openH)}):Play()
                end)

                RegisterSearch(DropFrame, text)

                WindowRoot:Connect(ThemeEvent.Event, function()
                    TweenService:Create(TitleLbl, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
                    TweenService:Create(Icon, TweenInfo.new(0.2), {TextColor3 = THEMES.LineColor}):Play()
                    for _, btn in OptionContainer:GetChildren() do
                        if btn:IsA("TextButton") then
                            local targetColor = THEMES.TextColor
                            if multi and table.find(selectedValues, btn.Text) then
                                targetColor = THEMES.LineColor
                            elseif not multi and selectedValues == btn.Text then
                                targetColor = THEMES.LineColor
                            end
                            TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = targetColor}):Play()
                        end
                    end
                end)

                local DropObj = {}
                function DropObj:Refresh(newList) BuildOptions(newList) end
                return DropObj
            end

            function SectionFunctions:SearchableDropdown(text: string, options: table, default, flag: string, callback)
                ElementCount = ElementCount + 1
                callback = callback or function() end
                local isDropped = false
                local selected = default or ""
                local allOptions = options
                local filteredOptions = {table.unpack(options)}
                
                if flag then WindowRoot.Flags[flag] = selected end

                local closedH = THEMES.BaseHeight + 8
                local DropFrame = Instance.new("Frame")
                DropFrame.Size = UDim2.new(1, 0, 0, closedH)
                DropFrame.BackgroundTransparency = 1
                DropFrame.ClipsDescendants = true
                DropFrame.LayoutOrder = ElementCount
                DropFrame.ZIndex = 4
                DropFrame.Parent = Container

                local Header = CreateButton()
                Header.Size = UDim2.new(1, 0, 0, closedH)
                Header.Text = ""
                Header.ZIndex = 4
                Header.Parent = DropFrame

                local TitleLbl = Instance.new("TextLabel")
                TitleLbl.Size = UDim2.new(1, -20, 1, 0)
                TitleLbl.Position = UDim2.new(0, 5, 0, 0)
                TitleLbl.BackgroundTransparency = 1
                TitleLbl.Text = text .. " : " .. (selected == "" and "Select..." or selected)
                TitleLbl.TextColor3 = THEMES.TextColor
                TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
                TitleLbl.Font = Enum.Font.Code
                TitleLbl.TextSize = THEMES.TextSize
                TitleLbl.ZIndex = 5
                TitleLbl.Parent = Header

                local Icon = Instance.new("TextLabel")
                Icon.Size = UDim2.new(0, 20, 1, 0)
                Icon.Position = UDim2.new(1, -20, 0, 0)
                Icon.BackgroundTransparency = 1
                Icon.Text = "+"
                Icon.TextColor3 = THEMES.LineColor
                Icon.Font = Enum.Font.Code
                Icon.TextSize = THEMES.TextSize + 2
                Icon.ZIndex = 5
                Icon.Parent = Header

                local SearchBox = Instance.new("TextBox")
                SearchBox.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight - 4)
                SearchBox.Position = UDim2.new(0, 0, 0, closedH)
                SearchBox.BackgroundColor3 = THEMES.FrameColor
                SearchBox.BorderColor3 = THEMES.LineColor
                SearchBox.Text = ""
                SearchBox.PlaceholderText = "  Search..."
                SearchBox.TextColor3 = THEMES.TextColor
                SearchBox.PlaceholderColor3 = THEMES.SubTextColor
                SearchBox.Font = Enum.Font.Code
                SearchBox.TextSize = THEMES.TextSize - 1
                SearchBox.ZIndex = 5
                SearchBox.Parent = DropFrame
                CreateGradient(SearchBox)

                local OptionContainer = Instance.new("Frame")
                OptionContainer.Size = UDim2.new(1, 0, 0, 0)
                OptionContainer.Position = UDim2.new(0, 0, 0, closedH + THEMES.BaseHeight - 2)
                OptionContainer.BackgroundTransparency = 1
                OptionContainer.ZIndex = 5
                OptionContainer.Parent = DropFrame

                local OptionLayout = Instance.new("UIListLayout")
                OptionLayout.Padding = UDim.new(0, 2)
                OptionLayout.Parent = OptionContainer

                local function GetOpenHeight() return closedH + THEMES.BaseHeight - 2 + (#filteredOptions * (THEMES.BaseHeight + 2)) end

                local function BuildOptions()
                    for _, child in OptionContainer:GetChildren() do if child:IsA("TextButton") then child:Destroy() end end
                    for _, opt in filteredOptions do
                        local OptBtn = CreateButton()
                        OptBtn.Text = opt
                        OptBtn.ZIndex = isDropped and 52 or 5
                        OptBtn.Parent = OptionContainer
                        if selected == opt then OptBtn.TextColor3 = THEMES.LineColor end

                        WindowRoot:Connect(OptBtn.MouseButton1Click, function()
                            selected = opt; TitleLbl.Text = text .. " : " .. selected
                            for _, btn in OptionContainer:GetChildren() do if btn:IsA("TextButton") then btn.TextColor3 = THEMES.TextColor end end
                            OptBtn.TextColor3 = THEMES.LineColor
                            isDropped = false; Icon.Text = "+"
                            DropFrame.ZIndex = 4; Header.ZIndex = 4; TitleLbl.ZIndex = 5; Icon.ZIndex = 5; OptionContainer.ZIndex = 5; SearchBox.ZIndex = 5
                            TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, closedH)}):Play()
                            SearchBox.Text = ""; filteredOptions = {table.unpack(allOptions)}
                            if flag then WindowRoot.Flags[flag] = selected end
                            callback(selected)
                        end)
                    end
                    if isDropped then TweenService:Create(DropFrame, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, GetOpenHeight())}):Play() end
                end

                WindowRoot:Connect(SearchBox:GetPropertyChangedSignal("Text"), function()
                    local q = SearchBox.Text:lower()
                    filteredOptions = {}
                    for _, opt in allOptions do if opt:lower():find(q, 1, true) then table.insert(filteredOptions, opt) end end
                    BuildOptions()
                end)
                BuildOptions()

                WindowRoot:Connect(Header.MouseButton1Click, function()
                    isDropped = not isDropped
                    Icon.Text = isDropped and "-" or "+"
                    if isDropped then
                        DropFrame.ZIndex = 50; Header.ZIndex = 50; TitleLbl.ZIndex = 51; Icon.ZIndex = 51
                        OptionContainer.ZIndex = 51; SearchBox.ZIndex = 51
                        for _, btn in OptionContainer:GetChildren() do if btn:IsA("TextButton") then btn.ZIndex = 52 end end
                    else
                        DropFrame.ZIndex = 4; Header.ZIndex = 4; TitleLbl.ZIndex = 5; Icon.ZIndex = 5
                        OptionContainer.ZIndex = 5; SearchBox.ZIndex = 5
                    end

                    TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, isDropped and GetOpenHeight() or closedH)}):Play()
                end)

                if flag then
                    WindowRoot.Setters[flag] = function(val)
                        selected = val
                        TitleLbl.Text = text .. " : " .. (selected == "" and "Select..." or selected)
                        if flag then WindowRoot.Flags[flag] = selected end
                        callback(selected)
                    end
                end
                RegisterSearch(DropFrame, text)

                WindowRoot:Connect(ThemeEvent.Event, function()
                    TweenService:Create(TitleLbl, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
                    TweenService:Create(Icon, TweenInfo.new(0.2), {TextColor3 = THEMES.LineColor}):Play()
                    TweenService:Create(SearchBox, TweenInfo.new(0.2), {
                        BackgroundColor3 = THEMES.FrameColor,
                        BorderColor3 = THEMES.LineColor,
                        TextColor3 = THEMES.TextColor,
                        PlaceholderColor3 = THEMES.SubTextColor
                    }):Play()
                    for _, btn in OptionContainer:GetChildren() do
                        if btn:IsA("TextButton") then
                            local targetColor = (selected == btn.Text) and THEMES.LineColor or THEMES.TextColor
                            TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = targetColor}):Play()
                        end
                    end
                end)
                
                local DropObj = {}
                function DropObj:Refresh(newList) allOptions = newList; filteredOptions = {table.unpack(allOptions)}; BuildOptions() end
                return DropObj
            end

            function SectionFunctions:PlayerDropdown(text: string, includeSelf: boolean, flag: string, callback)
                ElementCount = ElementCount + 1
                callback = callback or function() end
                includeSelf = includeSelf or false
                
                local DropdownObj = SectionFunctions:SearchableDropdown(text, {}, "", flag, callback)
                
                local function UpdatePlayerList()
                    local list = {}
                    for _, p in Players:GetPlayers() do
                        if includeSelf or p ~= Players.LocalPlayer then
                            table.insert(list, p.Name)
                        end
                    end
                    table.sort(list)
                    DropdownObj:Refresh(list)
                end

                UpdatePlayerList()

                WindowRoot:Connect(Players.PlayerAdded, UpdatePlayerList)
                WindowRoot:Connect(Players.PlayerRemoving, UpdatePlayerList)

                return DropdownObj
            end

            function SectionFunctions:RadioGroup(label: string, options: table, default, flag: string, callback)
                ElementCount = ElementCount + 1
                callback = callback or function() end
                local selected = default or (options[1] or "")
                
                if flag then WindowRoot.Flags[flag] = selected end

                local headerH = (label and label ~= "") and THEMES.BaseHeight or 0
                local totalH = headerH + #options * (THEMES.BaseHeight)

                local GroupFrame = Instance.new("Frame")
                GroupFrame.BackgroundTransparency = 1
                GroupFrame.Size = UDim2.new(1, 0, 0, totalH)
                GroupFrame.LayoutOrder = ElementCount
                GroupFrame.ZIndex = 4
                GroupFrame.Parent = Container

                local HeaderLbl
                if headerH > 0 then
                    HeaderLbl = Instance.new("TextLabel")
                    HeaderLbl.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight - 4)
                    HeaderLbl.BackgroundTransparency = 1
                    HeaderLbl.Text = label
                    HeaderLbl.TextColor3 = THEMES.TextColor
                    HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
                    HeaderLbl.Font = Enum.Font.Code
                    HeaderLbl.TextSize = THEMES.TextSize
                    HeaderLbl.ZIndex = 4
                    HeaderLbl.Parent = GroupFrame
                end

                local dots, labels = {}, {}

                for i, opt in options do
                    local RowBtn = Instance.new("TextButton")
                    RowBtn.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight - 2)
                    RowBtn.Position = UDim2.new(0, 0, 0, headerH + (i - 1) * THEMES.BaseHeight)
                    RowBtn.BackgroundTransparency = 1
                    RowBtn.Text = ""
                    RowBtn.ZIndex = 4
                    RowBtn.Parent = GroupFrame

                    local Radio = Instance.new("Frame")
                    Radio.Size = UDim2.new(0, 12, 0, 12)
                    Radio.Position = UDim2.new(0, 0, 0.5, -6)
                    Radio.BackgroundColor3 = opt == selected and THEMES.LineColor or THEMES.FrameColor
                    Radio.BorderColor3 = THEMES.BorderColor
                    Radio.ZIndex = 4
                    Radio.Parent = RowBtn
                    CreateGradient(Radio)
                    dots[opt] = Radio

                    local OptLbl = Instance.new("TextLabel")
                    OptLbl.Size = UDim2.new(1, -20, 1, 0)
                    OptLbl.Position = UDim2.new(0, 20, 0, 0)
                    OptLbl.BackgroundTransparency = 1
                    OptLbl.Text = opt
                    OptLbl.TextColor3 = opt == selected and THEMES.TextColor or THEMES.SubTextColor
                    OptLbl.TextXAlignment = Enum.TextXAlignment.Left
                    OptLbl.Font = Enum.Font.Code
                    OptLbl.TextSize = THEMES.TextSize
                    OptLbl.ZIndex = 4
                    OptLbl.Parent = RowBtn
                    labels[opt] = OptLbl

                    WindowRoot:Connect(RowBtn.MouseButton1Click, function()
                        for k, dot in dots do
                            TweenService:Create(dot, TweenInfo.new(0.15), {BackgroundColor3 = THEMES.FrameColor}):Play()
                            labels[k].TextColor3 = THEMES.SubTextColor
                        end
                        TweenService:Create(Radio, TweenInfo.new(0.15), {BackgroundColor3 = THEMES.LineColor}):Play()
                        OptLbl.TextColor3 = THEMES.TextColor
                        selected = opt
                        if flag then WindowRoot.Flags[flag] = selected end
                        callback(selected)
                    end)
                end

                if flag then
                    WindowRoot.Setters[flag] = function(val)
                        for k, dot in dots do
                            TweenService:Create(dot, TweenInfo.new(0.15), {BackgroundColor3 = THEMES.FrameColor}):Play()
                            labels[k].TextColor3 = THEMES.SubTextColor
                        end
                        if dots[val] then
                            TweenService:Create(dots[val], TweenInfo.new(0.15), {BackgroundColor3 = THEMES.LineColor}):Play()
                            labels[val].TextColor3 = THEMES.TextColor
                        end
                        selected = val
                        if flag then WindowRoot.Flags[flag] = selected end
                        callback(selected)
                    end
                end
                RegisterSearch(GroupFrame, label or table.concat(options, " "))

                WindowRoot:Connect(ThemeEvent.Event, function()
                    if HeaderLbl then 
                        TweenService:Create(HeaderLbl, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play() 
                    end
                    for opt, dot in dots do
                        TweenService:Create(dot, TweenInfo.new(0.2), {
                            BackgroundColor3 = (opt == selected) and THEMES.LineColor or THEMES.FrameColor,
                            BorderColor3 = THEMES.BorderColor
                        }):Play()
                        TweenService:Create(labels[opt], TweenInfo.new(0.2), {
                            TextColor3 = (opt == selected) and THEMES.TextColor or THEMES.SubTextColor
                        }):Play()
                    end
                end)
            end

            function SectionFunctions:ColorPicker(text, defaultColor, defaultAlpha, flag, callback)
                ElementCount = ElementCount + 1
                callback = callback or function() end
                defaultColor = defaultColor or Color3.fromRGB(255, 255, 255)
                defaultAlpha = defaultAlpha or 1
                local h, s, v = Color3.toHSV(defaultColor)
                local a = defaultAlpha
                local isOpen = false
                
                if flag then WindowRoot.Flags[flag] = {R = defaultColor.R, G = defaultColor.G, B = defaultColor.B, A = defaultAlpha} end

                local closedH = THEMES.BaseHeight + 8
                local PickerFrame = Instance.new("Frame")
                PickerFrame.Size = UDim2.new(1, 0, 0, closedH)
                PickerFrame.BackgroundTransparency = 1
                PickerFrame.ClipsDescendants = true
                PickerFrame.LayoutOrder = ElementCount
                PickerFrame.ZIndex = 4
                PickerFrame.Parent = Container

                local Header = CreateButton()
                Header.Size = UDim2.new(1, 0, 0, closedH)
                Header.Text = ""
                Header.ZIndex = 4
                Header.Parent = PickerFrame

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, -40, 1, 0)
                Lbl.Position = UDim2.new(0, 5, 0, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = THEMES.TextColor
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = THEMES.TextSize
                Lbl.ZIndex = 4
                Lbl.Parent = Header

                local CurrentColorFrame = Instance.new("Frame")
                CurrentColorFrame.Size = UDim2.new(0, 24, 0, 14)
                CurrentColorFrame.Position = UDim2.new(1, -29, 0.5, -7)
                CurrentColorFrame.BackgroundColor3 = defaultColor
                CurrentColorFrame.BackgroundTransparency = 1 - a
                CurrentColorFrame.BorderColor3 = THEMES.BorderColor
                CurrentColorFrame.ZIndex = 4
                CurrentColorFrame.Parent = Header

                local Body = Instance.new("Frame")
                Body.Size = UDim2.new(1, 0, 0, 165)
                Body.Position = UDim2.new(0, 0, 0, closedH)
                Body.BackgroundTransparency = 1
                Body.ZIndex = 5
                Body.Parent = PickerFrame

                local SVBox = Instance.new("TextButton")
                SVBox.Size = UDim2.new(0, 130, 0, 130)
                SVBox.Position = UDim2.new(0, 10, 0, 10)
                SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                SVBox.BorderColor3 = THEMES.BorderColor
                SVBox.Text = ""
                SVBox.AutoButtonColor = false
                SVBox.ZIndex = 5
                SVBox.Parent = Body

                local SatOverlay = Instance.new("Frame")
                SatOverlay.Size = UDim2.new(1, 0, 1, 0)
                SatOverlay.BackgroundColor3 = Color3.new(1, 1, 1)
                SatOverlay.BorderSizePixel = 0
                SatOverlay.ZIndex = 6
                SatOverlay.Parent = SVBox

                local SatGradient = Instance.new("UIGradient")
                SatGradient.Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 0), 
                    NumberSequenceKeypoint.new(1, 1)
                }
                SatGradient.Parent = SatOverlay

                local ValOverlay = Instance.new("Frame")
                ValOverlay.Size = UDim2.new(1, 0, 1, 0)
                ValOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
                ValOverlay.BorderSizePixel = 0
                ValOverlay.ZIndex = 7
                ValOverlay.Parent = SVBox

                local ValGradient = Instance.new("UIGradient")
                ValGradient.Rotation = 90
                ValGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}
                ValGradient.Parent = ValOverlay

                local SVCursor = Instance.new("Frame")
                SVCursor.Size = UDim2.new(0, 4, 0, 4)
                SVCursor.BackgroundColor3 = Color3.new(1, 1, 1)
                SVCursor.BorderColor3 = Color3.new(0, 0, 0)
                SVCursor.Rotation = 45
                SVCursor.ZIndex = 8
                SVCursor.Position = UDim2.new(s, -2, 1 - v, -2)
                SVCursor.Parent = SVBox

                local HueBar = Instance.new("TextButton")
                HueBar.Size = UDim2.new(0, 15, 0, 130)
                HueBar.Position = UDim2.new(0, 152, 0, 10)
                HueBar.BorderColor3 = THEMES.BorderColor
                HueBar.Text = ""
                HueBar.AutoButtonColor = false
                HueBar.ZIndex = 5
                HueBar.Parent = Body

                local HueGradient = Instance.new("UIGradient")
                HueGradient.Rotation = 90
                HueGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0.00, Color3.fromHSV(0, 1, 1)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.16, 1, 1)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
                    ColorSequenceKeypoint.new(0.50, Color3.fromHSV(0.5, 1, 1)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.66, 1, 1)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromHSV(1, 1, 1))
                }
                HueGradient.Parent = HueBar

                local AlphaBar = Instance.new("TextButton")
                AlphaBar.Size = UDim2.new(0, 15, 0, 130)
                AlphaBar.Position = UDim2.new(0, 172, 0, 10)
                AlphaBar.BorderColor3 = THEMES.BorderColor
                AlphaBar.Text = ""
                AlphaBar.AutoButtonColor = false
                AlphaBar.ZIndex = 5
                AlphaBar.Parent = Body
                CreateGradient(AlphaBar)

                local HueCursor = Instance.new("Frame")
                HueCursor.Size = UDim2.new(1, 4, 0, 2)
                HueCursor.Position = UDim2.new(0, -2, 1 - h, -2)
                HueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
                HueCursor.BorderColor3 = Color3.new(0, 0, 0)
                HueCursor.ZIndex = 6
                HueCursor.Parent = HueBar

                local AlphaCursor = Instance.new("Frame")
                AlphaCursor.Size = UDim2.new(1, 4, 0, 2)
                AlphaCursor.Position = UDim2.new(0, -2, 1 - a, -2)
                AlphaCursor.BackgroundColor3 = Color3.new(1, 1, 1)
                AlphaCursor.BorderColor3 = Color3.new(0, 0, 0)
                AlphaCursor.ZIndex = 6
                AlphaCursor.Parent = AlphaBar

                local AlphaGradient = Instance.new("UIGradient")
                AlphaGradient.Rotation = 90
                AlphaGradient.Transparency = NumberSequence.new{ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }
                AlphaGradient.Parent = AlphaBar

                local AlphaLbl = Instance.new("TextLabel")
                AlphaLbl.Size = UDim2.new(0, 35, 0, 12)
                AlphaLbl.Position = UDim2.new(0, 152, 0, 143)
                AlphaLbl.BackgroundTransparency = 1
                AlphaLbl.Text = "α"
                AlphaLbl.TextColor3 = THEMES.SubTextColor
                AlphaLbl.Font = Enum.Font.Code
                AlphaLbl.TextSize = 10
                AlphaLbl.ZIndex = 5
                AlphaLbl.Parent = Body

                local function UpdateColor()
                    local newColor = Color3.fromHSV(h, s, v)
                    CurrentColorFrame.BackgroundColor3 = newColor
                    CurrentColorFrame.BackgroundTransparency = 1 - a
                    SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    AlphaBar.BackgroundColor3 = newColor
                    if flag then WindowRoot.Flags[flag] = {R = newColor.R, G = newColor.G, B = newColor.B, A = a} end
                    callback(newColor, a)
                end

                SVCursor.Position = UDim2.new(s, -2, 1 - v, -2) -- Corrected initial position
                UpdateColor()

                if flag then
                    WindowRoot.Setters[flag] = function(colorData)
                        local newC
                        if typeof(colorData) == "Color3" then
                            newC = colorData
                        elseif type(colorData) == "table" then
                            newC = Color3.new(colorData.R or colorData.r or 1, colorData.G or colorData.g or 1, colorData.B or colorData.b or 1)
                            a = colorData.A or colorData.a or 1
                        end
                        
                        if newC then
                            h, s, v = Color3.toHSV(newC)
                            SVCursor.Position = UDim2.new(s, -2, 1 - v, -2)
                            HueCursor.Position = UDim2.new(0, -2, 1 - h, -2)
                            AlphaCursor.Position = UDim2.new(0, -2, 1 - a, -2)
                            UpdateColor()
                        end
                    end
                end

                local draggingSV, draggingHue, draggingAlpha = false, false, false

                WindowRoot:Connect(SVBox.InputBegan, function(i) 
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then 
                        draggingSV = true 
                    end 
                end)
                WindowRoot:Connect(HueBar.InputBegan, function(i) 
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then 
                        draggingHue = true 
                    end 
                end)
                WindowRoot:Connect(AlphaBar.InputBegan, function(i) 
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then 
                        draggingAlpha = true 
                    end 
                end)

                WindowRoot:Connect(UserInputService.InputChanged, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mPos = UserInputService:GetMouseLocation()
                        -- Correct for CoreGui inset if needed, but AbsolutePosition handles it
                        if draggingSV then
                            s = math.clamp((input.Position.X - SVBox.AbsolutePosition.X) / SVBox.AbsoluteSize.X, 0, 1)
                            v = 1 - math.clamp((input.Position.Y - SVBox.AbsolutePosition.Y) / SVBox.AbsoluteSize.Y, 0, 1)
                            SVCursor.Position = UDim2.new(s, -2, 1 - v, -2)
                            UpdateColor()
                        elseif draggingHue then
                            h = math.clamp((input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
                            HueCursor.Position = UDim2.new(0, -2, h, -2)
                            UpdateColor()
                        elseif draggingAlpha then
                            a = 1 - math.clamp((input.Position.Y - AlphaBar.AbsolutePosition.Y) / AlphaBar.AbsoluteSize.Y, 0, 1)
                            AlphaCursor.Position = UDim2.new(0, -2, 1 - a, -2)
                            UpdateColor()
                        end
                    end
                end)

                WindowRoot:Connect(UserInputService.InputEnded, function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingSV, draggingHue, draggingAlpha = false, false, false end
                end)

                WindowRoot:Connect(Header.MouseButton1Click, function()
                    isOpen = not isOpen
                    if isOpen then
                        PickerFrame.ZIndex = 50; Header.ZIndex = 50; Body.ZIndex = 51
                    else
                        PickerFrame.ZIndex = 4; Header.ZIndex = 4; Body.ZIndex = 5
                    end
                    TweenService:Create(PickerFrame, TweenInfo.new(0.2), {Size = isOpen and UDim2.new(1, 0, 0, closedH + 165) or UDim2.new(1, 0, 0, closedH)}):Play()
                end)
                RegisterSearch(PickerFrame, text)

                WindowRoot:Connect(ThemeEvent.Event, function()
                    TweenService:Create(Lbl, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
                    TweenService:Create(CurrentColorFrame, TweenInfo.new(0.2), {BorderColor3 = THEMES.BorderColor}):Play()
                    TweenService:Create(SVBox, TweenInfo.new(0.2), {BorderColor3 = THEMES.BorderColor}):Play()
                    TweenService:Create(HueBar, TweenInfo.new(0.2), {BorderColor3 = THEMES.BorderColor}):Play()
                    TweenService:Create(AlphaBar, TweenInfo.new(0.2), {BorderColor3 = THEMES.BorderColor}):Play()
                    TweenService:Create(AlphaLbl, TweenInfo.new(0.2), {TextColor3 = THEMES.SubTextColor}):Play()
                end)
            end

            function SectionFunctions:Label(text: string)
                ElementCount = ElementCount + 1
                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, 0, 0, 0)
                Lbl.AutomaticSize = Enum.AutomaticSize.Y
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = THEMES.TextColor
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = THEMES.TextSize
                Lbl.TextWrapped = true
                Lbl.LayoutOrder = ElementCount
                Lbl.ZIndex = 4
                Lbl.Parent = Container
                RegisterSearch(Lbl, text)

                WindowRoot:Connect(ThemeEvent.Event, function()
                    TweenService:Create(Lbl, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
                end)
                
                local LabelFunctions = setmetatable({
                    SetText = function(_, txt) Lbl.Text = txt end
                }, {
                    __index = Lbl,
                    __newindex = Lbl
                })
                return LabelFunctions
            end

            function SectionFunctions:Paragraph(text: string)
                ElementCount = ElementCount + 1
                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, -4, 0, 0)
                Lbl.AutomaticSize = Enum.AutomaticSize.Y 
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = THEMES.SubTextColor
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.TextYAlignment = Enum.TextYAlignment.Top
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = THEMES.TextSize - 1
                Lbl.TextWrapped = true
                Lbl.LayoutOrder = ElementCount
                Lbl.ZIndex = 4
                Lbl.Parent = Container
                RegisterSearch(Lbl, text)

                WindowRoot:Connect(ThemeEvent.Event, function()
                    TweenService:Create(Lbl, TweenInfo.new(0.2), {TextColor3 = THEMES.SubTextColor}):Play()
                end)
                
                local ParaFunctions = setmetatable({
                    SetText = function(_, txt) Lbl.Text = txt end
                }, {
                    __index = Lbl,
                    __newindex = Lbl
                })
                return ParaFunctions
            end

            function SectionFunctions:Separator(label: string?)
                ElementCount = ElementCount + 1
                local hasLabel = label and label ~= ""
                local SepFrame = Instance.new("Frame")
                SepFrame.Size = UDim2.new(1, 0, 0, hasLabel and 16 or 8)
                SepFrame.BackgroundTransparency = 1
                SepFrame.LayoutOrder = ElementCount
                SepFrame.ZIndex = 4
                SepFrame.Parent = Container

                local L1, L2, L, Txt
                if hasLabel then
                    L1 = Instance.new("Frame")
                    L1.Size = UDim2.new(0.25, 0, 0, 1)
                    L1.Position = UDim2.new(0, 0, 0.5, 0)
                    L1.BackgroundColor3 = THEMES.BorderColor
                    L1.BorderSizePixel = 0
                    L1.ZIndex = 4
                    L1.Parent = SepFrame

                    Txt = Instance.new("TextLabel")
                    Txt.Size = UDim2.new(0.5, 0, 1, 0)
                    Txt.Position = UDim2.new(0.25, 0, 0, 0)
                    Txt.BackgroundTransparency = 1
                    Txt.Text = label
                    Txt.TextColor3 = THEMES.SubTextColor
                    Txt.Font = Enum.Font.Code
                    Txt.TextSize = THEMES.TextSize - 2
                    Txt.ZIndex = 4
                    Txt.Parent = SepFrame

                    L2 = Instance.new("Frame")
                    L2.Size = UDim2.new(0.25, 0, 0, 1)
                    L2.Position = UDim2.new(0.75, 0, 0.5, 0)
                    L2.BackgroundColor3 = THEMES.BorderColor
                    L2.BorderSizePixel = 0
                    L2.ZIndex = 4
                    L2.Parent = SepFrame
                else
                    L = Instance.new("Frame")
                    L.Size = UDim2.new(1, 0, 0, 1)
                    L.Position = UDim2.new(0, 0, 0.5, 0)
                    L.BackgroundColor3 = THEMES.BorderColor
                    L.BorderSizePixel = 0
                    L.ZIndex = 4
                    L.Parent = SepFrame
                end
                RegisterSearch(SepFrame, label or "")

                WindowRoot:Connect(ThemeEvent.Event, function()
                    if hasLabel then
                        TweenService:Create(L1, TweenInfo.new(0.2), {BackgroundColor3 = THEMES.BorderColor}):Play()
                        TweenService:Create(L2, TweenInfo.new(0.2), {BackgroundColor3 = THEMES.BorderColor}):Play()
                        TweenService:Create(Txt, TweenInfo.new(0.2), {TextColor3 = THEMES.SubTextColor}):Play()
                    else
                        TweenService:Create(L, TweenInfo.new(0.2), {BackgroundColor3 = THEMES.BorderColor}):Play()
                    end
                end)
            end

            function SectionFunctions:Spacer(height: number?)
                ElementCount = ElementCount + 1
                local Sp = Instance.new("Frame")
                Sp.Size = UDim2.new(1, 0, 0, height or 10)
                Sp.BackgroundTransparency = 1
                Sp.LayoutOrder = ElementCount
                Sp.Parent = Container
            end

            function SectionFunctions:ProgressBar(text: string, min: number, max: number, default: number, flag: string)
                ElementCount = ElementCount + 1
                min = min or 0; max = max or 100; default = default or min
                local current = default
                
                if flag then WindowRoot.Flags[flag] = current end

                local PBFrame = Instance.new("Frame")
                PBFrame.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight + 10)
                PBFrame.BackgroundTransparency = 1
                PBFrame.LayoutOrder = ElementCount
                PBFrame.ZIndex = 4
                PBFrame.Parent = Container

                local TextLbl = Instance.new("TextLabel")
                TextLbl.Size = UDim2.new(0.65, 0, 0, THEMES.BaseHeight - 4)
                TextLbl.BackgroundTransparency = 1
                TextLbl.Text = text
                TextLbl.TextColor3 = THEMES.TextColor
                TextLbl.TextXAlignment = Enum.TextXAlignment.Left
                TextLbl.Font = Enum.Font.Code
                TextLbl.TextSize = THEMES.TextSize
                TextLbl.ZIndex = 4
                TextLbl.Parent = PBFrame

                local ValueLbl = Instance.new("TextLabel")
                ValueLbl.Size = UDim2.new(0.35, 0, 0, THEMES.BaseHeight - 4)
                ValueLbl.Position = UDim2.new(0.65, 0, 0, 0)
                ValueLbl.BackgroundTransparency = 1
                ValueLbl.Text = tostring(math.floor(default)) .. " / " .. tostring(max)
                ValueLbl.TextColor3 = THEMES.LineColor
                ValueLbl.TextXAlignment = Enum.TextXAlignment.Right
                ValueLbl.Font = Enum.Font.Code
                ValueLbl.TextSize = THEMES.TextSize - 1
                ValueLbl.ZIndex = 4
                ValueLbl.Parent = PBFrame

                local Track = Instance.new("Frame")
                Track.Size = UDim2.new(1, 0, 0, 8)
                Track.Position = UDim2.new(0, 0, 0, THEMES.BaseHeight)
                Track.BackgroundColor3 = THEMES.FrameColor
                Track.BorderColor3 = THEMES.BorderColor
                Track.ZIndex = 4
                Track.Parent = PBFrame
                CreateGradient(Track)

                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new(math.clamp((current - min) / (max - min), 0, 1), 0, 1, 0)
                Fill.BackgroundColor3 = THEMES.LineColor
                Fill.BorderSizePixel = 0
                Fill.ZIndex = 4
                Fill.Parent = Track

                local Obj = {}
                function Obj:Set(val)
                    current = math.clamp(val, min, max)
                    local ratio = (current - min) / (max - min)
                    TweenService:Create(Fill, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(ratio, 0, 1, 0)}):Play()
                    ValueLbl.Text = tostring(math.floor(current)) .. " / " .. tostring(max)
                    if flag then WindowRoot.Flags[flag] = current end
                end

                if flag then WindowRoot.Setters[flag] = function(v) Obj:Set(v) end end
                RegisterSearch(PBFrame, text)

                WindowRoot:Connect(ThemeEvent.Event, function()
                    TweenService:Create(TextLbl, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
                    TweenService:Create(ValueLbl, TweenInfo.new(0.2), {TextColor3 = THEMES.LineColor}):Play()
                    TweenService:Create(Track, TweenInfo.new(0.2), {
                        BackgroundColor3 = THEMES.FrameColor,
                        BorderColor3 = THEMES.BorderColor
                    }):Play()
                    TweenService:Create(Fill, TweenInfo.new(0.2), {BackgroundColor3 = THEMES.LineColor}):Play()
                end)

                return Obj
            end

            function SectionFunctions:StatusIndicator(label: string, initialText: string, initialColor: Color3)
                ElementCount = ElementCount + 1
                initialColor = initialColor or THEMES.SuccessColor

                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight - 4)
                Frame.BackgroundTransparency = 1
                Frame.LayoutOrder = ElementCount
                Frame.ZIndex = 4
                Frame.Parent = Container

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(0.5, 0, 1, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = label
                Lbl.TextColor3 = THEMES.TextColor
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = THEMES.TextSize
                Lbl.ZIndex = 4
                Lbl.Parent = Frame

                local Dot = Instance.new("Frame")
                Dot.Size = UDim2.new(0, 8, 0, 8)
                Dot.Position = UDim2.new(0.5, 3, 0.5, -4)
                Dot.BackgroundColor3 = initialColor
                Dot.BorderSizePixel = 0
                Dot.ZIndex = 4
                Dot.Parent = Frame
                RoundCorner(Dot, 4)

                local StatusLbl = Instance.new("TextLabel")
                StatusLbl.Size = UDim2.new(0.45, 0, 1, 0)
                StatusLbl.Position = UDim2.new(0.55, 0, 0, 0)
                StatusLbl.BackgroundTransparency = 1
                StatusLbl.Text = initialText or "Unknown"
                StatusLbl.TextColor3 = initialColor
                StatusLbl.TextXAlignment = Enum.TextXAlignment.Right
                StatusLbl.Font = Enum.Font.Code
                StatusLbl.TextSize = THEMES.TextSize
                StatusLbl.ZIndex = 4
                StatusLbl.Parent = Frame

                local Obj = {}
                function Obj:Set(statusText: string, color: Color3)
                    color = color or initialColor
                    StatusLbl.Text = statusText
                    StatusLbl.TextColor3 = color
                    TweenService:Create(Dot, TweenInfo.new(0.3), {BackgroundColor3 = color}):Play()
                end
                RegisterSearch(Frame, label)

                WindowRoot:Connect(ThemeEvent.Event, function()
                    TweenService:Create(Lbl, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
                end)

                return Obj
            end

            function SectionFunctions:Alert(alertText: string, alertType: string)
                ElementCount = ElementCount + 1
                local colors = {
                    info    = THEMES.InfoColor,
                    warn    = THEMES.WarningColor,
                    error   = THEMES.ErrorColor,
                    success = THEMES.SuccessColor,
                }
                local icons = { info = "i", warn = "!", error = "✕", success = "✓" }
                local alertColor = colors[alertType] or colors.info
                local icon = icons[alertType] or "i"

                local lines = math.max(1, math.ceil(#alertText / 30))
                local h = lines * 16 + 16

                local AlertFrame = Instance.new("Frame")
                AlertFrame.Size = UDim2.new(1, 0, 0, h)
                AlertFrame.BackgroundColor3 = THEMES.FrameColor
                AlertFrame.BorderColor3 = alertColor
                AlertFrame.LayoutOrder = ElementCount
                AlertFrame.ZIndex = 4
                AlertFrame.Parent = Container
                CreateGradient(AlertFrame)

                local Accent = Instance.new("Frame")
                Accent.Size = UDim2.new(0, 3, 1, 0)
                Accent.BackgroundColor3 = alertColor
                Accent.BorderSizePixel = 0
                Accent.ZIndex = 4
                Accent.Parent = AlertFrame

                local IconLbl = Instance.new("TextLabel")
                IconLbl.Size = UDim2.new(0, 20, 1, 0)
                IconLbl.Position = UDim2.new(0, 8, 0, 0)
                IconLbl.BackgroundTransparency = 1
                IconLbl.Text = icon
                IconLbl.TextColor3 = alertColor
                IconLbl.Font = Enum.Font.Code
                IconLbl.TextSize = THEMES.TextSize + 1
                IconLbl.ZIndex = 4
                IconLbl.Parent = AlertFrame

                local TextLbl = Instance.new("TextLabel")
                TextLbl.Size = UDim2.new(1, -36, 1, 0)
                TextLbl.Position = UDim2.new(0, 32, 0, 0)
                TextLbl.BackgroundTransparency = 1
                TextLbl.Text = alertText
                TextLbl.TextColor3 = THEMES.TextColor
                TextLbl.TextXAlignment = Enum.TextXAlignment.Left
                TextLbl.TextYAlignment = Enum.TextYAlignment.Center
                TextLbl.TextWrapped = true
                TextLbl.Font = Enum.Font.Code
                TextLbl.TextSize = THEMES.TextSize - 1
                TextLbl.ZIndex = 4
                TextLbl.Parent = AlertFrame
                RegisterSearch(AlertFrame, alertText)

                WindowRoot:Connect(ThemeEvent.Event, function()
                    TweenService:Create(AlertFrame, TweenInfo.new(0.2), {BackgroundColor3 = THEMES.FrameColor}):Play()
                    TweenService:Create(TextLbl, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
                end)
            end

            function SectionFunctions:Image(assetId: number | string, height: number?)
                ElementCount = ElementCount + 1
                height = height or 100

                local Img = Instance.new("ImageLabel")
                Img.Size = UDim2.new(1, 0, 0, height)
                Img.BackgroundTransparency = 1
                Img.Image = "rbxassetid://" .. tostring(assetId)
                Img.ScaleType = Enum.ScaleType.Fit
                Img.LayoutOrder = ElementCount
                Img.ZIndex = 4
                Img.Parent = Container
                return Img
            end

            function SectionFunctions:KeyValueTable(rows: table)
                ElementCount = ElementCount + 1
                local rowH = THEMES.BaseHeight - 2
                local totalH = #rows * rowH

                local TableFrame = Instance.new("Frame")
                TableFrame.Size = UDim2.new(1, 0, 0, totalH)
                TableFrame.BackgroundTransparency = 1
                TableFrame.LayoutOrder = ElementCount
                TableFrame.ZIndex = 4
                TableFrame.Parent = Container

                local valueLabels = {}
                local searchKeywords = ""
                local rowFrames = {}

                for i, row in rows do
                    searchKeywords = searchKeywords .. tostring(row[1]) .. " " .. tostring(row[2]) .. " "
                    local RowBg = Instance.new("Frame")
                    RowBg.Size = UDim2.new(1, 0, 0, rowH)
                    RowBg.Position = UDim2.new(0, 0, 0, (i - 1) * rowH)
                    RowBg.BackgroundColor3 = i % 2 == 0 and THEMES.FrameColor or THEMES.MainColor
                    RowBg.BackgroundTransparency = 0.3
                    RowBg.BorderSizePixel = 0
                    RowBg.ZIndex = 4
                    RowBg.Parent = TableFrame

                    local KeyLbl = Instance.new("TextLabel")
                    KeyLbl.Size = UDim2.new(0.5, -4, 1, 0)
                    KeyLbl.Position = UDim2.new(0, 6, 0, 0)
                    KeyLbl.BackgroundTransparency = 1
                    KeyLbl.Text = tostring(row[1])
                    KeyLbl.TextColor3 = THEMES.SubTextColor
                    KeyLbl.TextXAlignment = Enum.TextXAlignment.Left
                    KeyLbl.Font = Enum.Font.Code
                    KeyLbl.TextSize = THEMES.TextSize - 1
                    KeyLbl.ZIndex = 4
                    KeyLbl.Parent = RowBg

                    local ValLbl = Instance.new("TextLabel")
                    ValLbl.Size = UDim2.new(0.5, -6, 1, 0)
                    ValLbl.Position = UDim2.new(0.5, 0, 0, 0)
                    ValLbl.BackgroundTransparency = 1
                    ValLbl.Text = tostring(row[2])
                    ValLbl.TextColor3 = THEMES.TextColor
                    ValLbl.TextXAlignment = Enum.TextXAlignment.Right
                    ValLbl.Font = Enum.Font.Code
                    ValLbl.TextSize = THEMES.TextSize - 1
                    ValLbl.ZIndex = 4
                    ValLbl.Parent = RowBg

                    valueLabels[tostring(row[1])] = ValLbl
                    table.insert(rowFrames, {Bg = RowBg, Key = KeyLbl, Val = ValLbl, Index = i})
                end

                local Obj = {}
                function Obj:SetValue(key: string, value)
                    local lbl = valueLabels[tostring(key)]
                    if lbl then lbl.Text = tostring(value) end
                end
                RegisterSearch(TableFrame, searchKeywords)

                WindowRoot:Connect(ThemeEvent.Event, function()
                    for _, r in rowFrames do
                        TweenService:Create(r.Bg, TweenInfo.new(0.2), {BackgroundColor3 = (r.Index % 2 == 0) and THEMES.FrameColor or THEMES.MainColor}):Play()
                        TweenService:Create(r.Key, TweenInfo.new(0.2), {TextColor3 = THEMES.SubTextColor}):Play()
                        TweenService:Create(r.Val, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
                    end
                end)

                return Obj
            end

            function SectionFunctions:Console(height: number?)
                ElementCount = ElementCount + 1
                local consoleH = height or 120

                local ConsoleFrame = Instance.new("Frame")
                ConsoleFrame.Size = UDim2.new(1, 0, 0, consoleH)
                ConsoleFrame.BackgroundTransparency = 1
                ConsoleFrame.LayoutOrder = ElementCount
                ConsoleFrame.ZIndex = 4
                ConsoleFrame.Parent = Container

                local InnerBox = Instance.new("ScrollingFrame")
                InnerBox.Size = UDim2.new(1, 0, 1, 0)
                WindowRoot:Theme(InnerBox, "BackgroundColor3", "FrameColor")
                WindowRoot:Theme(InnerBox, "BorderColor3", "BorderColor")
                InnerBox.ScrollBarThickness = 2
                InnerBox.ScrollingDirection = Enum.ScrollingDirection.Y
                InnerBox.AutomaticCanvasSize = Enum.AutomaticSize.Y
                InnerBox.ZIndex = 4
                InnerBox.Parent = ConsoleFrame
                CreateGradient(InnerBox)

                local List = Instance.new("UIListLayout")
                List.SortOrder = Enum.SortOrder.LayoutOrder
                List.Padding = UDim.new(0, 2)
                List.Parent = InnerBox

                local UIPadding = Instance.new("UIPadding")
                UIPadding.PaddingTop = UDim.new(0, 4)
                UIPadding.PaddingLeft = UDim.new(0, 6)
                UIPadding.PaddingBottom = UDim.new(0, 4)
                UIPadding.Parent = InnerBox

                WindowRoot:Connect(ThemeEvent.Event, function()
                    TweenService:Create(InnerBox, TweenInfo.new(0.2), {
                        BackgroundColor3 = THEMES.FrameColor,
                        BorderColor3 = THEMES.BorderColor
                    }):Play()
                end)

                local lineCount = 0
                local ConsoleObj = {}

                function ConsoleObj:Print(msg: string, color: Color3?)
                    lineCount = lineCount + 1
                    local Line = Instance.new("TextLabel")
                    Line.Size = UDim2.new(1, -6, 0, 16)
                    Line.BackgroundTransparency = 1
                    Line.Text = string.format("[%s] %s", os.date("%H:%M:%S"), msg)
                    Line.TextColor3 = color or THEMES.TextColor
                    Line.TextXAlignment = Enum.TextXAlignment.Left
                    Line.Font = Enum.Font.Code
                    Line.TextSize = THEMES.TextSize - 1
                    Line.LayoutOrder = lineCount
                    Line.ZIndex = 4
                    Line.Parent = InnerBox

                    local isAtBottom = (InnerBox.CanvasPosition.Y + InnerBox.AbsoluteWindowSize.Y >= InnerBox.AbsoluteCanvasSize.Y - 20)
                    
                    task.defer(function()
                        if isAtBottom then
                            InnerBox.CanvasPosition = Vector2.new(0, 999999)
                        end
                    end)
                end

                function ConsoleObj:Clear()
                    for _, child in InnerBox:GetChildren() do
                        if child:IsA("TextLabel") then child:Destroy() end
                    end
                    lineCount = 0
                end

                RegisterSearch(ConsoleFrame, "Console Log Output")
                return ConsoleObj
            end

                function SectionFunctions:Webhook(text: string, flag: string, callback)
                    ElementCount = ElementCount + 1
                    local WebhookFrame = Instance.new("Frame")
                    WebhookFrame.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight * 2 + 10)
                    WebhookFrame.BackgroundTransparency = 1
                    WebhookFrame.LayoutOrder = ElementCount
                    WebhookFrame.Parent = Container
                    
                    local Lbl = Instance.new("TextLabel")
                    Lbl.Size = UDim2.new(1, 0, 0, 16)
                    Lbl.Text = text
                    Lbl.BackgroundTransparency = 1
                    WindowRoot:Theme(Lbl, "TextColor3", "SubTextColor")
                    Lbl.Font = Enum.Font.Code
                    Lbl.TextSize = THEMES.TextSize - 1
                    Lbl.TextXAlignment = Enum.TextXAlignment.Left
                    Lbl.Parent = WebhookFrame

                    local Input = Instance.new("TextBox")
                    Input.Size = UDim2.new(1, -65, 0, THEMES.BaseHeight)
                    Input.Position = UDim2.new(0, 0, 0, 18)
                    Input.PlaceholderText = "https://discord.com/api/webhooks/..."
                    WindowRoot:Theme(Input, "BackgroundColor3", "FrameColor")
                    WindowRoot:Theme(Input, "TextColor3", "TextColor")
                    Input.Font = Enum.Font.Code
                    Input.TextSize = THEMES.TextSize
                    Input.ClipsDescendants = true
                    Input.TextXAlignment = Enum.TextXAlignment.Left
                    Input.Parent = WebhookFrame
                    RoundCorner(Input, 4)
                    
                    local Padding = Instance.new("UIPadding")
                    Padding.PaddingLeft = UDim.new(0, 8)
                    Padding.PaddingRight = UDim.new(0, 8)
                    Padding.Parent = Input
                    
                    if flag then
                        Input.Text = WindowRoot.Flags[flag] or ""
                        WindowRoot:Connect(Input:GetPropertyChangedSignal("Text"), function()
                            WindowRoot.Flags[flag] = Input.Text
                            callback(Input.Text)
                        end)
                    end

                    local TestBtn = CreateButton()
                    TestBtn.Size = UDim2.new(0, 55, 0, THEMES.BaseHeight)
                    TestBtn.Position = UDim2.new(1, -55, 0, 18)
                    TestBtn.Text = "Test"
                    TestBtn.Parent = WebhookFrame
                    
                    WindowRoot:Connect(TestBtn.MouseButton1Click, function()
                        PlayClick()
                        local data = {
                            content = "NextLevel UI Webhook Test Successful!",
                            username = "NextLevel Hub"
                        }
                        local response = request({
                            Url = Input.Text,
                            Method = "POST",
                            Headers = { ["Content-Type"] = "application/json" },
                            Body = HttpService:JSONEncode(data)
                        })
                        if response.Success then
                            WindowRoot:Notify("Success", "Webhook test sent.", 2)
                        else
                            WindowRoot:Notify("Error", "Failed to send webhook.", 3)
                        end
                    end)
                end

            function SectionFunctions:Grid(text, items, columns, callback)
                ElementCount = ElementCount + 1
                columns  = columns  or 3
                callback = callback or function() end
                items    = items    or {}
        
                local rows   = math.ceil(#items / columns)
                local btnH   = THEMES.BaseHeight
                local totalH = THEMES.BaseHeight + rows * (btnH + 4) + 4
        
                local GridFrame = Instance.new("Frame")
                GridFrame.Size               = UDim2.new(1, 0, 0, totalH)
                GridFrame.BackgroundTransparency = 1
                GridFrame.LayoutOrder        = ElementCount
                GridFrame.ZIndex             = 4
                GridFrame.Parent             = Container
        
                if text and text ~= "" then
                    local HeaderLbl = Instance.new("TextLabel")
                    HeaderLbl.Size               = UDim2.new(1, 0, 0, THEMES.BaseHeight)
                    HeaderLbl.BackgroundTransparency = 1
                    HeaderLbl.Text               = text
                    HeaderLbl.Font               = Enum.Font.Code
                    HeaderLbl.TextSize           = THEMES.TextSize
                    HeaderLbl.TextXAlignment     = Enum.TextXAlignment.Left
                    HeaderLbl.ZIndex             = 4
                    HeaderLbl.Parent             = GridFrame
                    WindowRoot:Theme(HeaderLbl, "TextColor3", "TextColor")
                end
        
                local colW = 1 / columns
                for i, item in items do
                    local itemText = type(item) == "table" and item.text or tostring(item)
                    local itemId   = type(item) == "table" and item.id   or tostring(item)
                    local col      = (i - 1) % columns
                    local row      = math.floor((i - 1) / columns)
        
                    local B = Instance.new("TextButton")
                    B.Size     = UDim2.new(colW, -3, 0, btnH)
                    B.Position = UDim2.new(col * colW, 1, 0, THEMES.BaseHeight + 4 + row * (btnH + 4))
                    B.Text     = itemText
                    B.Font     = Enum.Font.Code
                    B.TextSize = THEMES.TextSize - 1
                    B.ZIndex   = 4
                    B.Parent   = GridFrame
                    WindowRoot:Theme(B, "BackgroundColor3", "FrameColor")
                    WindowRoot:Theme(B, "BorderColor3",     "ButtonBorderColor")
                    WindowRoot:Theme(B, "TextColor3",       "TextColor")
                    CreateGradient(B)
        
                    local capturedId = itemId
                    WindowRoot:Connect(B.MouseButton1Click, function() callback(capturedId) end)
                end
        
                RegisterSearch(GridFrame, text or table.concat(
                    (function()
                        local t = {}
                        for _, item in items do
                            table.insert(t, type(item) == "table" and item.text or tostring(item))
                        end
                        return t
                    end)(), " "))
                return GridFrame
            end


            function SectionFunctions:MultilineInput(text, placeholder, lineCount, flag, callback)
                ElementCount = ElementCount + 1
                lineCount = lineCount or 3
                callback  = callback  or function() end
                local h   = lineCount * 18 + 10
        
                if flag then WindowRoot.Flags[flag] = "" end
        
                local MLFrame = Instance.new("Frame")
                MLFrame.Size               = UDim2.new(1, 0, 0, THEMES.BaseHeight + h + 15)
                MLFrame.BackgroundTransparency = 1
                MLFrame.LayoutOrder        = ElementCount
                MLFrame.ZIndex             = 4
                MLFrame.Parent             = Container
        
                local NameLbl = Instance.new("TextLabel")
                NameLbl.Size               = UDim2.new(1, 0, 0, THEMES.BaseHeight)
                NameLbl.BackgroundTransparency = 1
                NameLbl.Text               = text
                NameLbl.Font               = Enum.Font.Code
                NameLbl.TextSize           = THEMES.TextSize
                NameLbl.TextXAlignment     = Enum.TextXAlignment.Left
                NameLbl.ZIndex             = 4
                NameLbl.Parent             = MLFrame
                WindowRoot:Theme(NameLbl, "TextColor3", "TextColor")
        
                local IBox = Instance.new("TextBox")
                IBox.Size               = UDim2.new(1, 0, 0, h)
                IBox.Position           = UDim2.new(0, 0, 0, THEMES.BaseHeight + 2)
                IBox.BackgroundColor3   = THEMES.FrameColor
                IBox.BorderColor3       = THEMES.BorderColor
                IBox.Text               = ""
                IBox.PlaceholderText    = placeholder or "Enter text..."
                IBox.TextColor3         = THEMES.TextColor
                IBox.PlaceholderColor3  = THEMES.SubTextColor
                IBox.Font               = Enum.Font.Code
                IBox.TextSize           = THEMES.TextSize
                IBox.MultiLine          = true
                IBox.ClearTextOnFocus   = false
                IBox.TextXAlignment     = Enum.TextXAlignment.Left
                IBox.TextYAlignment     = Enum.TextYAlignment.Top
                IBox.ClipsDescendants   = true
                IBox.ZIndex             = 4
                IBox.Parent             = MLFrame
                CreateGradient(IBox)
                RoundCorner(IBox, 4)

                local Padding = Instance.new("UIPadding")
                Padding.PaddingLeft = UDim.new(0, 8)
                Padding.PaddingRight = UDim.new(0, 8)
                Padding.PaddingTop = UDim.new(0, 8)
                Padding.PaddingBottom = UDim.new(0, 8)
                Padding.Parent = IBox
        
                local Pad = Instance.new("UIPadding")
                Pad.PaddingLeft = UDim.new(0, 5)
                Pad.PaddingTop  = UDim.new(0, 4)
                Pad.Parent      = IBox
        
                local function SetText(str)
                    IBox.Text = str
                    if flag then WindowRoot.Flags[flag] = str end
                    callback(str)
                end
        
                if flag then WindowRoot.Setters[flag] = SetText end
                WindowRoot:Connect(IBox.FocusLost, function() SetText(IBox.Text) end)
        
                RegisterSearch(MLFrame, text)
                WindowRoot:Connect(ThemeEvent.Event, function()
                    TweenService:Create(NameLbl, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
                    TweenService:Create(IBox,    TweenInfo.new(0.2), {
                        BackgroundColor3 = THEMES.FrameColor,
                        BorderColor3     = THEMES.BorderColor,
                        TextColor3       = THEMES.TextColor,
                    }):Play()
                end)
                return IBox
            end

                function SectionFunctions:TagInput(text, initialTags, maxTags, flag, callback)
        ElementCount = ElementCount + 1
        initialTags  = initialTags  or {}
        maxTags      = maxTags      or 10
        callback     = callback     or function() end
        local tags   = {table.unpack(initialTags)}
 
        if flag then WindowRoot.Flags[flag] = tags end
 
        local TagFrame = Instance.new("Frame")
        TagFrame.Size               = UDim2.new(1, 0, 0, THEMES.BaseHeight * 2 + 8)
        TagFrame.BackgroundTransparency = 1
        TagFrame.LayoutOrder        = ElementCount
        TagFrame.ClipsDescendants   = false
        TagFrame.ZIndex             = 4
        TagFrame.Parent             = Container
 
        local NameLbl = Instance.new("TextLabel")
        NameLbl.Size               = UDim2.new(1, 0, 0, THEMES.BaseHeight)
        NameLbl.BackgroundTransparency = 1
        NameLbl.Text               = text
        NameLbl.Font               = Enum.Font.Code
        NameLbl.TextSize           = THEMES.TextSize
        NameLbl.TextXAlignment     = Enum.TextXAlignment.Left
        NameLbl.ZIndex             = 4
        NameLbl.Parent             = TagFrame
        WindowRoot:Theme(NameLbl, "TextColor3", "TextColor")
 
        -- Input row
        local InputRow = Instance.new("Frame")
        InputRow.Size               = UDim2.new(1, 0, 0, THEMES.BaseHeight)
        InputRow.Position           = UDim2.new(0, 0, 0, THEMES.BaseHeight + 4)
        InputRow.BackgroundTransparency = 1
        InputRow.ZIndex             = 4
        InputRow.Parent             = TagFrame
 
        local TBox = Instance.new("TextBox")
        TBox.Size             = UDim2.new(1, -54, 1, 0)
        TBox.BackgroundColor3 = THEMES.FrameColor
        TBox.BorderColor3     = THEMES.BorderColor
        TBox.Text             = ""
        TBox.PlaceholderText  = "Add tag, press Enter..."
        TBox.TextColor3       = THEMES.TextColor
        TBox.PlaceholderColor3 = THEMES.SubTextColor
        TBox.Font             = Enum.Font.Code
        TBox.TextSize         = THEMES.TextSize
        TBox.ZIndex           = 4
        TBox.Parent           = InputRow
        CreateGradient(TBox)
 
        local AddBtn = Instance.new("TextButton")
        AddBtn.Size     = UDim2.new(0, 50, 1, 0)
        AddBtn.Position = UDim2.new(1, -50, 0, 0)
        AddBtn.Text     = "+ Add"
        AddBtn.Font     = Enum.Font.Code
        AddBtn.TextSize = THEMES.TextSize - 1
        AddBtn.ZIndex   = 4
        AddBtn.Parent   = InputRow
        WindowRoot:Theme(AddBtn, "BackgroundColor3", "FrameColor")
        WindowRoot:Theme(AddBtn, "BorderColor3",     "BorderColor")
        WindowRoot:Theme(AddBtn, "TextColor3",       "LineColor")
        CreateGradient(AddBtn)
 
        -- Tag chip display
        local TagDisplay = Instance.new("Frame")
        TagDisplay.Size               = UDim2.new(1, 0, 0, 0)
        TagDisplay.Position           = UDim2.new(0, 0, 0, THEMES.BaseHeight * 2 + 8)
        TagDisplay.BackgroundTransparency = 1
        TagDisplay.ZIndex             = 4
        TagDisplay.Parent             = TagFrame
 
        local TagListLayout = Instance.new("UIListLayout")
        TagListLayout.FillDirection   = Enum.FillDirection.Horizontal
        TagListLayout.Padding         = UDim.new(0, 4)
        TagListLayout.Wraps           = true
        TagListLayout.SortOrder       = Enum.SortOrder.LayoutOrder
        TagListLayout.Parent          = TagDisplay
 
        TagListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            local h = TagListLayout.AbsoluteContentSize.Y
            TagDisplay.Size  = UDim2.new(1, 0, 0, h)
            TagFrame.Size    = UDim2.new(1, 0, 0, THEMES.BaseHeight * 2 + 8 + h + (h > 0 and 6 or 0))
        end)
 
        local function RebuildTags()
            for _, c in TagDisplay:GetChildren() do
                if not c:IsA("UIListLayout") then c:Destroy() end
            end
            for i, tag in tags do
                local charW   = math.max(#tag * 7, 20) + 24
                local Pill    = Instance.new("Frame")
                Pill.Size     = UDim2.new(0, charW, 0, THEMES.BaseHeight - 4)
                Pill.BackgroundColor3 = THEMES.FrameColor
                Pill.BorderColor3     = THEMES.BorderColor
                Pill.ZIndex           = 5
                Pill.LayoutOrder      = i
                Pill.Parent           = TagDisplay
 
                local TL = Instance.new("TextLabel")
                TL.Size               = UDim2.new(1, -16, 1, 0)
                TL.Position           = UDim2.new(0, 4, 0, 0)
                TL.BackgroundTransparency = 1
                TL.Text               = tag
                TL.Font               = Enum.Font.Code
                TL.TextSize           = THEMES.TextSize - 1
                TL.TextXAlignment     = Enum.TextXAlignment.Left
                TL.ZIndex             = 5
                TL.Parent             = Pill
                WindowRoot:Theme(TL, "TextColor3", "TextColor")
 
                local XB = Instance.new("TextButton")
                XB.Size               = UDim2.new(0, 14, 1, 0)
                XB.Position           = UDim2.new(1, -14, 0, 0)
                XB.BackgroundTransparency = 1
                XB.Text               = "×"
                XB.Font               = Enum.Font.Code
                XB.TextSize           = THEMES.TextSize
                XB.ZIndex             = 6
                XB.Parent             = Pill
                WindowRoot:Theme(XB, "TextColor3", "SubTextColor")
 
                local capturedTag = tag
                WindowRoot:Connect(XB.MouseButton1Click, function()
                    local idx = table.find(tags, capturedTag)
                    if idx then
                        table.remove(tags, idx)
                        if flag then WindowRoot.Flags[flag] = tags end
                        callback(tags)
                        RebuildTags()
                    end
                end)
            end
        end
 
        local function AddTag(str)
            str = str:match("^%s*(.-)%s*$")
            if str == "" or #tags >= maxTags or table.find(tags, str) then return end
            table.insert(tags, str)
            if flag then WindowRoot.Flags[flag] = tags end
            callback(tags)
            RebuildTags()
            TBox.Text = ""
        end
 
        WindowRoot:Connect(AddBtn.MouseButton1Click,              function() AddTag(TBox.Text) end)
        WindowRoot:Connect(TBox.FocusLost, function(enter) if enter then AddTag(TBox.Text) end end)
 
        RebuildTags()
        RegisterSearch(TagFrame, text)
        WindowRoot:Connect(ThemeEvent.Event, function()
            TweenService:Create(NameLbl, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
            TweenService:Create(TBox,    TweenInfo.new(0.2), {
                BackgroundColor3 = THEMES.FrameColor,
                BorderColor3     = THEMES.BorderColor,
                TextColor3       = THEMES.TextColor,
            }):Play()
        end)
 
        local Obj = {}
        function Obj:GetTags()      return {table.unpack(tags)} end
        function Obj:SetTags(list)  tags = {table.unpack(list)}; RebuildTags() end
        function Obj:AddTag(str)    AddTag(str) end
        return Obj
    end

        function SectionFunctions:Timer(text, seconds, autoStart, onComplete)
        ElementCount = ElementCount + 1
        seconds    = seconds    or 60
        autoStart  = autoStart  or false
        onComplete = onComplete or function() end
 
        local remaining = seconds
        local running   = false
        local thread    = nil
 
        local function FormatTime(s)
            return string.format("%02d:%02d", math.floor(s / 60), s % 60)
        end
 
        local TimerFrame = Instance.new("Frame")
        TimerFrame.Size               = UDim2.new(1, 0, 0, THEMES.BaseHeight * 2 + 14)
        TimerFrame.BackgroundTransparency = 1
        TimerFrame.LayoutOrder        = ElementCount
        TimerFrame.ZIndex             = 4
        TimerFrame.Parent             = Container
 
        local NameLbl = Instance.new("TextLabel")
        NameLbl.Size               = UDim2.new(0.55, 0, 0, THEMES.BaseHeight)
        NameLbl.BackgroundTransparency = 1
        NameLbl.Text               = text
        NameLbl.Font               = Enum.Font.Code
        NameLbl.TextSize           = THEMES.TextSize
        NameLbl.TextXAlignment     = Enum.TextXAlignment.Left
        NameLbl.ZIndex             = 4
        NameLbl.Parent             = TimerFrame
        WindowRoot:Theme(NameLbl, "TextColor3", "TextColor")
 
        local TimeDisplay = Instance.new("TextLabel")
        TimeDisplay.Size               = UDim2.new(0.45, 0, 0, THEMES.BaseHeight)
        TimeDisplay.Position           = UDim2.new(0.55, 0, 0, 0)
        TimeDisplay.BackgroundTransparency = 1
        TimeDisplay.Text               = FormatTime(remaining)
        TimeDisplay.Font               = Enum.Font.Code
        TimeDisplay.TextSize           = THEMES.TextSize + 3
        TimeDisplay.TextXAlignment     = Enum.TextXAlignment.Right
        TimeDisplay.ZIndex             = 4
        TimeDisplay.Parent             = TimerFrame
        WindowRoot:Theme(TimeDisplay, "TextColor3", "LineColor")
 
        local Track = Instance.new("Frame")
        Track.Size     = UDim2.new(1, 0, 0, 4)
        Track.Position = UDim2.new(0, 0, 0, THEMES.BaseHeight + 4)
        Track.ZIndex   = 4
        Track.Parent   = TimerFrame
        WindowRoot:Theme(Track, "BackgroundColor3", "FrameColor")
        WindowRoot:Theme(Track, "BorderColor3",     "BorderColor")
 
        local Fill = Instance.new("Frame")
        Fill.Size             = UDim2.new(1, 0, 1, 0)
        Fill.BackgroundColor3 = THEMES.LineColor
        Fill.BorderSizePixel  = 0
        Fill.ZIndex           = 5
        Fill.Parent           = Track
 
        -- Three control buttons
        local BtnY = THEMES.BaseHeight + 12
        local function MakeBtn(label, xOffset)
            local B = Instance.new("TextButton")
            B.Size     = UDim2.new(0, 62, 0, THEMES.BaseHeight - 2)
            B.Position = UDim2.new(0, xOffset, 0, BtnY)
            B.Text     = label
            B.Font     = Enum.Font.Code
            B.TextSize = THEMES.TextSize - 1
            B.ZIndex   = 4
            B.Parent   = TimerFrame
            WindowRoot:Theme(B, "BackgroundColor3", "FrameColor")
            WindowRoot:Theme(B, "BorderColor3",     "BorderColor")
            WindowRoot:Theme(B, "TextColor3",       "TextColor")
            CreateGradient(B)
            return B
        end
        local StartBtn = MakeBtn("▶ Start", 0)
        local PauseBtn = MakeBtn("‖ Pause", 66)
        local ResetBtn = MakeBtn("↺ Reset", 132)
 
        local function UpdateVisuals()
            local ratio = seconds > 0 and math.clamp(remaining / seconds, 0, 1) or 0
            TimeDisplay.Text = FormatTime(remaining)
            Fill.Size = UDim2.new(ratio, 0, 1, 0)
            local c = ratio < 0.25 and THEMES.ErrorColor
                   or ratio < 0.5  and THEMES.WarningColor
                   or THEMES.LineColor
            Fill.BackgroundColor3    = c
            TimeDisplay.TextColor3   = c
        end
 
        local function StartTicking()
            if thread then task.cancel(thread); thread = nil end
            thread = task.spawn(function()
                while running and remaining > 0 do
                    task.wait(1)
                    if running then
                        remaining = remaining - 1
                        UpdateVisuals()
                        if remaining <= 0 then
                            running = false
                            onComplete()
                        end
                    end
                end
            end)
        end
 
        WindowRoot:Connect(StartBtn.MouseButton1Click, function()
            if not running and remaining > 0 then
                running = true; StartTicking()
            end
        end)
        WindowRoot:Connect(PauseBtn.MouseButton1Click, function()
            running = false
            if thread then task.cancel(thread); thread = nil end
        end)
        WindowRoot:Connect(ResetBtn.MouseButton1Click, function()
            running = false
            if thread then task.cancel(thread); thread = nil end
            remaining = seconds; UpdateVisuals()
        end)
 
        if autoStart then running = true; task.defer(StartTicking) end
 
        RegisterSearch(TimerFrame, text)
        WindowRoot:Connect(ThemeEvent.Event, function()
            TweenService:Create(NameLbl, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
            TweenService:Create(Track,   TweenInfo.new(0.2), {
                BackgroundColor3 = THEMES.FrameColor, BorderColor3 = THEMES.BorderColor
            }):Play()
        end)
 
        local Obj = {}
        function Obj:Set(s)
            running = false
            if thread then task.cancel(thread); thread = nil end
            seconds = s; remaining = s; UpdateVisuals()
        end
        function Obj:Start() if not running and remaining > 0 then running = true; StartTicking() end end
        function Obj:Pause() running = false; if thread then task.cancel(thread); thread = nil end end
        function Obj:Reset() remaining = seconds; UpdateVisuals(); running = false end
        return Obj
    end


        function SectionFunctions:Chart(text, data, height)
        ElementCount = ElementCount + 1
        height = height or 90
        data   = data   or {}
 
        local maxVal = 0
        for _, d in data do
            maxVal = math.max(maxVal, d.value or 0)
        end
 
        local outerH = THEMES.BaseHeight + height + 22
        local ChartFrame = Instance.new("Frame")
        ChartFrame.Size               = UDim2.new(1, 0, 0, outerH)
        ChartFrame.BackgroundTransparency = 1
        ChartFrame.LayoutOrder        = ElementCount
        ChartFrame.ZIndex             = 4
        ChartFrame.Parent             = Container
 
        local TitleLbl = Instance.new("TextLabel")
        TitleLbl.Size               = UDim2.new(1, 0, 0, THEMES.BaseHeight)
        TitleLbl.BackgroundTransparency = 1
        TitleLbl.Text               = text
        TitleLbl.Font               = Enum.Font.Code
        TitleLbl.TextSize           = THEMES.TextSize
        TitleLbl.TextXAlignment     = Enum.TextXAlignment.Left
        TitleLbl.ZIndex             = 4
        TitleLbl.Parent             = ChartFrame
        WindowRoot:Theme(TitleLbl, "TextColor3", "TextColor")
 
        local ChartArea = Instance.new("Frame")
        ChartArea.Size     = UDim2.new(1, 0, 0, height)
        ChartArea.Position = UDim2.new(0, 0, 0, THEMES.BaseHeight + 2)
        ChartArea.ZIndex   = 4
        ChartArea.Parent   = ChartFrame
        WindowRoot:Theme(ChartArea, "BackgroundColor3", "FrameColor")
        WindowRoot:Theme(ChartArea, "BorderColor3",     "BorderColor")
        CreateGradient(ChartArea)
 
        local barBars = {}
        if #data > 0 then
            local segW = 1 / #data
            for i, d in data do
                local ratio = maxVal > 0 and (d.value / maxVal) or 0
 
                local Bar = Instance.new("Frame")
                Bar.AnchorPoint  = Vector2.new(0, 1)
                Bar.Size         = UDim2.new(segW * 0.65, 0, 0, 0)
                Bar.Position     = UDim2.new((i - 1) * segW + segW * 0.175, 0, 1, 0)
                Bar.BorderSizePixel = 0
                Bar.ZIndex       = 5
                Bar.Parent       = ChartArea
                WindowRoot:Theme(Bar, "BackgroundColor3", "LineColor")
                table.insert(barBars, Bar)
 
                task.defer(function()
                    TweenService:Create(Bar,
                        TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                        {Size = UDim2.new(segW * 0.65, 0, ratio * 0.90, 0)}):Play()
                end)
 
                local ValLbl = Instance.new("TextLabel")
                ValLbl.Size               = UDim2.new(1, 0, 0, 12)
                ValLbl.AnchorPoint        = Vector2.new(0.5, 1)
                ValLbl.Position           = UDim2.new(0.5, 0, 0, -2)
                ValLbl.BackgroundTransparency = 1
                ValLbl.Text               = tostring(d.value)
                ValLbl.Font               = Enum.Font.Code
                ValLbl.TextSize           = 9
                ValLbl.ZIndex             = 6
                ValLbl.Parent             = Bar
                WindowRoot:Theme(ValLbl, "TextColor3", "SubTextColor")
 
                local LabelLbl = Instance.new("TextLabel")
                LabelLbl.Size               = UDim2.new(segW, 0, 0, 16)
                LabelLbl.Position           = UDim2.new((i - 1) * segW, 0, 0, THEMES.BaseHeight + 2 + height + 2)
                LabelLbl.BackgroundTransparency = 1
                LabelLbl.Text               = d.label or ""
                LabelLbl.Font               = Enum.Font.Code
                LabelLbl.TextSize           = 9
                LabelLbl.ZIndex             = 4
                LabelLbl.Parent             = ChartFrame
                WindowRoot:Theme(LabelLbl, "TextColor3", "SubTextColor")
            end
        end
 
        RegisterSearch(ChartFrame, text)
        WindowRoot:Connect(ThemeEvent.Event, function()
            TweenService:Create(TitleLbl, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
            TweenService:Create(ChartArea, TweenInfo.new(0.2), {
                BackgroundColor3 = THEMES.FrameColor,
                BorderColor3     = THEMES.BorderColor,
            }):Play()
            for _, b in barBars do
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = THEMES.LineColor}):Play()
            end
        end)
        return ChartFrame
    end
 


            return SectionFunctions
        end

        return TabFunctions
    end

    function self:Dialog(title, message, buttons, callback)
        buttons  = buttons  or {"OK"}
        callback = callback or function() end
 
        local ScreenGuiRef = self.Frames.MainFrame.Parent
 
        local Overlay = Instance.new("TextButton")
        Overlay.Size                = UDim2.new(1, 0, 1, 0)
        Overlay.BackgroundColor3    = Color3.new(0, 0, 0)
        Overlay.BackgroundTransparency = 0.4
        Overlay.BorderSizePixel     = 0
        Overlay.Text                = ""
        Overlay.AutoButtonColor     = false
        Overlay.ZIndex              = 200
        Overlay.Parent              = ScreenGuiRef
 
        local btnTotalW = #buttons * 80 + (#buttons - 1) * 6
        local dialogW   = math.max(280, btnTotalW + 40)
        local dialogH   = 130
 
        local DialogBox = Instance.new("Frame")
        DialogBox.Size     = UDim2.new(0, dialogW, 0, dialogH)
        DialogBox.Position = UDim2.new(0.5, -dialogW / 2, 0.5, -dialogH / 2)
        DialogBox.ZIndex   = 201
        DialogBox.Parent   = ScreenGuiRef
        WindowRoot:Theme(DialogBox, "BackgroundColor3", "MainColor")
        WindowRoot:Theme(DialogBox, "BorderColor3", "LineColor")
        CreateGradient(DialogBox)
 
        local Scale = Instance.new("UIScale")
        Scale.Scale = 0.8
        Scale.Parent = DialogBox
        TweenService:Create(Scale,
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Scale = 1}):Play()
 
        -- Title
        local TitleL = Instance.new("TextLabel")
        TitleL.Size               = UDim2.new(1, -10, 0, 28)
        TitleL.Position           = UDim2.new(0, 8, 0, 4)
        TitleL.BackgroundTransparency = 1
        TitleL.Text               = title
        TitleL.Font               = Enum.Font.SourceSansBold
        TitleL.TextSize           = THEMES.TextSize + 2
        TitleL.TextXAlignment     = Enum.TextXAlignment.Left
        TitleL.ZIndex             = 202
        TitleL.Parent             = DialogBox
        WindowRoot:Theme(TitleL, "TextColor3", "TextColor")
 
        -- Divider
        local Sep = Instance.new("Frame")
        Sep.Size              = UDim2.new(1, 0, 0, 1)
        Sep.Position          = UDim2.new(0, 0, 0, 32)
        Sep.BorderSizePixel   = 0
        Sep.ZIndex            = 202
        Sep.Parent            = DialogBox
        WindowRoot:Theme(Sep, "BackgroundColor3", "BorderColor")
 
        -- Message
        local MsgL = Instance.new("TextLabel")
        MsgL.Size                 = UDim2.new(1, -16, 0, 54)
        MsgL.Position             = UDim2.new(0, 8, 0, 38)
        MsgL.BackgroundTransparency = 1
        MsgL.Text                 = message
        MsgL.Font                 = Enum.Font.Code
        MsgL.TextSize             = THEMES.TextSize
        MsgL.TextWrapped          = true
        MsgL.TextXAlignment       = Enum.TextXAlignment.Left
        MsgL.TextYAlignment       = Enum.TextYAlignment.Top
        MsgL.ZIndex               = 202
        MsgL.Parent               = DialogBox
        WindowRoot:Theme(MsgL, "TextColor3", "SubTextColor")
 
        local function CloseDialog(selected)
            local fadeInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            TweenService:Create(Scale, fadeInfo, {Scale = 0.8}):Play()
            TweenService:Create(Overlay, fadeInfo, {BackgroundTransparency = 1}):Play()
            
            for _, child in DialogBox:GetDescendants() do
                if child:IsA("TextLabel") then
                    TweenService:Create(child, fadeInfo, {TextTransparency = 1}):Play()
                elseif child:IsA("Frame") or child:IsA("TextButton") then
                    TweenService:Create(child, fadeInfo, {BackgroundTransparency = 1}):Play()
                    if child:IsA("UIStroke") then TweenService:Create(child, fadeInfo, {Transparency = 1}):Play() end
                end
            end
            TweenService:Create(DialogBox, fadeInfo, {BackgroundTransparency = 1}):Play()

            task.delay(0.15, function()
                DialogBox:Destroy()
                Overlay:Destroy()
            end)
            callback(selected)
        end
 
        -- Buttons
        local startX = (dialogW - btnTotalW) / 2
        for i, btnText in buttons do
            local B = Instance.new("TextButton")
            B.Size     = UDim2.new(0, 80, 0, THEMES.BaseHeight)
            B.Position = UDim2.new(0, startX + (i - 1) * 86, 0, dialogH - THEMES.BaseHeight - 10)
            B.Text     = btnText
            B.Font     = Enum.Font.Code
            B.TextSize = THEMES.TextSize
            B.ZIndex   = 203
            B.Parent   = DialogBox
            WindowRoot:Theme(B, "BackgroundColor3", "FrameColor")
            WindowRoot:Theme(B, "BorderColor3",     "LineColor")
            WindowRoot:Theme(B, "TextColor3",       "TextColor")
            CreateGradient(B)
            WindowRoot:Connect(B.MouseButton1Click, function() CloseDialog(btnText) end)
        end
    end


    return self
end

function Library:ApplyPreset(presetName)
    local preset = self.Presets[presetName]
    if preset then
        for k, v in preset do THEMES[k] = v end
        ThemeEvent:Fire()
    end
end

function Library:BuildUtilityTab(iconId)
    local UtilTab = self:Tab("Utility", iconId or 11963373104) 

    local ClickerSec = UtilTab:Section("Auto Clicker")
    local acEnabled = false
    local cps = 10
    local isClicking = false

    ClickerSec:ToggleBind("Enable Auto Clicker", false, Enum.KeyCode.V, "AC_Enabled", "AC_Key", function(state) 
        acEnabled = state 
    end)
    ClickerSec:Slider("Clicks Per Second (CPS)", 1, 50, 10, 0, "AC_CPS", function(val) 
        cps = val 
    end)

    task.spawn(function()
        while true do
            if acEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                if m1click then pcall(m1click) end
            end
            task.wait(1 / cps)
        end
    end)
    
    ClickerSec:Paragraph("Note: Auto Clicker activates while holding Left Click if enabled.")

    local ServerSec = UtilTab:Section("Server Management")
    ServerSec:CreateButtonRow("Rejoin Server", function()
        self:Notify("Rejoining", "Attempting to rejoin the current server...", 3)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
    end, "Server Hop", function()
        self:ServerHop(game.PlaceId)
    end)
    
    ServerSec:Button("Copy Job ID", function()
        setclipboard(game.JobId)
        self:Notify("Copied", "Server Job ID copied to clipboard.", 3)
    end)
end

function Library:BuildSettingsTab(iconId)
    local ConfigTab = self:Tab("Settings", iconId or 3926307971)
    local SettingsSection = ConfigTab:Section("Configuration")
    local UISetupSection = ConfigTab:Section("UI Elements")

    local ConfigName = ""
    local SelectedConfig = ""
    local AutoloadFile = self.ConfigFolder .. "/autoload.txt"

    local function GetConfigs()
        local list = {}
        if isfolder(self.ConfigFolder) then
            for _, file in listfiles(self.ConfigFolder) do
                local name = file:match("([^/\\]+)%.json$")
                if name then table.insert(list, name) end
            end
        end
        return list
    end

    SettingsSection:Input("Config Name", "Enter name to save...", nil, function(txt) ConfigName = txt end)
    local Dropdown = SettingsSection:SearchableDropdown("Select Config", GetConfigs(), "", nil, function(val) SelectedConfig = val end)
    local ActiveConfigLbl = SettingsSection:Label("Active Config: None")

    SettingsSection:CreateButtonRow("Save Config", function()
        local name = ConfigName ~= "" and ConfigName or SelectedConfig
        if name == "" then return self:Notify("Error", "Please enter a config name.", 3) end
        
        local dataToSave = {}
        for flag, val in self.Flags do
            if not self.IgnoredFlags[flag] then
                if typeof(val) == "Color3" then
                    dataToSave[flag] = {r = val.R, g = val.G, b = val.B, _type = "Color3"}
                elseif type(val) == "table" and (val.R or val.r) then
                    -- Handle ColorPicker table format
                    dataToSave[flag] = {r = val.R or val.r, g = val.G or val.g, b = val.B or val.b, a = val.A or val.a or 1, _type = "ThemeColor"}
                else
                    dataToSave[flag] = val
                end
            end
        end

        local ok, err = pcall(function() writefile(self.ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(dataToSave)) end)
        if ok then
            self:Notify("Saved", "Config '" .. name .. "' saved.", 3)
            Dropdown:Refresh(GetConfigs())
            ActiveConfigLbl:SetText("Active Config: " .. name)
        else
            self:Notify("Error", "Save failed: " .. tostring(err), 5)
        end
    end, "Load Config", function()
        if SelectedConfig == "" then return self:Notify("Error", "Select a config first.", 3) end
        local path = self.ConfigFolder .. "/" .. SelectedConfig .. ".json"
        if not isfile(path) then return self:Notify("Error", "File not found.", 3) end
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
        if ok and type(data) == "table" then
            for flag, value in data do 
                if not self.IgnoredFlags[flag] and self.Setters[flag] then
                    local realVal = value
                    if type(value) == "table" then
                        if value._type == "Color3" or value._type == "ThemeColor" then
                            realVal = {R = value.r, G = value.g, B = value.b, A = value.a or 1}
                        end
                    end
                    -- For themes, we want to make sure they apply after a tiny frame gap
                    if flag:find("Theme_") then
                        task.spawn(function()
                            task.wait()
                            self.Setters[flag](realVal)
                        end)
                    else
                        self.Setters[flag](realVal)
                    end
                end 
            end
            ActiveConfigLbl:SetText("Active Config: " .. SelectedConfig)
            self:Notify("Loaded", "Config '" .. SelectedConfig .. "' applied.", 3)
        else
            self:Notify("Error", "Failed to parse config.", 5)
        end
    end)

    SettingsSection:CreateButtonRow("Delete Config", function()
        if SelectedConfig == "" then return self:Notify("Error", "Select a config to delete.", 3) end
        local path = self.ConfigFolder .. "/" .. SelectedConfig .. ".json"
        if isfile(path) then
            delfile(path)
            self:Notify("Deleted", "Config '" .. SelectedConfig .. "' removed.", 3)
            SelectedConfig = ""
            Dropdown:Refresh(GetConfigs())
        end
    end, "Set Autoload", function()
        if SelectedConfig == "" then return self:Notify("Error", "Select a config to autoload.", 3) end
        writefile(AutoloadFile, SelectedConfig)
        self:Notify("Autoload Set", "'" .. SelectedConfig .. "' will now load on inject.", 3)
    end)

    SettingsSection:CreateButtonRow("Export to Clipboard", function()
        local dataToExport = {}
        for flag, val in self.Flags do
            if not self.IgnoredFlags[flag] then dataToExport[flag] = val end
        end
        setclipboard(HttpService:JSONEncode(dataToExport))
        self:Notify("Exported", "Config copied to clipboard!", 3)
    end, "Import from Clipboard", function()
        local data = getclipboard()
        local ok, parsed = pcall(function() return HttpService:JSONDecode(data) end)
        if ok and type(parsed) == "table" then
            for flag, value in parsed do 
                if not self.IgnoredFlags[flag] and self.Setters[flag] then self.Setters[flag](value) end 
            end
            self:Notify("Imported", "Config loaded from clipboard.", 3)
        else
            self:Notify("Error", "Invalid clipboard data.", 3)
        end
    end)

    SettingsSection:Button("Refresh List", function() Dropdown:Refresh(GetConfigs()); self:Notify("Refreshed", "Config list updated.", 2) end)

    -- PREMIUM UI TOGGLES
    UISetupSection:Toggle("Show Watermark", not Library.IsSilent, "ShowWatermark", function(state)
        if self.WatermarkGui then self.WatermarkGui.Enabled = state end
    end)
    
    UISetupSection:Toggle("Show Active Keybinds", not Library.IsSilent, "ShowKeybinds", function(state)
        if self.KeybindGui then self.KeybindGui.Enabled = state end
        self:UpdateKeybinds()
    end)

    local rgbLoopId = 0
    UISetupSection:Toggle("RGB Chroma Accents", false, "RGBMode", function(state)
        rgbLoop = state
        if state then
            rgbLoopId = rgbLoopId + 1
            local currentId = rgbLoopId
            task.spawn(function()
                while rgbLoop and currentId == rgbLoopId do
                    local hue = tick() % 10 / 10 
                    self:SetTheme({LineColor = Color3.fromHSV(hue, 1, 1)})
                    task.wait(0.1) 
                end
            end)
        else
            rgbLoopId = rgbLoopId + 1
            self:SetTheme({LineColor = Color3.fromRGB(255, 255, 255)})
        end
    end)

    local BlurEffect = Instance.new("BlurEffect")
    BlurEffect.Size = 15
    BlurEffect.Enabled = false
    BlurEffect.Name = "NextLevel_Blur"
    BlurEffect.Parent = game:GetService("Lighting")
    table.insert(getgenv()._NextLevel_Garbage[self.Name], BlurEffect)

    local ScreenGui = self.Frames.MainFrame.Parent
    self:Connect(ScreenGui:GetPropertyChangedSignal("Enabled"), function()
        if self.Flags["MenuBlur"] then
            BlurEffect.Enabled = ScreenGui.Enabled
        end
    end)

    UISetupSection:Toggle("Menu Background Blur", false, "MenuBlur", function(state)
        BlurEffect.Enabled = state and ScreenGui.Enabled
    end)

    UISetupSection:Toggle("Silent Execution", false, "SilentExecution", function(state) end)

    UISetupSection:Button("Unload Library", function()
        self:Notify("Unloaded", "NextLevel UI has been unloaded. Re-inject to use again.", 5)
        self:Unload()
    end)

    local InfoSection = ConfigTab:Section("About")
    InfoSection:Label("NextLevel")
    InfoSection:Separator()
    InfoSection:StatusIndicator("Status", "Active", THEMES.SuccessColor)

    -- AUTOLOAD EXECUTION
    if isfile(AutoloadFile) then
        local autoName = readfile(AutoloadFile):gsub("%s+", "") -- Trim whitespace
        local path = self.ConfigFolder .. "/" .. autoName .. ".json"
        if isfile(path) then
            local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
            if ok and type(data) == "table" then
                task.delay(0.5, function()
                    for flag, value in data do 
                        if not self.IgnoredFlags[flag] and self.Setters[flag] then
                            local realVal = value
                            if type(value) == "table" then
                                if value._type == "Color3" or value._type == "ThemeColor" then
                                    realVal = {R = value.r, G = value.g, B = value.b, A = value.a or 1}
                                end
                            end
                            
                            if flag:find("Theme_") then
                                task.spawn(function()
                                    task.wait(0.2) -- Give theme tab extra time
                                    if self.Setters[flag] then self.Setters[flag](realVal) end
                                end)
                            else
                                self.Setters[flag](realVal)
                            end
                        end 
                    end
                    ActiveConfigLbl:SetText("Active Config: " .. autoName)
                    self:Notify("Autoload", "Successfully loaded config: " .. autoName, 3)
                end)
            end
        end
    end
end

function Library:BuildThemeTab(iconId)
    local ThemeTab = self:Tab("Theme", iconId or 3926305904)
    local PresetSec = ThemeTab:Section("Theme Presets")
    local ThemeSec = ThemeTab:Section("Custom Theme")

    for name, colors in self.Presets do
        PresetSec:Button(name, function()
            self:ApplyPreset(name)
        end)
    end

    for key, defaultColor in THEMES do
        if typeof(defaultColor) == "Color3" then
            ThemeSec:ColorPicker(key, defaultColor, 0, "Theme_"..key, function(color)
                THEMES[key] = color
                ThemeEvent:Fire()
            end)
        end
    end

    ThemeSec:Button("Reset to Default", function()
        self:SetTheme({
            MainColor        = Color3.fromRGB(15, 15, 15),
            FrameColor       = Color3.fromRGB(20, 20, 20),
            TabColor         = Color3.fromRGB(18, 18, 18),
            LineColor        = Color3.fromRGB(78, 78, 78),
            AccentColor      = Color3.fromRGB(78, 78, 78),
            BorderColor      = Color3.fromRGB(40, 40, 40),
            DarkColor        = Color3.fromRGB(10, 10, 10),
            SelectedTab      = Color3.fromRGB(78, 78, 78),
            TextColor        = Color3.fromRGB(245, 245, 245),
            ButtonBorderColor= Color3.fromRGB(35, 35, 35),
            SubTextColor     = Color3.fromRGB(150, 150, 150),
            SuccessColor     = Color3.fromRGB(255, 255, 255),
            WarningColor     = Color3.fromRGB(255, 175, 50),
            ErrorColor       = Color3.fromRGB(255, 70, 90),
            InfoColor        = Color3.fromRGB(255, 255, 255),
        })
        self:Notify("Theme Reset", "Restored default styling.", 3)
    end)
end

function Library:BuildNotificationLogTab(iconId)
    local LogTab = self:Tab("Notifications", iconId or 12154388837)
    local LogSec = LogTab:Section("Notification History")
    
    LogSec:Button("Refresh Log", function()
        LogSec:Clear()
        for i = #self.NotificationHistory, 1, -1 do
            local n = self.NotificationHistory[i]
            LogSec:Paragraph("[" .. n.Time .. "] " .. n.Title .. "\n" .. n.Text)
        end
    end)
    
    LogSec:Button("Clear History", function()
        self.NotificationHistory = {}
        LogSec:Clear()
        LogSec:Label("History cleared.")
    end)

    -- Initial load
    for i = #self.NotificationHistory, 1, -1 do
        local n = self.NotificationHistory[i]
        LogSec:Paragraph("[" .. n.Time .. "] " .. n.Title .. "\n" .. n.Text)
    end
end

function Library:BuildExecutorTab(iconId)
    local ExecTab = self:Tab("Executor", iconId or 11419711674)
    local ExecSec = ExecTab:Section("Internal Runner")
    
    local Code = ""
    ExecSec:MultilineInput("Source Code", "print('Hello NextLevel')", 10, "Exec_Source", function(t) Code = t end)
    
    ExecSec:CreateButtonRow("Execute", function()
        local func, err = loadstring(Code)
        if func then
            task.spawn(func)
            self:Notify("Success", "Code executed.", 2)
        else
            self:Notify("Error", err, 5)
        end
    end, "Clear", function()
        Code = ""
    end)
end

function Library:BuildChangelogTab(data, iconId)
    if type(data) == "table" and data.Icon then
        iconId = data.Icon
    end
    local ChangeTab = self:Tab("Changelog", iconId or 11419714317)
    for version, notes in data do
        if version ~= "Icon" then
            local Sec = ChangeTab:Section("Version " .. tostring(version))
            Sec:Paragraph(notes)
        end
    end
end


function Library:InitLoad(options)
    options = options or {}
 
    local Title       = options.Title           or "NEXUS HUB"
    local SubTitle    = options.SubTitle        or ""
    local Icon        = options.Icon            or nil
    local Duration    = options.Duration        or 5
    local AccentColor = options.AccentColor     or Color3.fromRGB(0, 210, 150)
    local BgColor     = options.BackgroundColor or Color3.fromRGB(5, 8, 13)
    local Statuses    = options.Statuses        or {
        "Establishing secure connection...",
        "Loading encryption modules...",
        "Authenticating payload...",
        "Injecting core systems...",
        "Building interface..."
    }

    local isSilent = options.Silent or false

    if not isSilent then
        local configFolder = Title .. "_Configs/" .. tostring(game.PlaceId)
        local autoloadFile = configFolder .. "/autoload.txt"
        if isfile(autoloadFile) then
            local autoName = readfile(autoloadFile):gsub("%s+", "") -- Trim all whitespace/newlines
            local path = configFolder .. "/" .. autoName .. ".json"
            if isfile(path) then
                local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
                if ok and type(data) == "table" and (data["SilentExecution"] == true or data["SilentExecution"] == 1) then
                    isSilent = true
                end
            end
        end
    end

    if isSilent then
        Library.IsSilent = true
        return
    end
 
    -- ── GUI root ────────────────────────────────────────────
    local LoadGui      = Instance.new("ScreenGui")
    LoadGui.Name       = "HK_PremiumLoader"
    LoadGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    LoadGui.IgnoreGuiInset = true
    if syn and syn.protect_gui then syn.protect_gui(LoadGui)
    elseif protectgui then protectgui(LoadGui) end
    LoadGui.Parent     = CoreGui
 
    -- ── Full-screen backdrop ────────────────────────────────
    local BG = Instance.new("Frame")
    BG.Size               = UDim2.new(1, 0, 1, 0)
    BG.BackgroundColor3   = BgColor
    BG.BackgroundTransparency = 1
    BG.BorderSizePixel    = 0
    BG.ZIndex             = 1
    BG.Parent             = LoadGui
 
    -- ── Scanlines (horizontal) ──────────────────────────────
    local ScanRoot = Instance.new("Frame")
    ScanRoot.Size               = UDim2.new(1, 0, 1, 0)
    ScanRoot.BackgroundTransparency = 1
    ScanRoot.ZIndex             = 2
    ScanRoot.Parent             = BG
 
    for i = 0, 40 do
        local sl = Instance.new("Frame")
        sl.Size             = UDim2.new(1, 0, 0, 1)
        sl.Position         = UDim2.new(0, 0, i / 40, 0)
        sl.BackgroundColor3 = AccentColor
        sl.BackgroundTransparency = 0.93
        sl.BorderSizePixel  = 0
        sl.ZIndex           = 2
        sl.Parent           = ScanRoot
    end
 
    -- ── Drifting particles ──────────────────────────────────
    local ParticleRoot = Instance.new("Frame")
    ParticleRoot.Size               = UDim2.new(1, 0, 1, 0)
    ParticleRoot.BackgroundTransparency = 1
    ParticleRoot.ZIndex             = 2
    ParticleRoot.Parent             = BG
 
    local particles = {}
    for _ = 1, 35 do
        local size = math.random(1, 3)
        local dot  = Instance.new("Frame")
        dot.Size              = UDim2.new(0, size, 0, size)
        dot.Position          = UDim2.new(math.random(), 0, math.random(), 0)
        dot.BackgroundColor3  = AccentColor
        dot.BackgroundTransparency = math.random(5, 9) / 10
        dot.BorderSizePixel   = 0
        dot.ZIndex            = 2
        dot.Parent            = ParticleRoot
        table.insert(particles, {
            frame  = dot,
            speedY = -(math.random() * 0.0004 + 0.0001),
            speedX = (math.random() - 0.5) * 0.00015,
        })
    end
 
    -- ── Card ────────────────────────────────────────────────
    local hasIcon = Icon ~= nil
    local cardH   = hasIcon and 270 or 240
    local cardW   = 430
 
    local Card = Instance.new("Frame")
    Card.Size               = UDim2.new(0, cardW, 0, cardH)
    Card.Position           = UDim2.new(0.5, -cardW / 2, 0.5, -cardH / 2)
    Card.BackgroundColor3   = BgColor
    Card.BackgroundTransparency = 1
    Card.BorderSizePixel    = 0
    Card.ZIndex             = 10
    Card.Parent             = BG
 
    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color       = AccentColor
    CardStroke.Thickness   = 1
    CardStroke.Transparency = 1
    CardStroke.Parent      = Card
 
    -- Animated corner L-brackets
    local cornerElems = {}
    local function MakeCorner(ax, ay)
        local g = Instance.new("Frame")
        g.Size          = UDim2.new(0, 20, 0, 20)
        g.AnchorPoint   = Vector2.new(ax, ay)
        g.Position      = UDim2.new(ax, ax == 0 and -1 or 1, ay, ay == 0 and -1 or 1)
        g.BackgroundTransparency = 1
        g.ZIndex        = 12
        g.Parent        = Card
 
        local hz = Instance.new("Frame")
        hz.Size             = UDim2.new(1, 0, 0, 2)
        hz.Position         = ay == 0 and UDim2.new(0,0,0,0) or UDim2.new(0,0,1,-2)
        hz.BackgroundColor3 = AccentColor
        hz.BackgroundTransparency = 1
        hz.BorderSizePixel  = 0
        hz.ZIndex           = 12
        hz.Parent           = g
 
        local vt = Instance.new("Frame")
        vt.Size             = UDim2.new(0, 2, 1, 0)
        vt.Position         = ax == 0 and UDim2.new(0,0,0,0) or UDim2.new(1,-2,0,0)
        vt.BackgroundColor3 = AccentColor
        vt.BackgroundTransparency = 1
        vt.BorderSizePixel  = 0
        vt.ZIndex           = 12
        vt.Parent           = g
 
        table.insert(cornerElems, {hz = hz, vt = vt})
    end
    MakeCorner(0, 0); MakeCorner(1, 0); MakeCorner(0, 1); MakeCorner(1, 1)
 
    -- Header bar
    local HeaderBar = Instance.new("Frame")
    HeaderBar.Size             = UDim2.new(1, 0, 0, 28)
    HeaderBar.BackgroundColor3 = AccentColor
    HeaderBar.BackgroundTransparency = 0.82
    HeaderBar.BorderSizePixel  = 0
    HeaderBar.ZIndex           = 11
    HeaderBar.Parent           = Card
 
    local HeaderTxt = Instance.new("TextLabel")
    HeaderTxt.Size               = UDim2.new(1, -12, 1, 0)
    HeaderTxt.Position           = UDim2.new(0, 8, 0, 0)
    HeaderTxt.BackgroundTransparency = 1
    HeaderTxt.Text               = ">> TERMINAL  //  INITIALIZING"
    HeaderTxt.TextColor3         = AccentColor
    HeaderTxt.Font               = Enum.Font.Code
    HeaderTxt.TextSize           = 11
    HeaderTxt.TextXAlignment     = Enum.TextXAlignment.Left
    HeaderTxt.TextTransparency   = 1
    HeaderTxt.ZIndex             = 12
    HeaderTxt.Parent             = HeaderBar
 
    local CursorDot = Instance.new("TextLabel")
    CursorDot.Size               = UDim2.new(0, 24, 1, 0)
    CursorDot.Position           = UDim2.new(1, -28, 0, 0)
    CursorDot.BackgroundTransparency = 1
    CursorDot.Text               = "●"
    CursorDot.TextColor3         = AccentColor
    CursorDot.Font               = Enum.Font.Code
    CursorDot.TextSize           = 9
    CursorDot.TextTransparency   = 1
    CursorDot.ZIndex             = 12
    CursorDot.Parent             = HeaderBar
 
    -- Content area
    local yOff = 36
    local Content = Instance.new("Frame")
    Content.Size               = UDim2.new(1, -28, 1, -(yOff + 8))
    Content.Position           = UDim2.new(0, 14, 0, yOff)
    Content.BackgroundTransparency = 1
    Content.ZIndex             = 11
    Content.Parent             = Card
 
    -- Optional icon
    if hasIcon then
        local IconImg = Instance.new("ImageLabel")
        IconImg.Size              = UDim2.new(0, 42, 0, 42)
        IconImg.Position          = UDim2.new(0.5, -21, 0, 0)
        IconImg.BackgroundTransparency = 1
        IconImg.Image             = type(Icon) == "number"
            and "rbxassetid://" .. tostring(Icon) or Icon
        IconImg.ImageColor3       = AccentColor
        IconImg.ImageTransparency = 1
        IconImg.ZIndex            = 13
        IconImg.Parent            = Content
        yOff = 52
 
        TweenService:Create(IconImg,
            TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {ImageTransparency = 0}):Play()
    end
 
    -- Title label (glitch-typewriter reveal)
    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size               = UDim2.new(1, 0, 0, 34)
    TitleLbl.Position           = UDim2.new(0, 0, 0, hasIcon and 50 or 4)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text               = ""
    TitleLbl.TextColor3         = Color3.new(1, 1, 1)
    TitleLbl.Font               = Enum.Font.GothamBold
    TitleLbl.TextSize           = 24
    TitleLbl.ZIndex             = 12
    TitleLbl.Parent             = Content
 
    -- Subtitle
    local SubLbl = Instance.new("TextLabel")
    SubLbl.Size               = UDim2.new(1, 0, 0, 18)
    SubLbl.Position           = UDim2.new(0, 0, 0, hasIcon and 86 or 40)
    SubLbl.BackgroundTransparency = 1
    SubLbl.Text               = SubTitle
    SubLbl.TextColor3         = AccentColor
    SubLbl.Font               = Enum.Font.Code
    SubLbl.TextSize           = 12
    SubLbl.TextTransparency   = 1
    SubLbl.ZIndex             = 12
    SubLbl.Parent             = Content
 
    local bodyBaseY = hasIcon and 110 or 64
 
    -- Expanding divider
    local Divider = Instance.new("Frame")
    Divider.Size             = UDim2.new(0, 0, 0, 1)
    Divider.Position         = UDim2.new(0, 0, 0, bodyBaseY)
    Divider.BackgroundColor3 = AccentColor
    Divider.BackgroundTransparency = 0.55
    Divider.BorderSizePixel  = 0
    Divider.ZIndex           = 12
    Divider.Parent           = Content
 
    -- Segment bar
    local SEG_COUNT = 22
    local SegContainer = Instance.new("Frame")
    SegContainer.Size               = UDim2.new(1, 0, 0, 8)
    SegContainer.Position           = UDim2.new(0, 0, 0, bodyBaseY + 12)
    SegContainer.BackgroundTransparency = 1
    SegContainer.ZIndex             = 12
    SegContainer.Parent             = Content
 
    local segments = {}
    for i = 1, SEG_COUNT do
        local seg = Instance.new("Frame")
        seg.Size             = UDim2.new(1 / SEG_COUNT, -2, 1, 0)
        seg.Position         = UDim2.new((i - 1) / SEG_COUNT, 1, 0, 0)
        seg.BackgroundColor3 = AccentColor
        seg.BackgroundTransparency = 0.86
        seg.BorderSizePixel  = 0
        seg.ZIndex           = 13
        seg.Parent           = SegContainer
        table.insert(segments, seg)
    end
 
    -- Percent label
    local PctLbl = Instance.new("TextLabel")
    PctLbl.Size               = UDim2.new(1, 0, 0, 16)
    PctLbl.Position           = UDim2.new(0, 0, 0, bodyBaseY + 24)
    PctLbl.BackgroundTransparency = 1
    PctLbl.Text               = "[ 0% ]"
    PctLbl.TextColor3         = AccentColor
    PctLbl.Font               = Enum.Font.Code
    PctLbl.TextSize           = 11
    PctLbl.TextXAlignment     = Enum.TextXAlignment.Right
    PctLbl.TextTransparency   = 1
    PctLbl.ZIndex             = 12
    PctLbl.Parent             = Content
 
    -- Status label
    local StatusLbl = Instance.new("TextLabel")
    StatusLbl.Size               = UDim2.new(1, -60, 0, 16)
    StatusLbl.Position           = UDim2.new(0, 0, 0, bodyBaseY + 24)
    StatusLbl.BackgroundTransparency = 1
    StatusLbl.Text               = "> " .. (Statuses[1] or "")
    StatusLbl.TextColor3         = Color3.fromRGB(140, 210, 170)
    StatusLbl.Font               = Enum.Font.Code
    StatusLbl.TextSize           = 11
    StatusLbl.TextXAlignment     = Enum.TextXAlignment.Left
    StatusLbl.TextTransparency   = 1
    StatusLbl.ZIndex             = 12
    StatusLbl.Parent             = Content
 
    -- ── Animate in ──────────────────────────────────────────
    local animating = true
 
    local inInfo = TweenInfo.new(0.9, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(BG,       inInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(Card,     inInfo, {BackgroundTransparency = 0.05}):Play()
    TweenService:Create(CardStroke, inInfo, {Transparency = 0.5}):Play()
 
    for _, ce in cornerElems do
        TweenService:Create(ce.hz, inInfo, {BackgroundTransparency = 0}):Play()
        TweenService:Create(ce.vt, inInfo, {BackgroundTransparency = 0}):Play()
    end
 
    task.wait(0.35)
    TweenService:Create(HeaderTxt, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(CursorDot, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(SubLbl,    TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    TweenService:Create(Divider,   TweenInfo.new(0.6, Enum.EasingStyle.Quart),
        {Size = UDim2.new(1, 0, 0, 1)}):Play()
    TweenService:Create(StatusLbl, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(PctLbl,    TweenInfo.new(0.3), {TextTransparency = 0}):Play()
 
    -- Glitch-typewriter title reveal
    task.spawn(function()
        local glyphPool = {"0","1","X","#","@","Z","!","▓","▒","░","█","◆"}
        task.wait(0.4)
        for i = 1, #Title do
            for _ = 1, 3 do
                TitleLbl.Text = string.sub(Title, 1, i - 1)
                    .. glyphPool[math.random(1, #glyphPool)]
                task.wait(0.03)
            end
            TitleLbl.Text = string.sub(Title, 1, i)
            task.wait(0.05)
        end
    end)
 
    -- Cursor blink loop
    task.spawn(function()
        while animating do
            task.wait(0.5)
            if animating then
                TweenService:Create(CursorDot, TweenInfo.new(0.1), {TextTransparency = 0.9}):Play()
                task.wait(0.5)
                if animating then
                    TweenService:Create(CursorDot, TweenInfo.new(0.1), {TextTransparency = 0}):Play()
                end
            end
        end
    end)
 
    -- Particle drift loop
    task.spawn(function()
        while animating do
            for _, p in particles do
                local pos = p.frame.Position
                local nx = pos.X.Scale + p.speedX
                local ny = pos.Y.Scale + p.speedY
                if ny < -0.02 then ny = 1.02; nx = math.random() end
                if nx < 0 then nx = 1 elseif nx > 1 then nx = 0 end
                p.frame.Position = UDim2.new(nx, 0, ny, 0)
            end
            task.wait()
        end
    end)
 
    -- Progress & status update loop
    local startTime    = os.clock()
    local statusIndex  = 1
    task.spawn(function()
        while os.clock() - startTime < Duration do
            local elapsed  = os.clock() - startTime
            local progress = math.clamp(elapsed / Duration, 0, 1)
            local filled   = math.floor(progress * SEG_COUNT)
 
            for i, seg in segments do
                seg.BackgroundTransparency = i <= filled and 0 or 0.86
            end
            PctLbl.Text = string.format("[ %d%% ]", math.floor(progress * 100))
 
            local expected = math.clamp(math.floor(progress * #Statuses) + 1, 1, #Statuses)
            if expected > statusIndex then
                statusIndex = expected
                local fullTxt = "> " .. Statuses[statusIndex]
                task.spawn(function()
                    TweenService:Create(StatusLbl, TweenInfo.new(0.12), {TextTransparency = 0.85}):Play()
                    task.wait(0.14)
                    StatusLbl.Text = "> ▌"
                    TweenService:Create(StatusLbl, TweenInfo.new(0.1), {TextTransparency = 0}):Play()
                    task.wait(0.1)
                    for k = 3, #fullTxt do
                        StatusLbl.Text = string.sub(fullTxt, 1, k) .. (k < #fullTxt and "▌" or "")
                        task.wait(0.018)
                    end
                    StatusLbl.Text = fullTxt
                end)
            end
 
            task.wait()
        end
        for _, seg in segments do seg.BackgroundTransparency = 0 end
        PctLbl.Text = "[ 100% ]"
    end)
 
    task.wait(Duration)
    animating = false
 
    -- ── Completion sequence ──────────────────────────────────
    StatusLbl.Text      = "> INITIALIZATION COMPLETE"
    StatusLbl.TextColor3 = AccentColor
 
    -- Cascade-fill segments white → accent
    for i, seg in segments do
        task.delay((i - 1) * 0.025, function()
            seg.BackgroundColor3    = Color3.new(1, 1, 1)
            seg.BackgroundTransparency = 0
            task.delay(0.18, function()
                TweenService:Create(seg, TweenInfo.new(0.35),
                    {BackgroundColor3 = AccentColor}):Play()
            end)
        end)
    end
    task.wait(0.7)
 
    -- Collapse card and fade out
    local outInfo = TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    TweenService:Create(Card,       outInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(CardStroke, outInfo, {Transparency = 1}):Play()
    TweenService:Create(BG,         outInfo, {BackgroundTransparency = 1}):Play()
    for _, ce in cornerElems do
        TweenService:Create(ce.hz, outInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(ce.vt, outInfo, {BackgroundTransparency = 1}):Play()
    end
    for _, desc in Card:GetDescendants() do
        if desc:IsA("TextLabel") then
            TweenService:Create(desc, outInfo, {TextTransparency = 1}):Play()
        elseif desc:IsA("ImageLabel") then
            TweenService:Create(desc, outInfo, {ImageTransparency = 1}):Play()
        elseif desc:IsA("Frame") then
            TweenService:Create(desc, outInfo, {BackgroundTransparency = 1}):Play()
        end
    end
 
    task.wait(0.6)
    LoadGui:Destroy()
end

return Library