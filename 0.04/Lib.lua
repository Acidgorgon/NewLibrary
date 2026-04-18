local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Executor function fallbacks
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

local Library = {}
Library.__index = Library

if not getgenv()._Heartkiss_Garbage then
    getgenv()._Heartkiss_Garbage = {}
end

local function CleanID(id: string)
    if not getgenv()._Heartkiss_Garbage[id] then return end
    for _, item in ipairs(getgenv()._Heartkiss_Garbage[id]) do
        if typeof(item) == "RBXScriptConnection" then item:Disconnect()
        elseif typeof(item) == "Instance" then item:Destroy()
        elseif type(item) == "function" then task.spawn(item)
        elseif type(item) == "thread" then task.cancel(item) end
    end
    getgenv()._Heartkiss_Garbage[id] = nil
end

local THEMES = {
    MainColor        = Color3.fromRGB(30, 30, 30),
    FrameColor       = Color3.fromRGB(25, 25, 25),
    TabColor         = Color3.fromRGB(24, 24, 24),
    LineColor        = Color3.fromRGB(255, 255, 255),
    BorderColor      = Color3.fromRGB(70, 70, 70),
    DarkColor        = Color3.fromRGB(0, 0, 0),
    SelectedTab      = Color3.fromRGB(207, 207, 207),
    TextColor        = Color3.fromRGB(255, 255, 255),
    ButtonBorderColor= Color3.fromRGB(27, 27, 27),
    SubTextColor     = Color3.fromRGB(160, 160, 160),
    SuccessColor     = Color3.fromRGB(80, 220, 120),
    WarningColor     = Color3.fromRGB(255, 190, 50),
    ErrorColor       = Color3.fromRGB(255, 80, 80),
    InfoColor        = Color3.fromRGB(80, 140, 255),
    TextSize         = 13,
    BaseHeight       = 22,
}

local ThemeEvent = Instance.new("BindableEvent")

local function CreateGradient(Parent: any, Rotation)
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.19, Color3.fromRGB(203, 203, 203)),
        ColorSequenceKeypoint.new(0.52, Color3.fromRGB(175, 175, 175)),
        ColorSequenceKeypoint.new(0.84, Color3.fromRGB(197, 197, 197)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))
    }
    UIGradient.Rotation = Rotation or 90
    UIGradient.Parent = Parent
end

local function RoundCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(radius or 0, radius and 0 or 4)
    c.Parent = parent
    return c
end

local function ProtectGui(gui)
    if syn and syn.protect_gui then syn.protect_gui(gui)
    elseif protectgui then protectgui(gui) end
end

function Library:Notify(title: string, text: string, duration: number)
    duration = duration or 3
    if not self.NotifyLayout then return end

    local Holder = Instance.new("Frame")
    Holder.BackgroundTransparency = 1
    Holder.Size = UDim2.new(1, 0, 0, 60)
    Holder.Parent = self.NotifyLayout

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
        local tweenOut = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        TweenService:Create(Notif, tweenOut, {Position = UDim2.new(1, 30, 0, 0), BackgroundTransparency = 1}):Play()
        TweenService:Create(Title, tweenOut, {TextTransparency = 1}):Play()
        TweenService:Create(Desc, tweenOut, {TextTransparency = 1}):Play()
        task.delay(0.4, function() Holder:Destroy() end)
    end)
end

function Library:SetTheme(overrides: table)
    for k, v in pairs(overrides) do
        if THEMES[k] ~= nil then THEMES[k] = v end
    end
    ThemeEvent:Fire() 
end

function Library:GetFlag(flag: string) return self.Flags and self.Flags[flag] end

function Library:IgnoreFlag(flag: string)
    if self.IgnoredFlags then
        self.IgnoredFlags[flag] = true
    end
end

function Library:AddTooltip(element: GuiObject, tipText: string)
    local garbage = getgenv()._Heartkiss_Garbage[self.Name]
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

