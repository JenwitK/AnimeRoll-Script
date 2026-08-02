--!strict
-- Galaxy Hub UI - Bundled for Executor (Single Script)

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local cloneref = (cloneref or clonereference or function(instance) return instance end)
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local HttpService = cloneref(game:GetService("HttpService"))

local Modules = {}

--------------------------------------------------------------------------------
-- 1. THEME: Palette
--------------------------------------------------------------------------------
Modules.Palette = (function()
    local Palette = {}
    Palette.Colors = {
        Background = Color3.fromRGB(15, 15, 18),
        Secondary = Color3.fromRGB(22, 22, 30),
        SectionBg = Color3.fromRGB(18, 18, 24),
        Accent = Color3.fromHex("#7B2FFF"), -- Cyan/Purple theme from WindUI
        Hover = Color3.fromHex("#9D55FF"),
        TextPrimary = Color3.fromRGB(248, 250, 252),
        TextMuted = Color3.fromRGB(148, 163, 184),
        BorderStroke = Color3.fromRGB(45, 45, 55),
        Red = Color3.fromHex("#ff4830"),
        Green = Color3.fromHex("#10C550"),
        Blue = Color3.fromHex("#257AF7"),
    }
    Palette.Opacities = { Background = 0.85, Secondary = 0.9 }
    Palette.Tokens = { BorderRadius = UDim.new(0, 8), StrokeThickness = 1, FontPrimary = Enum.Font.Gotham }
    return Palette
end)()

--------------------------------------------------------------------------------
-- 2. ANIMATIONS: ButtonAnimations
--------------------------------------------------------------------------------
Modules.ButtonAnimations = (function()
    local Palette = Modules.Palette
    local ButtonAnimations = {}
    function ButtonAnimations.BindHoverAndClick(button: TextButton)
        local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local hoverTween = TweenService:Create(button, info, {BackgroundColor3 = Color3.fromRGB(200, 200, 200)})
        local leaveTween = TweenService:Create(button, info, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
        button.MouseEnter:Connect(function() hoverTween:Play() end)
        button.MouseLeave:Connect(function() leaveTween:Play() end)
        button.MouseButton1Down:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {
                Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset - 4, button.Size.Y.Scale, button.Size.Y.Offset - 4)
            }):Play()
        end)
        button.MouseButton1Up:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset + 4, button.Size.Y.Scale, button.Size.Y.Offset + 4)
            }):Play()
        end)
    end
    function ButtonAnimations.BindSecondaryHoverAndClick(button: TextButton)
        local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local hoverTween = TweenService:Create(button, info, {BackgroundColor3 = Palette.Colors.BorderStroke})
        local leaveTween = TweenService:Create(button, info, {BackgroundColor3 = Palette.Colors.Secondary})
        button.MouseEnter:Connect(function() hoverTween:Play() end)
        button.MouseLeave:Connect(function() leaveTween:Play() end)
        button.MouseButton1Down:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {
                Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset - 2, button.Size.Y.Scale, button.Size.Y.Offset - 2)
            }):Play()
        end)
        button.MouseButton1Up:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset + 2, button.Size.Y.Scale, button.Size.Y.Offset + 2)
            }):Play()
        end)
    end
    return ButtonAnimations
end)()

--------------------------------------------------------------------------------
-- 3. BASE COMPONENTS
--------------------------------------------------------------------------------
Modules.FrameFactory = (function()
    local Palette = Modules.Palette
    local FrameFactory = {}
    function FrameFactory.new(name: string, parent: Instance?): Frame
        local frame = Instance.new("Frame")
        frame.Name = name
        frame.BackgroundColor3 = Palette.Colors.Background
        frame.BackgroundTransparency = 1 - Palette.Opacities.Background
        frame.BorderSizePixel = 0
        if parent then frame.Parent = parent end
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = Palette.Tokens.BorderRadius
        uiCorner.Parent = frame
        local uiStroke = Instance.new("UIStroke")
        uiStroke.Thickness = Palette.Tokens.StrokeThickness
        uiStroke.Color = Palette.Colors.BorderStroke
        uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        uiStroke.Parent = frame
        return frame
    end
    return FrameFactory
end)()

Modules.ScrollingFrameFactory = (function()
    local ScrollingFrameFactory = {}
    function ScrollingFrameFactory.new(name: string, parent: Instance?): ScrollingFrame
        local sf = Instance.new("ScrollingFrame")
        sf.Name = name
        sf.BackgroundTransparency = 1
        sf.BorderSizePixel = 0
        sf.ScrollBarThickness = 2
        sf.ScrollBarImageColor3 = Modules.Palette.Colors.Accent
        if parent then sf.Parent = parent end
        return sf
    end
    return ScrollingFrameFactory
end)()

Modules.TextButtonFactory = (function()
    local Palette = Modules.Palette
    local TextButtonFactory = {}
    function TextButtonFactory.new(name: string, text: string, parent: Instance?): TextButton
        local button = Instance.new("TextButton")
        button.Name = name
        button.Text = text
        button.Font = Palette.Tokens.FontPrimary
        button.TextSize = 14
        button.TextColor3 = Palette.Colors.TextPrimary
        button.BackgroundColor3 = Palette.Colors.Secondary
        button.AutoButtonColor = false
        button.BorderSizePixel = 0
        if parent then button.Parent = parent end
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = Palette.Tokens.BorderRadius
        uiCorner.Parent = button
        return button
    end
    return TextButtonFactory
end)()

