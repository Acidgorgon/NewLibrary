local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local isfolder = isfolder or function() return false end
local makefolder = makefolder or function() end
local writefile = writefile or function() end
local readfile = readfile or function() return "{}" end
local listfiles = listfiles or function() return {} end
local isfile = isfile or function() return false end
local delfile = delfile or function() end

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
}

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

local function CreateButton()
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 15)
    Btn.BackgroundColor3 = THEMES.FrameColor
    Btn.BorderColor3 = THEMES.ButtonBorderColor
    Btn.TextColor3 = THEMES.TextColor
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 12
    CreateGradient(Btn)
    return Btn
end

-- ─────────────────────────────────────────────────────────────────────────────
-- LIBRARY METHODS
-- ─────────────────────────────────────────────────────────────────────────────

function Library:Notify(title: string, text: string, duration: number)
    duration = duration or 3
    if not self.NotifyLayout then return end

    local Holder = Instance.new("Frame")
    Holder.BackgroundTransparency = 1
    Holder.Size = UDim2.new(1, 0, 0, 50)
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
    Title.TextSize = 13
    Title.TextTransparency = 1
    Title.Parent = Notif

    local Desc = Instance.new("TextLabel")
    Desc.Size = UDim2.new(1, -10, 0, 25)
    Desc.Position = UDim2.new(0, 5, 0, 22)
    Desc.BackgroundTransparency = 1
    Desc.Text = text
    Desc.TextColor3 = THEMES.TextColor
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.TextYAlignment = Enum.TextYAlignment.Top
    Desc.TextWrapped = true
    Desc.Font = Enum.Font.Code
    Desc.TextSize = 12
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

-- Apply theme overrides. Affects elements created AFTER this call.
function Library:SetTheme(overrides: table)
    for k, v in pairs(overrides) do
        if THEMES[k] ~= nil then
            THEMES[k] = v
        end
    end
end

-- Convenience getter for a flag value.
function Library:GetFlag(flag: string)
    return self.Flags[flag]
end

-- Attach a hover tooltip to any GuiObject.
function Library:AddTooltip(element: GuiObject, tipText: string)
    local garbage = getgenv()._Heartkiss_Garbage[self.Name]

    local TipFrame = Instance.new("Frame")
    TipFrame.Size = UDim2.new(0, 160, 0, 22)
    TipFrame.BackgroundColor3 = THEMES.MainColor
    TipFrame.BorderColor3 = THEMES.LineColor
    TipFrame.ZIndex = 20
    TipFrame.Visible = false
    TipFrame.Parent = self.Frames.MainFrame

    local TipLbl = Instance.new("TextLabel")
    TipLbl.Size = UDim2.new(1, -8, 1, 0)
    TipLbl.Position = UDim2.new(0, 4, 0, 0)
    TipLbl.BackgroundTransparency = 1
    TipLbl.Text = tipText
    TipLbl.TextColor3 = THEMES.SubTextColor
    TipLbl.Font = Enum.Font.Code
    TipLbl.TextSize = 11
    TipLbl.TextWrapped = true
    TipLbl.ZIndex = 21
    TipLbl.Parent = TipFrame

    table.insert(garbage, element.MouseEnter:Connect(function() TipFrame.Visible = true end))
    table.insert(garbage, element.MouseLeave:Connect(function() TipFrame.Visible = false end))
    table.insert(garbage, UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and TipFrame.Visible then
            local mf = self.Frames.MainFrame
            TipFrame.Position = UDim2.new(0,
                input.Position.X - mf.AbsolutePosition.X + 12,
                0,
                input.Position.Y - mf.AbsolutePosition.Y + 12
            )
        end
    end))

    table.insert(garbage, TipFrame)
end

function Library:Unload() CleanID(self.Name) end

-- ─────────────────────────────────────────────────────────────────────────────
-- CONSTRUCTOR
-- ─────────────────────────────────────────────────────────────────────────────

