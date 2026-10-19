local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer

local function randomizeName(length)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    local name = ""
    for i = 1, (length or 10) do
        local rand = math.random(1, #chars)
        name = name .. chars:sub(rand, rand)
    end
    return name
end

local Cheiz = {}
Cheiz.WindowConfig = {
    Title = "CHEIZ LIBRARY",
    FloatingButton = true,
    IconSize = UDim2.fromOffset(45, 45),
    IconId = 1000418434,
    DisplayOrder = 999999,
    DragThreshold = 15,
    Transparent = true,
    BackgroundTransparency = 0.35,
}

local TargetParent = nil
local success, err = pcall(function()
    if gethui then
        TargetParent = gethui()
    elseif cloneref then
        TargetParent = cloneref(CoreGui)
    else
        TargetParent = CoreGui
    end
end)

if not success or not TargetParent then
    TargetParent = LocalPlayer:WaitForChild("PlayerGui")
end

local guiName = randomizeName(12)
if TargetParent:FindFirstChild(guiName) then
    TargetParent[guiName]:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = Cheiz.WindowConfig.DisplayOrder
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local protectGui = syn and syn.protect_gui or protectgui
if protectGui then
    protectGui(ScreenGui)
end
ScreenGui.Parent = TargetParent

local function applyTabGradient(instance)
    local grad = instance:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 210, 255)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(30, 120, 245)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 85, 200))
    })
    grad.Rotation = 90
    grad.Parent = instance
    return grad
end

local function applyHeaderGradient(instance)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 18, 26)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 75, 170))
    })
    grad.Rotation = 90
    grad.Parent = instance
    return grad
end

local function applyTextGradient(textLabel)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 200, 230))
    })
    grad.Rotation = 90
    grad.Parent = textLabel
end

local NotifHolder = Instance.new("Frame")
NotifHolder.Name = randomizeName(8)
NotifHolder.Size = UDim2.new(0, 230, 1, -20)
NotifHolder.Position = UDim2.new(1, -240, 0, 10)
NotifHolder.BackgroundTransparency = 1
NotifHolder.ZIndex = 100
NotifHolder.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Padding = UDim.new(0, 6)
NotifLayout.Parent = NotifHolder