Modules.TextLabelFactory = (function()
    local Palette = Modules.Palette
    local TextLabelFactory = {}
    function TextLabelFactory.new(name: string, text: string, parent: Instance?): TextLabel
        local label = Instance.new("TextLabel")
        label.Name = name
        label.Text = text
        label.Font = Palette.Tokens.FontPrimary
        label.TextSize = 16
        label.TextColor3 = Palette.Colors.TextPrimary
        label.BackgroundTransparency = 1
        label.BorderSizePixel = 0
        label.TextXAlignment = Enum.TextXAlignment.Left
        if parent then label.Parent = parent end
        return label
    end
    return TextLabelFactory
end)()

Modules.InputFactory = (function()
    local Palette = Modules.Palette
    local InputFactory = {}
    function InputFactory.new(name: string, placeholder: string, parent: Instance?): TextBox
        local input = Instance.new("TextBox")
        input.Name = name
        input.PlaceholderText = placeholder
        input.Text = ""
        input.Font = Palette.Tokens.FontPrimary
        input.TextSize = 14
        input.TextColor3 = Palette.Colors.TextPrimary
        input.BackgroundColor3 = Palette.Colors.Secondary
        input.BorderSizePixel = 0
        if parent then input.Parent = parent end
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = Palette.Tokens.BorderRadius
        uiCorner.Parent = input
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Palette.Colors.BorderStroke
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = input
        return input
    end
    return InputFactory
end)()

--------------------------------------------------------------------------------
-- 4. COMPLEX COMPONENTS
--------------------------------------------------------------------------------
Modules.WindowFactory = (function()
    local FrameFactory = Modules.FrameFactory
    local TextLabelFactory = Modules.TextLabelFactory
    local Palette = Modules.Palette
    local WindowFactory = {}
    function WindowFactory.new(title: string, parent: Instance?): (Frame, Frame)
        local mainWindow = FrameFactory.new("MainWindow", parent)
        mainWindow.Size = UDim2.new(0, 650, 0, 450)
        mainWindow.Position = UDim2.new(0.5, -325, 0.5, -225)
        
        local bgGradient = Instance.new("UIGradient")
        bgGradient.Color = ColorSequence.new(Palette.Colors.Background, Palette.Colors.Secondary)
        bgGradient.Rotation = 45
        bgGradient.Parent = mainWindow
        
        local dropShadow = Instance.new("ImageLabel")
        dropShadow.Name = "DropShadow"
        dropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        dropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        dropShadow.Size = UDim2.new(1, 40, 1, 40)
        dropShadow.BackgroundTransparency = 1
        dropShadow.Image = "rbxassetid://1316045217"
        dropShadow.ImageColor3 = Color3.new(0, 0, 0)
        dropShadow.ImageTransparency = 0.5
        dropShadow.SliceCenter = Rect.new(10, 10, 118, 118)
        dropShadow.ZIndex = mainWindow.ZIndex - 1
        dropShadow.Parent = mainWindow
        
        local topBar = Instance.new("Frame")
        topBar.Name = "TopBar"
        topBar.Size = UDim2.new(1, 0, 0, 40)
        topBar.BackgroundTransparency = 1
        topBar.Parent = mainWindow
        
        local titleIcon = Instance.new("ImageLabel")
        titleIcon.Name = "TitleIcon"
        titleIcon.Size = UDim2.new(0, 18, 0, 18)
        titleIcon.Position = UDim2.new(0, 15, 0.5, -9)
        titleIcon.BackgroundTransparency = 1
        titleIcon.Image = "rbxassetid://7733772159"
        titleIcon.ImageColor3 = Palette.Colors.Accent
        titleIcon.Parent = topBar

        local titleLabel = TextLabelFactory.new("Title", title, topBar)
        titleLabel.Size = UDim2.new(1, -45, 1, 0)
        titleLabel.Position = UDim2.new(0, 45, 0, 0)
        titleLabel.Font = Enum.Font.GothamBold
        
        local separator = Instance.new("Frame")
        separator.Name = "Separator"
        separator.Size = UDim2.new(1, 0, 0, 1)
        separator.Position = UDim2.new(0, 0, 1, -1)
        separator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        separator.BorderSizePixel = 0
        separator.Parent = topBar

        local sepGradient = Instance.new("UIGradient")
        sepGradient.Color = ColorSequence.new(Palette.Colors.BorderStroke)
        sepGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        sepGradient.Parent = separator

        local contentCanvas = Instance.new("Frame")
        contentCanvas.Name = "Content"
        contentCanvas.Size = UDim2.new(1, 0, 1, -40)
        contentCanvas.Position = UDim2.new(0, 0, 0, 40)
        contentCanvas.BackgroundTransparency = 1
        contentCanvas.Parent = mainWindow

        local dragging = false
        local dragInput, dragStart, startPos
        topBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = mainWindow.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        topBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                mainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        return mainWindow, contentCanvas
    end
    return WindowFactory
end)()