function Library.new(Name: string, Size: UDim2, KeyBind: Enum.UserInputType | Enum.KeyCode)
    local self = setmetatable({}, Library)
    local WindowRoot = self

    function self:Connect(signal, callback)
        local connection = signal:Connect(callback)
        table.insert(getgenv()._Heartkiss_Garbage[self.Name], connection)
        return connection
    end

    function self:Theme(instance, prop, key)
        instance[prop] = THEMES[key]
        self:Connect(ThemeEvent.Event, function()
            if instance.Parent then
                TweenService:Create(instance, TweenInfo.new(0.2), {[prop] = THEMES[key]}):Play()
            end
        end)
    end

    local function CreateButton()
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight)
        
        WindowRoot:Theme(Btn, "BackgroundColor3", "FrameColor")
        WindowRoot:Theme(Btn, "BorderColor3", "ButtonBorderColor")
        WindowRoot:Theme(Btn, "TextColor3", "TextColor")
        
        Btn.Font = Enum.Font.Code
        Btn.TextSize = THEMES.TextSize
        CreateGradient(Btn)
        return Btn
    end

    self.Name         = Name or "Heartkiss"
    self.Size         = Size or UDim2.fromOffset(520, 560)
    self.Tabs         = {}
    self.KeyBind      = KeyBind or Enum.KeyCode.RightControl
    self.Flags        = {}
    self.Setters      = {}
    self.SearchData   = {} 
    self.IgnoredFlags = {}
    self.BoundElements= {} 
    self.ConfigFolder = self.Name .. "_Configs"
    
    if not isfolder(self.ConfigFolder) then makefolder(self.ConfigFolder) end

    CleanID(self.Name)
    getgenv()._Heartkiss_Garbage[self.Name] = {}
    local garbage = getgenv()._Heartkiss_Garbage[self.Name]

    -- CORE GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = self.Name
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
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
    WindowRoot:Theme(MainFrame, "BorderColor3", "LineColor")
    MainFrame.Position = UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2)
    MainFrame.Size = self.Size
    MainFrame.ClipsDescendants = true
    MainFrame.ZIndex = 1
    MainFrame.Parent = ScreenGui
    CreateGradient(MainFrame)

    local DragFrame = Instance.new("TextButton")
    DragFrame.Size = UDim2.new(1, -150, 0, 30)
    DragFrame.BackgroundTransparency = 1
    DragFrame.Text = ""
    DragFrame.ZIndex = 5
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
    self:Connect(RunService.RenderStepped, function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -10, 0, 30)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Name
    WindowRoot:Theme(Title, "TextColor3", "TextColor")
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = THEMES.TextSize + 2
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 5
    Title.Parent = MainFrame

    local EXPANDED_HEIGHT = self.Size.Y.Offset
    local minimized = false

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 20, 0, 20)
    MinBtn.Position = UDim2.new(1, -26, 0, 5)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "−"
    WindowRoot:Theme(MinBtn, "TextColor3", "LineColor")
    MinBtn.Font = Enum.Font.Code
    MinBtn.TextSize = 18
    MinBtn.ZIndex = 5
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
    Line.Size = UDim2.new(1, 0, 0, 1)
    Line.Position = UDim2.new(0, 0, 0, 30)
    WindowRoot:Theme(Line, "BackgroundColor3", "LineColor")
    Line.BorderSizePixel = 0
    Line.ZIndex = 2
    Line.Parent = MainFrame

    local InnerBg = Instance.new("Frame")
    InnerBg.Size = UDim2.new(1, -16, 1, -46)
    InnerBg.Position = UDim2.new(0, 8, 0, 38)
    WindowRoot:Theme(InnerBg, "BackgroundColor3", "FrameColor")
    WindowRoot:Theme(InnerBg, "BorderColor3", "BorderColor")
    InnerBg.ZIndex = 0
    InnerBg.Parent = MainFrame
    CreateGradient(InnerBg)

    local Tabs = Instance.new("Frame")
    Tabs.Size = UDim2.new(1, -170, 0, 28) 
    Tabs.Position = UDim2.new(0, 12, 0, 42)
    WindowRoot:Theme(Tabs, "BackgroundColor3", "TabColor")
    WindowRoot:Theme(Tabs, "BorderColor3", "BorderColor")
    Tabs.ZIndex = 2
    Tabs.Parent = MainFrame

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Active = true
    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.Always
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
    ScrollingFrame.ScrollBarThickness = 0
    ScrollingFrame.ZIndex = 3
    ScrollingFrame.Parent = Tabs

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.FillDirection = Enum.FillDirection.Horizontal
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Parent = ScrollingFrame

    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(0, 146, 0, 28)
    SearchBox.Position = UDim2.new(1, -158, 0, 42)
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
        local q = SearchBox.Text:lower()
        for _, sectionData in ipairs(WindowRoot.SearchData) do
            local hasVisibleElement = false
            for _, item in ipairs(sectionData.Elements) do
                local match = (q == "") or item.SearchText:find(q, 1, true)
                item.Element.Visible = match
                if match then hasVisibleElement = true end
            end
            sectionData.Section.Visible = hasVisibleElement
        end
    end)

    local FrameHolder = Instance.new("Frame")
    FrameHolder.Size = UDim2.new(1, -24, 1, -84)
    FrameHolder.Position = UDim2.new(0, 12, 0, 74)
    WindowRoot:Theme(FrameHolder, "BackgroundColor3", "TabColor")
    WindowRoot:Theme(FrameHolder, "BorderColor3", "BorderColor")
    FrameHolder.ZIndex = 2
    FrameHolder.Parent = MainFrame
    CreateGradient(FrameHolder)

    self.Frames = {
        MainFrame   = MainFrame,
        Tabs        = Tabs,
        FrameHolder = FrameHolder
    }

    self:Connect(MinBtn.MouseButton1Click, function()
        minimized = not minimized
        InnerBg.Visible = not minimized
        Tabs.Visible = not minimized
        FrameHolder.Visible = not minimized
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, self.Size.X.Offset, 0, minimized and 32 or EXPANDED_HEIGHT)}):Play()
        MinBtn.Text = minimized and "+" or "−"
    end)
    
    self:Connect(UserInputService.InputBegan, function(Input, GPE)
        if GPE then return end
        if Input.KeyCode == self.KeyBind or Input.UserInputType == self.KeyBind then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    -- WATERMARK
    local WatermarkGui = Instance.new("ScreenGui")
    WatermarkGui.Name = "Heartkiss_Watermark"
    WatermarkGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    WatermarkGui.Enabled = true
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
    RoundCorner(WMMain, 2)

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

    -- ACTIVE KEYBINDS
    local KeybindGui = Instance.new("ScreenGui")
    KeybindGui.Name = "Heartkiss_Keybinds"
    KeybindGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    KeybindGui.Enabled = true
    ProtectGui(KeybindGui)
    KeybindGui.Parent = CoreGui
    table.insert(garbage, KeybindGui)
    self.KeybindGui = KeybindGui

    local KBMain = Instance.new("Frame")
    KBMain.Size = UDim2.new(0, 180, 0, 30)
    KBMain.Position = UDim2.new(1, -200, 0.5, -100)
    WindowRoot:Theme(KBMain, "BackgroundColor3", "MainColor")
    WindowRoot:Theme(KBMain, "BorderColor3", "LineColor")
    KBMain.Parent = KeybindGui
    CreateGradient(KBMain)

    local KBTitle = Instance.new("TextLabel")
    KBTitle.Size = UDim2.new(1, 0, 0, 24)
    KBTitle.Text = " Active Keybinds "
    WindowRoot:Theme(KBTitle, "TextColor3", "TextColor")
    KBTitle.BackgroundTransparency = 1
    KBTitle.Font = Enum.Font.SourceSansBold
    KBTitle.TextSize = THEMES.TextSize + 1
    KBTitle.Parent = KBMain

    local KBContainer = Instance.new("Frame")
    KBContainer.Size = UDim2.new(1, -10, 1, -30)
    KBContainer.Position = UDim2.new(0, 5, 0, 26)
    KBContainer.BackgroundTransparency = 1
    KBContainer.Parent = KBMain

    local KBList = Instance.new("UIListLayout")
    KBList.Padding = UDim.new(0, 4)
    KBList.Parent = KBContainer

    self:Connect(KBList:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        TweenService:Create(KBMain, TweenInfo.new(0.2), {Size = UDim2.new(0, 180, 0, KBList.AbsoluteContentSize.Y + 35)}):Play()
    end)

    local kbDragging, kbDragInput, kbDragStart, kbStartPos
    self:Connect(KBMain.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            kbDragging = true; kbDragStart = input.Position; kbStartPos = KBMain.Position
        end
    end)
    self:Connect(KBMain.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then kbDragging = false end
    end)
    self:Connect(UserInputService.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then kbDragInput = input end
    end)
    self:Connect(RunService.RenderStepped, function()
        if kbDragging and kbDragInput then
            local delta = kbDragInput.Position - kbDragStart
            KBMain.Position = UDim2.new(kbStartPos.X.Scale, kbStartPos.X.Offset + delta.X, kbStartPos.Y.Scale, kbStartPos.Y.Offset + delta.Y)
        end
    end)

    function self:UpdateKeybinds()
        for _, child in ipairs(KBContainer:GetChildren()) do if child:IsA("TextLabel") then child:Destroy() end end
        for name, state in pairs(self.BoundElements) do
            if state == true then
                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, 0, 0, 18)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = "[+] " .. name
                WindowRoot:Theme(Lbl, "TextColor3", "SubTextColor")
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = THEMES.TextSize - 1
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = KBContainer
            end
        end
    end

    self:Connect(ThemeEvent.Event, function()
        self:UpdateKeybinds()
    end)

    function self:Tab(text: string)
        local Tab = Instance.new("TextButton")
        Tab.Name = text
        WindowRoot:Theme(Tab, "BorderColor3", "BorderColor")
        WindowRoot:Theme(Tab, "TextColor3", "TextColor")
        WindowRoot:Theme(Tab, "BackgroundColor3", "TabColor")
        Tab.Size = UDim2.new(0, 60, 0.5, 0)
        Tab.Font = Enum.Font.Code
        Tab.Text = " " .. text .. " "
        Tab.TextScaled = false
        Tab.TextSize = THEMES.TextSize + 1
        Tab.ZIndex = 3
        Tab.Parent = ScrollingFrame
        CreateGradient(Tab, -90)

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, -8, 1, -8)
        Page.Position = UDim2.new(0, 4, 0, 4)
        WindowRoot:Theme(Page, "BackgroundColor3", "FrameColor")
        WindowRoot:Theme(Page, "BorderColor3", "BorderColor")
        Page.ScrollBarThickness = 0
        Page.ScrollingDirection = Enum.ScrollingDirection.Y
        Page.Visible = false
        Page.ZIndex = 3
        Page.Parent = FrameHolder
        CreateGradient(Page)

        WindowRoot:Connect(ThemeEvent.Event, function()
            TweenService:Create(Tab, TweenInfo.new(0.2), {BackgroundColor3 = Page.Visible and THEMES.SelectedTab or THEMES.TabColor}):Play()
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
            for _, tab in self.Tabs do
                tab.Page.Visible = false
                tab.Button.BackgroundColor3 = THEMES.TabColor
            end
            Page.Visible = true
            Tab.BackgroundColor3 = THEMES.SelectedTab
        end)

        if #self.Tabs == 0 then
            Page.Visible = true
            Tab.BackgroundColor3 = THEMES.SelectedTab
        end
        table.insert(self.Tabs, {Button = Tab, Page = Page})

        local TabFunctions = {}
        local SectionCount = 0

        function TabFunctions:Section(title: string)
            SectionCount = SectionCount + 1
            local ParentFrame = (SectionCount % 2 == 1) and LeftColumn or RightColumn

            local Section = Instance.new("Frame")
            Section.Name = title
            Section.Size = UDim2.new(1, 0, 0, 100)
            WindowRoot:Theme(Section, "BackgroundColor3", "MainColor")
            WindowRoot:Theme(Section, "BorderColor3", "BorderColor")
            Section.BackgroundTransparency = 0.4
            Section.BorderMode = Enum.BorderMode.Inset
            Section.ZIndex = 3
            Section.Parent = ParentFrame
            CreateGradient(Section)

            local Label = Instance.new("TextLabel")
            Label.Text = " " .. title .. " "
            WindowRoot:Theme(Label, "TextColor3", "TextColor")
            WindowRoot:Theme(Label, "BackgroundColor3", "FrameColor")
            Label.BorderSizePixel = 0
            Label.Position = UDim2.new(0, 10, 0, -10)
            Label.AutomaticSize = Enum.AutomaticSize.XY
            Label.Font = Enum.Font.Code
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

            local SectionFunctions = {}
            local ElementCount = 0

            local function RegisterSearch(elem: Instance, searchText: string)
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
                WindowRoot:Connect(Btn.MouseButton1Click, callback)
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
                Btn1.ZIndex = 4
                Btn1.Parent = RowFrame

                local Btn2 = CreateButton()
                Btn2.Size = UDim2.new(0.5, -3, 1, 0)
                Btn2.Position = UDim2.new(0.5, 3, 0, 0)
                Btn2.Text = text2
                Btn2.ZIndex = 4
                Btn2.Parent = RowFrame

                WindowRoot:Connect(Btn1.MouseButton1Click, callback1)
                WindowRoot:Connect(Btn2.MouseButton1Click, callback2)
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

                local boxSize = THEMES.BaseHeight - 6
                local CheckMark = Instance.new("Frame")
                CheckMark.Size = UDim2.new(0, boxSize, 0, boxSize)
                CheckMark.Position = UDim2.new(0, 0, 0.5, -(boxSize/2))
                CheckMark.BackgroundColor3 = enabled and THEMES.LineColor or THEMES.FrameColor
                CheckMark.BorderColor3 = THEMES.BorderColor
                CheckMark.ZIndex = 4
                CheckMark.Parent = ToggleBtn
                CreateGradient(CheckMark)

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
                        BackgroundColor3 = enabled and THEMES.LineColor or THEMES.FrameColor,
                        BorderColor3 = THEMES.BorderColor
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

                local boxSize = THEMES.BaseHeight - 6
                local CheckMark = Instance.new("Frame")
                CheckMark.Size = UDim2.new(0, boxSize, 0, boxSize)
                CheckMark.Position = UDim2.new(0, 0, 0.5, -(boxSize/2))
                CheckMark.BackgroundColor3 = enabled and THEMES.LineColor or THEMES.FrameColor
                CheckMark.BorderColor3 = THEMES.BorderColor
                CheckMark.ZIndex = 4
                CheckMark.Parent = ToggleBtn
                CreateGradient(CheckMark)

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
                        BackgroundColor3 = enabled and THEMES.LineColor or THEMES.FrameColor,
                        BorderColor3 = THEMES.BorderColor
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

                local dragging = false

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
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; Update(i) end
                end)
                WindowRoot:Connect(UserInputService.InputEnded, function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                WindowRoot:Connect(UserInputService.InputChanged, function(i)
                    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then Update(i) end
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
                MinusBtn.Text = "−"
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
                    Icon.Text = isDropped and "−" or "+"
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
                    for _, btn in ipairs(OptionContainer:GetChildren()) do
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
                    Icon.Text = isDropped and "−" or "+"
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
                    for _, btn in ipairs(OptionContainer:GetChildren()) do
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
                
                -- Create a standard searchable dropdown first (starts empty)
                local DropdownObj = SectionFunctions:SearchableDropdown(text, {}, "", flag, callback)
                
                local function UpdatePlayerList()
                    local list = {}
                    for _, p in ipairs(Players:GetPlayers()) do
                        if includeSelf or p ~= Players.LocalPlayer then
                            table.insert(list, p.Name)
                        end
                    end
                    table.sort(list)
                    DropdownObj:Refresh(list)
                end

                -- Populate initially
                UpdatePlayerList()

                -- Automatically refresh when players join or leave
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

                for i, opt in ipairs(options) do
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
                        for k, dot in pairs(dots) do
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
                        for k, dot in pairs(dots) do
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
                    for opt, dot in pairs(dots) do
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

                local SatGradient = Instance.new("UIGradient")
                SatGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}
                SatGradient.Parent = SVBox

                local ValOverlay = Instance.new("Frame")
                ValOverlay.Size = UDim2.new(1, 0, 1, 0)
                ValOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
                ValOverlay.BorderSizePixel = 0
                ValOverlay.ZIndex = 5
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
                SVCursor.ZIndex = 6
                SVCursor.Position = UDim2.new(1 - s, -2, 1 - v, -2)
                SVCursor.Parent = SVBox

                local HueBar = Instance.new("TextButton")
                HueBar.Size = UDim2.new(0, 15, 0, 130)
                HueBar.Position = UDim2.new(0, 150, 0, 10)
                HueBar.BorderColor3 = THEMES.BorderColor
                HueBar.Text = ""
                HueBar.AutoButtonColor = false
                HueBar.ZIndex = 5
                HueBar.Parent = Body

                local HueGradient = Instance.new("UIGradient")
                HueGradient.Rotation = 90
                HueGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0.00, Color3.fromHSV(1, 1, 1)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.83, 1, 1)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.66, 1, 1)),
                    ColorSequenceKeypoint.new(0.50, Color3.fromHSV(0.5, 1, 1)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.33, 1, 1)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.16, 1, 1)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromHSV(0, 1, 1))
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

                if flag then
                    WindowRoot.Setters[flag] = function(colorData)
                        if type(colorData) == "table" then
                            local newC = Color3.new(colorData.R, colorData.G, colorData.B)
                            h, s, v = Color3.toHSV(newC)
                            a = colorData.A
                            SVCursor.Position = UDim2.new(1 - s, -2, 1 - v, -2)
                            UpdateColor()
                        end
                    end
                end

                local draggingSV, draggingHue, draggingAlpha = false, false, false

                WindowRoot:Connect(SVBox.InputBegan, function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingSV = true end end)
                WindowRoot:Connect(HueBar.InputBegan, function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingHue = true end end)
                WindowRoot:Connect(AlphaBar.InputBegan, function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingAlpha = true end end)

                WindowRoot:Connect(UserInputService.InputChanged, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        if draggingSV then
                            s = 1 - math.clamp((input.Position.X - SVBox.AbsolutePosition.X) / SVBox.AbsoluteSize.X, 0, 1)
                            v = 1 - math.clamp((input.Position.Y - SVBox.AbsolutePosition.Y) / SVBox.AbsoluteSize.Y, 0, 1)
                            SVCursor.Position = UDim2.new(1 - s, -2, 1 - v, -2)
                            UpdateColor()
                        elseif draggingHue then
                            h = 1 - math.clamp((input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
                            UpdateColor()
                        elseif draggingAlpha then
                            a = 1 - math.clamp((input.Position.Y - AlphaBar.AbsolutePosition.Y) / AlphaBar.AbsoluteSize.Y, 0, 1)
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
                Lbl.Size = UDim2.new(1, 0, 0, THEMES.BaseHeight)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = THEMES.TextColor
                Lbl.TextXAlignment = Enum.TextXAlignment.Center
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = THEMES.TextSize
                Lbl.LayoutOrder = ElementCount
                Lbl.ZIndex = 4
                Lbl.Parent = Container
                RegisterSearch(Lbl, text)

                WindowRoot:Connect(ThemeEvent.Event, function()
                    TweenService:Create(Lbl, TweenInfo.new(0.2), {TextColor3 = THEMES.TextColor}):Play()
                end)
                return Lbl
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
                return Lbl
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

                for i, row in ipairs(rows) do
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
                    for _, r in ipairs(rowFrames) do
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

                -- Padding for the text inside the box
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

                    -- Auto-scroll to bottom
                    task.defer(function()
                        InnerBox.CanvasPosition = Vector2.new(0, InnerBox.AbsoluteCanvasSize.Y)
                    end)
                end

                function ConsoleObj:Clear()
                    for _, child in ipairs(InnerBox:GetChildren()) do
                        if child:IsA("TextLabel") then child:Destroy() end
                    end
                    lineCount = 0
                end

                RegisterSearch(ConsoleFrame, "Console Log Output")
                return ConsoleObj
            end

            return SectionFunctions
        end

        return TabFunctions
    end

    return self
end

function Library:BuildMacroTab()
    local MacroTab = self:Tab("Macros")
    local RecorderSection = MacroTab:Section("Macro Recorder")

    local isRecording = false
    local isPlaying = false
    local macroEvents = {}
    local lastEventTime = 0
    local playbackConnection = nil

    local StatusLabel = RecorderSection:Label("Status: Idle (0 events)")

    local function RecordEvent(inputType, inputObj)
        if not isRecording then return end
        local currentTime = tick()
        local delay = currentTime - lastEventTime
        lastEventTime = currentTime

        if inputObj.UserInputType == Enum.UserInputType.MouseButton1 then
            table.insert(macroEvents, {Type = inputType, Key = "M1", Delay = delay})
            StatusLabel.Text = "Status: Recording (" .. #macroEvents .. " events)"
        elseif inputObj.UserInputType == Enum.UserInputType.MouseButton2 then
            table.insert(macroEvents, {Type = inputType, Key = "M2", Delay = delay})
            StatusLabel.Text = "Status: Recording (" .. #macroEvents .. " events)"
        elseif inputObj.UserInputType == Enum.UserInputType.Keyboard then
            if inputObj.KeyCode == self.KeyBind then return end
            table.insert(macroEvents, {Type = inputType, Key = inputObj.KeyCode.Value, Delay = delay})
            StatusLabel.Text = "Status: Recording (" .. #macroEvents .. " events)"
        end
    end

    self:Connect(UserInputService.InputBegan, function(input, gpe)
        if gpe then return end
        RecordEvent("Began", input)
    end)

    self:Connect(UserInputService.InputEnded, function(input, gpe)
        if gpe then return end
        RecordEvent("Ended", input)
    end)

    RecorderSection:ToggleBind("Record Macro", false, Enum.KeyCode.F3, nil, nil, function(state)
        if isPlaying then 
            self:Notify("Error", "Cannot record while playing a macro.", 3)
            return false 
        end
        
        isRecording = state
        if isRecording then
            macroEvents = {}
            lastEventTime = tick()
            StatusLabel.Text = "Status: Recording (0 events)"
            StatusLabel.TextColor3 = THEMES.ErrorColor 
        else
            StatusLabel.Text = "Status: Idle (" .. #macroEvents .. " events)"
            StatusLabel.TextColor3 = THEMES.SubTextColor
            self:Notify("Macro Saved", "Recorded " .. #macroEvents .. " inputs.", 3)
        end
    end)

    local LoopMacro = false
    RecorderSection:Toggle("Loop Playback", false, nil, function(state) LoopMacro = state end)

    RecorderSection:ToggleBind("Play Macro", false, Enum.KeyCode.F4, nil, nil, function(state)
        if isRecording then return self:Notify("Error", "Cannot play while recording.", 3) end
        if #macroEvents == 0 then return self:Notify("Error", "No macro recorded yet.", 3) end

        isPlaying = state
        if isPlaying then
            StatusLabel.Text = "Status: Playing..."
            StatusLabel.TextColor3 = THEMES.SuccessColor
            
            playbackConnection = task.spawn(function()
                repeat
                    for _, event in ipairs(macroEvents) do
                        if not isPlaying then break end
                        task.wait(event.Delay)
                        if event.Key == "M1" then
                            if event.Type == "Began" then m1click() end
                        elseif event.Key == "M2" then
                            if event.Type == "Began" then m2click() end
                        else
                            if event.Type == "Began" then kpress(event.Key)
                            elseif event.Type == "Ended" then krelease(event.Key) end
                        end
                    end
                until not LoopMacro or not isPlaying
                
                isPlaying = false
                StatusLabel.Text = "Status: Idle (" .. #macroEvents .. " events)"
                StatusLabel.TextColor3 = THEMES.SubTextColor
            end)
        else
            if playbackConnection then task.cancel(playbackConnection) end
            StatusLabel.Text = "Status: Idle (" .. #macroEvents .. " events)"
            StatusLabel.TextColor3 = THEMES.SubTextColor
            
            for _, event in ipairs(macroEvents) do
                if type(event.Key) == "number" then krelease(event.Key) end
            end
        end
    end)

    RecorderSection:Button("Clear Macro", function()
        if isRecording or isPlaying then return self:Notify("Error", "Stop recording/playing first.", 3) end
        macroEvents = {}
        StatusLabel.Text = "Status: Idle (0 events)"
        self:Notify("Cleared", "Macro memory cleared.", 2)
    end)
end

function Library:BuildSettingsTab()
    local ConfigTab = self:Tab("Settings")
    local SettingsSection = ConfigTab:Section("Configuration")
    local UISetupSection = ConfigTab:Section("UI Elements")

    local ConfigName = ""
    local SelectedConfig = ""
    local AutoloadFile = self.Name .. "_Configs/autoload.txt"

    local function GetConfigs()
        local list = {}
        if isfolder(self.ConfigFolder) then
            for _, file in ipairs(listfiles(self.ConfigFolder)) do
                local name = file:match("([^/\\]+)%.json$")
                if name then table.insert(list, name) end
            end
        end
        return list
    end

    SettingsSection:Input("Config Name", "Enter name to save...", nil, function(txt) ConfigName = txt end)
    local Dropdown = SettingsSection:SearchableDropdown("Select Config", GetConfigs(), "", nil, function(val) SelectedConfig = val end)

    SettingsSection:CreateButtonRow("Save Config", function()
        local name = ConfigName ~= "" and ConfigName or SelectedConfig
        if name == "" then return self:Notify("Error", "Please enter a config name.", 3) end
        
        local dataToSave = {}
        for flag, val in pairs(self.Flags) do
            if not self.IgnoredFlags[flag] then dataToSave[flag] = val end
        end

        local ok, err = pcall(function() writefile(self.ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(dataToSave)) end)
        if ok then
            self:Notify("Saved", "Config '" .. name .. "' saved.", 3)
            Dropdown:Refresh(GetConfigs())
        else
            self:Notify("Error", "Save failed: " .. tostring(err), 5)
        end
    end, "Load Config", function()
        if SelectedConfig == "" then return self:Notify("Error", "Select a config first.", 3) end
        local path = self.ConfigFolder .. "/" .. SelectedConfig .. ".json"
        if not isfile(path) then return self:Notify("Error", "File not found.", 3) end
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
        if ok and type(data) == "table" then
            for flag, value in pairs(data) do 
                if not self.IgnoredFlags[flag] and self.Setters[flag] then self.Setters[flag](value) end 
            end
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
        for flag, val in pairs(self.Flags) do
            if not self.IgnoredFlags[flag] then dataToExport[flag] = val end
        end
        setclipboard(HttpService:JSONEncode(dataToExport))
        self:Notify("Exported", "Config copied to clipboard!", 3)
    end, "Import from Clipboard", function()
        local data = getclipboard()
        local ok, parsed = pcall(function() return HttpService:JSONDecode(data) end)
        if ok and type(parsed) == "table" then
            for flag, value in pairs(parsed) do 
                if not self.IgnoredFlags[flag] and self.Setters[flag] then self.Setters[flag](value) end 
            end
            self:Notify("Imported", "Config loaded from clipboard.", 3)
        else
            self:Notify("Error", "Invalid clipboard data.", 3)
        end
    end)

    SettingsSection:Button("Refresh List", function() Dropdown:Refresh(GetConfigs()); self:Notify("Refreshed", "Config list updated.", 2) end)

    -- PREMIUM UI TOGGLES
    UISetupSection:Toggle("Show Watermark", true, "ShowWatermark", function(state)
        if self.WatermarkGui then self.WatermarkGui.Enabled = state end
    end)
    
    UISetupSection:Toggle("Show Active Keybinds", true, "ShowKeybinds", function(state)
        if self.KeybindGui then self.KeybindGui.Enabled = state end
    end)

    local InfoSection = ConfigTab:Section("About")
    InfoSection:Label("Heartkiss UI Library")
    InfoSection:Separator()
    InfoSection:Label("Press keybind to toggle UI")
    InfoSection:Separator("─────")
    InfoSection:StatusIndicator("Status", "Active", THEMES.SuccessColor)

    -- AUTOLOAD EXECUTION
    if isfile(AutoloadFile) then
        local autoName = readfile(AutoloadFile)
        local path = self.ConfigFolder .. "/" .. autoName .. ".json"
        if isfile(path) then
            local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
            if ok and type(data) == "table" then
                task.delay(0.5, function()
                    for flag, value in pairs(data) do 
                        if not self.IgnoredFlags[flag] and self.Setters[flag] then self.Setters[flag](value) end 
                    end
                    self:Notify("Autoload", "Successfully loaded config: " .. autoName, 3)
                end)
            end
        end
    end
end

return Library