function Cheiz:SendNotification(titleText, messageText, duration)
    local dur = duration or 1
    
    local card = Instance.new("Frame")
    card.Size = UDim2.fromOffset(230, 52)
    card.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
    card.BorderSizePixel = 0
    card.BackgroundTransparency = 1
    card.Parent = NotifHolder

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Color3.fromRGB(20, 110, 240)
    cardStroke.Thickness = 1.5
    cardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    cardStroke.Parent = card

    local notifHeader = Instance.new("Frame")
    notifHeader.Size = UDim2.new(1, 0, 0, 20)
    notifHeader.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    notifHeader.BorderSizePixel = 0
    notifHeader.BackgroundTransparency = 1
    notifHeader.Parent = card

    applyHeaderGradient(notifHeader)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -10, 1, 0)
    title.Position = UDim2.fromOffset(6, 0)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 11
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = notifHeader
    applyTextGradient(title)

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -12, 0, 24)
    desc.Position = UDim2.fromOffset(6, 23)
    desc.BackgroundTransparency = 1
    desc.Text = messageText
    desc.TextColor3 = Color3.fromRGB(180, 190, 210)
    desc.TextSize = 10
    desc.Font = Enum.Font.GothamBold
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = card

    TweenService:Create(card, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    TweenService:Create(cardStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
    TweenService:Create(notifHeader, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    TweenService:Create(title, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
    TweenService:Create(desc, TweenInfo.new(0.2), {TextTransparency = 0}):Play()

    task.delay(dur, function()
        local fadeOut = TweenService:Create(card, TweenInfo.new(0.2), {BackgroundTransparency = 1})
        TweenService:Create(cardStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
        TweenService:Create(notifHeader, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        TweenService:Create(title, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        TweenService:Create(desc, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            card:Destroy()
        end)
    end)
end

local MainBase = Instance.new("Frame")
MainBase.Name = randomizeName(8)
MainBase.Size = UDim2.fromOffset(430, 300)
MainBase.AnchorPoint = Vector2.new(0.5, 0.55)
MainBase.Position = UDim2.new(0.5, 0, 0.5, 0)
MainBase.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
MainBase.BackgroundTransparency = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
MainBase.BorderSizePixel = 0
MainBase.Visible = true
MainBase.Parent = ScreenGui

local UIScale = Instance.new("UIScale")
UIScale.Scale = 1
UIScale.Parent = MainBase

local AspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
AspectRatioConstraint.AspectRatio = 430 / 300
AspectRatioConstraint.Parent = MainBase

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 0, 0)
MainStroke.Thickness = 2
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainBase

local Header = Instance.new("Frame")
Header.Name = randomizeName(8)
Header.Size = UDim2.new(1, 0, 0, 36)
Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Header.BackgroundTransparency = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
Header.BorderSizePixel = 0
Header.Parent = MainBase

applyHeaderGradient(Header)

local HeaderStroke = Instance.new("UIStroke")
HeaderStroke.Color = Color3.fromRGB(0, 0, 0)
HeaderStroke.Thickness = 1.5
HeaderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
HeaderStroke.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.fromOffset(10, 0)
Title.BackgroundTransparency = 1
Title.Text = Cheiz.WindowConfig.Title
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header
applyTextGradient(Title)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(24, 24)
CloseBtn.Position = UDim2.new(1, -29, 0.5, -12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 35, 35)
CloseBtn.BackgroundTransparency = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Color3.fromRGB(0, 0, 0)
CloseStroke.Thickness = 1.5
CloseStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
CloseStroke.Parent = CloseBtn

local savedPosition = MainBase.Position
local isUIVisible = true

local function toggleUI()
    isUIVisible = not isUIVisible
    local targetAlpha = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
    if isUIVisible then
        MainBase.Visible = true
        MainBase.Position = UDim2.new(savedPosition.X.Scale, savedPosition.X.Offset, 1.5, 0)
        MainBase.BackgroundTransparency = 1
        
        TweenService:Create(MainBase, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = savedPosition,
            BackgroundTransparency = targetAlpha
        }):Play()
    else
        savedPosition = MainBase.Position
        
        local tw = TweenService:Create(MainBase, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(savedPosition.X.Scale, savedPosition.X.Offset, 1.5, 0),
            BackgroundTransparency = 1
        })
        tw:Play()
        tw.Completed:Connect(function()
            if not isUIVisible then MainBase.Visible = false end
        end)
    end
end

if Cheiz.WindowConfig.FloatingButton then
    local FloatBtnFrame = Instance.new("Frame")
    FloatBtnFrame.Name = randomizeName(8)
    FloatBtnFrame.Size = Cheiz.WindowConfig.IconSize
    FloatBtnFrame.Position = UDim2.new(0, 20, 0.5, -20)
    FloatBtnFrame.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
    FloatBtnFrame.BorderSizePixel = 0
    FloatBtnFrame.ZIndex = 50
    FloatBtnFrame.Parent = ScreenGui

    local FloatCorner = Instance.new("UICorner")
    FloatCorner.CornerRadius = UDim.new(0, 8)
    FloatCorner.Parent = FloatBtnFrame

    if Cheiz.WindowConfig.IconId then
        local IconImg = Instance.new("ImageLabel")
        IconImg.Size = UDim2.new(1, -8, 1, -8)
        IconImg.Position = UDim2.fromOffset(4, 4)
        IconImg.BackgroundTransparency = 1
        IconImg.Image = "rbxassetid://" .. tostring(Cheiz.WindowConfig.IconId)
        IconImg.Parent = FloatBtnFrame
    else
        local IconTxt = Instance.new("TextLabel")
        IconTxt.Size = UDim2.fromScale(1, 1)
        IconTxt.BackgroundTransparency = 1
        IconTxt.Text = "UI"
        IconTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
        IconTxt.TextSize = 14
        IconTxt.Font = Enum.Font.GothamBold
        IconTxt.Parent = FloatBtnFrame
    end

    local FloatBtn = Instance.new("TextButton")
    FloatBtn.Size = UDim2.fromScale(1, 1)
    FloatBtn.BackgroundTransparency = 1
    FloatBtn.Text = ""
    FloatBtn.Parent = FloatBtnFrame

    local floatActive, floatStart, floatPos, floatDragging = nil, nil, nil, false

    FloatBtn.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and floatActive == nil then
            floatActive = input
            floatStart = input.Position
            floatPos = FloatBtnFrame.Position
            floatDragging = false
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input == floatActive then 
            if not floatDragging then
                local origSize = Cheiz.WindowConfig.IconSize
                local smallSize = UDim2.fromOffset(origSize.X.Offset * 0.8, origSize.Y.Offset * 0.8)
                
                local tweenDown = TweenService:Create(FloatBtnFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = smallSize})
                local tweenUp = TweenService:Create(FloatBtnFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = origSize})
                
                tweenDown:Play()
                tweenDown.Completed:Connect(function()
                    tweenUp:Play()
                end)

                toggleUI()
            end
            floatActive = nil 
            floatDragging = false 
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == floatActive and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - floatStart
            if not floatDragging and (math.abs(delta.X) > Cheiz.WindowConfig.DragThreshold or math.abs(delta.Y) > Cheiz.WindowConfig.DragThreshold) then
                floatDragging = true
            end
            if floatDragging then
                FloatBtnFrame.Position = UDim2.new(floatPos.X.Scale, floatPos.X.Offset + delta.X, floatPos.Y.Scale, floatPos.Y.Offset + delta.Y)
            end
        end
    end)
end

local DialogueOverlay = Instance.new("Frame")
DialogueOverlay.Name = randomizeName(8)
DialogueOverlay.Size = UDim2.fromScale(1, 1)
DialogueOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DialogueOverlay.BackgroundTransparency = 0.5
DialogueOverlay.Visible = false
DialogueOverlay.ZIndex = 80
DialogueOverlay.Parent = ScreenGui

local Pages = {}
local TabButtons = {}
local ActiveTab = nil

local function SwitchTab(tabName)
    for name, page in pairs(Pages) do
        page.Visible = (name == tabName)
    end
    
    for name, btn in pairs(TabButtons) do
        local existingGrad = btn:FindFirstChildOfClass("UIGradient")
        local tAlpha = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
        if name == tabName then
            btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundTransparency = tAlpha
            btn.TextColor3 = Color3.fromRGB(10, 15, 30)
            applyTabGradient(btn)
        else
            btn.BackgroundColor3 = Color3.fromRGB(20, 24, 34)
            btn.BackgroundTransparency = tAlpha
            btn.TextColor3 = Color3.fromRGB(150, 160, 180)
            if existingGrad then
                existingGrad:Destroy()
            end
        end
    end
    ActiveTab = tabName
end

function Cheiz:CloseDialogue()
    DialogueOverlay.Visible = false
end

function Cheiz:AddFloatingMenu(config)
    local menuFrame = Instance.new("Frame")
    menuFrame.Name = randomizeName(8)
    
    if config.Size then
        menuFrame.Size = UDim2.fromOffset(config.Size.X, config.Size.Y)
    else
        menuFrame.Size = UDim2.fromOffset(130, 26)
    end
    
    menuFrame.Position = config.Position or UDim2.new(0, 15, 0.2, 0)
    menuFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 24)
    menuFrame.BackgroundTransparency = 0.2
    menuFrame.BorderSizePixel = 0
    menuFrame.ZIndex = 60
    menuFrame.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = menuFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(35, 40, 52)
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = menuFrame

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 8)
    layout.Parent = menuFrame

    local dynamicLabels = {}

    for _, item in ipairs(config.Items or {}) do
        if item.Type == "Label" then
            local container = Instance.new("Frame")
            container.Size = UDim2.fromOffset(52, 20)
            container.BackgroundTransparency = 1
            container.Parent = menuFrame

            local subLayout = Instance.new("UIListLayout")
            subLayout.FillDirection = Enum.FillDirection.Horizontal
            subLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            subLayout.Padding = UDim.new(0, 3)
            subLayout.Parent = container

            local valLbl = Instance.new("TextLabel")
            valLbl.Size = UDim2.fromOffset(24, 20)
            valLbl.BackgroundTransparency = 1
            valLbl.Text = item.Value or "0"
            valLbl.TextColor3 = item.Color or Color3.fromRGB(240, 70, 70)
            valLbl.TextSize = 10
            valLbl.Font = Enum.Font.GothamBold
            valLbl.TextXAlignment = Enum.TextXAlignment.Right
            valLbl.Parent = container

            local descLbl = Instance.new("TextLabel")
            descLbl.Size = UDim2.fromOffset(24, 20)
            descLbl.BackgroundTransparency = 1
            descLbl.Text = item.Title or "STAT"
            descLbl.TextColor3 = Color3.fromRGB(160, 170, 190)
            descLbl.TextSize = 9
            descLbl.Font = Enum.Font.GothamBold
            descLbl.TextXAlignment = Enum.TextXAlignment.Left
            descLbl.Parent = container

            if item.Dynamic then
                dynamicLabels[item.Dynamic] = valLbl
            end
        end
    end

    if dynamicLabels["FPS"] or dynamicLabels["PING"] then
        task.spawn(function()
            while menuFrame and menuFrame.Parent do
                if dynamicLabels["FPS"] then
                    local fps = math.floor(workspace:GetRealPhysicsFPS())
                    dynamicLabels["FPS"].Text = tostring(fps)
                end
                if dynamicLabels["PING"] then
                    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                    dynamicLabels["PING"].Text = tostring(ping) .. "ms"
                end
                task.wait(0.5)
            end
        end)
    end

    if config.Draggable then
        local active, dragStart, startPos = nil, nil, nil

        menuFrame.InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and active == nil then
                active = input
                dragStart = input.Position
                startPos = menuFrame.Position
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input == active then active = nil end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == active and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                menuFrame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    return menuFrame
end

