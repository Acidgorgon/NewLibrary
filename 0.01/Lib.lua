local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Executor File System Fallbacks (Prevents errors on unsupported executors)
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
    MainColor = Color3.fromRGB(30, 30, 30),
    FrameColor = Color3.fromRGB(25, 25, 25),
    TabColor = Color3.fromRGB(24, 24, 24),
    LineColor = Color3.fromRGB(243, 117, 255),
    BorderColor = Color3.fromRGB(70, 70, 70),
    DarkColor = Color3.fromRGB(0, 0, 0),
    SelectedTab = Color3.fromRGB(252, 175, 248),
    TextColor = Color3.fromRGB(255, 255, 255),
    ButtonBorderColor = Color3.fromRGB(27, 27, 27)
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

function Library:Notify(title: string, text: string, duration: number)
    duration = duration or 3
    if not self.NotifyLayout then return end

    -- Create an invisible holder so UIListLayout doesn't fight our X-axis tween
    local Holder = Instance.new("Frame")
    Holder.BackgroundTransparency = 1
    Holder.Size = UDim2.new(1, 0, 0, 50)
    Holder.Parent = self.NotifyLayout

    local Notif = Instance.new("Frame")
    Notif.Size = UDim2.new(1, 0, 1, 0)
    Notif.BackgroundColor3 = THEMES.MainColor
    Notif.BorderColor3 = THEMES.LineColor
    Notif.Position = UDim2.new(1, 30, 0, 0) -- Start slightly off-screen to the right
    Notif.BackgroundTransparency = 1 -- Start fully transparent
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

    -- Smooth entrance: Slide left and fade in simultaneously
    local tweenIn = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(Notif, tweenIn, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0}):Play()
    TweenService:Create(Title, tweenIn, {TextTransparency = 0}):Play()
    TweenService:Create(Desc, tweenIn, {TextTransparency = 0}):Play()

    -- Cleanup routine
    task.delay(duration, function()
        -- Smooth exit: Slide right and fade out
        local tweenOut = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        TweenService:Create(Notif, tweenOut, {Position = UDim2.new(1, 30, 0, 0), BackgroundTransparency = 1}):Play()
        TweenService:Create(Title, tweenOut, {TextTransparency = 1}):Play()
        TweenService:Create(Desc, tweenOut, {TextTransparency = 1}):Play()
        
        -- Wait for the exit animation to finish before destroying
        task.delay(0.4, function()
            Holder:Destroy()
        end)
    end)
end

function Library:Unload() CleanID(self.Name) end