Modules.TabSystem = (function()
    local Palette = Modules.Palette
    local ButtonAnimations = Modules.ButtonAnimations
    local TextButtonFactory = Modules.TextButtonFactory
    local TabSystem = {}
    type TabConfig = { Name: string, Icon: string?, Content: ScrollingFrame }
    
    function TabSystem.new(parent: Instance, tabs: {TabConfig})
        local container = Instance.new("Frame")
        container.Name = "TabSystem"
        container.Size = UDim2.new(1, 0, 1, 0)
        container.BackgroundTransparency = 1
        container.Parent = parent
        
        local sidebar = Instance.new("Frame")
        sidebar.Name = "Sidebar"
        sidebar.Size = UDim2.new(0, 150, 1, 0)
        sidebar.BackgroundColor3 = Palette.Colors.Secondary
        sidebar.BackgroundTransparency = 1 - Palette.Opacities.Secondary
        sidebar.BorderSizePixel = 0
        sidebar.Parent = container
        
        local sideGradient = Instance.new("UIGradient")
        sideGradient.Color = ColorSequence.new(Palette.Colors.Secondary, Palette.Colors.Background)
        sideGradient.Rotation = 90
        sideGradient.Parent = sidebar
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 5)
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = sidebar
        
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 10)
        padding.Parent = sidebar

        local contentArea = Instance.new("Frame")
        contentArea.Name = "ContentArea"
        contentArea.Size = UDim2.new(1, -150, 1, 0)
        contentArea.Position = UDim2.new(0, 150, 0, 0)
        contentArea.BackgroundTransparency = 1
        contentArea.Parent = container
        
        local tabItems = {}
        
        for i, tab in ipairs(tabs) do
            local btn = TextButtonFactory.new("Tab_" .. tab.Name, tab.Name, sidebar)
            btn.Size = UDim2.new(1, -20, 0, 35)
            btn.BackgroundColor3 = Palette.Colors.Secondary
            btn.BackgroundTransparency = 1
            btn.TextColor3 = Palette.Colors.TextMuted
            btn.TextXAlignment = Enum.TextXAlignment.Left
            
            local padding = Instance.new("UIPadding")
            padding.PaddingLeft = UDim.new(0, tab.Icon and 35 or 15)
            padding.Parent = btn
            
            local icon
            if tab.Icon then
                icon = Instance.new("ImageLabel")
                icon.Size = UDim2.new(0, 18, 0, 18)
                icon.Position = UDim2.new(0, -25, 0.5, -9)
                icon.BackgroundTransparency = 1
                icon.Image = tab.Icon
                icon.ImageColor3 = Palette.Colors.TextMuted
                icon.Parent = btn
            end
            
            local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local hoverTween = TweenService:Create(btn, info, {TextColor3 = Palette.Colors.TextPrimary, BackgroundTransparency = 0.8})
            local leaveTween = TweenService:Create(btn, info, {TextColor3 = Palette.Colors.TextMuted, BackgroundTransparency = 1})
            
            btn.MouseEnter:Connect(function() 
                hoverTween:Play() 
                if icon and btn.TextColor3 ~= Palette.Colors.Accent then TweenService:Create(icon, info, {ImageColor3 = Palette.Colors.TextPrimary}):Play() end
            end)
            btn.MouseLeave:Connect(function() 
                leaveTween:Play() 
                if icon and btn.TextColor3 ~= Palette.Colors.Accent then TweenService:Create(icon, info, {ImageColor3 = Palette.Colors.TextMuted}):Play() end
            end)
            
            local canvasGroup = Instance.new("CanvasGroup")
            canvasGroup.Name = "Canvas_" .. tab.Name
            canvasGroup.Size = UDim2.new(1, 0, 1, 0)
            canvasGroup.BackgroundTransparency = 1
            canvasGroup.GroupTransparency = (i == 1) and 0 or 1
            canvasGroup.Visible = (i == 1)
            canvasGroup.Parent = contentArea
            
            tab.Content.Parent = canvasGroup
            tab.Content.Size = UDim2.new(1, 0, 1, 0)
            tab.Content.Position = UDim2.new(0, 0, 0, 0)
            
            table.insert(tabItems, {Btn = btn, Icon = icon, Group = canvasGroup, Content = tab.Content})
            
            btn.MouseButton1Click:Connect(function()
                if canvasGroup.Visible then return end
                for j, item in ipairs(tabItems) do
                    local b, iGrp, ico = item.Btn, item.Group, item.Icon
                    if iGrp.Visible then
                        iGrp.Visible = false
                        iGrp.GroupTransparency = 1
                    end
                    b.TextColor3 = Palette.Colors.TextMuted
                    b.Font = Palette.Tokens.FontPrimary
                    if ico then TweenService:Create(ico, TweenInfo.new(0.2), {ImageColor3 = Palette.Colors.TextMuted}):Play() end
                end
                
                canvasGroup.Visible = true
                canvasGroup.GroupTransparency = 1
                tab.Content.Position = UDim2.new(0, 0, 0, 15)
                TweenService:Create(canvasGroup, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
                TweenService:Create(tab.Content, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 0, 0, 0)
                }):Play()

                btn.TextColor3 = Palette.Colors.Accent
                btn.Font = Enum.Font.GothamBold
                if icon then TweenService:Create(icon, TweenInfo.new(0.2), {ImageColor3 = Palette.Colors.Accent}):Play() end
            end)
            
            if i == 1 then
                btn.TextColor3 = Palette.Colors.Accent
                btn.Font = Enum.Font.GothamBold
                if icon then icon.ImageColor3 = Palette.Colors.Accent end
            end
        end
        return container
    end
    return TabSystem
end)()