function Cheiz:CreateDialogue(config)
    DialogueOverlay.Visible = true

    for _, child in ipairs(DialogueOverlay:GetChildren()) do 
        child:Destroy() 
    end

    local box = Instance.new("Frame")
    box.Size = UDim2.fromOffset(320, 180)
    box.Position = UDim2.new(0.5, -160, 0.5, -90)
    box.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
    box.BackgroundTransparency = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
    box.BorderSizePixel = 0
    box.ZIndex = 81
    box.Parent = DialogueOverlay

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(30, 35, 48)
    stroke.Thickness = 1.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = box

    local accent = Instance.new("Frame")
    accent.Size = UDim2.fromOffset(4, 18)
    accent.Position = UDim2.fromOffset(12, 12)
    accent.BackgroundColor3 = Color3.fromRGB(20, 110, 240)
    accent.BorderSizePixel = 0
    accent.ZIndex = 82
    accent.Parent = box

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -40, 0, 18)
    titleLbl.Position = UDim2.fromOffset(22, 12)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = config.Title or "Dialogue Title"
    titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLbl.TextSize = 14
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 82
    titleLbl.Parent = box

    local warnTitle = (config.Warns and config.Warns.Warning) or "WARNING"
    local warnLbl = Instance.new("TextLabel")
    warnLbl.Size = UDim2.new(1, -24, 0, 14)
    warnLbl.Position = UDim2.fromOffset(12, 38)
    warnLbl.BackgroundTransparency = 1
    warnLbl.Text = warnTitle
    warnLbl.TextColor3 = Color3.fromRGB(20, 110, 240)
    warnLbl.TextSize = 10
    warnLbl.Font = Enum.Font.GothamBold
    warnLbl.TextXAlignment = Enum.TextXAlignment.Left
    warnLbl.ZIndex = 82
    warnLbl.Parent = box

    local warnBodyText = (config.Warns and config.Warns.Text) or ""
    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -24, 0, 42)
    descLbl.Position = UDim2.fromOffset(12, 54)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = warnBodyText
    descLbl.TextColor3 = Color3.fromRGB(200, 205, 215)
    descLbl.TextSize = 10
    descLbl.TextWrapped = (config.TextWrapped == nil and true) or config.TextWrapped
    descLbl.Font = Enum.Font.GothamBold
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.ZIndex = 82
    descLbl.Parent = box

    local statsLbl = Instance.new("TextLabel")
    statsLbl.Size = UDim2.new(1, -24, 0, 16)
    statsLbl.Position = UDim2.fromOffset(12, 100)
    statsLbl.BackgroundTransparency = 1
    statsLbl.Text = "Your FPS: --  Your Ping: --"
    statsLbl.TextColor3 = Color3.fromRGB(80, 220, 120)
    statsLbl.TextSize = 11
    statsLbl.Font = Enum.Font.GothamBold
    statsLbl.TextXAlignment = Enum.TextXAlignment.Left
    statsLbl.RichText = true
    statsLbl.ZIndex = 82
    statsLbl.Parent = box

    task.spawn(function()
        local fps = math.floor(workspace:GetRealPhysicsFPS())
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        
        if config.SomeText then
            local formattedText = config.SomeText:gsub("{FPS}", tostring(fps)):gsub("{PING}", tostring(ping))
            statsLbl.Text = formattedText
        else
            statsLbl.Text = string.format("Your FPS <font color=\"rgb(80,220,120)\">%d</font>  Your Ping <font color=\"rgb(80,220,120)\">%d ms</font>", fps, ping)
        end
    end)

    local btnsConfig = config.Buttons or {}

    local cancelBtn = Instance.new("TextButton")
    cancelBtn.Size = UDim2.fromOffset(135, 30)
    cancelBtn.Position = UDim2.new(0, 12, 1, -40)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(35, 38, 48)
    cancelBtn.BackgroundTransparency = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
    cancelBtn.Text = (btnsConfig.Cancel and btnsConfig.Cancel.Text) or "Cancel"
    cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    cancelBtn.TextSize = 11
    cancelBtn.Font = Enum.Font.GothamBold
    cancelBtn.ZIndex = 82
    cancelBtn.Parent = box

    local confirmBtn = Instance.new("TextButton")
    confirmBtn.Size = UDim2.fromOffset(135, 30)
    confirmBtn.Position = UDim2.new(1, -147, 1, -40)
    confirmBtn.BackgroundColor3 = Color3.fromRGB(20, 110, 240)
    confirmBtn.BackgroundTransparency = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
    confirmBtn.Text = (btnsConfig.Confirm and btnsConfig.Confirm.Text) or "Turn On"
    confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirmBtn.TextSize = 11
    confirmBtn.Font = Enum.Font.GothamBold
    confirmBtn.ZIndex = 82
    confirmBtn.Parent = box

    cancelBtn.MouseButton1Click:Connect(function()
        Cheiz:CloseDialogue()
        if btnsConfig.Cancel and btnsConfig.Cancel.Callback then
            btnsConfig.Cancel.Callback()
        end
    end)

    confirmBtn.MouseButton1Click:Connect(function()
        Cheiz:CloseDialogue()
        if btnsConfig.Confirm and btnsConfig.Confirm.Callback then
            btnsConfig.Confirm.Callback()
        end
    end)