function Library.new(Name: string, Size: UDim2, KeyBind: Enum.UserInputType | Enum.KeyCode)
    local self = setmetatable({}, Library)
    local WindowRoot = self

    -- Wraps a connection and adds it to the garbage bin
    function self:Connect(signal, callback)
        local connection = signal:Connect(callback)
        table.insert(getgenv()._Heartkiss_Garbage[self.Name], connection)
        return connection
    end

    -- Throws custom Instances, Threads, or Functions into the garbage bin
    function self:Manage(item)
        table.insert(getgenv()._Heartkiss_Garbage[self.Name], item)
        return item
    end

    self.Name       = Name or "Heartkiss"
    self.Size       = Size or UDim2.fromOffset(488, 518)
    self.Tabs       = {}
    self.KeyBind    = KeyBind or Enum.KeyCode.RightControl
    self.Flags      = {}
    self.Setters    = {}
    self.ConfigFolder = self.Name .. "_Configs"
    if not isfolder(self.ConfigFolder) then makefolder(self.ConfigFolder) end

    CleanID(self.Name)
    getgenv()._Heartkiss_Garbage[self.Name] = {}
    local garbage = getgenv()._Heartkiss_Garbage[self.Name]

    -- ── ScreenGuis ──────────────────────────────────────────────────────────
    local function ProtectGui(gui)
        if syn and syn.protect_gui then syn.protect_gui(gui)
        elseif protectgui then protectgui(gui) end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = self.Name
    ProtectGui(ScreenGui)
    ScreenGui.Parent = CoreGui
    table.insert(garbage, ScreenGui)

    local NotifyGui = Instance.new("ScreenGui")
    NotifyGui.Name = self.Name .. "_Notifications"
    ProtectGui(NotifyGui)
    NotifyGui.Parent = CoreGui
    table.insert(garbage, NotifyGui)

    -- ── Notification layout ─────────────────────────────────────────────────
    local NotifyLayout = Instance.new("Frame")
    NotifyLayout.Name = "Layout"
    NotifyLayout.BackgroundTransparency = 1
    NotifyLayout.Size = UDim2.new(0, 250, 1, -40)
    NotifyLayout.Position = UDim2.new(1, -260, 0, 20)
    NotifyLayout.Parent = NotifyGui

    local NotifyList = Instance.new("UIListLayout")
    NotifyList.SortOrder = Enum.SortOrder.LayoutOrder
    NotifyList.VerticalAlignment = Enum.VerticalAlignment.Top
    NotifyList.Padding = UDim.new(0, 10)
    NotifyList.Parent = NotifyLayout

    self.NotifyLayout = NotifyLayout

    -- ── Main window ─────────────────────────────────────────────────────────
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = THEMES.MainColor
    MainFrame.BorderColor3 = THEMES.LineColor
    MainFrame.Position = UDim2.new(0.5, 0, 0.463, 0)
    MainFrame.Size = UDim2.new(0, 488, 0, 518)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    CreateGradient(MainFrame)

    local UIDragDetector = Instance.new("UIDragDetector")
    UIDragDetector.Parent = MainFrame

    local Frame = Instance.new("Frame")
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = THEMES.FrameColor
    Frame.BorderColor3 = Color3.fromRGB(98, 98, 98)
    Frame.Position = UDim2.new(0.498, 0, 0.508, 0)
    Frame.Size = UDim2.new(0.959, 0, 0.943, 0)
    Frame.ZIndex = 1
    Frame.Parent = MainFrame
    CreateGradient(Frame)

    local Line = Instance.new("Frame")
    Line.Name = "Line"
    Line.AnchorPoint = Vector2.new(0.5, 0.5)
    Line.BackgroundColor3 = THEMES.LineColor
    Line.BorderSizePixel = 0
    Line.Position = UDim2.new(0.5, 0, 0, 0)
    Line.Size = UDim2.new(1, 0, 0.002, 0)
    Line.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.AnchorPoint = Vector2.new(0.5, 0.5)
    Title.Position = UDim2.new(0.498, 0, 0.020, 0)
    Title.Size = UDim2.new(0, 440, 0, 17)
    Title.Font = Enum.Font.SourceSans
    Title.Text = Name
    Title.TextColor3 = THEMES.TextColor
    Title.BackgroundTransparency = 1
    Title.TextScaled = true
    Title.TextWrapped = true
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = MainFrame

    -- ── Minimize button ──────────────────────────────────────────────────────
    local minimized = false
    local EXPANDED_HEIGHT = 518

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 18, 0, 18)
    MinBtn.Position = UDim2.new(1, -22, 0, 3)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "−"
    MinBtn.TextColor3 = THEMES.LineColor
    MinBtn.Font = Enum.Font.Code
    MinBtn.TextSize = 16
    MinBtn.ZIndex = 5
    MinBtn.Parent = MainFrame

    table.insert(garbage, MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        local targetH = minimized and 26 or EXPANDED_HEIGHT
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 488, 0, targetH)}):Play()
        MinBtn.Text = minimized and "+" or "−"
    end))

    -- ── Tab bar ─────────────────────────────────────────────────────────────
    local Tabs = Instance.new("Frame")
    Tabs.Name = "Tabs"
    Tabs.AnchorPoint = Vector2.new(0.5, 0.5)
    Tabs.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    Tabs.BorderColor3 = THEMES.BorderColor
    Tabs.Position = UDim2.new(0.498, 0, 0.095, 0)
    Tabs.Size = UDim2.new(0.917, 0, 0.058, 0)
    Tabs.Parent = MainFrame

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Active = true
    ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    ScrollingFrame.Size = UDim2.new(1, 0, 0.952, 0)
    ScrollingFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.Always
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
    ScrollingFrame.ScrollBarThickness = 0
    ScrollingFrame.Parent = Tabs

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.FillDirection = Enum.FillDirection.Horizontal
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Parent = ScrollingFrame

    local FrameHolder = Instance.new("Frame")
    FrameHolder.Name = "FrameHolder"
    FrameHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    FrameHolder.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    FrameHolder.BorderColor3 = THEMES.BorderColor
    FrameHolder.Position = UDim2.new(0.498, 0, 0.533, 0)
    FrameHolder.Size = UDim2.new(0.917, 0, 0.859, 0)
    FrameHolder.Parent = MainFrame
    CreateGradient(FrameHolder)

    self.Frames = {
        MainFrame   = MainFrame,
        Frame       = Frame,
        Title       = Title,
        Tabs        = Tabs,
        FrameHolder = FrameHolder
    }

    -- ── Toggle visibility ────────────────────────────────────────────────────
    local inputCon = UserInputService.InputBegan:Connect(function(Input, GPE)
        if GPE then return end
        if Input.KeyCode == self.KeyBind or Input.UserInputType == self.KeyBind then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)
    table.insert(garbage, inputCon)

    -- ── Tab builder ──────────────────────────────────────────────────────────
    function self:Tab(text: string)
        local Tab = Instance.new("TextButton")
        Tab.Name = text
        Tab.BackgroundColor3 = THEMES.TabColor
        Tab.BorderColor3 = Color3.fromRGB(112, 112, 112)
        Tab.Size = UDim2.new(0, 47, 0, 19)
        Tab.Font = Enum.Font.Code
        Tab.Text = " " .. text .. " "
        Tab.TextColor3 = THEMES.TextColor
        Tab.TextScaled = true
        Tab.TextSize = 14
        Tab.Parent = ScrollingFrame
        CreateGradient(Tab, -90)

        local Page = Instance.new("ScrollingFrame")
        Page.AnchorPoint = Vector2.new(0.5, 0.5)
        Page.Size = UDim2.fromScale(0.97, 0.97)
        Page.Position = UDim2.fromScale(0.5, 0.5)
        Page.BackgroundColor3 = THEMES.FrameColor
        Page.BorderColor3 = THEMES.BorderColor
        Page.ScrollBarThickness = 0
        Page.ScrollingDirection = Enum.ScrollingDirection.Y
        Page.Visible = false
        Page.Parent = FrameHolder
        CreateGradient(Page)

        local LeftColumn = Instance.new("Frame")
        LeftColumn.Name = "LeftColumn"
        LeftColumn.Size = UDim2.new(0.5, -5, 1, 0)
        LeftColumn.Position = UDim2.new(0, 0, 0, 12)
        LeftColumn.BackgroundTransparency = 1
        LeftColumn.Parent = Page

        local LeftList = Instance.new("UIListLayout")
        LeftList.Padding = UDim.new(0, 8)
        LeftList.SortOrder = Enum.SortOrder.LayoutOrder
        LeftList.Parent = LeftColumn

        local RightColumn = Instance.new("Frame")
        RightColumn.Name = "RightColumn"
        RightColumn.Size = UDim2.new(0.5, -5, 1, 0)
        RightColumn.Position = UDim2.new(0.5, 5, 0, 12)
        RightColumn.BackgroundTransparency = 1
        RightColumn.Parent = Page

        local RightList = Instance.new("UIListLayout")
        RightList.Padding = UDim.new(0, 8)
        RightList.SortOrder = Enum.SortOrder.LayoutOrder
        RightList.Parent = RightColumn

        local function UpdateCanvas()
            Page.CanvasSize = UDim2.new(0, 0, 0,
                math.max(LeftList.AbsoluteContentSize.Y, RightList.AbsoluteContentSize.Y) + 20)
        end
        LeftList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)
        RightList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)

        local con = Tab.MouseButton1Click:Connect(function()
            for _, tab in self.Tabs do
                tab.Page.Visible = false
                tab.Button.BackgroundColor3 = THEMES.TabColor
            end
            Page.Visible = true
            Tab.BackgroundColor3 = THEMES.SelectedTab
        end)
        table.insert(garbage, con)

        -- FIX: highlight the first tab button when it's auto-selected
        if #self.Tabs == 0 then
            Page.Visible = true
            Tab.BackgroundColor3 = THEMES.SelectedTab
        end
        table.insert(self.Tabs, {Button = Tab, Page = Page})

        -- ── Section builder ───────────────────────────────────────────────────
        local TabFunctions = {}
        local SectionCount = 0

        function TabFunctions:Section(title: string)
            SectionCount = SectionCount + 1
            local ParentFrame = (SectionCount % 2 == 1) and LeftColumn or RightColumn

            local Section = Instance.new("Frame")
            Section.Name = title
            Section.Size = UDim2.new(1, 0, 0, 100)
            Section.BackgroundColor3 = THEMES.MainColor
            Section.BackgroundTransparency = 0.4
            Section.BorderColor3 = THEMES.BorderColor
            Section.BorderMode = Enum.BorderMode.Inset
            Section.Parent = ParentFrame
            CreateGradient(Section)

            local Label = Instance.new("TextLabel")
            Label.Text = " " .. title .. " "
            Label.TextColor3 = THEMES.TextColor
            Label.BackgroundColor3 = THEMES.FrameColor
            Label.BorderSizePixel = 0
            Label.Position = UDim2.new(0, 10, 0, -8)
            Label.AutomaticSize = Enum.AutomaticSize.XY
            Label.Font = Enum.Font.Code
            Label.TextSize = 12
            Label.ZIndex = 2
            Label.Parent = Section

            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1, -10, 1, -15)
            Container.Position = UDim2.new(0, 5, 0, 15)
            Container.BackgroundTransparency = 1
            Container.Parent = Section

            local List = Instance.new("UIListLayout")
            List.Padding = UDim.new(0, 5)
            List.SortOrder = Enum.SortOrder.LayoutOrder
            List.Parent = Container

            List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Section.Size = UDim2.new(1, 0, 0, List.AbsoluteContentSize.Y + 25)
            end)

            local SectionFunctions = {}
            local ElementCount = 0

            -- ────────────────────────────────────────────────────────────────
            -- BUTTON
            -- ────────────────────────────────────────────────────────────────
            function SectionFunctions:Button(text, callback)
                ElementCount = ElementCount + 1
                callback = callback or function() end
                local Btn = CreateButton()
                Btn.Text = text
                Btn.LayoutOrder = ElementCount
                Btn.Parent = Container
                table.insert(garbage, Btn.MouseButton1Click:Connect(callback))
                return Btn
            end

            -- ────────────────────────────────────────────────────────────────
            -- CREATE BUTTON ROW
            -- ────────────────────────────────────────────────────────────────
            function SectionFunctions:CreateButtonRow(text1, callback1, text2, callback2)
                ElementCount = ElementCount + 1
                local RowFrame = Instance.new("Frame")
                RowFrame.Size = UDim2.new(1, 0, 0, 15)
                RowFrame.BackgroundTransparency = 1
                RowFrame.LayoutOrder = ElementCount
                RowFrame.Parent = Container

                local Btn1 = CreateButton()
                Btn1.Size = UDim2.new(0.5, -3, 1, 0)
                Btn1.Text = text1
                Btn1.Parent = RowFrame

                local Btn2 = CreateButton()
                Btn2.Size = UDim2.new(0.5, -3, 1, 0)
                Btn2.Position = UDim2.new(0.5, 3, 0, 0)
                Btn2.Text = text2
                Btn2.Parent = RowFrame

                table.insert(garbage, Btn1.MouseButton1Click:Connect(callback1))
                table.insert(garbage, Btn2.MouseButton1Click:Connect(callback2))
                return Btn1, Btn2
            end

            -- ────────────────────────────────────────────────────────────────
            -- TOGGLE
            -- ────────────────────────────────────────────────────────────────
            function SectionFunctions:Toggle(text: string, default: boolean, flag: string, callback)
                ElementCount = ElementCount + 1
                default = default or false
                callback = callback or function() end
                local enabled = default
                if flag then WindowRoot.Flags[flag] = enabled end

                local ToggleBtn = Instance.new("TextButton")
                ToggleBtn.Size = UDim2.new(1, 0, 0, 20)
                ToggleBtn.BackgroundTransparency = 1
                ToggleBtn.Text = ""
                ToggleBtn.LayoutOrder = ElementCount
                ToggleBtn.Parent = Container

                local CheckMark = Instance.new("Frame")
                CheckMark.Size = UDim2.new(0, 12, 0, 12)
                CheckMark.Position = UDim2.new(0, 0, 0.5, -6)
                CheckMark.BackgroundColor3 = enabled and THEMES.LineColor or THEMES.FrameColor
                CheckMark.BorderColor3 = THEMES.BorderColor
                CheckMark.Parent = ToggleBtn
                CreateGradient(CheckMark)

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, -20, 1, 0)
                Lbl.Position = UDim2.new(0, 18, 0, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = THEMES.TextColor
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 12
                Lbl.Parent = ToggleBtn

                local function UpdateVisuals(state)
                    enabled = state
                    if flag then WindowRoot.Flags[flag] = enabled end
                    TweenService:Create(CheckMark, TweenInfo.new(0.2),
                        {BackgroundColor3 = enabled and THEMES.LineColor or THEMES.FrameColor}):Play()
                    callback(enabled)
                end

                if flag then WindowRoot.Setters[flag] = UpdateVisuals end
                table.insert(garbage, ToggleBtn.MouseButton1Click:Connect(function() UpdateVisuals(not enabled) end))
            end

            -- ────────────────────────────────────────────────────────────────
            -- TOGGLEBIND
            -- ────────────────────────────────────────────────────────────────

            function SectionFunctions:ToggleBind(text: string, defaultState: boolean, defaultKey: Enum.KeyCode, flagState: string, flagKey: string, callback)
                ElementCount = ElementCount + 1
                defaultState = defaultState or false
                local enabled = defaultState
                local CurrentKey = defaultKey or Enum.KeyCode.Unknown
                local isBinding = false
                callback = callback or function() end

                if flagState then WindowRoot.Flags[flagState] = enabled end
                if flagKey then WindowRoot.Flags[flagKey] = CurrentKey.Name end

                local TBFrame = Instance.new("Frame")
                TBFrame.Size = UDim2.new(1, 0, 0, 20)
                TBFrame.BackgroundTransparency = 1
                TBFrame.LayoutOrder = ElementCount
                TBFrame.Parent = Container

                local ToggleBtn = Instance.new("TextButton")
                ToggleBtn.Size = UDim2.new(1, -65, 1, 0)
                ToggleBtn.BackgroundTransparency = 1
                ToggleBtn.Text = ""
                ToggleBtn.Parent = TBFrame

                local CheckMark = Instance.new("Frame")
                CheckMark.Size = UDim2.new(0, 12, 0, 12)
                CheckMark.Position = UDim2.new(0, 0, 0.5, -6)
                CheckMark.BackgroundColor3 = enabled and THEMES.LineColor or THEMES.FrameColor
                CheckMark.BorderColor3 = THEMES.BorderColor
                CheckMark.Parent = ToggleBtn
                CreateGradient(CheckMark)

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, -20, 1, 0)
                Lbl.Position = UDim2.new(0, 18, 0, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = THEMES.TextColor
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 12
                Lbl.Parent = ToggleBtn

                local BindBtn = Instance.new("TextButton")
                BindBtn.Size = UDim2.new(0, 60, 1, 0)
                BindBtn.Position = UDim2.new(1, -60, 0, 0)
                BindBtn.BackgroundColor3 = THEMES.FrameColor
                BindBtn.BorderColor3 = THEMES.BorderColor
                BindBtn.Text = "[" .. CurrentKey.Name .. "]"
                BindBtn.TextColor3 = THEMES.TextColor
                BindBtn.Font = Enum.Font.Code
                BindBtn.TextSize = 12
                BindBtn.Parent = TBFrame
                CreateGradient(BindBtn)

                local function UpdateVisuals(state)
                    enabled = state
                    if flagState then WindowRoot.Flags[flagState] = enabled end
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

                table.insert(garbage, ToggleBtn.MouseButton1Click:Connect(function() 
                    UpdateVisuals(not enabled) 
                end))

                table.insert(garbage, BindBtn.MouseButton1Click:Connect(function()
                    isBinding = true
                    BindBtn.Text = "[...]"
                    BindBtn.BorderColor3 = THEMES.LineColor
                end))

                table.insert(garbage, UserInputService.InputBegan:Connect(function(input, processed)
                    if isBinding then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            isBinding = false
                            BindBtn.BorderColor3 = THEMES.BorderColor
                            if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Escape then
                                SetBind("Unknown")
                            else
                                SetBind(input.KeyCode.Name)
                            end
                        end
                    elseif not processed and CurrentKey ~= Enum.KeyCode.Unknown and input.KeyCode == CurrentKey then
                        UpdateVisuals(not enabled)
                    end
                end))
            end

            -- ────────────────────────────────────────────────────────────────
            -- SWITCH  (iOS-style sliding pill)
            -- ────────────────────────────────────────────────────────────────
            function SectionFunctions:Switch(text: string, default: boolean, flag: string, callback)
                ElementCount = ElementCount + 1
                default = default or false
                callback = callback or function() end
                local enabled = default
                if flag then WindowRoot.Flags[flag] = enabled end

                local SwitchFrame = Instance.new("Frame")
                SwitchFrame.Size = UDim2.new(1, 0, 0, 18)
                SwitchFrame.BackgroundTransparency = 1
                SwitchFrame.LayoutOrder = ElementCount
                SwitchFrame.Parent = Container

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, -44, 1, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = THEMES.TextColor
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 12
                Lbl.Parent = SwitchFrame

                local Track = Instance.new("TextButton")
                Track.Size = UDim2.new(0, 36, 0, 16)
                Track.Position = UDim2.new(1, -38, 0.5, -8)
                Track.BackgroundColor3 = enabled and THEMES.LineColor or THEMES.FrameColor
                Track.BorderColor3 = THEMES.BorderColor
                Track.Text = ""
                Track.AutoButtonColor = false
                Track.Parent = SwitchFrame
                CreateGradient(Track)
                RoundCorner(Track, 1)

                local Knob = Instance.new("Frame")
                Knob.Size = UDim2.new(0, 10, 0, 10)
                Knob.Position = enabled and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)
                Knob.BackgroundColor3 = Color3.new(1, 1, 1)
                Knob.BorderSizePixel = 0
                Knob.Parent = Track
                RoundCorner(Knob, 1)

                local function UpdateSwitch(state)
                    enabled = state
                    if flag then WindowRoot.Flags[flag] = enabled end
                    TweenService:Create(Track, TweenInfo.new(0.2),
                        {BackgroundColor3 = enabled and THEMES.LineColor or THEMES.FrameColor}):Play()
                    TweenService:Create(Knob, TweenInfo.new(0.2),
                        {Position = enabled and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)}):Play()
                    callback(enabled)
                end

                if flag then WindowRoot.Setters[flag] = UpdateSwitch end
                table.insert(garbage, Track.MouseButton1Click:Connect(function() UpdateSwitch(not enabled) end))
            end

            -- ────────────────────────────────────────────────────────────────
            -- SLIDER
            -- ────────────────────────────────────────────────────────────────
            function SectionFunctions:Slider(text: string, min: number, max: number, default: number, decimals: number, flag: string, callback)
                ElementCount = ElementCount + 1
                default = default or min
                decimals = decimals or 0
                callback = callback or function() end
                if flag then WindowRoot.Flags[flag] = default end

                local SliderFrame = Instance.new("Frame")
                SliderFrame.Size = UDim2.new(1, 0, 0, 35)
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.LayoutOrder = ElementCount
                SliderFrame.Parent = Container

                local TextLbl = Instance.new("TextLabel")
                TextLbl.Size = UDim2.new(1, 0, 0, 15)
                TextLbl.BackgroundTransparency = 1
                TextLbl.Text = text
                TextLbl.TextColor3 = THEMES.TextColor
                TextLbl.TextXAlignment = Enum.TextXAlignment.Left
                TextLbl.Font = Enum.Font.Code
                TextLbl.TextSize = 12
                TextLbl.Parent = SliderFrame

                local ValueLbl = Instance.new("TextLabel")
                ValueLbl.Size = UDim2.new(1, 0, 0, 15)
                ValueLbl.BackgroundTransparency = 1
                ValueLbl.Text = tostring(default)
                ValueLbl.TextColor3 = THEMES.TextColor
                ValueLbl.TextXAlignment = Enum.TextXAlignment.Right
                ValueLbl.Font = Enum.Font.Code
                ValueLbl.TextSize = 12
                ValueLbl.Parent = SliderFrame

                local SlideBar = Instance.new("TextButton")
                SlideBar.Size = UDim2.new(1, 0, 0, 10)
                SlideBar.Position = UDim2.new(0, 0, 0, 20)
                SlideBar.BackgroundColor3 = THEMES.FrameColor
                SlideBar.BorderColor3 = THEMES.BorderColor
                SlideBar.Text = ""
                SlideBar.AutoButtonColor = false
                SlideBar.Parent = SliderFrame
                CreateGradient(SlideBar)

                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                Fill.BackgroundColor3 = THEMES.LineColor
                Fill.BorderSizePixel = 0
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
                    local ratio = math.clamp(
                        (input.Position.X - SlideBar.AbsolutePosition.X) / SlideBar.AbsoluteSize.X, 0, 1)
                    SetValue(min + (max - min) * ratio)
                end

                if flag then WindowRoot.Setters[flag] = SetValue end

                table.insert(garbage, SlideBar.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; Update(i) end
                end))
                table.insert(garbage, UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end))
                table.insert(garbage, UserInputService.InputChanged:Connect(function(i)
                    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then Update(i) end
                end))
            end

            -- ────────────────────────────────────────────────────────────────
            -- STEPPER  (± integer stepping)
            -- ────────────────────────────────────────────────────────────────
            function SectionFunctions:Stepper(text: string, min: number, max: number, default: number, step: number, flag: string, callback)
                ElementCount = ElementCount + 1
                default = default or min
                step = step or 1
                callback = callback or function() end
                local value = default
                if flag then WindowRoot.Flags[flag] = value end

                local StepFrame = Instance.new("Frame")
                StepFrame.Size = UDim2.new(1, 0, 0, 20)
                StepFrame.BackgroundTransparency = 1
                StepFrame.LayoutOrder = ElementCount
                StepFrame.Parent = Container

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, -82, 1, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = THEMES.TextColor
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 12
                Lbl.Parent = StepFrame

                local MinusBtn = Instance.new("TextButton")
                MinusBtn.Size = UDim2.new(0, 22, 1, 0)
                MinusBtn.Position = UDim2.new(1, -78, 0, 0)
                MinusBtn.BackgroundColor3 = THEMES.FrameColor
                MinusBtn.BorderColor3 = THEMES.BorderColor
                MinusBtn.Text = "−"
                MinusBtn.TextColor3 = THEMES.LineColor
                MinusBtn.Font = Enum.Font.Code
                MinusBtn.TextSize = 14
                MinusBtn.Parent = StepFrame
                CreateGradient(MinusBtn)

                local ValueLbl = Instance.new("TextLabel")
                ValueLbl.Size = UDim2.new(0, 30, 1, 0)
                ValueLbl.Position = UDim2.new(1, -54, 0, 0)
                ValueLbl.BackgroundColor3 = THEMES.FrameColor
                ValueLbl.BorderColor3 = THEMES.BorderColor
                ValueLbl.Text = tostring(value)
                ValueLbl.TextColor3 = THEMES.TextColor
                ValueLbl.Font = Enum.Font.Code
                ValueLbl.TextSize = 11
                ValueLbl.Parent = StepFrame
                CreateGradient(ValueLbl)

                local PlusBtn = Instance.new("TextButton")
                PlusBtn.Size = UDim2.new(0, 22, 1, 0)
                PlusBtn.Position = UDim2.new(1, -22, 0, 0)
                PlusBtn.BackgroundColor3 = THEMES.FrameColor
                PlusBtn.BorderColor3 = THEMES.BorderColor
                PlusBtn.Text = "+"
                PlusBtn.TextColor3 = THEMES.LineColor
                PlusBtn.Font = Enum.Font.Code
                PlusBtn.TextSize = 14
                PlusBtn.Parent = StepFrame
                CreateGradient(PlusBtn)

                local function SetValue(v)
                    value = math.clamp(v, min, max)
                    ValueLbl.Text = tostring(value)
                    if flag then WindowRoot.Flags[flag] = value end
                    callback(value)
                end

                if flag then WindowRoot.Setters[flag] = SetValue end
                table.insert(garbage, MinusBtn.MouseButton1Click:Connect(function() SetValue(value - step) end))
                table.insert(garbage, PlusBtn.MouseButton1Click:Connect(function() SetValue(value + step) end))
            end

            -- ────────────────────────────────────────────────────────────────
            -- BIND  (keybind picker)
            -- ────────────────────────────────────────────────────────────────
            function SectionFunctions:Bind(text: string, defaultKey: Enum.KeyCode, flag: string, callback)
                ElementCount = ElementCount + 1
                callback = callback or function() end
                local CurrentKey = defaultKey or Enum.KeyCode.Unknown
                local isBinding = false
                if flag then WindowRoot.Flags[flag] = CurrentKey.Name end

                local KeybindFrame = Instance.new("Frame")
                KeybindFrame.Size = UDim2.new(1, 0, 0, 15)
                KeybindFrame.BackgroundTransparency = 1
                KeybindFrame.LayoutOrder = ElementCount
                KeybindFrame.Parent = Container

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, -65, 1, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = THEMES.TextColor
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 12
                Lbl.Parent = KeybindFrame

                local BindBtn = Instance.new("TextButton")
                BindBtn.Size = UDim2.new(0, 60, 1, 0)
                BindBtn.Position = UDim2.new(1, -60, 0, 0)
                BindBtn.BackgroundColor3 = THEMES.FrameColor
                BindBtn.BorderColor3 = THEMES.BorderColor
                BindBtn.Text = "[" .. CurrentKey.Name .. "]"
                BindBtn.TextColor3 = THEMES.TextColor
                BindBtn.Font = Enum.Font.Code
                BindBtn.TextSize = 12
                BindBtn.Parent = KeybindFrame
                CreateGradient(BindBtn)

                local function SetBind(keyName)
                    CurrentKey = Enum.KeyCode[keyName] or Enum.KeyCode.Unknown
                    BindBtn.Text = "[" .. CurrentKey.Name .. "]"
                    if flag then WindowRoot.Flags[flag] = CurrentKey.Name end
                end

                if flag then WindowRoot.Setters[flag] = SetBind end

                table.insert(garbage, BindBtn.MouseButton1Click:Connect(function()
                    isBinding = true
                    BindBtn.Text = "[...]"
                    BindBtn.BorderColor3 = THEMES.LineColor
                end))
                table.insert(garbage, UserInputService.InputBegan:Connect(function(input, processed)
                    if isBinding then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            isBinding = false
                            BindBtn.BorderColor3 = THEMES.BorderColor
                            if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Escape then
                                SetBind("Unknown")
                            else
                                SetBind(input.KeyCode.Name)
                            end
                        end
                    elseif not processed and CurrentKey ~= Enum.KeyCode.Unknown and input.KeyCode == CurrentKey then
                        callback()
                    end
                end))
            end

            -- ────────────────────────────────────────────────────────────────
            -- INPUT  (text box)
            -- ────────────────────────────────────────────────────────────────
            function SectionFunctions:Input(text: string, placeholder: string, flag: string, callback)
                ElementCount = ElementCount + 1
                callback = callback or function() end
                if flag then WindowRoot.Flags[flag] = "" end

                local InputFrame = Instance.new("Frame")
                InputFrame.Size = UDim2.new(1, 0, 0, 40)
                InputFrame.BackgroundTransparency = 1
                InputFrame.LayoutOrder = ElementCount
                InputFrame.Parent = Container

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, 0, 0, 15)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = THEMES.TextColor
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 12
                Lbl.Parent = InputFrame

                local InputBox = Instance.new("TextBox")
                InputBox.Size = UDim2.new(1, 0, 0, 20)
                InputBox.Position = UDim2.new(0, 0, 0, 18)
                InputBox.BackgroundColor3 = THEMES.FrameColor
                InputBox.BorderColor3 = THEMES.BorderColor
                InputBox.Text = ""
                InputBox.PlaceholderText = placeholder or "..."
                InputBox.TextColor3 = THEMES.TextColor
                InputBox.Font = Enum.Font.Code
                InputBox.TextSize = 12
                InputBox.Parent = InputFrame
                CreateGradient(InputBox)

                local function SetText(txt)
                    InputBox.Text = txt
                    if flag then WindowRoot.Flags[flag] = txt end
                    callback(txt)
                end

                if flag then WindowRoot.Setters[flag] = SetText end

                table.insert(garbage, InputBox.FocusLost:Connect(function()
                    SetText(InputBox.Text)
                    local old = InputBox.BorderColor3
                    InputBox.BorderColor3 = THEMES.LineColor
                    task.wait(0.1)
                    InputBox.BorderColor3 = old
                end))
            end

            -- ────────────────────────────────────────────────────────────────
            -- DROPDOWN  (single or multi-select)
            -- ────────────────────────────────────────────────────────────────
            function SectionFunctions:Dropdown(text: string, options: table, multi: boolean, default, flag: string, callback)
                ElementCount = ElementCount + 1
                callback = callback or function() end
                local isDropped = false
                local dropdownOptions = options
                local selectedValues = multi and (default or {}) or (default or "")
                if flag then WindowRoot.Flags[flag] = selectedValues end

                local DropFrame = Instance.new("Frame")
                DropFrame.Size = UDim2.new(1, 0, 0, 30)
                DropFrame.BackgroundTransparency = 1
                DropFrame.ClipsDescendants = true
                DropFrame.LayoutOrder = ElementCount
                DropFrame.Parent = Container

                local Header = CreateButton()
                Header.Text = ""
                Header.Parent = DropFrame
                CreateGradient(Header)

                local TitleLbl = Instance.new("TextLabel")
                TitleLbl.Size = UDim2.new(1, -20, 1, 0)
                TitleLbl.Position = UDim2.new(0, 5, 0, 0)
                TitleLbl.BackgroundTransparency = 1
                TitleLbl.Text = text .. " : Select..."
                TitleLbl.TextColor3 = THEMES.TextColor
                TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
                TitleLbl.Font = Enum.Font.Code
                TitleLbl.TextSize = 12
                TitleLbl.Parent = Header

                local Icon = Instance.new("TextLabel")
                Icon.Size = UDim2.new(0, 20, 1, 0)
                Icon.Position = UDim2.new(1, -20, 0, 0)
                Icon.BackgroundTransparency = 1
                Icon.Text = "+"
                Icon.TextColor3 = THEMES.LineColor
                Icon.Font = Enum.Font.Code
                Icon.Parent = Header

                local OptionContainer = Instance.new("Frame")
                OptionContainer.Size = UDim2.new(1, 0, 0, 0)
                OptionContainer.Position = UDim2.new(0, 0, 0, 30)
                OptionContainer.BackgroundTransparency = 1
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
                    for _, child in OptionContainer:GetChildren() do
                        if child:IsA("TextButton") then child:Destroy() end
                    end
                    dropdownOptions = newOptions
                    for _, opt in dropdownOptions do
                        local OptBtn = CreateButton()
                        OptBtn.Text = opt
                        OptBtn.Parent = OptionContainer
                        CreateGradient(OptBtn)

                        if multi and table.find(selectedValues, opt) then OptBtn.TextColor3 = THEMES.LineColor
                        elseif not multi and selectedValues == opt then OptBtn.TextColor3 = THEMES.LineColor end

                        table.insert(garbage, OptBtn.MouseButton1Click:Connect(function()
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
                                TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 30)}):Play()
                            end
                            UpdateTitle()
                            if flag then WindowRoot.Flags[flag] = selectedValues end
                            callback(selectedValues)
                        end))
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

                table.insert(garbage, Header.MouseButton1Click:Connect(function()
                    isDropped = not isDropped
                    Icon.Text = isDropped and "−" or "+"
                    local openH = isDropped and (30 + (#dropdownOptions * 19) + 5) or 30
                    TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, openH)}):Play()
                end))

                local DropObj = {}
                function DropObj:Refresh(newList) BuildOptions(newList) end
                return DropObj
            end

            -- ────────────────────────────────────────────────────────────────
            -- SEARCHABLE DROPDOWN
            -- ────────────────────────────────────────────────────────────────
            function SectionFunctions:SearchableDropdown(text: string, options: table, default, flag: string, callback)
                ElementCount = ElementCount + 1
                callback = callback or function() end
                local isDropped = false
                local selected = default or ""
                local allOptions = options
                local filteredOptions = {table.unpack(options)}
                if flag then WindowRoot.Flags[flag] = selected end

                local DropFrame = Instance.new("Frame")
                DropFrame.Size = UDim2.new(1, 0, 0, 30)
                DropFrame.BackgroundTransparency = 1
                DropFrame.ClipsDescendants = true
                DropFrame.LayoutOrder = ElementCount
                DropFrame.Parent = Container

                local Header = CreateButton()
                Header.Text = ""
                Header.Parent = DropFrame
                CreateGradient(Header)

                local TitleLbl = Instance.new("TextLabel")
                TitleLbl.Size = UDim2.new(1, -20, 1, 0)
                TitleLbl.Position = UDim2.new(0, 5, 0, 0)
                TitleLbl.BackgroundTransparency = 1
                TitleLbl.Text = text .. " : " .. (selected == "" and "Select..." or selected)
                TitleLbl.TextColor3 = THEMES.TextColor
                TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
                TitleLbl.Font = Enum.Font.Code
                TitleLbl.TextSize = 12
                TitleLbl.Parent = Header

                local Icon = Instance.new("TextLabel")
                Icon.Size = UDim2.new(0, 20, 1, 0)
                Icon.Position = UDim2.new(1, -20, 0, 0)
                Icon.BackgroundTransparency = 1
                Icon.Text = "+"
                Icon.TextColor3 = THEMES.LineColor
                Icon.Font = Enum.Font.Code
                Icon.Parent = Header

                local SearchBox = Instance.new("TextBox")
                SearchBox.Size = UDim2.new(1, 0, 0, 18)
                SearchBox.Position = UDim2.new(0, 0, 0, 16)
                SearchBox.BackgroundColor3 = THEMES.FrameColor
                SearchBox.BorderColor3 = THEMES.LineColor
                SearchBox.Text = ""
                SearchBox.PlaceholderText = "  Search..."
                SearchBox.TextColor3 = THEMES.TextColor
                SearchBox.PlaceholderColor3 = THEMES.SubTextColor
                SearchBox.Font = Enum.Font.Code
                SearchBox.TextSize = 11
                SearchBox.Parent = DropFrame
                CreateGradient(SearchBox)

                local OptionContainer = Instance.new("Frame")
                OptionContainer.Size = UDim2.new(1, 0, 0, 0)
                OptionContainer.Position = UDim2.new(0, 0, 0, 36)
                OptionContainer.BackgroundTransparency = 1
                OptionContainer.Parent = DropFrame

                local OptionLayout = Instance.new("UIListLayout")
                OptionLayout.Padding = UDim.new(0, 2)
                OptionLayout.Parent = OptionContainer

                local function GetOpenHeight()
                    return 36 + (#filteredOptions * 19) + 5
                end

                local function BuildOptions()
                    for _, child in OptionContainer:GetChildren() do
                        if child:IsA("TextButton") then child:Destroy() end
                    end
                    for _, opt in filteredOptions do
                        local OptBtn = CreateButton()
                        OptBtn.Text = opt
                        OptBtn.Parent = OptionContainer
                        CreateGradient(OptBtn)
                        if selected == opt then OptBtn.TextColor3 = THEMES.LineColor end

                        table.insert(garbage, OptBtn.MouseButton1Click:Connect(function()
                            selected = opt
                            TitleLbl.Text = text .. " : " .. selected
                            for _, btn in OptionContainer:GetChildren() do
                                if btn:IsA("TextButton") then btn.TextColor3 = THEMES.TextColor end
                            end
                            OptBtn.TextColor3 = THEMES.LineColor
                            isDropped = false; Icon.Text = "+"
                            TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 30)}):Play()
                            SearchBox.Text = ""
                            filteredOptions = {table.unpack(allOptions)}
                            if flag then WindowRoot.Flags[flag] = selected end
                            callback(selected)
                        end))
                    end
                    if isDropped then
                        TweenService:Create(DropFrame, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, GetOpenHeight())}):Play()
                    end
                end

                table.insert(garbage, SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                    local q = SearchBox.Text:lower()
                    filteredOptions = {}
                    for _, opt in allOptions do
                        if opt:lower():find(q, 1, true) then table.insert(filteredOptions, opt) end
                    end
                    BuildOptions()
                end))

                BuildOptions()

                table.insert(garbage, Header.MouseButton1Click:Connect(function()
                    isDropped = not isDropped
                    Icon.Text = isDropped and "−" or "+"
                    TweenService:Create(DropFrame, TweenInfo.new(0.2),
                        {Size = UDim2.new(1, 0, 0, isDropped and GetOpenHeight() or 30)}):Play()
                end))

                if flag then
                    WindowRoot.Setters[flag] = function(val)
                        selected = val
                        TitleLbl.Text = text .. " : " .. (selected == "" and "Select..." or selected)
                        if flag then WindowRoot.Flags[flag] = selected end
                        callback(selected)
                    end
                end
            end

            -- ────────────────────────────────────────────────────────────────
            -- RADIO GROUP
            -- ────────────────────────────────────────────────────────────────
            function SectionFunctions:RadioGroup(label: string, options: table, default, flag: string, callback)
                ElementCount = ElementCount + 1
                callback = callback or function() end
                local selected = default or (options[1] or "")
                if flag then WindowRoot.Flags[flag] = selected end

                local headerH = (label and label ~= "") and 16 or 0
                local totalH = headerH + #options * 18

                local GroupFrame = Instance.new("Frame")
                GroupFrame.BackgroundTransparency = 1
                GroupFrame.Size = UDim2.new(1, 0, 0, totalH)
                GroupFrame.LayoutOrder = ElementCount
                GroupFrame.Parent = Container

                if headerH > 0 then
                    local HeaderLbl = Instance.new("TextLabel")
                    HeaderLbl.Size = UDim2.new(1, 0, 0, 14)
                    HeaderLbl.BackgroundTransparency = 1
                    HeaderLbl.Text = label
                    HeaderLbl.TextColor3 = THEMES.TextColor
                    HeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
                    HeaderLbl.Font = Enum.Font.Code
                    HeaderLbl.TextSize = 12
                    HeaderLbl.Parent = GroupFrame
                end

                local dots, labels = {}, {}

                for i, opt in ipairs(options) do
                    local RowBtn = Instance.new("TextButton")
                    RowBtn.Size = UDim2.new(1, 0, 0, 16)
                    RowBtn.Position = UDim2.new(0, 0, 0, headerH + (i - 1) * 18)
                    RowBtn.BackgroundTransparency = 1
                    RowBtn.Text = ""
                    RowBtn.Parent = GroupFrame

                    local Radio = Instance.new("Frame")
                    Radio.Size = UDim2.new(0, 10, 0, 10)
                    Radio.Position = UDim2.new(0, 0, 0.5, -5)
                    Radio.BackgroundColor3 = opt == selected and THEMES.LineColor or THEMES.FrameColor
                    Radio.BorderColor3 = THEMES.BorderColor
                    Radio.Parent = RowBtn
                    CreateGradient(Radio)
                    dots[opt] = Radio

                    local OptLbl = Instance.new("TextLabel")
                    OptLbl.Size = UDim2.new(1, -16, 1, 0)
                    OptLbl.Position = UDim2.new(0, 16, 0, 0)
                    OptLbl.BackgroundTransparency = 1
                    OptLbl.Text = opt
                    OptLbl.TextColor3 = opt == selected and THEMES.TextColor or THEMES.SubTextColor
                    OptLbl.TextXAlignment = Enum.TextXAlignment.Left
                    OptLbl.Font = Enum.Font.Code
                    OptLbl.TextSize = 12
                    OptLbl.Parent = RowBtn
                    labels[opt] = OptLbl

                    table.insert(garbage, RowBtn.MouseButton1Click:Connect(function()
                        for k, dot in dots do
                            TweenService:Create(dot, TweenInfo.new(0.15), {BackgroundColor3 = THEMES.FrameColor}):Play()
                            labels[k].TextColor3 = THEMES.SubTextColor
                        end
                        TweenService:Create(Radio, TweenInfo.new(0.15), {BackgroundColor3 = THEMES.LineColor}):Play()
                        OptLbl.TextColor3 = THEMES.TextColor
                        selected = opt
                        if flag then WindowRoot.Flags[flag] = selected end
                        callback(selected)
                    end))
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
            end

            -- ────────────────────────────────────────────────────────────────
            -- COLOR PICKER
            -- ────────────────────────────────────────────────────────────────
            function SectionFunctions:ColorPicker(text, defaultColor, defaultAlpha, flag, callback)
                ElementCount = ElementCount + 1
                callback = callback or function() end
                defaultColor = defaultColor or Color3.fromRGB(255, 255, 255)
                defaultAlpha = defaultAlpha or 1
                local h, s, v = Color3.toHSV(defaultColor)
                local a = defaultAlpha
                local isOpen = false
                if flag then WindowRoot.Flags[flag] = {R = defaultColor.R, G = defaultColor.G, B = defaultColor.B, A = defaultAlpha} end

                local PickerFrame = Instance.new("Frame")
                PickerFrame.Size = UDim2.new(1, 0, 0, 30)
                PickerFrame.BackgroundTransparency = 1
                PickerFrame.ClipsDescendants = true
                PickerFrame.LayoutOrder = ElementCount
                PickerFrame.Parent = Container

                local Header = CreateButton()
                Header.Text = ""
                Header.Parent = PickerFrame
                CreateGradient(Header)

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, -40, 1, 0)
                Lbl.Position = UDim2.new(0, 5, 0, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = THEMES.TextColor
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 12
                Lbl.Parent = Header

                local CurrentColorFrame = Instance.new("Frame")
                CurrentColorFrame.Size = UDim2.new(0, 20, 0, 12)
                CurrentColorFrame.Position = UDim2.new(1, -25, 0.5, -6)
                CurrentColorFrame.BackgroundColor3 = defaultColor
                CurrentColorFrame.BackgroundTransparency = 1 - a
                CurrentColorFrame.BorderColor3 = THEMES.BorderColor
                CurrentColorFrame.Parent = Header

                local Body = Instance.new("Frame")
                Body.Size = UDim2.new(1, 0, 0, 165)
                Body.Position = UDim2.new(0, 0, 0, 30)
                Body.BackgroundTransparency = 1
                Body.Parent = PickerFrame

                local SVBox = Instance.new("TextButton")
                SVBox.Size = UDim2.new(0, 130, 0, 130)
                SVBox.Position = UDim2.new(0, 10, 0, 10)
                SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                SVBox.BorderColor3 = THEMES.BorderColor
                SVBox.Text = ""
                SVBox.AutoButtonColor = false
                SVBox.Parent = Body

                local SatGradient = Instance.new("UIGradient")
                SatGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}
                SatGradient.Parent = SVBox

                local ValOverlay = Instance.new("Frame")
                ValOverlay.Size = UDim2.new(1, 0, 1, 0)
                ValOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
                ValOverlay.BorderSizePixel = 0
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
                SVCursor.ZIndex = 3
                SVCursor.Position = UDim2.new(1 - s, -2, 1 - v, -2)
                SVCursor.Parent = SVBox

                local HueBar = Instance.new("TextButton")
                HueBar.Size = UDim2.new(0, 15, 0, 130)
                HueBar.Position = UDim2.new(0, 150, 0, 10)
                HueBar.BorderColor3 = THEMES.BorderColor
                HueBar.Text = ""
                HueBar.AutoButtonColor = false
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

                -- Alpha bar
                local AlphaBar = Instance.new("TextButton")
                AlphaBar.Size = UDim2.new(0, 15, 0, 130)
                AlphaBar.Position = UDim2.new(0, 172, 0, 10)
                AlphaBar.BorderColor3 = THEMES.BorderColor
                AlphaBar.Text = ""
                AlphaBar.AutoButtonColor = false
                AlphaBar.Parent = Body
                CreateGradient(AlphaBar)

                local AlphaGradient = Instance.new("UIGradient")
                AlphaGradient.Rotation = 90
                AlphaGradient.Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1)
                }
                AlphaGradient.Parent = AlphaBar

                local AlphaLbl = Instance.new("TextLabel")
                AlphaLbl.Size = UDim2.new(0, 35, 0, 12)
                AlphaLbl.Position = UDim2.new(0, 152, 0, 143)
                AlphaLbl.BackgroundTransparency = 1
                AlphaLbl.Text = "α"
                AlphaLbl.TextColor3 = THEMES.SubTextColor
                AlphaLbl.Font = Enum.Font.Code
                AlphaLbl.TextSize = 10
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

                table.insert(garbage, SVBox.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingSV = true end
                end))
                table.insert(garbage, HueBar.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingHue = true end
                end))
                table.insert(garbage, AlphaBar.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingAlpha = true end
                end))

                table.insert(garbage, UserInputService.InputChanged:Connect(function(input)
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
                end))

                table.insert(garbage, UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSV, draggingHue, draggingAlpha = false, false, false
                    end
                end))

                table.insert(garbage, Header.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    TweenService:Create(PickerFrame, TweenInfo.new(0.2),
                        {Size = isOpen and UDim2.new(1, 0, 0, 200) or UDim2.new(1, 0, 0, 30)}):Play()
                end))
            end

            -- ────────────────────────────────────────────────────────────────
            -- LABEL
            -- ────────────────────────────────────────────────────────────────
            function SectionFunctions:Label(text: string)
                ElementCount = ElementCount + 1
                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, 0, 0, 20)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = THEMES.TextColor
                Lbl.TextXAlignment = Enum.TextXAlignment.Center
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 12
                Lbl.LayoutOrder = ElementCount
                Lbl.Parent = Container
                return Lbl
            end

            -- ────────────────────────────────────────────────────────────────
            -- PARAGRAPH  (multi-line text block)
            -- ────────────────────────────────────────────────────────────────
            function SectionFunctions:Paragraph(text: string)
                ElementCount = ElementCount + 1
                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, -4, 0, 0) -- -4px padding to prevent edge touching
                Lbl.AutomaticSize = Enum.AutomaticSize.Y -- Auto-scales height to fit wrapped text
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = THEMES.SubTextColor
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.TextYAlignment = Enum.TextYAlignment.Top
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 11
                Lbl.TextWrapped = true
                Lbl.LayoutOrder = ElementCount
                Lbl.Parent = Container
                return Lbl
            end

            -- ────────────────────────────────────────────────────────────────
            -- SEPARATOR  (optional centered label)
            -- ────────────────────────────────────────────────────────────────
            function SectionFunctions:Separator(label: string?)
                ElementCount = ElementCount + 1
                local hasLabel = label and label ~= ""
                local SepFrame = Instance.new("Frame")
                SepFrame.Size = UDim2.new(1, 0, 0, hasLabel and 14 or 6)
                SepFrame.BackgroundTransparency = 1
                SepFrame.LayoutOrder = ElementCount
                SepFrame.Parent = Container

                if hasLabel then
                    local L1 = Instance.new("Frame")
                    L1.Size = UDim2.new(0.25, 0, 0, 1)
                    L1.Position = UDim2.new(0, 0, 0.5, 0)
                    L1.BackgroundColor3 = THEMES.BorderColor
                    L1.BorderSizePixel = 0
                    L1.Parent = SepFrame

                    local Txt = Instance.new("TextLabel")
                    Txt.Size = UDim2.new(0.5, 0, 1, 0)
                    Txt.Position = UDim2.new(0.25, 0, 0, 0)
                    Txt.BackgroundTransparency = 1
                    Txt.Text = label
                    Txt.TextColor3 = THEMES.SubTextColor
                    Txt.Font = Enum.Font.Code
                    Txt.TextSize = 10
                    Txt.Parent = SepFrame

                    local L2 = Instance.new("Frame")
                    L2.Size = UDim2.new(0.25, 0, 0, 1)
                    L2.Position = UDim2.new(0.75, 0, 0.5, 0)
                    L2.BackgroundColor3 = THEMES.BorderColor
                    L2.BorderSizePixel = 0
                    L2.Parent = SepFrame
                else
                    local L = Instance.new("Frame")
                    L.Size = UDim2.new(1, 0, 0, 1)
                    L.Position = UDim2.new(0, 0, 0.5, 0)
                    L.BackgroundColor3 = THEMES.BorderColor
                    L.BorderSizePixel = 0
                    L.Parent = SepFrame
                end
            end

            -- ────────────────────────────────────────────────────────────────
            -- SPACER  (invisible vertical gap)
            -- ────────────────────────────────────────────────────────────────
            function SectionFunctions:Spacer(height: number?)
                ElementCount = ElementCount + 1
                local Sp = Instance.new("Frame")
                Sp.Size = UDim2.new(1, 0, 0, height or 8)
                Sp.BackgroundTransparency = 1
                Sp.LayoutOrder = ElementCount
                Sp.Parent = Container
            end

            -- ────────────────────────────────────────────────────────────────
            -- PROGRESS BAR  (display-only, returns :Set(val))
            -- ────────────────────────────────────────────────────────────────
            function SectionFunctions:ProgressBar(text: string, min: number, max: number, default: number, flag: string)
                ElementCount = ElementCount + 1
                min = min or 0; max = max or 100; default = default or min
                local current = default
                if flag then WindowRoot.Flags[flag] = current end

                local PBFrame = Instance.new("Frame")
                PBFrame.Size = UDim2.new(1, 0, 0, 30)
                PBFrame.BackgroundTransparency = 1
                PBFrame.LayoutOrder = ElementCount
                PBFrame.Parent = Container

                local TextLbl = Instance.new("TextLabel")
                TextLbl.Size = UDim2.new(0.65, 0, 0, 14)
                TextLbl.BackgroundTransparency = 1
                TextLbl.Text = text
                TextLbl.TextColor3 = THEMES.TextColor
                TextLbl.TextXAlignment = Enum.TextXAlignment.Left
                TextLbl.Font = Enum.Font.Code
                TextLbl.TextSize = 12
                TextLbl.Parent = PBFrame

                local ValueLbl = Instance.new("TextLabel")
                ValueLbl.Size = UDim2.new(0.35, 0, 0, 14)
                ValueLbl.Position = UDim2.new(0.65, 0, 0, 0)
                ValueLbl.BackgroundTransparency = 1
                ValueLbl.Text = tostring(math.floor(default)) .. " / " .. tostring(max)
                ValueLbl.TextColor3 = THEMES.LineColor
                ValueLbl.TextXAlignment = Enum.TextXAlignment.Right
                ValueLbl.Font = Enum.Font.Code
                ValueLbl.TextSize = 11
                ValueLbl.Parent = PBFrame

                local Track = Instance.new("Frame")
                Track.Size = UDim2.new(1, 0, 0, 8)
                Track.Position = UDim2.new(0, 0, 0, 18)
                Track.BackgroundColor3 = THEMES.FrameColor
                Track.BorderColor3 = THEMES.BorderColor
                Track.Parent = PBFrame
                CreateGradient(Track)

                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new(math.clamp((current - min) / (max - min), 0, 1), 0, 1, 0)
                Fill.BackgroundColor3 = THEMES.LineColor
                Fill.BorderSizePixel = 0
                Fill.Parent = Track

                local Obj = {}
                function Obj:Set(val)
                    current = math.clamp(val, min, max)
                    local ratio = (current - min) / (max - min)
                    TweenService:Create(Fill, TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                        {Size = UDim2.new(ratio, 0, 1, 0)}):Play()
                    ValueLbl.Text = tostring(math.floor(current)) .. " / " .. tostring(max)
                    if flag then WindowRoot.Flags[flag] = current end
                end

                if flag then WindowRoot.Setters[flag] = function(v) Obj:Set(v) end end
                return Obj
            end

            -- ────────────────────────────────────────────────────────────────
            -- STATUS INDICATOR  (dot + text, returns :Set(text, color))
            -- ────────────────────────────────────────────────────────────────
            function SectionFunctions:StatusIndicator(label: string, initialText: string, initialColor: Color3)
                ElementCount = ElementCount + 1
                initialColor = initialColor or THEMES.SuccessColor

                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 15)
                Frame.BackgroundTransparency = 1
                Frame.LayoutOrder = ElementCount
                Frame.Parent = Container

                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(0.5, 0, 1, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = label
                Lbl.TextColor3 = THEMES.TextColor
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Font = Enum.Font.Code
                Lbl.TextSize = 12
                Lbl.Parent = Frame

                local Dot = Instance.new("Frame")
                Dot.Size = UDim2.new(0, 7, 0, 7)
                Dot.Position = UDim2.new(0.5, 3, 0.5, -3)
                Dot.BackgroundColor3 = initialColor
                Dot.BorderSizePixel = 0
                Dot.Parent = Frame
                RoundCorner(Dot, 1)

                local StatusLbl = Instance.new("TextLabel")
                StatusLbl.Size = UDim2.new(0.45, 0, 1, 0)
                StatusLbl.Position = UDim2.new(0.55, 0, 0, 0)
                StatusLbl.BackgroundTransparency = 1
                StatusLbl.Text = initialText or "Unknown"
                StatusLbl.TextColor3 = initialColor
                StatusLbl.TextXAlignment = Enum.TextXAlignment.Right
                StatusLbl.Font = Enum.Font.Code
                StatusLbl.TextSize = 12
                StatusLbl.Parent = Frame

                local Obj = {}
                function Obj:Set(statusText: string, color: Color3)
                    color = color or initialColor
                    StatusLbl.Text = statusText
                    StatusLbl.TextColor3 = color
                    TweenService:Create(Dot, TweenInfo.new(0.3), {BackgroundColor3 = color}):Play()
                end
                return Obj
            end

            -- ────────────────────────────────────────────────────────────────
            -- ALERT  (info / warn / error / success banner)
            -- ────────────────────────────────────────────────────────────────
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

                -- Estimate height based on text length
                local lines = math.max(1, math.ceil(#alertText / 30))
                local h = lines * 14 + 14

                local AlertFrame = Instance.new("Frame")
                AlertFrame.Size = UDim2.new(1, 0, 0, h)
                AlertFrame.BackgroundColor3 = THEMES.FrameColor
                AlertFrame.BorderColor3 = alertColor
                AlertFrame.LayoutOrder = ElementCount
                AlertFrame.Parent = Container
                CreateGradient(AlertFrame)

                -- Left accent bar
                local Accent = Instance.new("Frame")
                Accent.Size = UDim2.new(0, 2, 1, 0)
                Accent.BackgroundColor3 = alertColor
                Accent.BorderSizePixel = 0
                Accent.Parent = AlertFrame

                local IconLbl = Instance.new("TextLabel")
                IconLbl.Size = UDim2.new(0, 18, 1, 0)
                IconLbl.Position = UDim2.new(0, 6, 0, 0)
                IconLbl.BackgroundTransparency = 1
                IconLbl.Text = icon
                IconLbl.TextColor3 = alertColor
                IconLbl.Font = Enum.Font.Code
                IconLbl.TextSize = 13
                IconLbl.Parent = AlertFrame

                local TextLbl = Instance.new("TextLabel")
                TextLbl.Size = UDim2.new(1, -30, 1, 0)
                TextLbl.Position = UDim2.new(0, 28, 0, 0)
                TextLbl.BackgroundTransparency = 1
                TextLbl.Text = alertText
                TextLbl.TextColor3 = THEMES.TextColor
                TextLbl.TextXAlignment = Enum.TextXAlignment.Left
                TextLbl.TextYAlignment = Enum.TextYAlignment.Center
                TextLbl.TextWrapped = true
                TextLbl.Font = Enum.Font.Code
                TextLbl.TextSize = 11
                TextLbl.Parent = AlertFrame
            end

            -- ────────────────────────────────────────────────────────────────
            -- IMAGE  (displays an rbxassetid image)
            -- ────────────────────────────────────────────────────────────────
            function SectionFunctions:Image(assetId: number | string, height: number?)
                ElementCount = ElementCount + 1
                height = height or 80

                local Img = Instance.new("ImageLabel")
                Img.Size = UDim2.new(1, 0, 0, height)
                Img.BackgroundTransparency = 1
                Img.Image = "rbxassetid://" .. tostring(assetId)
                Img.ScaleType = Enum.ScaleType.Fit
                Img.LayoutOrder = ElementCount
                Img.Parent = Container
                return Img
            end

            -- ────────────────────────────────────────────────────────────────
            -- KEY-VALUE TABLE  (alternating-row data grid)
            --   rows = { {"Key", "Value"}, ... }
            --   returns :SetValue(key, value)
            -- ────────────────────────────────────────────────────────────────
            function SectionFunctions:KeyValueTable(rows: table)
                ElementCount = ElementCount + 1
                local rowH = 17
                local totalH = #rows * rowH

                local TableFrame = Instance.new("Frame")
                TableFrame.Size = UDim2.new(1, 0, 0, totalH)
                TableFrame.BackgroundTransparency = 1
                TableFrame.LayoutOrder = ElementCount
                TableFrame.Parent = Container

                local valueLabels = {}

                for i, row in ipairs(rows) do
                    local RowBg = Instance.new("Frame")
                    RowBg.Size = UDim2.new(1, 0, 0, rowH)
                    RowBg.Position = UDim2.new(0, 0, 0, (i - 1) * rowH)
                    RowBg.BackgroundColor3 = i % 2 == 0 and THEMES.FrameColor or THEMES.MainColor
                    RowBg.BackgroundTransparency = 0.3
                    RowBg.BorderSizePixel = 0
                    RowBg.Parent = TableFrame

                    local KeyLbl = Instance.new("TextLabel")
                    KeyLbl.Size = UDim2.new(0.5, -2, 1, 0)
                    KeyLbl.Position = UDim2.new(0, 4, 0, 0)
                    KeyLbl.BackgroundTransparency = 1
                    KeyLbl.Text = tostring(row[1])
                    KeyLbl.TextColor3 = THEMES.SubTextColor
                    KeyLbl.TextXAlignment = Enum.TextXAlignment.Left
                    KeyLbl.Font = Enum.Font.Code
                    KeyLbl.TextSize = 11
                    KeyLbl.Parent = RowBg

                    local ValLbl = Instance.new("TextLabel")
                    ValLbl.Size = UDim2.new(0.5, -4, 1, 0)
                    ValLbl.Position = UDim2.new(0.5, 0, 0, 0)
                    ValLbl.BackgroundTransparency = 1
                    ValLbl.Text = tostring(row[2])
                    ValLbl.TextColor3 = THEMES.TextColor
                    ValLbl.TextXAlignment = Enum.TextXAlignment.Right
                    ValLbl.Font = Enum.Font.Code
                    ValLbl.TextSize = 11
                    ValLbl.Parent = RowBg

                    valueLabels[tostring(row[1])] = ValLbl
                end

                local Obj = {}
                function Obj:SetValue(key: string, value)
                    local lbl = valueLabels[tostring(key)]
                    if lbl then lbl.Text = tostring(value) end
                end
                return Obj
            end

            return SectionFunctions
        end -- Section

        return TabFunctions
    end -- Tab

    return self
end -- Library.new

-- ─────────────────────────────────────────────────────────────────────────────
-- BUILT-IN SETTINGS TAB
-- ─────────────────────────────────────────────────────────────────────────────

function Library:BuildSettingsTab()
    local ConfigTab = self:Tab("Settings")
    local SettingsSection = ConfigTab:Section("Configuration")

    local ConfigName = ""
    local SelectedConfig = ""

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
    local Dropdown = SettingsSection:Dropdown("Select Config", GetConfigs(), false, nil, nil, function(val) SelectedConfig = val end)

    SettingsSection:CreateButtonRow("Save Config", function()
        local name = ConfigName ~= "" and ConfigName or SelectedConfig
        if name == "" then return self:Notify("Error", "Please enter a config name.", 3) end
        local ok, err = pcall(function()
            writefile(self.ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(self.Flags))
        end)
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
                if self.Setters[flag] then self.Setters[flag](value) end
            end
            self:Notify("Loaded", "Config '" .. SelectedConfig .. "' applied.", 3)
        else
            self:Notify("Error", "Failed to parse config.", 5)
        end
    end)

    SettingsSection:Button("Refresh List", function()
        Dropdown:Refresh(GetConfigs())
        self:Notify("Refreshed", "Config list updated.", 2)
    end)

    local InfoSection = ConfigTab:Section("About")
    InfoSection:Label("Heartkiss UI Library")
    InfoSection:Separator()
    InfoSection:Label("Press keybind to toggle UI")
    InfoSection:Separator("─────")
    InfoSection:StatusIndicator("Status", "Active", THEMES.SuccessColor)
end

return Library