Modules.SectionFactory = (function()
    local Palette = Modules.Palette
    local TextLabelFactory = Modules.TextLabelFactory
    local SectionFactory = {}
    function SectionFactory.new(title: string, parent: Instance?): Frame
        local section = Instance.new("Frame")
        section.Name = "Section_" .. title
        section.Size = UDim2.new(1, 0, 0, 0) -- Auto size based on content later
        section.BackgroundColor3 = Palette.Colors.SectionBg
        section.BorderSizePixel = 0
        if parent then section.Parent = parent end
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = Palette.Tokens.BorderRadius
        corner.Parent = section
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Palette.Colors.BorderStroke
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = section

        local accentBar = Instance.new("Frame")
        accentBar.Name = "AccentBar"
        accentBar.Size = UDim2.new(0, 3, 0, 16)
        accentBar.Position = UDim2.new(0, 10, 0, 12)
        accentBar.BackgroundColor3 = Palette.Colors.Accent
        accentBar.BorderSizePixel = 0
        accentBar.Parent = section
        
        local accentCorner = Instance.new("UICorner")
        accentCorner.CornerRadius = UDim.new(1, 0)
        accentCorner.Parent = accentBar

        local titleLbl = TextLabelFactory.new("Title", title, section)
        titleLbl.Size = UDim2.new(1, -30, 0, 30)
        titleLbl.Position = UDim2.new(0, 20, 0, 5)
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.TextSize = 14
        
        local content = Instance.new("Frame")
        content.Name = "Content"
        content.Size = UDim2.new(1, 0, 1, -35)
        content.Position = UDim2.new(0, 0, 0, 35)
        content.BackgroundTransparency = 1
        content.Parent = section

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 10)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = content
        
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 5)
        padding.PaddingBottom = UDim.new(0, 15)
        padding.PaddingLeft = UDim.new(0, 15)
        padding.PaddingRight = UDim.new(0, 15)
        padding.Parent = content

        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            section.Size = UDim2.new(1, -20, 0, layout.AbsoluteContentSize.Y + 50)
        end)

        return section
    end
    return SectionFactory
end)()

Modules.ToggleSwitchFactory = (function()
    local Palette = Modules.Palette
    local TextLabelFactory = Modules.TextLabelFactory
    local ToggleSwitchFactory = {}
    function ToggleSwitchFactory.new(name: string, title: string, initialState: boolean, parent: Instance?): (Frame, BindableEvent)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 30)
        row.BackgroundTransparency = 1
        if parent then row.Parent = parent end

        local lbl = TextLabelFactory.new("Title", title, row)
        lbl.Size = UDim2.new(1, -60, 1, 0)
        lbl.TextSize = 13

        local container = Instance.new("Frame")
        container.Name = name
        container.Size = UDim2.new(0, 44, 0, 24)
        container.Position = UDim2.new(1, -44, 0.5, -12)
        container.BackgroundColor3 = initialState and Color3.fromRGB(255, 255, 255) or Palette.Colors.Secondary
        container.BorderSizePixel = 0
        container.Parent = row

        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new(Palette.Colors.Accent, Palette.Colors.Hover)
        gradient.Rotation = 45
        gradient.Enabled = initialState
        gradient.Parent = container

        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(1, 0)
        uiCorner.Parent = container

        local knob = Instance.new("Frame")
        knob.Name = "Knob"
        knob.Size = UDim2.new(0, 18, 0, 18)
        knob.Position = initialState and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        knob.BackgroundColor3 = Palette.Colors.TextPrimary
        knob.BorderSizePixel = 0
        knob.Parent = container

        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = knob
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 1, 0)
        button.BackgroundTransparency = 1
        button.Text = ""
        button.Parent = container
        
        local state = initialState
        local onToggled = Instance.new("BindableEvent")
        local info = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        button.MouseButton1Click:Connect(function()
            state = not state
            local bgGoal = state and Color3.fromRGB(255, 255, 255) or Palette.Colors.Secondary
            local posGoal = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
            gradient.Enabled = state
            TweenService:Create(container, info, {BackgroundColor3 = bgGoal}):Play()
            TweenService:Create(knob, info, {Position = posGoal}):Play()
            onToggled:Fire(state)
        end)
        
        return row, onToggled
    end
    return ToggleSwitchFactory
end)()