end

local PopupOverlay = Instance.new("Frame")
PopupOverlay.Name = randomizeName(8)
PopupOverlay.Size = UDim2.fromScale(1, 1)
PopupOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
PopupOverlay.BackgroundTransparency = 0.5
PopupOverlay.Visible = false
PopupOverlay.ZIndex = 90
PopupOverlay.Parent = ScreenGui

local PopupBox = Instance.new("Frame")
PopupBox.Size = UDim2.fromOffset(260, 120)
PopupBox.Position = UDim2.new(0.5, -130, 0.5, -60)
PopupBox.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
PopupBox.BackgroundTransparency = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
PopupBox.BorderSizePixel = 0
PopupBox.ZIndex = 91
PopupBox.Parent = PopupOverlay

local PopupStroke = Instance.new("UIStroke")
PopupStroke.Color = Color3.fromRGB(20, 110, 240)
PopupStroke.Thickness = 2
PopupStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
PopupStroke.Parent = PopupBox

local PopupHeader = Instance.new("Frame")
PopupHeader.Size = UDim2.new(1, 0, 0, 28)
PopupHeader.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PopupHeader.BackgroundTransparency = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
PopupHeader.BorderSizePixel = 0
PopupHeader.ZIndex = 92
PopupHeader.Parent = PopupBox

applyHeaderGradient(PopupHeader)

local PopupTitle = Instance.new("TextLabel")
PopupTitle.Size = UDim2.fromScale(1, 1)
PopupTitle.BackgroundTransparency = 1
PopupTitle.Text = "Close Script?"
PopupTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PopupTitle.TextSize = 13
PopupTitle.Font = Enum.Font.GothamBold
PopupTitle.ZIndex = 93
PopupTitle.Parent = PopupHeader
applyTextGradient(PopupTitle)

local BackBtn = Instance.new("TextButton")
BackBtn.Size = UDim2.fromOffset(100, 28)
BackBtn.Position = UDim2.new(0, 20, 1, -42)
BackBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
BackBtn.BackgroundTransparency = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
BackBtn.Text = "Back"
BackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BackBtn.TextSize = 12
BackBtn.Font = Enum.Font.GothamBold
BackBtn.ZIndex = 92
BackBtn.Parent = PopupBox

local ConfirmCloseBtn = Instance.new("TextButton")
ConfirmCloseBtn.Size = UDim2.fromOffset(100, 28)
ConfirmCloseBtn.Position = UDim2.new(1, -120, 1, -42)
ConfirmCloseBtn.BackgroundColor3 = Color3.fromRGB(200, 35, 35)
ConfirmCloseBtn.BackgroundTransparency = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
ConfirmCloseBtn.Text = "Close"
ConfirmCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmCloseBtn.TextSize = 12
ConfirmCloseBtn.Font = Enum.Font.GothamBold
ConfirmCloseBtn.ZIndex = 92
ConfirmCloseBtn.Parent = PopupBox

CloseBtn.MouseButton1Click:Connect(function()
    PopupOverlay.Visible = true
end)

BackBtn.MouseButton1Click:Connect(function()
    PopupOverlay.Visible = false
end)

ConfirmCloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local TabBar = Instance.new("Frame")
TabBar.Name = randomizeName(8)
TabBar.Size = UDim2.new(1, -16, 0, 28)
TabBar.Position = UDim2.fromOffset(8, 42)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainBase

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 4)
TabLayout.Parent = TabBar

local PageContainer = Instance.new("Frame")
PageContainer.Name = randomizeName(8)
PageContainer.Size = UDim2.new(1, -16, 1, -82)
PageContainer.Position = UDim2.fromOffset(8, 74)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainBase

