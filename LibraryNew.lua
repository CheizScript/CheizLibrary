local Cheiz = {}
Cheiz.__index = Cheiz
Cheiz.Flags = {}

local cloneref = cloneref or function(i) return i end
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))

local function getContainer()
    if gethui then
        return gethui()
    else
        return cloneref(game:GetService("CoreGui"))
    end
end

local function getRandomName(prefix)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local name = prefix or "UI_"
    for i = 1, 12 do
        local randIndex = math.random(1, #chars)
        name = name .. chars:sub(randIndex, randIndex)
    end
    return name
end

local function applyBlueGradient(parent)
    local gradient = Instance.new("UIGradient")
    gradient.Name = getRandomName("Grad_")
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 80, 200))
    })
    gradient.Parent = parent
    return gradient
end

local function applyOutline(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Name = getRandomName("Stroke_")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = color or Color3.fromRGB(0, 0, 0)
    stroke.Thickness = thickness or 1.5
    stroke.Parent = parent
    return stroke
end

local function applyTextStroke(textLabel, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Name = getRandomName("TextStroke_")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    stroke.Color = color or Color3.fromRGB(0, 0, 0)
    stroke.Thickness = thickness or 1.2
    stroke.Parent = textLabel
    return stroke
end

local function playClickAnimation(button)
    local ripple = Instance.new("Frame")
    ripple.Name = getRandomName("Ripple_")
    ripple.Size = UDim2.new(1, 0, 1, 0)
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.5
    ripple.BorderSizePixel = 0
    ripple.ZIndex = button.ZIndex + 1
    ripple.Parent = button

    local corner = button:FindFirstChildOfClass("UICorner")
    if corner then
        local rCorner = corner:Clone()
        rCorner.Parent = ripple
    end

    applyBlueGradient(ripple)

    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(ripple, tweenInfo, {BackgroundTransparency = 1})
    
    tween.Completed:Connect(function()
        ripple:Destroy()
    end)
    
    tween:Play()
end

function Cheiz:Close()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    elseif Cheiz.ActiveGui then
        Cheiz.ActiveGui:Destroy()
    end
end

function Cheiz:CreateWindow(config)
    config = config or {}
    local titleText = config.Title or "RETRO PANEL"

    local window = setmetatable({}, Cheiz)
    window.IsCollapsed = false
    window.MaxHeight = 320

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = getRandomName("Gui_")
    screenGui.ResetOnSpawn = false
    screenGui.Parent = getContainer()
    Cheiz.ActiveGui = screenGui

    local backdrop = Instance.new("TextButton")
    backdrop.Name = getRandomName("Backdrop_")
    backdrop.Size = UDim2.new(1, 0, 1, 0)
    backdrop.Position = UDim2.new(0, 0, 0, 0)
    backdrop.BackgroundTransparency = 1
    backdrop.Text = ""
    backdrop.AutoButtonColor = false
    backdrop.Visible = false
    backdrop.ZIndex = 8
    backdrop.Parent = screenGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = getRandomName("Main_")
    mainFrame.Size = UDim2.new(0, 220, 0, 28)
    mainFrame.Position = UDim2.new(0.7, 0, 0.3, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    local sizeConstraint = Instance.new("UISizeConstraint")
    sizeConstraint.Name = getRandomName("Constraint_")
    sizeConstraint.MinSize = Vector2.new(180, 28)
    sizeConstraint.MaxSize = Vector2.new(400, 600)
    sizeConstraint.Parent = mainFrame

    local mainCorner = Instance.new("UICorner")
    mainCorner.Name = getRandomName("Corner_")
    mainCorner.CornerRadius = UDim.new(0, 4)
    mainCorner.Parent = mainFrame

    applyOutline(mainFrame, Color3.fromRGB(40, 40, 40), 2)

    local titleBar = Instance.new("Frame")
    titleBar.Name = getRandomName("Header_")
    titleBar.Size = UDim2.new(1, 0, 0, 28)
    titleBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.Name = getRandomName("Corner_")
    titleCorner.CornerRadius = UDim.new(0, 4)
    titleCorner.Parent = titleBar

    applyBlueGradient(titleBar)
    applyOutline(titleBar, Color3.fromRGB(0, 0, 0), 1.5)

    local titleTextLabel = Instance.new("TextLabel")
    titleTextLabel.Name = getRandomName("Title_")
    titleTextLabel.Size = UDim2.new(1, -30, 1, 0)
    titleTextLabel.Position = UDim2.new(0, 8, 0, 0)
    titleTextLabel.BackgroundTransparency = 1
    titleTextLabel.Font = Enum.Font.FredokaOne
    titleTextLabel.Text = titleText
    titleTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleTextLabel.TextSize = 14
    titleTextLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleTextLabel.Parent = titleBar

    applyTextStroke(titleTextLabel, Color3.fromRGB(0, 0, 0), 1.2)

    local collapseBtn = Instance.new("TextButton")
    collapseBtn.Name = getRandomName("Collapse_")
    collapseBtn.Size = UDim2.new(0, 24, 0, 24)
    collapseBtn.Position = UDim2.new(1, -26, 0.5, -12)
    collapseBtn.BackgroundTransparency = 1
    collapseBtn.Font = Enum.Font.FredokaOne
    collapseBtn.Text = "▲"
    collapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    collapseBtn.TextSize = 13
    collapseBtn.Parent = titleBar

    applyTextStroke(collapseBtn, Color3.fromRGB(0, 0, 0), 1.2)

    local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = getRandomName("Scroll_")
scrollFrame.Size = UDim2.new(1, -18, 1, -34)
scrollFrame.Position = UDim2.new(0, 6, 0, 30)

scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ClipsDescendants = true
scrollFrame.ScrollBarThickness = 1
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 170, 255)
scrollFrame.ScrollBarImageTransparency = 1
scrollFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollFrame.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.CanvasPosition = Vector2.new(0, 0)
scrollFrame.Parent = mainFrame

    local layout = Instance.new("UIListLayout")
    layout.Name = getRandomName("Layout_")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = scrollFrame

    local padding = Instance.new("UIPadding")
    padding.Name = getRandomName("Padding_")
    padding.PaddingRight = UDim.new(0, 4)
    padding.PaddingBottom = UDim.new(0, 4)
    padding.PaddingTop = UDim.new(0, 2)
    padding.Parent = scrollFrame

    local function updateLayout()
    local contentHeight = layout.AbsoluteContentSize.Y
    local topPadding = padding.PaddingTop.Offset
    local bottomPadding = padding.PaddingBottom.Offset
    
    scrollFrame.CanvasSize = UDim2.fromOffset(
        0,
        contentHeight + topPadding + bottomPadding
    )

    window.FullHeight = math.min(contentHeight + 38, window.MaxHeight)

    if not window.IsCollapsed then
        mainFrame.Size = UDim2.new(0, 220, 0, window.FullHeight)
    end
end

    window.UpdateLayout = updateLayout
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateLayout)

    collapseBtn.MouseButton1Click:Connect(function()
        window.IsCollapsed = not window.IsCollapsed

        local targetHeight = window.IsCollapsed and 28 or window.FullHeight
        collapseBtn.Text = window.IsCollapsed and "▼" or "▲"

        scrollFrame.Visible = not window.IsCollapsed

        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        local tween = TweenService:Create(mainFrame, tweenInfo, {
            Size = UDim2.new(0, 220, 0, targetHeight)
        })
        tween:Play()
    end)

    window.ScreenGui = screenGui
    window.Backdrop = backdrop
    window.MainFrame = mainFrame
    window.Container = scrollFrame
    window.LayoutOrderCount = 1
    return window
end

function Cheiz:AddFolder(config)
    config = type(config) == "string" and { Title = config } or config or {}
    local folderName = config.Title or "Folder"

    local folder = setmetatable({}, Cheiz)
    folder.IsCollapsed = false
    folder.ScreenGui = self.ScreenGui or (self.Window and self.Window.ScreenGui)
    folder.Backdrop = self.Backdrop or (self.Window and self.Window.Backdrop)
    folder.Window = self.Window or self

    local folderFrame = Instance.new("Frame")
    folderFrame.Name = getRandomName("Folder_")
    folderFrame.Size = UDim2.new(1, 0, 0, 26)
    folderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    folderFrame.BorderSizePixel = 0
    folderFrame.ClipsDescendants = true
    folderFrame.LayoutOrder = self.LayoutOrderCount
    folderFrame.Parent = self.Container

    local frameCorner = Instance.new("UICorner")
    frameCorner.Name = getRandomName("Corner_")
    frameCorner.CornerRadius = UDim.new(0, 3)
    frameCorner.Parent = folderFrame

    applyOutline(folderFrame, Color3.fromRGB(45, 45, 45), 1.2)

    local header = Instance.new("Frame")
    header.Name = getRandomName("Header_")
    header.Size = UDim2.new(1, 0, 0, 26)
    header.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    header.BorderSizePixel = 0
    header.Parent = folderFrame

    local headerCorner = Instance.new("UICorner")
    headerCorner.Name = getRandomName("Corner_")
    headerCorner.CornerRadius = UDim.new(0, 3)
    headerCorner.Parent = header

    applyOutline(header, Color3.fromRGB(55, 55, 55), 1)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = getRandomName("Title_")
    titleLabel.Size = UDim2.new(1, -30, 1, 0)
    titleLabel.Position = UDim2.new(0, 6, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.FredokaOne
    titleLabel.Text = folderName
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header

    applyTextStroke(titleLabel, Color3.fromRGB(0, 0, 0), 1)

    local arrowBtn = Instance.new("TextButton")
    arrowBtn.Name = getRandomName("Arrow_")
    arrowBtn.Size = UDim2.new(0, 24, 1, 0)
    arrowBtn.Position = UDim2.new(1, -24, 0, 0)
    arrowBtn.BackgroundTransparency = 1
    arrowBtn.Font = Enum.Font.FredokaOne
    arrowBtn.Text = "▲"
    arrowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    arrowBtn.TextSize = 12
    arrowBtn.Parent = header

    applyTextStroke(arrowBtn, Color3.fromRGB(0, 0, 0), 1)

    local folderContent = Instance.new("Frame")
    folderContent.Name = getRandomName("Content_")
    folderContent.Size = UDim2.new(1, -8, 0, 0)
    folderContent.Position = UDim2.new(0, 4, 0, 28)
    folderContent.BackgroundTransparency = 1
    folderContent.Parent = folderFrame

    local folderLayout = Instance.new("UIListLayout")
    folderLayout.Name = getRandomName("Layout_")
    folderLayout.SortOrder = Enum.SortOrder.LayoutOrder
    folderLayout.Padding = UDim.new(0, 4)
    folderLayout.Parent = folderContent

    local folderPadding = Instance.new("UIPadding")
    folderPadding.Name = getRandomName("Padding_")
    folderPadding.PaddingBottom = UDim.new(0, 4)
    folderPadding.Parent = folderContent

    local function updateFolderSize()
        local contentHeight = folderLayout.AbsoluteContentSize.Y
        folderContent.Size = UDim2.new(1, -8, 0, contentHeight)
        
        if not folder.IsCollapsed then
            folderFrame.Size = UDim2.new(1, 0, 0, contentHeight + 32)
        end
        folder.Window.UpdateLayout()
    end

    folderLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateFolderSize)

    local function toggleFolder()
        folder.IsCollapsed = not folder.IsCollapsed
        arrowBtn.Text = folder.IsCollapsed and "▼" or "▲"
        folderContent.Visible = not folder.IsCollapsed
        
        local targetHeight = folder.IsCollapsed and 26 or (folderLayout.AbsoluteContentSize.Y + 32)
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        local tween = TweenService:Create(folderFrame, tweenInfo, {Size = UDim2.new(1, 0, 0, targetHeight)})
        
        tween.Changed:Connect(function()
            folder.Window.UpdateLayout()
        end)
        
        tween:Play()
    end

    arrowBtn.MouseButton1Click:Connect(toggleFolder)

    self.LayoutOrderCount = self.LayoutOrderCount + 1

    folder.Container = folderContent
    folder.LayoutOrderCount = 1

    function folder:SetTitle(newTitle)
        titleLabel.Text = newTitle
    end

    return folder
end

function Cheiz:AddButton(config)
    config = type(config) == "string" and { Title = config } or config or {}
    local text = config.Title or "Button"
    local callback = config.Callback

    local button = Instance.new("TextButton")
    button.Name = getRandomName("Btn_")
    button.Size = UDim2.new(1, 0, 0, 26)
    button.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    button.BorderSizePixel = 0
    button.Font = Enum.Font.FredokaOne
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 13
    button.LayoutOrder = self.LayoutOrderCount
    button.ClipsDescendants = true
    button.Parent = self.Container

    local corner = Instance.new("UICorner")
    corner.Name = getRandomName("Corner_")
    corner.CornerRadius = UDim.new(0, 3)
    corner.Parent = button

    applyOutline(button, Color3.fromRGB(60, 60, 60), 1.2)
    applyTextStroke(button, Color3.fromRGB(0, 0, 0), 1.2)

    self.LayoutOrderCount = self.LayoutOrderCount + 1

    button.MouseButton1Click:Connect(function()
        playClickAnimation(button)
        if callback then callback() end
    end)

    local buttonObj = {}
    function buttonObj:SetTitle(newTitle)
        button.Text = newTitle
    end
    return buttonObj
end

function Cheiz:AddToggle(config)
    config = type(config) == "string" and { Title = config } or config or {}
    local text = config.Title or "Toggle"
    local flag = config.Flag
    local state = config.Default or false
    local callback = config.Callback

    if flag then
        Cheiz.Flags[flag] = state
    end

    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = getRandomName("ToggleFrame_")
    toggleFrame.Size = UDim2.new(1, 0, 0, 26)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.LayoutOrder = self.LayoutOrderCount
    toggleFrame.Parent = self.Container

    self.LayoutOrderCount = self.LayoutOrderCount + 1

    local label = Instance.new("TextLabel")
    label.Name = getRandomName("Label_")
    label.Size = UDim2.new(1, -26, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.FredokaOne
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame

    applyTextStroke(label, Color3.fromRGB(0, 0, 0), 1)

    local box = Instance.new("TextButton")
    box.Name = getRandomName("Box_")
    box.Size = UDim2.new(0, 20, 0, 20)
    box.Position = UDim2.new(1, -20, 0.5, -10)
    box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    box.BorderSizePixel = 0
    box.Font = Enum.Font.FredokaOne
    box.Text = state and "✓" or ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 13
    box.Parent = toggleFrame

    local boxCorner = Instance.new("UICorner")
    boxCorner.Name = getRandomName("Corner_")
    boxCorner.CornerRadius = UDim.new(0, 3)
    boxCorner.Parent = box

    local boxGradient = applyBlueGradient(box)
    boxGradient.Enabled = state

    if not state then
        box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end

    applyOutline(box, Color3.fromRGB(0, 0, 0), 1.2)

    local function updateToggle(newState)
        state = newState
        if flag then
            Cheiz.Flags[flag] = state
        end
        boxGradient.Enabled = state
        box.BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(30, 30, 30)
        box.Text = state and "✓" or ""
        playClickAnimation(box)
        if callback then callback(state) end
    end

    box.MouseButton1Click:Connect(function()
        updateToggle(not state)
    end)

    local toggleObj = {}
    function toggleObj:SetTitle(newTitle)
        label.Text = newTitle
    end
    function toggleObj:SetToggle(newState)
        updateToggle(newState)
    end
    return toggleObj
end

function Cheiz:AddSlider(config)
    config = config or {}
    local text = config.Title or "Slider"
    local min = config.Min or 0
    local max = config.Max or 100
    local default = math.clamp(config.Default or min, min, max)
    local flag = config.Flag
    local callback = config.Callback

    if flag then
        Cheiz.Flags[flag] = default
    end

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = getRandomName("SliderFrame_")
    sliderFrame.Size = UDim2.new(1, 0, 0, 46)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.LayoutOrder = self.LayoutOrderCount
    sliderFrame.Parent = self.Container

    local frameCorner = Instance.new("UICorner")
    frameCorner.Name = getRandomName("Corner_")
    frameCorner.CornerRadius = UDim.new(0, 3)
    frameCorner.Parent = sliderFrame

    applyOutline(sliderFrame, Color3.fromRGB(50, 50, 50), 1.2)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = getRandomName("Label_")
    titleLabel.Size = UDim2.new(1, -54, 0, 18)
    titleLabel.Position = UDim2.new(0, 6, 0, 2)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.FredokaOne
    titleLabel.Text = text
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 11
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = sliderFrame

    applyTextStroke(titleLabel, Color3.fromRGB(0, 0, 0), 1)

    local valBox = Instance.new("TextBox")
    valBox.Name = getRandomName("ValBox_")
    valBox.Size = UDim2.new(0, 42, 0, 20)
    valBox.Position = UDim2.new(1, -48, 0, 2)
    valBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    valBox.BorderSizePixel = 0
    valBox.Font = Enum.Font.FredokaOne
    valBox.Text = tostring(default)
    valBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    valBox.TextSize = 11
    valBox.ClearTextOnFocus = false
    valBox.Parent = sliderFrame

    local valCorner = Instance.new("UICorner")
    valCorner.Name = getRandomName("Corner_")
    valCorner.CornerRadius = UDim.new(0, 3)
    valCorner.Parent = valBox

    applyOutline(valBox, Color3.fromRGB(50, 50, 50), 1)

    local track = Instance.new("TextButton")
    track.Name = getRandomName("Track_")
    track.Size = UDim2.new(1, -12, 0, 14)
    track.Position = UDim2.new(0, 6, 0, 24)
    track.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    track.BorderSizePixel = 0
    track.Text = ""
    track.AutoButtonColor = false
    track.Parent = sliderFrame

    local trackCorner = Instance.new("UICorner")
    trackCorner.Name = getRandomName("Corner_")
    trackCorner.CornerRadius = UDim.new(0, 3)
    trackCorner.Parent = track

    applyOutline(track, Color3.fromRGB(40, 40, 40), 1)

    local fill = Instance.new("Frame")
    fill.Name = getRandomName("Fill_")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fill.BorderSizePixel = 0
    fill.Parent = track

    local fillCorner = Instance.new("UICorner")
    fillCorner.Name = getRandomName("Corner_")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill

    local thumb = Instance.new("Frame")
    thumb.Name = getRandomName("Thumb_")
    thumb.Size = UDim2.new(0, 10, 1, 4)
    thumb.Position = UDim2.new(1, -5, 0, -2)
    thumb.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    thumb.BorderSizePixel = 0
    thumb.Parent = fill

    local thumbCorner = Instance.new("UICorner")
    thumbCorner.Name = getRandomName("Corner_")
    thumbCorner.CornerRadius = UDim.new(0, 3)
    thumbCorner.Parent = thumb

    applyOutline(thumb, Color3.fromRGB(0, 0, 0), 1)

    self.LayoutOrderCount = self.LayoutOrderCount + 1

    local dragging = false

    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * pos)
        
        fill.Size = UDim2.new(pos, 0, 1, 0)
        valBox.Text = tostring(value)
        if flag then
            Cheiz.Flags[flag] = value
        end
        if callback then callback(value) end
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    valBox.FocusLost:Connect(function()
        local num = tonumber(valBox.Text)
        if num then
            num = math.clamp(num, min, max)
            valBox.Text = tostring(num)
            fill.Size = UDim2.new((num - min) / (max - min), 0, 1, 0)
            if flag then
                Cheiz.Flags[flag] = num
            end
            if callback then callback(num) end
        else
            valBox.Text = tostring(min)
        end
    end)

    local sliderObj = {}
    function sliderObj:SetTitle(newTitle)
        titleLabel.Text = newTitle
    end
    return sliderObj
end

function Cheiz:AddTextBox(config)
    config = type(config) == "string" and { Title = config } or config or {}
    local text = config.Title or "Input"
    local placeholderText = config.Placeholder or "Enter value..."
    local flag = config.Flag
    local callback = config.Callback

    local boxFrame = Instance.new("Frame")
    boxFrame.Name = getRandomName("BoxFrame_")
    boxFrame.Size = UDim2.new(1, 0, 0, 48)
    boxFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    boxFrame.BorderSizePixel = 0
    boxFrame.LayoutOrder = self.LayoutOrderCount
    boxFrame.Parent = self.Container

    local frameCorner = Instance.new("UICorner")
    frameCorner.Name = getRandomName("Corner_")
    frameCorner.CornerRadius = UDim.new(0, 3)
    frameCorner.Parent = boxFrame

    applyOutline(boxFrame, Color3.fromRGB(50, 50, 50), 1.2)

    local descLabel = Instance.new("TextLabel")
    descLabel.Name = getRandomName("Desc_")
    descLabel.Size = UDim2.new(1, -12, 0, 16)
    descLabel.Position = UDim2.new(0, 6, 0, 3)
    descLabel.BackgroundTransparency = 1
    descLabel.Font = Enum.Font.FredokaOne
    descLabel.Text = text
    descLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    descLabel.TextSize = 11
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = boxFrame

    applyTextStroke(descLabel, Color3.fromRGB(0, 0, 0), 1)

    local textBox = Instance.new("TextBox")
    textBox.Name = getRandomName("Input_")
    textBox.Size = UDim2.new(1, -12, 0, 24)
    textBox.Position = UDim2.new(0, 6, 0, 20)
    textBox.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    textBox.BorderSizePixel = 0
    textBox.Font = Enum.Font.FredokaOne
    textBox.PlaceholderText = placeholderText
    textBox.PlaceholderColor3 = Color3.fromRGB(130, 130, 130)
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.TextSize = 11
    textBox.TextXAlignment = Enum.TextXAlignment.Center
    textBox.ClearTextOnFocus = false
    textBox.Parent = boxFrame

    local boxCorner = Instance.new("UICorner")
    boxCorner.Name = getRandomName("Corner_")
    boxCorner.CornerRadius = UDim.new(0, 3)
    boxCorner.Parent = textBox

    applyOutline(textBox, Color3.fromRGB(40, 40, 40), 1)

    self.LayoutOrderCount = self.LayoutOrderCount + 1

    textBox.FocusLost:Connect(function(enterPressed)
        if flag then
            Cheiz.Flags[flag] = textBox.Text
        end
        if callback then
            callback(textBox.Text, enterPressed)
        end
    end)

    local textBoxObj = {}
    function textBoxObj:SetTitle(newTitle)
        descLabel.Text = newTitle
    end
    return textBoxObj
end

function Cheiz:AddDropdown(config)
    config = config or {}
    local descText = config.Desc or config.Title or "Select Option"
    local titleText = config.Title or "Select Option"
    local options = config.Options or {}
    local flag = config.Flag
    local callback = config.Callback

    local open = false
    local currentSelection = options[1] or titleText

    if flag then
        Cheiz.Flags[flag] = currentSelection
    end

    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = getRandomName("DropdownFrame_")
    dropdownFrame.Size = UDim2.new(1, 0, 0, 48)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.LayoutOrder = self.LayoutOrderCount
    dropdownFrame.Parent = self.Container

    local frameCorner = Instance.new("UICorner")
    frameCorner.Name = getRandomName("Corner_")
    frameCorner.CornerRadius = UDim.new(0, 3)
    frameCorner.Parent = dropdownFrame

    applyOutline(dropdownFrame, Color3.fromRGB(50, 50, 50), 1.2)

    local descLabel = Instance.new("TextLabel")
    descLabel.Name = getRandomName("Desc_")
    descLabel.Size = UDim2.new(1, -12, 0, 16)
    descLabel.Position = UDim2.new(0, 6, 0, 3)
    descLabel.BackgroundTransparency = 1
    descLabel.Font = Enum.Font.FredokaOne
    descLabel.Text = descText
    descLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    descLabel.TextSize = 11
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = dropdownFrame

    applyTextStroke(descLabel, Color3.fromRGB(0, 0, 0), 1)

    local mainBtn = Instance.new("TextButton")
    mainBtn.Name = getRandomName("DropdownBtn_")
    mainBtn.Size = UDim2.new(1, -12, 0, 24)
    mainBtn.Position = UDim2.new(0, 6, 0, 20)
    mainBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    mainBtn.BorderSizePixel = 0
    mainBtn.Font = Enum.Font.FredokaOne
    mainBtn.Text = currentSelection .. "  ▼"
    mainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainBtn.TextSize = 11
    mainBtn.ClipsDescendants = true
    mainBtn.Parent = dropdownFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.Name = getRandomName("Corner_")
    btnCorner.CornerRadius = UDim.new(0, 3)
    btnCorner.Parent = mainBtn

    applyOutline(mainBtn, Color3.fromRGB(40, 40, 40), 1)

    self.LayoutOrderCount = self.LayoutOrderCount + 1

    local popoutMenu = Instance.new("Frame")
    popoutMenu.Name = getRandomName("Popout_")
    popoutMenu.Size = UDim2.new(0, 200, 0, (#options + 1) * 30 + 8)
    popoutMenu.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    popoutMenu.BorderSizePixel = 0
    popoutMenu.Visible = false
    popoutMenu.ZIndex = 10
    popoutMenu.Parent = self.ScreenGui

    local menuCorner = Instance.new("UICorner")
    menuCorner.Name = getRandomName("Corner_")
    menuCorner.CornerRadius = UDim.new(0, 4)
    menuCorner.Parent = popoutMenu

    applyOutline(popoutMenu, Color3.fromRGB(50, 50, 50), 1.5)

    local menuList = Instance.new("UIListLayout")
    menuList.Name = getRandomName("Layout_")
    menuList.SortOrder = Enum.SortOrder.LayoutOrder
    menuList.Padding = UDim.new(0, 3)
    menuList.Parent = popoutMenu

    local menuPadding = Instance.new("UIPadding")
    menuPadding.Name = getRandomName("Padding_")
    menuPadding.PaddingTop = UDim.new(0, 4)
    menuPadding.PaddingBottom = UDim.new(0, 4)
    menuPadding.PaddingLeft = UDim.new(0, 4)
    menuPadding.PaddingRight = UDim.new(0, 4)
    menuPadding.Parent = popoutMenu

    local popoutTitle = Instance.new("TextLabel")
    popoutTitle.Name = getRandomName("Title_")
    popoutTitle.Size = UDim2.new(1, 0, 0, 22)
    popoutTitle.BackgroundTransparency = 1
    popoutTitle.Font = Enum.Font.FredokaOne
    popoutTitle.Text = titleText
    popoutTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    popoutTitle.TextSize = 13
    popoutTitle.LayoutOrder = 0
    popoutTitle.ZIndex = 11
    popoutTitle.Parent = popoutMenu

    applyTextStroke(popoutTitle, Color3.fromRGB(0, 0, 0), 1)

    local function closeDropdown()
        open = false
        popoutMenu.Visible = false
        self.Backdrop.Visible = false
    end

    for i, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Name = getRandomName("Opt_")
        optBtn.Size = UDim2.new(1, 0, 0, 28)
        optBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        optBtn.BorderSizePixel = 0
        optBtn.Font = Enum.Font.FredokaOne
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        optBtn.TextSize = 12
        optBtn.LayoutOrder = i
        optBtn.ZIndex = 11
        optBtn.ClipsDescendants = true
        optBtn.Parent = popoutMenu

        local optCorner = Instance.new("UICorner")
        optCorner.Name = getRandomName("Corner_")
        optCorner.CornerRadius = UDim.new(0, 3)
        optCorner.Parent = optBtn

        applyOutline(optBtn, Color3.fromRGB(45, 45, 45), 1)

        optBtn.MouseButton1Click:Connect(function()
            mainBtn.Text = opt .. "  ▼"
            playClickAnimation(optBtn)
            if flag then
                Cheiz.Flags[flag] = opt
            end
            closeDropdown()
            if callback then callback(opt) end
        end)
    end

    mainBtn.MouseButton1Click:Connect(function()
        open = not open
        playClickAnimation(mainBtn)
        if open then
            local windowFrame = self.MainFrame or (self.Window and self.Window.MainFrame)
            if windowFrame then
                local winPos = windowFrame.AbsolutePosition
                local winSize = windowFrame.AbsoluteSize
                popoutMenu.Position = UDim2.new(0, winPos.X + (winSize.X / 2) - 100, 0, winPos.Y + (winSize.Y / 2) - (((#options + 1) * 30 + 8) / 2))
            else
                local absolutePos = mainBtn.AbsolutePosition
                local absoluteSize = mainBtn.AbsoluteSize
                popoutMenu.Position = UDim2.new(0, absolutePos.X, 0, absolutePos.Y + absoluteSize.Y + 3)
            end
            popoutMenu.Visible = true
            self.Backdrop.Visible = true
        else
            closeDropdown()
        end
    end)

    self.Backdrop.MouseButton1Click:Connect(function()
        if open then
            closeDropdown()
        end
    end)

    local dropdownObj = {}
    function dropdownObj:SetTitle(newTitle)
        descLabel.Text = newTitle
    end
    return dropdownObj
end

function Cheiz:AddLabel(config)
    config = type(config) == "string" and { Title = config } or config or {}
    local text = config.Title or "Label"

    local label = Instance.new("TextLabel")
    label.Name = getRandomName("Label_")
    label.Size = UDim2.new(1, 0, 0, 18)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.FredokaOne
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 12
    label.LayoutOrder = self.LayoutOrderCount
    label.Parent = self.Container

    applyTextStroke(label, Color3.fromRGB(0, 0, 0), 1)

    self.LayoutOrderCount = self.LayoutOrderCount + 1

    local labelObj = {}
    function labelObj:SetTitle(newTitle)
        label.Text = newTitle
    end
    function labelObj:SetText(newText)
        label.Text = newText
    end
    return labelObj
end

return Cheiz