Modules.SliderFactory = (function()
    local Palette = Modules.Palette
    local TextLabelFactory = Modules.TextLabelFactory
    local SliderFactory = {}
    function SliderFactory.new(name: string, title: string, min: number, max: number, defaultVal: number, parent: Instance?): (Frame, BindableEvent)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 45)
        row.BackgroundTransparency = 1
        if parent then row.Parent = parent end

        local lbl = TextLabelFactory.new("Title", title, row)
        lbl.Size = UDim2.new(1, -50, 0, 20)
        lbl.TextSize = 13
        
        local valueDisplay = TextLabelFactory.new("Value", tostring(defaultVal), row)
        valueDisplay.Size = UDim2.new(0, 50, 0, 20)
        valueDisplay.Position = UDim2.new(1, -50, 0, 0)
        valueDisplay.TextXAlignment = Enum.TextXAlignment.Right
        valueDisplay.TextColor3 = Palette.Colors.Accent
        valueDisplay.TextSize = 13

        local container = Instance.new("Frame")
        container.Name = name
        container.Size = UDim2.new(1, 0, 0, 16)
        container.Position = UDim2.new(0, 0, 0, 25)
        container.BackgroundTransparency = 1
        container.Parent = row

        local track = Instance.new("TextButton")
        track.Name = "Track"
        track.Size = UDim2.new(1, 0, 0, 6)
        track.Position = UDim2.new(0, 0, 0.5, -3)
        track.BackgroundColor3 = Palette.Colors.BorderStroke
        track.AutoButtonColor = false
        track.Text = ""
        track.Parent = container
        local trackCorner = Instance.new("UICorner")
        trackCorner.CornerRadius = UDim.new(1, 0)
        trackCorner.Parent = track

        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        fill.Parent = track
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = fill
        
        local fillGradient = Instance.new("UIGradient")
        fillGradient.Color = ColorSequence.new(Palette.Colors.Accent, Palette.Colors.Hover)
        fillGradient.Parent = fill

        local knob = Instance.new("Frame")
        knob.Name = "Knob"
        knob.Size = UDim2.new(0, 16, 0, 16)
        knob.Position = UDim2.new(1, -8, 0.5, -8)
        knob.BackgroundColor3 = Palette.Colors.TextPrimary
        knob.Parent = fill
        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = knob
        
        local knobShadow = Instance.new("ImageLabel")
        knobShadow.Name = "Shadow"
        knobShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        knobShadow.Position = UDim2.new(0.5, 0, 0.5, 2)
        knobShadow.Size = UDim2.new(1, 10, 1, 10)
        knobShadow.BackgroundTransparency = 1
        knobShadow.Image = "rbxassetid://1316045217"
        knobShadow.ImageColor3 = Color3.new(0, 0, 0)
        knobShadow.ImageTransparency = 0.6
        knobShadow.ZIndex = knob.ZIndex - 1
        knobShadow.Parent = knob
        
        local onValueChanged = Instance.new("BindableEvent")
        
        local function UpdateSlider(percentage: number)
            percentage = math.clamp(percentage, 0, 1)
            fill.Size = UDim2.new(percentage, 0, 1, 0)
            local rawVal = min + ((max - min) * percentage)
            local val = math.round(rawVal * 100) / 100
            valueDisplay.Text = tostring(val)
            onValueChanged:Fire(val)
        end
        
        local defPercent = (defaultVal - min) / (max - min)
        UpdateSlider(defPercent)

        local dragging = false
        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                UpdateSlider((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                UpdateSlider((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X)
            end
        end)

        return row, onValueChanged
    end
    return SliderFactory
end)()

Modules.DropdownFactory = (function()
    local Palette = Modules.Palette
    local ButtonAnimations = Modules.ButtonAnimations
    local TextButtonFactory = Modules.TextButtonFactory
    local TextLabelFactory = Modules.TextLabelFactory
    local DropdownFactory = {}
    function DropdownFactory.new(name: string, title: string, options: {string}, isMulti: boolean, parent: Instance?, preselected: {[string]: boolean}?): (Frame, BindableEvent)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 65)
        row.BackgroundTransparency = 1
        if parent then row.Parent = parent end

        local lbl = TextLabelFactory.new("Title", title, row)
        lbl.Size = UDim2.new(1, 0, 0, 20)
        lbl.TextSize = 13

        local container = Instance.new("Frame")
        container.Name = name
        container.Size = UDim2.new(1, 0, 0, 36)
        container.Position = UDim2.new(0, 0, 0, 25)
        container.BackgroundTransparency = 1
        container.Parent = row

        local mainBtn = TextButtonFactory.new("MainButton", isMulti and "Select options..." or (options[1] or "Select..."), container)
        mainBtn.Size = UDim2.new(1, 0, 1, 0)
        mainBtn.BackgroundColor3 = Palette.Colors.Secondary
        mainBtn.TextColor3 = Palette.Colors.TextPrimary
        mainBtn.TextTruncate = Enum.TextTruncate.AtEnd
        ButtonAnimations.BindSecondaryHoverAndClick(mainBtn)
        
        local arrow = TextLabelFactory.new("Arrow", "v", mainBtn)
        arrow.Size = UDim2.new(0, 30, 1, 0)
        arrow.Position = UDim2.new(1, -30, 0, 0)
        arrow.Font = Enum.Font.GothamBold
        arrow.TextSize = 12
        arrow.TextColor3 = Palette.Colors.TextMuted

        local scrollingFrame = Instance.new("ScrollingFrame")
        scrollingFrame.Name = "OptionsList"
        scrollingFrame.Size = UDim2.new(1, 0, 0, 120)
        scrollingFrame.Position = UDim2.new(0, 0, 1, 4)
        scrollingFrame.BackgroundColor3 = Palette.Colors.SectionBg
        scrollingFrame.BorderSizePixel = 0
        scrollingFrame.ScrollBarThickness = 2
        scrollingFrame.ScrollBarImageColor3 = Palette.Colors.Accent
        scrollingFrame.Visible = false
        scrollingFrame.ZIndex = 15
        scrollingFrame.Parent = container

        local stroke = Instance.new("UIStroke")
        stroke.Color = Palette.Colors.BorderStroke
        stroke.Thickness = Palette.Tokens.StrokeThickness
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = scrollingFrame

        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = Palette.Tokens.BorderRadius
        uiCorner.Parent = scrollingFrame

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 4)
        listLayout.Parent = scrollingFrame

        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 6)
        padding.PaddingBottom = UDim.new(0, 6)
        padding.PaddingLeft = UDim.new(0, 6)
        padding.PaddingRight = UDim.new(0, 6)
        padding.Parent = scrollingFrame
        
        local onOptionSelected = Instance.new("BindableEvent")
        local isOpen = false
        local selectedItems = {}

        -- Restore previously-saved selections (shown highlighted + in the label).
        if isMulti and preselected then
            for _, opt in ipairs(options) do
                if preselected[opt] then table.insert(selectedItems, opt) end
            end
            if #selectedItems > 0 then
                mainBtn.Text = table.concat(selectedItems, ", ")
            end
        end

        mainBtn.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            scrollingFrame.Visible = isOpen
            arrow.Text = isOpen and "^" or "v"
            if isOpen then row.ZIndex = 10 container.ZIndex = 10 else row.ZIndex = 1 container.ZIndex = 1 end
        end)

        for i, optionText in ipairs(options) do
            local optBtn = TextButtonFactory.new("Option_" .. i, optionText, scrollingFrame)
            optBtn.Size = UDim2.new(1, 0, 0, 32)
            optBtn.BackgroundColor3 = Palette.Colors.Secondary
            optBtn.TextColor3 = Palette.Colors.TextMuted
            optBtn.ZIndex = 16
            if isMulti and preselected and preselected[optionText] then
                optBtn.TextColor3 = Palette.Colors.Accent
            end

            ButtonAnimations.BindSecondaryHoverAndClick(optBtn)

            optBtn.MouseButton1Click:Connect(function()
                if isMulti then
                    if table.find(selectedItems, optionText) then
                        table.remove(selectedItems, table.find(selectedItems, optionText))
                        optBtn.TextColor3 = Palette.Colors.TextMuted
                    else
                        table.insert(selectedItems, optionText)
                        optBtn.TextColor3 = Palette.Colors.Accent
                    end
                    mainBtn.Text = #selectedItems > 0 and table.concat(selectedItems, ", ") or "Select options..."
                    onOptionSelected:Fire(selectedItems)
                else
                    mainBtn.Text = optionText
                    isOpen = false
                    scrollingFrame.Visible = false
                    arrow.Text = "v"
                    row.ZIndex = 1 container.ZIndex = 1
                    onOptionSelected:Fire({optionText})
                end
            end)
        end
        
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            local contentHeight = listLayout.AbsoluteContentSize.Y + 12
            local height = math.min(140, contentHeight)
            scrollingFrame.Size = UDim2.new(1, 0, 0, height)
            scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
        end)
        
        local function Refresh(newOptions)
            for _, child in ipairs(scrollingFrame:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            options = newOptions
            if not isMulti then
                if not table.find(options, mainBtn.Text) then
                    mainBtn.Text = options[1] or "Select..."
                end
            end
            for i, optionText in ipairs(options) do
                local optBtn = TextButtonFactory.new("Option_" .. i, optionText, scrollingFrame)
                optBtn.Size = UDim2.new(1, 0, 0, 32)
                optBtn.BackgroundColor3 = Palette.Colors.Secondary
                optBtn.TextColor3 = Palette.Colors.TextMuted
                optBtn.ZIndex = 16
                
                ButtonAnimations.BindSecondaryHoverAndClick(optBtn)
                
                optBtn.MouseButton1Click:Connect(function()
                    if isMulti then
                        if table.find(selectedItems, optionText) then
                            table.remove(selectedItems, table.find(selectedItems, optionText))
                            optBtn.TextColor3 = Palette.Colors.TextMuted
                        else
                            table.insert(selectedItems, optionText)
                            optBtn.TextColor3 = Palette.Colors.Accent
                        end
                        mainBtn.Text = #selectedItems > 0 and table.concat(selectedItems, ", ") or "Select options..."
                        onOptionSelected:Fire(selectedItems)
                    else
                        mainBtn.Text = optionText
                        isOpen = false
                        scrollingFrame.Visible = false
                        arrow.Text = "v"
                        row.ZIndex = 1 container.ZIndex = 1
                        onOptionSelected:Fire({optionText})
                    end
                end)
            end
        end

        return row, onOptionSelected, Refresh
    end
    return DropdownFactory
end)()