function Library.new(Name: string, Size: UDim2, KeyBind: Enum.UserInputType | Enum.KeyCode)
    local self = setmetatable({}, Library)
    local WindowRoot = self

    self.Name = Name or "Heartkiss"
    self.Size = Size or UDim2.fromScale(488, 518)
    self.Tabs = {}
    self.KeyBind = KeyBind or Enum.KeyCode.RightControl
    
    self.Flags = {}
    self.Setters = {}
    self.ConfigFolder = self.Name .. "_Configs"
    if not isfolder(self.ConfigFolder) then makefolder(self.ConfigFolder) end

    CleanID(self.Name)
    getgenv()._Heartkiss_Garbage[self.Name] = {}
    local garbage = getgenv()._Heartkiss_Garbage[self.Name]

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = self.Name
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) elseif protectgui then protectgui(ScreenGui) end
    ScreenGui.Parent = CoreGui
    table.insert(garbage, ScreenGui)

    local NotifyGui = Instance.new("ScreenGui")
    NotifyGui.Name = self.Name .. "_Notifications"
    if syn and syn.protect_gui then syn.protect_gui(NotifyGui) elseif protectgui then protectgui(NotifyGui) end
    NotifyGui.Parent = CoreGui
    table.insert(garbage, NotifyGui)

    local NotifyPosition = "TopRight"

    local NotifyLayout = Instance.new("Frame")
    NotifyLayout.Name = "Layout"
    NotifyLayout.BackgroundTransparency = 1
    NotifyLayout.Size = UDim2.new(0, 250, 1, -40)
    NotifyLayout.Position = UDim2.new(1, -260, 0, 20)
    NotifyLayout.Parent = NotifyGui
    
    local NotifyList = Instance.new("UIListLayout")
    NotifyList.SortOrder = Enum.SortOrder.LayoutOrder
    NotifyList.VerticalAlignment = NotifyPosition == "TopRight" and Enum.VerticalAlignment.Top or Enum.VerticalAlignment.Bottom
    NotifyList.Padding = UDim.new(0, 10)
    NotifyList.Parent = NotifyLayout

    self.NotifyLayout = NotifyLayout

    local MainFrame = Instance.new("Frame")
    local Frame = Instance.new("Frame")
    local Line = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local Tabs = Instance.new("Frame")
    local ScrollingFrame = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")
    local FrameHolder = Instance.new("Frame")

    local UIDragDetector = Instance.new("UIDragDetector")
    UIDragDetector.Parent = MainFrame

    MainFrame.Name = "MainFrame"
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = THEMES.MainColor
    MainFrame.BorderColor3 = THEMES.LineColor
    MainFrame.Position = UDim2.new(0.5, 0, 0.463, 0)
    MainFrame.Size = UDim2.new(0, 488, 0, 518)
    MainFrame.Parent = ScreenGui
    CreateGradient(MainFrame)

    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = THEMES.FrameColor
    Frame.BorderColor3 = Color3.fromRGB(98, 98, 98)
    Frame.Position = UDim2.new(0.498, 0, 0.508, 0)
    Frame.Size = UDim2.new(0.959, 0, 0.943, 0)
    Frame.ZIndex = 1
    Frame.Parent = MainFrame
    CreateGradient(Frame)

    Line.Name = "Line"
    Line.AnchorPoint = Vector2.new(0.5, 0.5)
    Line.BackgroundColor3 = THEMES.LineColor
    Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Line.BorderSizePixel = 0
    Line.Position = UDim2.new(0.5, 0, 0, 0)
    Line.Size = UDim2.new(1, 0, 0.002, 0)
    Line.Parent = Frame

    Title.Name = "Title"
    Title.AnchorPoint = Vector2.new(0.5, 0.5)
    Title.Position = UDim2.new(0.498, 0, 0.020, 0)
    Title.Size = UDim2.new(0, 468, 0, 17)
    Title.Font = Enum.Font.SourceSans
    Title.Text = Name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.TextScaled = true
    Title.TextWrapped = true
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = MainFrame

    Tabs.Name = "Tabs"
    Tabs.AnchorPoint = Vector2.new(0.5, 0.5)
    Tabs.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    Tabs.BorderColor3 = THEMES.BorderColor
    Tabs.Position = UDim2.new(0.498, 0, 0.095, 0)
    Tabs.Size = UDim2.new(0.917, 0, 0.058, 0)
    Tabs.Parent = MainFrame

    ScrollingFrame.Active = true
    ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ScrollingFrame.BackgroundTransparency = 1.000
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    ScrollingFrame.Size = UDim2.new(1, 0, 0.952, 0)
    ScrollingFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.Always
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X 
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
    ScrollingFrame.ScrollBarThickness = 0
    ScrollingFrame.Parent = Tabs

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollingFrame
    
    FrameHolder.Name = "FrameHolder"
    FrameHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    FrameHolder.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    FrameHolder.BorderColor3 = THEMES.BorderColor
    FrameHolder.Position = UDim2.new(0.498, 0, 0.533, 0)
    FrameHolder.Size = UDim2.new(0.917, 0, 0.859, 0)
    FrameHolder.Parent = MainFrame
    CreateGradient(FrameHolder)

    self.Frames = {
        MainFrame = MainFrame,
        Frame = Frame,
        Title = Title,
        Tabs = Tabs,
        FrameHolder = FrameHolder
    }

    local inputCon = UserInputService.InputBegan:Connect(function(Input, GPE)
        if GPE then return end
        if Input.KeyCode == self.KeyBind or Input.UserInputType == self.KeyBind then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)
    table.insert(garbage, inputCon)

    function self:Tab(text: string)
        local Tab = Instance.new("TextButton")
        Tab.Name = text
        Tab.BackgroundColor3 = THEMES.TabColor 
        Tab.BorderColor3 = Color3.fromRGB(112, 112, 112)
        Tab.Size = UDim2.new(0, 47, 0, 19)
        Tab.Font = Enum.Font.Code
        Tab.Text = " " .. text .. " "
        Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        Tab.TextScaled = true
        Tab.TextSize = 14.000
        Tab.Parent = self.Frames.Tabs.ScrollingFrame
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
        Page.Parent = self.Frames.FrameHolder
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
            local leftH = LeftList.AbsoluteContentSize.Y
            local rightH = RightList.AbsoluteContentSize.Y
            Page.CanvasSize = UDim2.new(0, 0, 0, math.max(leftH, rightH) + 20)
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

        if #self.Tabs == 0 then Page.Visible = true end
        table.insert(self.Tabs, {Button = Tab, Page = Page})

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

            function SectionFunctions:Button(text, callback)
                ElementCount = ElementCount + 1
                callback = callback or function() end
                local Btn = CreateButton()
                Btn.Text = text
                Btn.LayoutOrder = ElementCount
                Btn.Parent = Container

                table.insert(garbage, Btn.MouseButton1Click:Connect(callback))
            end

            function SectionFunctions:Toggle(text: string, default: boolean, flag: string, callback: () -> ())
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

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -20, 1, 0)
                Label.Position = UDim2.new(0, 18, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = THEMES.TextColor
                Label.TextXAlignment = Enum.TextXAlignment.Left 
                Label.Font = Enum.Font.Code
                Label.TextSize = 12
                Label.Parent = ToggleBtn

                local function UpdateVisuals(state)
                    enabled = state
                    if flag then WindowRoot.Flags[flag] = enabled end
                    TweenService:Create(CheckMark, TweenInfo.new(0.2), {BackgroundColor3 = enabled and THEMES.LineColor or THEMES.FrameColor}):Play()
                    callback(enabled)
                end

                if flag then WindowRoot.Setters[flag] = UpdateVisuals end

                table.insert(garbage, ToggleBtn.MouseButton1Click:Connect(function() UpdateVisuals(not enabled) end))
            end
            
            function SectionFunctions:Dropdown(text: string, options: table, multi: boolean, default, flag: string, callback: () -> ())
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

                local Title = Instance.new("TextLabel")
                Title.Size = UDim2.new(1, -20, 1, 0)
                Title.Position = UDim2.new(0, 5, 0, 0)
                Title.BackgroundTransparency = 1
                Title.Text = text .. " : Select..."
                Title.TextColor3 = THEMES.TextColor
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.Font = Enum.Font.Code
                Title.TextSize = 12
                Title.Parent = Header
                
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
                        Title.Text = text .. (#selectedValues == 0 and " : Select..." or " : [" .. table.concat(selectedValues, ", ") .. "]")
                    else
                        Title.Text = text .. " : " .. (selectedValues == "" and "Select..." or selectedValues)
                    end
                end

                local function BuildOptions(newOptions)
                    for _, child in OptionContainer:GetChildren() do if child:IsA("TextButton") then child:Destroy() end end
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
                                local index = table.find(selectedValues, opt)
                                if index then table.remove(selectedValues, index); OptBtn.TextColor3 = THEMES.TextColor
                                else table.insert(selectedValues, opt); OptBtn.TextColor3 = THEMES.LineColor end
                            else
                                selectedValues = opt
                                for _, btn in OptionContainer:GetChildren() do if btn:IsA("TextButton") then btn.TextColor3 = THEMES.TextColor end end
                                OptBtn.TextColor3 = THEMES.LineColor
                                isDropped = false
                                Icon.Text = "+"
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
                        UpdateTitle()
                        BuildOptions(dropdownOptions)
                        callback(selectedValues)
                    end
                end

                BuildOptions(options)
                UpdateTitle()

                table.insert(garbage, Header.MouseButton1Click:Connect(function()
                    isDropped = not isDropped
                    Icon.Text = isDropped and "-" or "+"
                    local openHeight = isDropped and (30 + (#dropdownOptions * 22) + 5) or 30
                    TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, openHeight)}):Play()
                end))

                local DropdownObject = {}
                function DropdownObject:Refresh(newList) BuildOptions(newList) end
                return DropdownObject
            end

            function SectionFunctions:Label(text: string)
                ElementCount = ElementCount + 1 
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 20)
                Label.Position = UDim2.fromScale(0.5, 1)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = THEMES.TextColor
                Label.TextXAlignment = Enum.TextXAlignment.Center
                Label.Font = Enum.Font.Code
                Label.TextSize = 12
                Label.LayoutOrder = ElementCount 
                Label.Parent = Container
                return Label
            end

            -- ADDED: CreateButtonRow restored
            function SectionFunctions:CreateButtonRow(text1, callback1, text2, callback2)
                ElementCount = ElementCount + 1
                local RowFrame = Instance.new("Frame")
                RowFrame.Size = UDim2.new(1, 0, 0, 22)
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
            end

            function SectionFunctions:Slider(text: string, min: number, max: number, default: number, decimals: number, flag: string, callback: () -> ())
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

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 15)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = THEMES.TextColor
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Font = Enum.Font.Code
                Label.TextSize = 12
                Label.Parent = SliderFrame

                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Size = UDim2.new(1, 0, 0, 15)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(default)
                ValueLabel.TextColor3 = THEMES.TextColor
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.Font = Enum.Font.Code
                ValueLabel.TextSize = 12
                ValueLabel.Parent = SliderFrame

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
                    ValueLabel.Text = string.format("%." .. decimals .. "f", rounded)
                    
                    if flag then WindowRoot.Flags[flag] = rounded end
                    callback(rounded)
                end

                local function Update(input)
                    local SizeX = math.clamp((input.Position.X - SlideBar.AbsolutePosition.X) / SlideBar.AbsoluteSize.X, 0, 1)
                    local rawValue = min + ((max - min) * SizeX)
                    SetValue(rawValue)
                end

                if flag then WindowRoot.Setters[flag] = SetValue end

                table.insert(garbage, SlideBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; Update(input) end
                end))
                table.insert(garbage, UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end))
                table.insert(garbage, UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
                end))
            end

            function SectionFunctions:Bind(text: string, defaultKey: Enum.KeyCode, flag: string, callback: () -> ())
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

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -65, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = THEMES.TextColor
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Font = Enum.Font.Code
                Label.TextSize = 12
                Label.Parent = KeybindFrame

                local BindBtn = Instance.new("TextButton")
                BindBtn.Size = UDim2.new(0, 60, 1, 0)
                BindBtn.Position = UDim2.new(1, -60, 0, 0)
                BindBtn.BackgroundColor3 = THEMES.FrameColor
                BindBtn.BorderColor3 = THEMES.BorderColor
                BindBtn.Text = "[" .. (CurrentKey.Name) .. "]"
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
                    elseif not processed and CurrentKey ~= Enum.KeyCode.Unknown and (input.KeyCode == CurrentKey) then
                         callback()
                    end
                end))
            end

            function SectionFunctions:Input(text: string, placeholder: string, flag: string, callback: () -> ())
                ElementCount = ElementCount + 1
                callback = callback or function() end

                if flag then WindowRoot.Flags[flag] = "" end

                local InputFrame = Instance.new("Frame")
                InputFrame.Size = UDim2.new(1, 0, 0, 40)
                InputFrame.BackgroundTransparency = 1
                InputFrame.LayoutOrder = ElementCount
                InputFrame.Parent = Container

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 15)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = THEMES.TextColor
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Font = Enum.Font.Code
                Label.TextSize = 12
                Label.Parent = InputFrame

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

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -40, 1, 0)
                Label.Position = UDim2.new(0, 5, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = THEMES.TextColor
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Font = Enum.Font.Code
                Label.TextSize = 12
                Label.Parent = Header

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
                ValOverlay.BackgroundColor3 = Color3.new(0,0,0)
                ValOverlay.BorderSizePixel = 0
                ValOverlay.Parent = SVBox
                
                local ValGradient = Instance.new("UIGradient")
                ValGradient.Rotation = 90
                ValGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}
                ValGradient.Parent = ValOverlay

                local SVCursor = Instance.new("Frame")
                SVCursor.Size = UDim2.new(0, 4, 0, 4)
                SVCursor.BackgroundColor3 = Color3.new(1,1,1)
                SVCursor.BorderColor3 = Color3.new(0,0,0)
                SVCursor.Rotation = 45
                SVCursor.ZIndex = 3
                SVCursor.Parent = SVBox

                local HueBar = Instance.new("TextButton")
                HueBar.Size = UDim2.new(0, 15, 0, 130)
                HueBar.Position = UDim2.new(0, 150, 0, 10)
                HueBar.BorderColor3 = THEMES.BorderColor
                HueBar.Text = ""
                HueBar.AutoButtonColor = false
                HueBar.Parent = Body

                -- ADDED: Restored the full 7-point gradient so the rainbow works properly
                local HueGradient = Instance.new("UIGradient")
                HueGradient.Rotation = 90
                HueGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0.00, Color3.fromHSV(1,1,1)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.83,1,1)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.66,1,1)),
                    ColorSequenceKeypoint.new(0.50, Color3.fromHSV(0.5,1,1)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.33,1,1)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.16,1,1)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromHSV(0,1,1))
                }
                HueGradient.Parent = HueBar

                local function UpdateColor()
                    local newColor = Color3.fromHSV(h, s, v)
                    CurrentColorFrame.BackgroundColor3 = newColor
                    CurrentColorFrame.BackgroundTransparency = 1 - a
                    SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1) 
                    
                    if flag then WindowRoot.Flags[flag] = {R = newColor.R, G = newColor.G, B = newColor.B, A = a} end
                    callback(newColor, a)
                end

                if flag then
                    WindowRoot.Setters[flag] = function(colorData)
                        if type(colorData) == "table" then
                            local newC = Color3.new(colorData.R, colorData.G, colorData.B)
                            h, s, v = Color3.toHSV(newC)
                            a = colorData.A
                            SVCursor.Position = UDim2.new(1-s, -2, 1-v, -2)
                            UpdateColor()
                        end
                    end
                end

                local draggingSV, draggingHue = false, false

                table.insert(garbage, SVBox.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingSV = true end end))
                table.insert(garbage, HueBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingHue = true end end))
                
                table.insert(garbage, UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        if draggingSV then
                            s = 1 - math.clamp((input.Position.X - SVBox.AbsolutePosition.X) / SVBox.AbsoluteSize.X, 0, 1)
                            v = 1 - math.clamp((input.Position.Y - SVBox.AbsolutePosition.Y) / SVBox.AbsoluteSize.Y, 0, 1)
                            SVCursor.Position = UDim2.new(1-s, -2, 1-v, -2)
                            UpdateColor()
                        elseif draggingHue then
                            h = 1 - math.clamp((input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
                            UpdateColor()
                        end
                    end
                end))

                table.insert(garbage, UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingSV, draggingHue = false, false end
                end))

                table.insert(garbage, Header.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    TweenService:Create(PickerFrame, TweenInfo.new(0.2), {Size = isOpen and UDim2.new(1, 0, 0, 195) or UDim2.new(1, 0, 0, 30)}):Play()
                end))
            end

            return SectionFunctions
        end

        return TabFunctions
    end

    return self