function Cheiz:CreateTab(tabName)
    local btn = Instance.new("TextButton")
    btn.Name = randomizeName(8)
    btn.Size = UDim2.new(0, 95, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(20, 24, 34)
    btn.BackgroundTransparency = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(150, 160, 180)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = TabBar
    applyTextGradient(btn)

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(0, 0, 0)
    btnStroke.Thickness = 1.5
    btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    btnStroke.Parent = btn

    local scrollPage = Instance.new("ScrollingFrame")
    scrollPage.Name = tabName .. "Tab"
    scrollPage.Size = UDim2.fromScale(1, 1)
    scrollPage.BackgroundTransparency = 1
    scrollPage.BorderSizePixel = 0
    scrollPage.CanvasSize = UDim2.fromScale(0, 0)
    scrollPage.ScrollBarThickness = 3
    scrollPage.Visible = false
    scrollPage.Parent = PageContainer

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 6)
    pageLayout.Parent = scrollPage

    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollPage.CanvasSize = UDim2.fromOffset(0, pageLayout.AbsoluteContentSize.Y + 10)
    end)

    Pages[tabName] = scrollPage
    TabButtons[tabName] = btn

    btn.MouseButton1Click:Connect(function()
        SwitchTab(tabName)
    end)

    if not ActiveTab then
        SwitchTab(tabName)
    end

    local TabAPI = {}

    function TabAPI:Select()
        SwitchTab(tabName)
    end

    function TabAPI:AddDivider()
        local divCard = Instance.new("Frame")
        divCard.Name = "Card_Divider"
        divCard.Size = UDim2.new(1, -4, 0, 10)
        divCard.BackgroundTransparency = 1
        divCard.Parent = scrollPage

        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, 0, 0, 1)
        line.Position = UDim2.new(0, 0, 0.5, 0)
        line.BackgroundColor3 = Color3.fromRGB(35, 42, 60)
        line.BorderSizePixel = 0
        line.Parent = divCard

        return divCard
    end

    function TabAPI:AddSection(sectionTitle)
        local sectionFrame = Instance.new("Frame")
        sectionFrame.Name = "Section_" .. sectionTitle
        sectionFrame.Size = UDim2.new(1, -4, 0, 28)
        sectionFrame.BackgroundTransparency = 1
        sectionFrame.Parent = scrollPage

        local sectionBtn = Instance.new("TextButton")
        sectionBtn.Size = UDim2.fromScale(1, 1)
        sectionBtn.BackgroundTransparency = 1
        sectionBtn.Text = "v " .. sectionTitle
        sectionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        sectionBtn.TextSize = 14
        sectionBtn.Font = Enum.Font.GothamBold
        sectionBtn.TextXAlignment = Enum.TextXAlignment.Left
        sectionBtn.Parent = sectionFrame
        applyTextGradient(sectionBtn)

        local expanded = true
        sectionBtn.MouseButton1Click:Connect(function()
            expanded = not expanded
            sectionBtn.Text = (expanded and "v " or "> ") .. sectionTitle
            
            for _, child in ipairs(scrollPage:GetChildren()) do
                if child:IsA("Frame") and child ~= sectionFrame and child.Name:find("Card_") then
                    if expanded then
                        child.Visible = true
                        child.Size = UDim2.new(1, -4, 0, 0)
                        local targetH = 34
                        if child.Name:find("Toggle") then targetH = 44 end
                        if child.Name:find("Slider") then targetH = 50 end
                        if child.Name:find("TextBox") then targetH = (child.AbsoluteSize.Y > 40 and 52 or 42) end
                        TweenService:Create(child, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Size = UDim2.new(1, -4, 0, targetH)
                        }):Play()
                    else
                        local tw = TweenService:Create(child, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Size = UDim2.new(1, -4, 0, 0)
                        })
                        tw:Play()
                        tw.Completed:Connect(function()
                            if not expanded then child.Visible = false end
                        end)
                    end
                end
            end
        end)

        local sectionObj = {
            SetTitle = function(self, newText)
                sectionTitle = newText
                sectionBtn.Text = (expanded and "v " or "> ") .. newText
            end
        }
        return sectionObj
    end

    function TabAPI:AddLabel(config)
        local labelText = config.Title or "Label"
        local configColor = config.Color
        local card = Instance.new("Frame")
        card.Name = "Card_" .. labelText
        card.Size = UDim2.new(1, -4, 0, 32)
        card.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
        card.BackgroundTransparency = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
        card.BorderSizePixel = 0
        card.ClipsDescendants = true
        card.Parent = scrollPage

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 0, 0)
        stroke.Thickness = 1.5
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = card

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -16, 1, 0)
        textLabel.Position = UDim2.fromOffset(8, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = labelText
        textLabel.TextColor3 = configColor or Color3.fromRGB(255, 255, 255)
        textLabel.TextSize = 12
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.Parent = card
        if not configColor then applyTextGradient(textLabel) end

        return {
            SetTitle = function(self, newText)
                labelText = newText
                textLabel.Text = newText
                card.Name = "Card_" .. newText
            end
        }
    end

    function TabAPI:AddButton(config)
        local titleText = config.Title or "Button"
        local buttonBtnText = config.ButtonText or "Execute"
        local callback = config.Callback

        local card = Instance.new("Frame")
        card.Name = "Card_" .. titleText
        card.Size = UDim2.new(1, -4, 0, 34)
        card.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
        card.BackgroundTransparency = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
        card.BorderSizePixel = 0
        card.ClipsDescendants = true
        card.Parent = scrollPage

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 0, 0)
        stroke.Thickness = 1.5
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = card

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -125, 1, 0)
        title.Position = UDim2.fromOffset(10, 0)
        title.BackgroundTransparency = 1
        title.Text = titleText
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 13
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = card
        applyTextGradient(title)

        local actionBtn = Instance.new("TextButton")
        actionBtn.Size = UDim2.fromOffset(100, 22)
        actionBtn.Position = UDim2.new(1, -110, 0.5, -11)
        actionBtn.BackgroundColor3 = Color3.fromRGB(25, 120, 240)
        actionBtn.BackgroundTransparency = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
        actionBtn.BorderSizePixel = 0
        actionBtn.Text = buttonBtnText
        actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        actionBtn.TextSize = 11
        actionBtn.Font = Enum.Font.GothamBold
        actionBtn.Parent = card
        applyTextGradient(actionBtn)

        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = Color3.fromRGB(0, 0, 0)
        btnStroke.Thickness = 1.5
        btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        btnStroke.Parent = actionBtn

        actionBtn.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)

        return {
            SetTitle = function(self, newText)
                titleText = newText
                title.Text = newText
                card.Name = "Card_" .. newText
            end,
            SetButtonText = function(self, newBtnText)
                actionBtn.Text = newBtnText
            end
        }
    end

    function TabAPI:AddToggle(config)
        local titleText = config.Title or "Toggle"
        local descText = config.Desc or ""
        local defaultState = config.Default or false
        local callback = config.Callback
        local dropdownConfig = config.Dropdown
        local keybindConfig = config.Keybind

        local hasDesc = descText ~= ""
        local hasDropdown = dropdownConfig and dropdownConfig.Options ~= nil
        local baseHeight = hasDesc and 44 or 34

        local card = Instance.new("Frame")
        card.Name = "Card_Toggle_" .. titleText
        card.Size = UDim2.new(1, -4, 0, baseHeight)
        card.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
        card.BackgroundTransparency = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
        card.BorderSizePixel = 0
        card.ClipsDescendants = true
        card.Parent = scrollPage

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 0, 0)
        stroke.Thickness = 1.5
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = card

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -65, 0, 16)
        title.Position = UDim2.fromOffset(10, hasDesc and 4 or 9)
        title.BackgroundTransparency = 1
        title.Text = titleText
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 13
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = card
        applyTextGradient(title)

        local desc = nil
        if hasDesc then
            desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(1, -65, 0, 14)
            desc.Position = UDim2.fromOffset(10, 22)
            desc.BackgroundTransparency = 1
            desc.Text = descText
            desc.TextColor3 = Color3.fromRGB(130, 140, 160)
            desc.TextSize = 10
            desc.Font = Enum.Font.GothamBold
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.Parent = card
        end

        local currentKey = keybindConfig and keybindConfig.Default
        local keybindBtn = nil
        if keybindConfig then
            keybindBtn = Instance.new("TextButton")
            keybindBtn.Size = UDim2.fromOffset(45, 18)
            keybindBtn.Position = UDim2.new(1, -98, 0.5, -9)
            keybindBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
            keybindBtn.BackgroundTransparency = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
            keybindBtn.Text = currentKey and currentKey.Name or "None"
            keybindBtn.TextColor3 = Color3.fromRGB(180, 190, 210)
            keybindBtn.TextSize = 9
            keybindBtn.Font = Enum.Font.GothamBold
            keybindBtn.Parent = card
            
            local kbStroke = Instance.new("UIStroke")
            kbStroke.Color = Color3.fromRGB(0, 0, 0)
            kbStroke.Thickness = 1
            kbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            kbStroke.Parent = keybindBtn
        end

        local toggleBox = Instance.new("Frame")
        toggleBox.Size = UDim2.fromOffset(38, 20)
        toggleBox.Position = UDim2.new(1, -48, 0.5, -10)
        local tAlpha = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
        toggleBox.BackgroundColor3 = defaultState and Color3.fromRGB(25, 120, 240) or Color3.fromRGB(30, 35, 48)
        toggleBox.BackgroundTransparency = tAlpha
        toggleBox.BorderSizePixel = 0
        toggleBox.Parent = card

        local boxStroke = Instance.new("UIStroke")
        boxStroke.Color = Color3.fromRGB(0, 0, 0)
        boxStroke.Thickness = 1.5
        boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        boxStroke.Parent = toggleBox

        local knob = Instance.new("Frame")
        knob.Size = UDim2.fromOffset(14, 14)
        knob.Position = defaultState and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.BackgroundTransparency = tAlpha
        knob.BorderSizePixel = 0
        knob.Parent = toggleBox

        local clickBtn = Instance.new("TextButton")
        clickBtn.Size = UDim2.new(1, keybindConfig and -55 or 0, 1, 0)
        clickBtn.BackgroundTransparency = 1
        clickBtn.Text = ""
        clickBtn.Parent = card

        local dropdownFrame = nil
        local dropdownListLayout = nil
        if hasDropdown then
            dropdownFrame = Instance.new("Frame")
            dropdownFrame.Name = "DropdownContainer"
            dropdownFrame.Size = UDim2.new(1, -16, 0, 0)
            dropdownFrame.Position = UDim2.fromOffset(8, baseHeight)
            dropdownFrame.BackgroundColor3 = Color3.fromRGB(14, 16, 24)
            dropdownFrame.BackgroundTransparency = 1
            dropdownFrame.Visible = false
            dropdownFrame.Parent = card

            dropdownListLayout = Instance.new("UIListLayout")
            dropdownListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            dropdownListLayout.Padding = UDim.new(0, 4)
            dropdownListLayout.Parent = dropdownFrame

            for _, optText in ipairs(dropdownConfig.Options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 24)
                optBtn.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
                optBtn.BackgroundTransparency = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
                optBtn.Text = "  " .. optText
                optBtn.TextColor3 = Color3.fromRGB(180, 190, 210)
                optBtn.TextSize = 11
                optBtn.Font = Enum.Font.GothamBold
                optBtn.TextXAlignment = Enum.TextXAlignment.Left
                optBtn.Parent = dropdownFrame

                local optStroke = Instance.new("UIStroke")
                optStroke.Color = Color3.fromRGB(0, 0, 0)
                optStroke.Thickness = 1
                optStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                optStroke.Parent = optBtn

                optBtn.MouseButton1Click:Connect(function()
                    if dropdownConfig.Callback then
                        dropdownConfig.Callback(optText)
                    end
                end)
            end
        end

        local toggled = defaultState

        local function updateState(newState)
            toggled = newState
            local alphaVal = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
            toggleBox.BackgroundColor3 = toggled and Color3.fromRGB(25, 120, 240) or Color3.fromRGB(30, 35, 48)
            toggleBox.BackgroundTransparency = alphaVal
            knob.Position = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            
            if hasDropdown then
                if toggled then
                    dropdownFrame.Visible = true
                    local contentH = (#dropdownConfig.Options * 28) + 8
                    local totalH = baseHeight + contentH
                    TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, -4, 0, totalH)
                    }):Play()
                    TweenService:Create(dropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, -16, 0, contentH),
                        BackgroundTransparency = alphaVal
                    }):Play()
                else
                    TweenService:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        Size = UDim2.new(1, -4, 0, baseHeight)
                    }):Play()
                    local tw = TweenService:Create(dropdownFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        Size = UDim2.new(1, -16, 0, 0),
                        BackgroundTransparency = 1
                    })
                    tw:Play()
                    tw.Completed:Connect(function()
                        if not toggled then dropdownFrame.Visible = false end
                    end)
                end
            end

            if callback then callback(toggled) end
        end

        clickBtn.MouseButton1Click:Connect(function()
            updateState(not toggled)
        end)

        if keybindConfig and keybindBtn then
            local listening = false
            keybindBtn.MouseButton1Click:Connect(function()
                if listening then return end
                listening = true
                keybindBtn.Text = "..."
                
                local connection
                connection = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        keybindBtn.Text = currentKey.Name
                        listening = false
                        connection:Disconnect()
                    end
                end)
            end)

            UserInputService.InputBegan:Connect(function(input, gpe)
                if not gpe and currentKey and input.KeyCode == currentKey then
                    updateState(not toggled)
                end
            end)
        end

        return {
            SetToggle = function(self, state)
                updateState(state)
            end,
            SetTitle = function(self, newText)
                titleText = newText
                title.Text = newText
                card.Name = "Card_Toggle_" .. newText
            end
        }
    end

    function TabAPI:AddSlider(config)
        local titleText = config.Title or "Slider"
        local descText = config.Desc or ""
        local minVal = config.Min or 0
        local maxVal = config.Max or 100
        local defaultVal = config.Default or 50
        local step = config.Step or 1
        local callback = config.Callback

        local hasDesc = descText ~= ""
        local baseHeight = hasDesc and 48 or 40

        local card = Instance.new("Frame")
        card.Name = "Card_Slider_" .. titleText
        card.Size = UDim2.new(1, -4, 0, baseHeight)
        card.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
        card.BackgroundTransparency = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
        card.BorderSizePixel = 0
        card.ClipsDescendants = true
        card.Parent = scrollPage

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 0, 0)
        stroke.Thickness = 1.5
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = card

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -60, 0, 16)
        title.Position = UDim2.fromOffset(10, hasDesc and 4 or 6)
        title.BackgroundTransparency = 1
        title.Text = titleText
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 13
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = card
        applyTextGradient(title)

        local valLabel = Instance.new("TextLabel")
        valLabel.Size = UDim2.new(0, 50, 0, 16)
        valLabel.Position = UDim2.new(1, -55, 0, hasDesc and 4 or 6)
        valLabel.BackgroundTransparency = 1
        valLabel.Text = tostring(defaultVal)
        valLabel.TextColor3 = Color3.fromRGB(180, 190, 210)
        valLabel.TextSize = 12
        valLabel.Font = Enum.Font.GothamBold
        valLabel.TextXAlignment = Enum.TextXAlignment.Right
        valLabel.Parent = card

        if hasDesc then
            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(1, -20, 0, 14)
            desc.Position = UDim2.fromOffset(10, 20)
            desc.BackgroundTransparency = 1
            desc.Text = descText
            desc.TextColor3 = Color3.fromRGB(130, 140, 160)
            desc.TextSize = 10
            desc.Font = Enum.Font.GothamBold
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.Parent = card
        end

        local sliderBar = Instance.new("Frame")
        sliderBar.Size = UDim2.new(1, -20, 0, 6)
        sliderBar.Position = UDim2.new(0, 10, 0, hasDesc and 36 or 28)
        sliderBar.BackgroundColor3 = Color3.fromRGB(30, 35, 48)
        sliderBar.BorderSizePixel = 0
        sliderBar.Parent = card

        local barCorner = Instance.new("UICorner")
        barCorner.CornerRadius = UDim.new(1, 0)
        barCorner.Parent = sliderBar

        local sliderFill = Instance.new("Frame")
        local initPercent = math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1)
        sliderFill.Size = UDim2.new(initPercent, 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(25, 120, 240)
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBar

        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = sliderFill

        local sliderBtn = Instance.new("TextButton")
        sliderBtn.Size = UDim2.new(1, 10, 1, 10)
        sliderBtn.Position = UDim2.fromOffset(-5, -5)
        sliderBtn.BackgroundTransparency = 1
        sliderBtn.Text = ""
        sliderBtn.Parent = sliderBar

        local currentValue = defaultVal
        local dragging = false

        local function updateSlider(inputPos)
            local barPos = sliderBar.AbsolutePosition.X
            local barSize = sliderBar.AbsoluteSize.X
            local pos = math.clamp((inputPos - barPos) / barSize, 0, 1)
            local rawVal = minVal + ((maxVal - minVal) * pos)
            
            if step > 0 then
                currentValue = math.round(rawVal / step) * step
            else
                currentValue = rawVal
            end
            currentValue = math.clamp(currentValue, minVal, maxVal)

            local p = (currentValue - minVal) / (maxVal - minVal)
            sliderFill.Size = UDim2.new(p, 0, 1, 0)
            valLabel.Text = tostring(currentValue)

            if callback then callback(currentValue) end
        end

        sliderBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                updateSlider(input.Position.X)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(input.Position.X)
            end
        end)

        return {
            SetTitle = function(self, newText)
                titleText = newText
                title.Text = newText
                card.Name = "Card_Slider_" .. newText
            end
        }
    end

    function TabAPI:AddTextBox(config)
        local titleText = config.Title or "TextBox"
        local descText = config.Desc or ""
        local placeholderText = config.Placeholder or "Type here..."
        local defaultText = config.Default or ""
        local callback = config.Callback

        local hasDesc = descText ~= ""
        local baseHeight = hasDesc and 52 or 42

        local card = Instance.new("Frame")
        card.Name = "Card_TextBox_" .. titleText
        card.Size = UDim2.new(1, -4, 0, baseHeight)
        card.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
        card.BackgroundTransparency = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
        card.BorderSizePixel = 0
        card.ClipsDescendants = true
        card.Parent = scrollPage

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 0, 0)
        stroke.Thickness = 1.5
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = card

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -120, 0, 16)
        title.Position = UDim2.fromOffset(10, hasDesc and 4 or 6)
        title.BackgroundTransparency = 1
        title.Text = titleText
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 13
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = card
        applyTextGradient(title)

        if hasDesc then
            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(1, -120, 0, 14)
            desc.Position = UDim2.fromOffset(10, 20)
            desc.BackgroundTransparency = 1
            desc.Text = descText
            desc.TextColor3 = Color3.fromRGB(130, 140, 160)
            desc.TextSize = 10
            desc.Font = Enum.Font.GothamBold
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.Parent = card
        end

        local textBoxBg = Instance.new("Frame")
        textBoxBg.Size = UDim2.new(0, 110, 0, 24)
        textBoxBg.Position = UDim2.new(1, -118, 0.5, -12)
        textBoxBg.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
        textBoxBg.BackgroundTransparency = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
        textBoxBg.BorderSizePixel = 0
        textBoxBg.Parent = card

        local boxStroke = Instance.new("UIStroke")
        boxStroke.Color = Color3.fromRGB(0, 0, 0)
        boxStroke.Thickness = 1
        boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        boxStroke.Parent = textBoxBg

        local boxCorner = Instance.new("UICorner")
        boxCorner.CornerRadius = UDim.new(0, 4)
        boxCorner.Parent = textBoxBg

        local textInput = Instance.new("TextBox")
        textInput.Size = UDim2.new(1, -10, 1, 0)
        textInput.Position = UDim2.fromOffset(5, 0)
        textInput.BackgroundTransparency = 1
        textInput.Text = defaultText
        textInput.PlaceholderText = placeholderText
        textInput.PlaceholderColor3 = Color3.fromRGB(110, 120, 140)
        textInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        textInput.TextSize = 11
        textInput.Font = Enum.Font.GothamBold
        textInput.TextXAlignment = Enum.TextXAlignment.Left
        textInput.Parent = textBoxBg

        textInput.FocusLost:Connect(function(enterPressed)
            if callback then
                callback(textInput.Text, enterPressed)
            end
        end)

        return {
            SetTitle = function(self, newText)
                titleText = newText
                title.Text = newText
                card.Name = "Card_TextBox_" .. newText
            end
        }
    end

    return TabAPI