Modules.NotificationSystem = (function()
    local Palette = Modules.Palette
    local TextLabelFactory = Modules.TextLabelFactory
    local NotificationSystem = {}
    local container = nil
    
    function NotificationSystem.Init(parent: Instance)
        container = Instance.new("Frame")
        container.Name = "NotificationContainer"
        container.Size = UDim2.new(0, 300, 1, -20)
        container.Position = UDim2.new(1, -320, 0, 10)
        container.BackgroundTransparency = 1
        container.Parent = parent

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 10)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        listLayout.Parent = container
    end

    function NotificationSystem.Notify(title: string, content: string, duration: number)
        if not container then return end
        duration = duration or 3
        
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(1, 0, 0, 60)
        notif.BackgroundTransparency = 1
        notif.Parent = container

        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Palette.Colors.Background
        bg.BackgroundTransparency = 1 - Palette.Opacities.Background
        bg.BorderSizePixel = 0
        bg.Parent = notif
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = Palette.Tokens.BorderRadius
        corner.Parent = bg
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Palette.Colors.Accent
        stroke.Thickness = 2
        stroke.Parent = bg
        
        local titleLbl = TextLabelFactory.new("Title", title, bg)
        titleLbl.Size = UDim2.new(1, -20, 0, 25)
        titleLbl.Position = UDim2.new(0, 10, 0, 5)
        titleLbl.Font = Enum.Font.GothamBold
        
        local contentLbl = TextLabelFactory.new("Content", content, bg)
        contentLbl.Size = UDim2.new(1, -20, 0, 20)
        contentLbl.Position = UDim2.new(0, 10, 0, 30)
        contentLbl.TextSize = 13
        contentLbl.TextColor3 = Palette.Colors.TextMuted
        
        -- Animation IN
        bg.Position = UDim2.new(1, 50, 0, 0)
        TweenService:Create(bg, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        
        task.spawn(function()
            task.wait(duration)
            local outTween = TweenService:Create(bg, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 1})
            outTween:Play()
            outTween.Completed:Wait()
            notif:Destroy()
        end)
    end
    
    return NotificationSystem
end)()