end

-----------------------------
-- BUILT-IN SETTINGS TAB
-----------------------------

function Library:BuildSettingsTab()
    local ConfigTab = self:Tab("UI Settings")
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

    -- Uses CreateButtonRow correctly now!
    SettingsSection:CreateButtonRow("Save Config", function()
        local name = ConfigName ~= "" and ConfigName or SelectedConfig
        if name == "" then return self:Notify("Error", "Please enter a config name.", 3) end
        
        local success, err = pcall(function()
            writefile(self.ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(self.Flags))
        end)
        
        if success then
            self:Notify("Success", "Saved config: " .. name, 3)
            Dropdown:Refresh(GetConfigs())
        else
            self:Notify("Error", "Failed to save: " .. tostring(err), 5)
        end
    end, "Load Config", function()
        if SelectedConfig == "" then return self:Notify("Error", "Please select a config.", 3) end
        
        local path = self.ConfigFolder .. "/" .. SelectedConfig .. ".json"
        if not isfile(path) then return self:Notify("Error", "Config file not found.", 3) end
        
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
        
        if success and type(data) == "table" then
            for flag, value in pairs(data) do
                if self.Setters[flag] then self.Setters[flag](value) end
            end
            self:Notify("Success", "Loaded config: " .. SelectedConfig, 3)
        else
            self:Notify("Error", "Failed to load/parse JSON.", 5)
        end
    end)
    
    SettingsSection:Button("Refresh List", function()
        Dropdown:Refresh(GetConfigs())
        self:Notify("Refreshed", "Config list updated.", 2)
    end)
end

return Library