end

function Cheiz:AddSearchFeatures(config)
    local BottomFrame = Instance.new("Frame")
    BottomFrame.Name = randomizeName(8)
    BottomFrame.Size = UDim2.new(1, 0, 0, 26)
    BottomFrame.Position = UDim2.new(0, 0, 1, 8)
    BottomFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
    BottomFrame.BackgroundTransparency = Cheiz.WindowConfig.Transparent and Cheiz.WindowConfig.BackgroundTransparency or 0
    BottomFrame.BorderSizePixel = 0
    BottomFrame.Parent = MainBase

    local BottomStroke = Instance.new("UIStroke")
    BottomStroke.Color = Color3.fromRGB(0, 0, 0)
    BottomStroke.Thickness = 1.5
    BottomStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    BottomStroke.Parent = BottomFrame

    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(1, -12, 1, 0)
    SearchBox.Position = UDim2.fromOffset(6, 0)
    SearchBox.BackgroundTransparency = 1
    SearchBox.Text = ""
    SearchBox.PlaceholderText = (config and config.Title) or "Search features..."
    SearchBox.PlaceholderColor3 = Color3.fromRGB(110, 120, 140)
    SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchBox.TextSize = 11
    SearchBox.Font = Enum.Font.GothamBold
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    SearchBox.Parent = BottomFrame

    local searchFocusLine = Instance.new("Frame")
    searchFocusLine.Size = UDim2.new(1, 0, 0, 2)
    searchFocusLine.Position = UDim2.new(0, 0, 1, -2)
    searchFocusLine.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
    searchFocusLine.BackgroundTransparency = 1
    searchFocusLine.BorderSizePixel = 0
    searchFocusLine.Parent = BottomFrame

    SearchBox.Focused:Connect(function()
        searchFocusLine.BackgroundTransparency = 0
    end)
    SearchBox.FocusLost:Connect(function()
        searchFocusLine.BackgroundTransparency = 1
    end)

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local filterText = SearchBox.Text:lower()
        for _, page in pairs(Pages) do
            for _, child in ipairs(page:GetChildren()) do
                if child:IsA("Frame") and child.Name:find("Card_") then
                    if filterText == "" or child.Name:lower():find(filterText) then
                        child.Visible = true
                    else
                        child.Visible = false
                    end
                end
            end
        end
    end)
end

local activeInput = nil
local dragStart = nil
local startPos = nil
local isDragging = false

Header.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and activeInput == nil then
        activeInput = input
        dragStart = input.Position
        startPos = MainBase.Position
        isDragging = false
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input == activeInput then
        activeInput = nil
        isDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == activeInput and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        if not isDragging then
            if math.abs(delta.X) > Cheiz.WindowConfig.DragThreshold or math.abs(delta.Y) > Cheiz.WindowConfig.DragThreshold then
                isDragging = true
            end
        end
        if isDragging then
            MainBase.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            savedPosition = MainBase.Position
        end
    end
end)

return Cheiz