--------------------------------------------------------------------------------
-- APP ENTRY (Roll Anime to Fight!)
--------------------------------------------------------------------------------
;(function()
    local WindowFactory = Modules.WindowFactory
    local TabSystem = Modules.TabSystem
    local ToggleSwitchFactory = Modules.ToggleSwitchFactory
    local DropdownFactory = Modules.DropdownFactory
    local SectionFactory = Modules.SectionFactory
    local TextLabelFactory = Modules.TextLabelFactory
    local ScrollingFrameFactory = Modules.ScrollingFrameFactory

    -- UI root
    local coreGui = nil
    pcall(function() coreGui = gethui() end)
    if not coreGui then pcall(function() coreGui = game:GetService("CoreGui") end) end
    if not coreGui then coreGui = LocalPlayer:WaitForChild("PlayerGui") end
    if coreGui:FindFirstChild("RollAnimeHubUI") then coreGui.RollAnimeHubUI:Destroy() end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RollAnimeHubUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = coreGui
    Modules.NotificationSystem.Init(screenGui)

    local mainWindow, contentCanvas = WindowFactory.new("Roll Anime Hub | Auto Roll", screenGui)
    local uiScale = Instance.new("UIScale")
    uiScale.Parent = mainWindow

    -- Toggle UI visibility with RightShift / RightControl
    local isVisible = true
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.RightControl then
            isVisible = not isVisible
            if isVisible then
                screenGui.Enabled = true
                TweenService:Create(uiScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
            else
                local tw = TweenService:Create(uiScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0})
                tw:Play()
                tw.Completed:Once(function() if not isVisible then screenGui.Enabled = false end end)
            end
        end
    end)

    -- ================= Data =================
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local charsRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Characters")
    local RollRemote = charsRemote:WaitForChild("Roll")
    local BuyRemote = charsRemote:WaitForChild("Buy")

    local characterNames = {}
    pcall(function()
        for _, c in ipairs(ReplicatedStorage.Assets.Characters:GetChildren()) do
            table.insert(characterNames, c.Name)
        end
    end)
    table.sort(characterNames)

    -- Pull mutations live from the game too, so new ones (e.g. "Cursed") show up
    -- automatically on future updates without editing the script.
    local mutationNames = {}
    pcall(function()
        for _, m in ipairs(ReplicatedStorage.Assets.Mutations:GetChildren()) do
            table.insert(mutationNames, m.Name)
        end
    end)
    table.sort(mutationNames)
    if #mutationNames == 0 then -- fallback if the folder path ever changes
        mutationNames = {"Gold", "Diamond", "Demon", "Destroyer", "Astronaut", "Hollow", "Slayer", "Cursed"}
    end

    -- Tiers (rarities) pulled live from the game, so new tiers auto-appear.
    local tierNames = {}
    pcall(function()
        for _, t in ipairs(ReplicatedStorage.Assets.RarityGradient:GetChildren()) do
            table.insert(tierNames, t.Name)
        end
    end)
    table.sort(tierNames)

    -- ================= State =================
    local selectedChars = {}      -- set: character Name -> true
    local selectedMutations = {}  -- set: mutation Name -> true
    local selectedTiers = {}      -- set: tier (Rarity) -> true; FIRST priority
    local isAutoRoll = false
    local stopAfterBuy = true
    local rollDelay = 1.5

    -- ================= Config persistence =================
    local HttpService = game:GetService("HttpService")
    local CONFIG_FILE = "RollAnimeHub_config.json"

    local function saveConfig()
        if not writefile then return end
        local data = { chars = {}, muts = {}, tiers = {}, stopAfterBuy = stopAfterBuy, rollDelay = rollDelay }
        for k in pairs(selectedChars) do table.insert(data.chars, k) end
        for k in pairs(selectedMutations) do table.insert(data.muts, k) end
        for k in pairs(selectedTiers) do table.insert(data.tiers, k) end
        pcall(function() writefile(CONFIG_FILE, HttpService:JSONEncode(data)) end)
    end

    -- Restore saved targets/toggles/delay so nothing needs re-picking each run.
    -- (Auto Roll itself is intentionally NOT auto-started on load.)
    pcall(function()
        if isfile and readfile and isfile(CONFIG_FILE) then
            local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
            if type(data) == "table" then
                for _, v in ipairs(data.chars or {}) do selectedChars[v] = true end
                for _, v in ipairs(data.muts or {}) do selectedMutations[v] = true end
                for _, v in ipairs(data.tiers or {}) do selectedTiers[v] = true end
                if type(data.stopAfterBuy) == "boolean" then stopAfterBuy = data.stopAfterBuy end
                if type(data.rollDelay) == "number" then rollDelay = data.rollDelay end
            end
        end
    end)

    -- ================= Tab layout helper =================
    local function CreateTabContent(name)
        local sf = ScrollingFrameFactory.new(name)
        sf.Size = UDim2.new(1, 0, 1, 0)
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 10)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = sf
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 15)
        padding.PaddingLeft = UDim.new(0, 15)
        padding.PaddingRight = UDim.new(0, 15)
        padding.PaddingBottom = UDim.new(0, 15)
        padding.Parent = sf
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            sf.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 30)
        end)
        return sf
    end

    local rollTab = CreateTabContent("AutoRollTab")

    -- Target Selection Section
    local targetSec = SectionFactory.new("Target Selection", rollTab)
    local targetContent = targetSec:WaitForChild("Content")

    local _, charEv = DropdownFactory.new("CharSel", "Target Characters", characterNames, true, targetContent, selectedChars)
    charEv.Event:Connect(function(sel)
        selectedChars = {}
        if type(sel) == "table" then
            for _, n in ipairs(sel) do selectedChars[n] = true end
        end
        saveConfig()
    end)

    local _, mutEv = DropdownFactory.new("MutSel", "Target Mutations (empty = any)", mutationNames, true, targetContent, selectedMutations)
    mutEv.Event:Connect(function(sel)
        selectedMutations = {}
        if type(sel) == "table" then
            for _, m in ipairs(sel) do selectedMutations[m] = true end
        end
        saveConfig()
    end)

    local _, tierEv = DropdownFactory.new("TierSel", "Target Tiers (first priority - buys any match)", tierNames, true, targetContent, selectedTiers)
    tierEv.Event:Connect(function(sel)
        selectedTiers = {}
        if type(sel) == "table" then
            for _, t in ipairs(sel) do selectedTiers[t] = true end
        end
        saveConfig()
    end)

    -- Auto Roll Control Section
    local ctrlSec = SectionFactory.new("Auto Roll", rollTab)
    local ctrlContent = ctrlSec:WaitForChild("Content")

    local _, stopEv = ToggleSwitchFactory.new("StopTog", "Stop After Buying Target", stopAfterBuy, ctrlContent)
    stopEv.Event:Connect(function(s) stopAfterBuy = s; saveConfig() end)

    local _, delayEv = Modules.SliderFactory.new("RollDelay", "Roll Delay (s)", 0.1, 10, rollDelay, ctrlContent)
    delayEv.Event:Connect(function(val) rollDelay = val; saveConfig() end)

    local statusLabel = TextLabelFactory.new("Status", "Idle.", ctrlContent)
    statusLabel.Size = UDim2.new(1, 0, 0, 20)
    statusLabel.TextSize = 12
    statusLabel.TextColor3 = Modules.Palette.Colors.TextMuted

    local _, rollTogEv = ToggleSwitchFactory.new("RollTog", "Enable Auto Roll", false, ctrlContent)
    rollTogEv.Event:Connect(function(s)
        isAutoRoll = s
        Modules.NotificationSystem.Notify("Auto Roll", s and "Enabled!" or "Disabled!", 2)
        if statusLabel then statusLabel.Text = s and "Rolling..." or "Idle." end
    end)

    TabSystem.new(contentCanvas, {
        {Name = "Auto Roll", Icon = "rbxassetid://7733920644", Content = rollTab}
    })

    -- ================= Logic (hybrid: prompt roll + remote buy) =================
    -- The REAL roll is triggered by the plot's ProximityPrompt (Roll:FireServer
    -- is a ghost that doesn't decrement pity). Each real roll fires
    -- Characters.Roll.OnClientEvent with a VALID rollId + 3 results, and
    -- Characters.Buy:FireServer(rollId, slot) then genuinely purchases
    -- (verified: gold dropped by the exact price). Earlier buys failed only
    -- because they used ghost rollIds from Roll:FireServer.

    -- Find the plot this player owns (its units/previews carry our UserId).
    -- Note: plot assignment changes between sessions, so resolve dynamically.
    local function findMyPlot()
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return nil end
        for _, plot in ipairs(plots:GetChildren()) do
            local chars = plot:FindFirstChild("Characters")
            if chars then
                for _, m in ipairs(chars:GetChildren()) do
                    if m:GetAttribute("OwnerUserId") == LocalPlayer.UserId
                        or m:GetAttribute("RollOwner") == LocalPlayer.UserId then
                        return plot
                    end
                end
            end
        end
        return nil
    end

    local function getRollPrompt(plot)
        local n = plot and plot:FindFirstChild("Roll")
        n = n and n:FindFirstChild("RollButton")
        n = n and n:FindFirstChild("Button")
        return n and n:FindFirstChild("RollPrompt")
    end

    -- Match priority:
    --  1. TIER (Rarity) — if the slot's tier is selected, buy it regardless of
    --     the character/mutation filters (first priority).
    --  2. Otherwise: character must be selected AND either no mutation filter is
    --     set (buy any version) or its mutation is one we want.
    local function matches(info)
        if info.Rarity and selectedTiers[info.Rarity] then return true end
        if not (info.Name and selectedChars[info.Name]) then return false end
        if next(selectedMutations) == nil then return true end
        return info.Mutation ~= nil and info.Mutation ~= "" and selectedMutations[info.Mutation] == true
    end

    -- Each real roll delivers rollId + the 3 options here; buy the matches.
    local lastRollId = nil
    RollRemote.OnClientEvent:Connect(function(plr, plot, results, n, rollId)
        if plr ~= LocalPlayer or not isAutoRoll then return end
        if type(results) ~= "table" or rollId == lastRollId then return end
        lastRollId = rollId
        local stopNow = false
        for slot, info in pairs(results) do
            if type(info) == "table" and matches(info) then
                pcall(function() BuyRemote:FireServer(rollId, slot) end)
                local mtxt = (info.Mutation and info.Mutation ~= "") and (" [" .. tostring(info.Mutation) .. "]") or ""
                Modules.NotificationSystem.Notify("Bought!", tostring(info.Name) .. mtxt .. " ($" .. tostring(info.Price) .. ")", 4)
                if stopAfterBuy then stopNow = true break end
            end
        end
        if stopNow then
            isAutoRoll = false
            if statusLabel then statusLabel.Text = "Target bought - stopped. Re-toggle to continue." end
        end
    end)

    -- Built-in Anti-AFK: prevents the idle kick by simulating a harmless
    -- right-click whenever Roblox flags us idle. Guarded against duplicates.
    if getgenv().RollAnimeAntiAFK then pcall(function() getgenv().RollAnimeAntiAFK:Disconnect() end) end
    getgenv().RollAnimeAntiAFK = LocalPlayer.Idled:Connect(function()
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)

    -- Roll loop: trigger the real roll prompt; the handler above buys matches.
    if getgenv().RollAnimeTask then task.cancel(getgenv().RollAnimeTask) end
    local myPlot = nil
    getgenv().RollAnimeTask = task.spawn(function()
        while true do
            if isAutoRoll and fireproximityprompt then
                if not (myPlot and myPlot.Parent) then myPlot = findMyPlot() end
                local prompt = getRollPrompt(myPlot)
                if prompt then
                    pcall(function() fireproximityprompt(prompt) end)
                elseif statusLabel then
                    statusLabel.Text = "Roll prompt not found - are you on your plot?"
                end
            end
            task.wait(rollDelay)
        end
    end)

    Modules.NotificationSystem.Notify("Roll Anime Hub", "Loaded! Press RightShift to toggle.", 4)
end)()
