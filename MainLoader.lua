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

function Cheiz:AddWindow(config)
    local windowConfig = {
        Title = (config and config.Title) or "CHEIZ HUB",
        FloatingButton = (config and config.FloatingButton ~= nil) and config.FloatingButton or true,
        IconSize = (config and config.IconSize) or UDim2.fromOffset(45, 45),
        IconId = (config and config.IconId) or 1000418434,
        DisplayOrder = (config and config.DisplayOrder) or 999999,
        DragThreshold = (config and config.DragThreshold) or 15,
        Transparent = (config and config.Transparent ~= nil) and config.Transparent or true,
        BackgroundTransparency = (config and config.BackgroundTransparency) or 0.35,
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
    ScreenGui.DisplayOrder = windowConfig.DisplayOrder
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

    local elementAlpha = windowConfig.Transparent and windowConfig.BackgroundTransparency or 0

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
        card.BackgroundTransparency = elementAlpha
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
        notifHeader.BackgroundTransparency = elementAlpha
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

        task.delay(dur, function()
            local fadeOut = TweenService:Create(card, TweenInfo.new(0.2), {BackgroundTransparency = 1})
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
    MainBase.BackgroundTransparency = elementAlpha
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
    Header.BackgroundTransparency = elementAlpha
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
    Title.Text = windowConfig.Title
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
    CloseBtn.BackgroundTransparency = elementAlpha
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
        if isUIVisible then
            MainBase.Visible = true
            MainBase.Position = UDim2.new(savedPosition.X.Scale, savedPosition.X.Offset, 1.5, 0)
            MainBase.BackgroundTransparency = 1
            
            TweenService:Create(MainBase, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = savedPosition,
                BackgroundTransparency = elementAlpha
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

    if windowConfig.FloatingButton then
        local FloatBtnFrame = Instance.new("Frame")
        FloatBtnFrame.Name = randomizeName(8)
        FloatBtnFrame.Size = windowConfig.IconSize
        FloatBtnFrame.Position = UDim2.new(0, 20, 0.5, -20)
        FloatBtnFrame.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
        FloatBtnFrame.BackgroundTransparency = elementAlpha
        FloatBtnFrame.BorderSizePixel = 0
        FloatBtnFrame.ZIndex = 50
        FloatBtnFrame.Parent = ScreenGui

        local FloatCorner = Instance.new("UICorner")
        FloatCorner.CornerRadius = UDim.new(0, 8)
        FloatCorner.Parent = FloatBtnFrame

        if windowConfig.IconId then
            local IconImg = Instance.new("ImageLabel")
            IconImg.Size = UDim2.new(1, -8, 1, -8)
            IconImg.Position = UDim2.fromOffset(4, 4)
            IconImg.BackgroundTransparency = 1
            IconImg.Image = "rbxassetid://" .. tostring(windowConfig.IconId)
            IconImg.Parent = FloatBtnFrame
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
                    toggleUI()
                end
                floatActive = nil 
                floatDragging = false 
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == floatActive and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - floatStart
                if not floatDragging and (math.abs(delta.X) > windowConfig.DragThreshold or math.abs(delta.Y) > windowConfig.DragThreshold) then
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

    function Cheiz:CloseDialogue()
        DialogueOverlay.Visible = false
    end

    function Cheiz:AddFloatingMenu(config)
        local menuFrame = Instance.new("Frame")
        menuFrame.Name = randomizeName(8)
        menuFrame.Size = config.Size and UDim2.fromOffset(config.Size.X, config.Size.Y) or UDim2.fromOffset(130, 26)
        menuFrame.Position = config.Position or UDim2.new(0, 15, 0.2, 0)
        menuFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 24)
        menuFrame.BackgroundTransparency = elementAlpha
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
                        dynamicLabels["FPS"].Text = tostring(math.floor(workspace:GetRealPhysicsFPS()))
                    end
                    if dynamicLabels["PING"] then
                        dynamicLabels["PING"].Text = tostring(math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())) .. "ms"
                    end
                    task.wait(0.5)
                end
            end)
        end

        return menuFrame
    end

    function Cheiz:CreateDialogue(config)
        DialogueOverlay.Visible = true
        for _, child in ipairs(DialogueOverlay:GetChildren()) do child:Destroy() end

        local box = Instance.new("Frame")
        box.Size = UDim2.fromOffset(320, 180)
        box.Position = UDim2.new(0.5, -160, 0.5, -90)
        box.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
        box.BackgroundTransparency = elementAlpha
        box.BorderSizePixel = 0
        box.ZIndex = 81
        box.Parent = DialogueOverlay

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(30, 35, 48)
        stroke.Thickness = 1.5
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = box

        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(1, -40, 0, 18)
        titleLbl.Position = UDim2.fromOffset(22, 12)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = config.Title or "Dialogue"
        titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLbl.TextSize = 14
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.ZIndex = 82
        titleLbl.Parent = box

        local btns = config.Buttons or {}
        local cancelBtn = Instance.new("TextButton")
        cancelBtn.Size = UDim2.fromOffset(135, 30)
        cancelBtn.Position = UDim2.new(0, 12, 1, -40)
        cancelBtn.BackgroundColor3 = Color3.fromRGB(35, 38, 48)
        cancelBtn.BackgroundTransparency = elementAlpha
        cancelBtn.Text = (btns.Cancel and btns.Cancel.Text) or "Cancel"
        cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        cancelBtn.TextSize = 11
        cancelBtn.Font = Enum.Font.GothamBold
        cancelBtn.ZIndex = 82
        cancelBtn.Parent = box

        local confirmBtn = Instance.new("TextButton")
        confirmBtn.Size = UDim2.fromOffset(135, 30)
        confirmBtn.Position = UDim2.new(1, -147, 1, -40)
        confirmBtn.BackgroundColor3 = Color3.fromRGB(20, 110, 240)
        confirmBtn.BackgroundTransparency = elementAlpha
        confirmBtn.Text = (btns.Confirm and btns.Confirm.Text) or "Confirm"
        confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        confirmBtn.TextSize = 11
        confirmBtn.Font = Enum.Font.GothamBold
        confirmBtn.ZIndex = 82
        confirmBtn.Parent = box

        cancelBtn.MouseButton1Click:Connect(function()
            Cheiz:CloseDialogue()
            if btns.Cancel and btns.Cancel.Callback then btns.Cancel.Callback() end
        end)

        confirmBtn.MouseButton1Click:Connect(function()
            Cheiz:CloseDialogue()
            if btns.Confirm and btns.Confirm.Callback then btns.Confirm.Callback() end
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
    PopupBox.BackgroundTransparency = elementAlpha
    
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
    PopupHeader.BackgroundTransparency = elementAlpha
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
    BackBtn.BackgroundTransparency = elementAlpha
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
    ConfirmCloseBtn.BackgroundTransparency = elementAlpha
    ConfirmCloseBtn.Text = "Close"
    ConfirmCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ConfirmCloseBtn.TextSize = 12
    ConfirmCloseBtn.Font = Enum.Font.GothamBold
    ConfirmCloseBtn.ZIndex = 92
    ConfirmCloseBtn.Parent = PopupBox

    CloseBtn.MouseButton1Click:Connect(function() PopupOverlay.Visible = true end)
    BackBtn.MouseButton1Click:Connect(function() PopupOverlay.Visible = false end)
    ConfirmCloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

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

    local Pages = {}
    local TabButtons = {}
    local ActiveTab = nil

    local function SwitchTab(tabName)
        for name, page in pairs(Pages) do page.Visible = (name == tabName) end
        for name, btn in pairs(TabButtons) do
            local existingGrad = btn:FindFirstChildOfClass("UIGradient")
            if name == tabName then
                btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                btn.BackgroundTransparency = elementAlpha
                btn.TextColor3 = Color3.fromRGB(10, 15, 30)
                applyTabGradient(btn)
            else
                btn.BackgroundColor3 = Color3.fromRGB(20, 24, 34)
                btn.BackgroundTransparency = elementAlpha
                btn.TextColor3 = Color3.fromRGB(150, 160, 180)
                if existingGrad then existingGrad:Destroy() end
            end
        end
        ActiveTab = tabName
    end

    local WindowAPI = {}

    function WindowAPI:CreateTab(tabName)
        local btn = Instance.new("TextButton")
        btn.Name = randomizeName(8)
        btn.Size = UDim2.new(0, 95, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(20, 24, 34)
        btn.BackgroundTransparency = elementAlpha
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

        btn.MouseButton1Click:Connect(function() SwitchTab(tabName) end)
        if not ActiveTab then SwitchTab(tabName) end

        local TabAPI = {}

        function TabAPI:Select()
            SwitchTab(tabName)
        end

        function TabAPI:AddDivider()
            local divCard = Instance.new("Frame")
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
                        child.Visible = expanded
                    end
                end
            end)
            return { SetTitle = function(self, t) sectionBtn.Text = t end }
        end

        function TabAPI:AddLabel(config)
            local card = Instance.new("Frame")
            card.Name = "Card_Label"
            card.Size = UDim2.new(1, -4, 0, 32)
            card.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
            card.BackgroundTransparency = elementAlpha
            card.BorderSizePixel = 0
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
            textLabel.Text = config.Title or "Label"
            textLabel.TextColor3 = config.Color or Color3.fromRGB(255, 255, 255)
            textLabel.TextSize = 12
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextXAlignment = Enum.TextXAlignment.Left
            textLabel.Parent = card
            if not config.Color then applyTextGradient(textLabel) end
            return card
        end

        function TabAPI:AddButton(config)
            local card = Instance.new("Frame")
            card.Name = "Card_Button"
            card.Size = UDim2.new(1, -4, 0, 34)
            card.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
            card.BackgroundTransparency = elementAlpha
            card.BorderSizePixel = 0
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
            title.Text = config.Title or "Button"
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
            actionBtn.BackgroundTransparency = elementAlpha
            actionBtn.BorderSizePixel = 0
            actionBtn.Text = config.ButtonText or "Execute"
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
                if config.Callback then config.Callback() end
            end)
            return card
        end

        function TabAPI:AddToggle(config)
            local card = Instance.new("Frame")
            card.Name = "Card_Toggle"
            card.Size = UDim2.new(1, -4, 0, config.Desc and 44 or 34)
            card.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
            card.BackgroundTransparency = elementAlpha
            card.BorderSizePixel = 0
            card.Parent = scrollPage

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(0, 0, 0)
            stroke.Thickness = 1.5
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = card

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -65, 0, 16)
            title.Position = UDim2.fromOffset(10, config.Desc and 4 or 9)
            title.BackgroundTransparency = 1
            title.Text = config.Title or "Toggle"
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.TextSize = 13
            title.Font = Enum.Font.GothamBold
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = card
            applyTextGradient(title)

            if config.Desc then
                local desc = Instance.new("TextLabel")
                desc.Size = UDim2.new(1, -65, 0, 14)
                desc.Position = UDim2.fromOffset(10, 22)
                desc.BackgroundTransparency = 1
                desc.Text = config.Desc
                desc.TextColor3 = Color3.fromRGB(130, 140, 160)
                desc.TextSize = 10
                desc.Font = Enum.Font.GothamBold
                desc.TextXAlignment = Enum.TextXAlignment.Left
                desc.Parent = card
            end

            local toggleBox = Instance.new("Frame")
            toggleBox.Size = UDim2.fromOffset(38, 20)
            toggleBox.Position = UDim2.new(1, -48, 0.5, -10)
            toggleBox.BackgroundColor3 = config.Default and Color3.fromRGB(25, 120, 240) or Color3.fromRGB(30, 35, 48)
            toggleBox.BackgroundTransparency = elementAlpha
            toggleBox.BorderSizePixel = 0
            toggleBox.Parent = card

            local boxStroke = Instance.new("UIStroke")
            boxStroke.Color = Color3.fromRGB(0, 0, 0)
            boxStroke.Thickness = 1.5
            boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            boxStroke.Parent = toggleBox

            local knob = Instance.new("Frame")
            knob.Size = UDim2.fromOffset(14, 14)
            knob.Position = config.Default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.BackgroundTransparency = elementAlpha
            knob.BorderSizePixel = 0
            knob.Parent = toggleBox

            local clickBtn = Instance.new("TextButton")
            clickBtn.Size = UDim2.fromScale(1, 1)
            clickBtn.BackgroundTransparency = 1
            clickBtn.Text = ""
            clickBtn.Parent = card

            local toggled = config.Default or false
            clickBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                toggleBox.BackgroundColor3 = toggled and Color3.fromRGB(25, 120, 240) or Color3.fromRGB(30, 35, 48)
                knob.Position = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                if config.Callback then config.Callback(toggled) end
            end)
            return card
        end

        function TabAPI:AddDropdown(config)
            local titleText = config.Title or "Dropdown"
            local descText = config.Desc or ""
            local options = config.Options or {}
            local isMulti = config.Multi or false
            local defaultVal = config.Default
            local callback = config.Callback

            local hasDesc = descText ~= ""
            local baseHeight = hasDesc and 52 or 42

            local card = Instance.new("Frame")
            card.Name = "Card_Dropdown_" .. titleText
            card.Size = UDim2.new(1, -4, 0, baseHeight)
            card.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
            card.BackgroundTransparency = elementAlpha
            card.BorderSizePixel = 0
            card.ClipsDescendants = true
            card.Parent = scrollPage

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(0, 0, 0)
            stroke.Thickness = 1.5
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = card

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -140, 0, 16)
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
                desc.Size = UDim2.new(1, -140, 0, 14)
                desc.Position = UDim2.fromOffset(10, 20)
                desc.BackgroundTransparency = 1
                desc.Text = descText
                desc.TextColor3 = Color3.fromRGB(130, 140, 160)
                desc.TextSize = 10
                desc.Font = Enum.Font.GothamBold
                desc.TextXAlignment = Enum.TextXAlignment.Left
                desc.Parent = card
            end

            local dropdownBtn = Instance.new("TextButton")
            dropdownBtn.Size = UDim2.new(0, 130, 0, 26)
            dropdownBtn.Position = UDim2.new(1, -138, 0.5, -13)
            dropdownBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
            dropdownBtn.BackgroundTransparency = elementAlpha
            dropdownBtn.BorderSizePixel = 0
            dropdownBtn.Text = ""
            dropdownBtn.Parent = card

            local btnStroke = Instance.new("UIStroke")
            btnStroke.Color = Color3.fromRGB(0, 0, 0)
            btnStroke.Thickness = 1.5
            btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            btnStroke.Parent = dropdownBtn

            local btnLabel = Instance.new("TextLabel")
            btnLabel.Size = UDim2.new(1, -20, 1, 0)
            btnLabel.Position = UDim2.fromOffset(8, 0)
            btnLabel.BackgroundTransparency = 1
            btnLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            btnLabel.TextSize = 11
            btnLabel.Font = Enum.Font.GothamBold
            btnLabel.TextXAlignment = Enum.TextXAlignment.Left
            btnLabel.Parent = dropdownBtn

            local arrow = Instance.new("TextLabel")
            arrow.Size = UDim2.fromOffset(16, 16)
            arrow.Position = UDim2.new(1, -18, 0.5, -8)
            arrow.BackgroundTransparency = 1
            arrow.Text = "v"
            arrow.TextColor3 = Color3.fromRGB(180, 190, 210)
            arrow.TextSize = 10
            arrow.Font = Enum.Font.GothamBold
            arrow.Parent = dropdownBtn

            local listContainer = Instance.new("Frame")
            listContainer.Name = "ListContainer"
            listContainer.Size = UDim2.new(1, -16, 0, 0)
            listContainer.Position = UDim2.fromOffset(8, baseHeight)
            listContainer.BackgroundTransparency = 1
            listContainer.Visible = false
            listContainer.Parent = card

            local listLayout = Instance.new("UIListLayout")
            listLayout.SortOrder = Enum.SortOrder.LayoutOrder
            listLayout.Padding = UDim.new(0, 4)
            listLayout.Parent = listContainer

            local selectedValues = {}
            if isMulti then
                if type(defaultVal) == "table" then
                    for _, v in ipairs(defaultVal) do selectedValues[v] = true end
                end
            else
                selectedValues = defaultVal or options[1]
            end

            local function getDisplayText()
                if isMulti then
                    local t = {}
                    for _, opt in ipairs(options) do
                        if selectedValues[opt] then table.insert(t, opt) end
                    end
                    if #t == 0 then return "Select..." end
                    return table.concat(t, ", ")
                else
                    return tostring(selectedValues or "Select...")
                end
            end

            btnLabel.Text = getDisplayText()

            for _, opt in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 24)
                local isSelected = isMulti and selectedValues[opt] or (selectedValues == opt)
                optBtn.BackgroundColor3 = isSelected and Color3.fromRGB(25, 120, 240) or Color3.fromRGB(22, 26, 36)
                optBtn.BackgroundTransparency = elementAlpha
                optBtn.Text = "  " .. opt
                optBtn.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 190, 210)
                optBtn.TextSize = 11
                optBtn.Font = Enum.Font.GothamBold
                optBtn.TextXAlignment = Enum.TextXAlignment.Left
                optBtn.Parent = listContainer

                local optStroke = Instance.new("UIStroke")
                optStroke.Color = Color3.fromRGB(0, 0, 0)
                optStroke.Thickness = 1
                optStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                optStroke.Parent = optBtn

                optBtn.MouseButton1Click:Connect(function()
                    if isMulti then
                        selectedValues[opt] = not selectedValues[opt]
                        optBtn.BackgroundColor3 = selectedValues[opt] and Color3.fromRGB(25, 120, 240) or Color3.fromRGB(22, 26, 36)
                        optBtn.TextColor3 = selectedValues[opt] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 190, 210)
                        btnLabel.Text = getDisplayText()
                        if callback then callback(selectedValues) end
                    else
                        selectedValues = opt
                        for _, child in ipairs(listContainer:GetChildren()) do
                            if child:IsA("TextButton") then
                                local match = (child.Text:gsub("^%s*", "") == selectedValues)
                                child.BackgroundColor3 = match and Color3.fromRGB(25, 120, 240) or Color3.fromRGB(22, 26, 36)
                                child.TextColor3 = match and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 190, 210)
                            end
                        end
                        btnLabel.Text = getDisplayText()
                        
                        isOpen = false
                        arrow.Text = "v"
                        TweenService:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Size = UDim2.new(1, -4, 0, baseHeight)
                        }):Play()
                        local tw = TweenService:Create(listContainer, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Size = UDim2.new(1, -16, 0, 0)
                        })
                        tw:Play()
                        tw.Completed:Connect(function()
                            if not isOpen then listContainer.Visible = false end
                        end)

                        if callback then callback(selectedValues) end
                    end
                end)
            end

            local isOpen = false
            dropdownBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                arrow.Text = isOpen and "^" or "v"

                if isOpen then
                    listContainer.Visible = true
                    local contentH = (#options * 28) + 8
                    local totalH = baseHeight + contentH
                    TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, -4, 0, totalH)
                    }):Play()
                    TweenService:Create(listContainer, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, -16, 0, contentH)
                    }):Play()
                else
                    TweenService:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        Size = UDim2.new(1, -4, 0, baseHeight)
                    }):Play()
                    local tw = TweenService:Create(listContainer, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        Size = UDim2.new(1, -16, 0, 0)
                    })
                    tw:Play()
                    tw.Completed:Connect(function()
                        if not isOpen then listContainer.Visible = false end
                    end)
                end
            end)

            return card
        end

        function TabAPI:AddSlider(config)
            local card = Instance.new("Frame")
            card.Name = "Card_Slider"
            card.Size = UDim2.new(1, -4, 0, config.Desc and 46 or 40)
            card.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
            card.BackgroundTransparency = elementAlpha
            card.BorderSizePixel = 0
            card.Parent = scrollPage

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(0, 0, 0)
            stroke.Thickness = 1.5
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = card

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -60, 0, 16)
            title.Position = UDim2.fromOffset(10, config.Desc and 4 or 5)
            title.BackgroundTransparency = 1
            title.Text = config.Title or "Slider"
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.TextSize = 13
            title.Font = Enum.Font.GothamBold
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = card
            applyTextGradient(title)

            local valLabel = Instance.new("TextLabel")
            valLabel.Size = UDim2.new(0, 50, 0, 16)
            valLabel.Position = UDim2.new(1, -55, 0, config.Desc and 4 or 5)
            valLabel.BackgroundTransparency = 1
            valLabel.Text = tostring(config.Default or 50)
            valLabel.TextColor3 = Color3.fromRGB(180, 190, 210)
            valLabel.TextSize = 12
            valLabel.Font = Enum.Font.GothamBold
            valLabel.TextXAlignment = Enum.TextXAlignment.Right
            valLabel.Parent = card

            local sliderBar = Instance.new("Frame")
            sliderBar.Size = UDim2.new(1, -20, 0, 4)
            sliderBar.Position = UDim2.new(0, 10, 0, config.Desc and 37 or 29)
            sliderBar.BackgroundColor3 = Color3.fromRGB(30, 35, 48)
            sliderBar.BackgroundTransparency = elementAlpha
            sliderBar.BorderSizePixel = 0
            sliderBar.Parent = card

            local initP = math.clamp(((config.Default or 50) - (config.Min or 0)) / ((config.Max or 100) - (config.Min or 0)), 0, 1)
            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new(initP, 0, 1, 0)
            sliderFill.BackgroundColor3 = Color3.fromRGB(25, 120, 240)
            sliderFill.BackgroundTransparency = elementAlpha
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderBar

            local sliderBtn = Instance.new("TextButton")
            sliderBtn.Size = UDim2.new(1, 10, 1, 10)
            sliderBtn.Position = UDim2.fromOffset(-5, -5)
            sliderBtn.BackgroundTransparency = 1
            sliderBtn.Text = ""
            sliderBtn.Parent = sliderBar

            local minVal = config.Min or 0
            local maxVal = config.Max or 100
            local step = config.Step or 1
            local currentValue = config.Default or 50
            local dragging = false

            sliderBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local barPos = sliderBar.AbsolutePosition.X
                    local barSize = sliderBar.AbsoluteSize.X
                    local pos = math.clamp((input.Position.X - barPos) / barSize, 0, 1)
                    local rawVal = minVal + ((maxVal - minVal) * pos)
                    currentValue = step > 0 and math.round(rawVal / step) * step or rawVal
                    currentValue = math.clamp(currentValue, minVal, maxVal)

                    sliderFill.Size = UDim2.new((currentValue - minVal) / (maxVal - minVal), 0, 1, 0)
                    valLabel.Text = tostring(currentValue)
                    if config.Callback then config.Callback(currentValue) end
                end
            end)

            return card
        end

        function TabAPI:AddTextBox(config)
            local card = Instance.new("Frame")
            card.Name = "Card_TextBox"
            card.Size = UDim2.new(1, -4, 0, config.Desc and 52 or 42)
            card.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
            card.BackgroundTransparency = elementAlpha
            card.BorderSizePixel = 0
            card.Parent = scrollPage

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(0, 0, 0)
            stroke.Thickness = 1.5
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = card

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -120, 0, 16)
            title.Position = UDim2.fromOffset(10, config.Desc and 4 or 6)
            title.BackgroundTransparency = 1
            title.Text = config.Title or "TextBox"
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.TextSize = 13
            title.Font = Enum.Font.GothamBold
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = card
            applyTextGradient(title)

            local textBoxBg = Instance.new("Frame")
            textBoxBg.Size = UDim2.new(0, 110, 0, 24)
            textBoxBg.Position = UDim2.new(1, -118, 0.5, -12)
            textBoxBg.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
            textBoxBg.BackgroundTransparency = elementAlpha
            textBoxBg.BorderSizePixel = 0
            textBoxBg.Parent = card

            local boxStroke = Instance.new("UIStroke")
            boxStroke.Color = Color3.fromRGB(0, 0, 0)
            boxStroke.Thickness = 1
            boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            boxStroke.Parent = textBoxBg

            local focusLine = Instance.new("Frame")
            focusLine.Size = UDim2.new(1, 0, 0, 2)
            focusLine.Position = UDim2.new(0, 0, 1, -2)
            focusLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            focusLine.BackgroundTransparency = 1
            focusLine.BorderSizePixel = 0
            focusLine.Parent = textBoxBg

            local textInput = Instance.new("TextBox")
            textInput.Size = UDim2.new(1, -10, 1, 0)
            textInput.Position = UDim2.fromOffset(5, 0)
            textInput.BackgroundTransparency = 1
            textInput.Text = config.Default or ""
            textInput.PlaceholderText = config.Placeholder or "Type here..."
            textInput.PlaceholderColor3 = Color3.fromRGB(110, 120, 140)
            textInput.TextColor3 = Color3.fromRGB(255, 255, 255)
            textInput.TextSize = 11
            textInput.Font = Enum.Font.GothamBold
            textInput.TextXAlignment = Enum.TextXAlignment.Left
            textInput.Parent = textBoxBg

            textInput.Focused:Connect(function() focusLine.BackgroundTransparency = 0 end)
            textInput.FocusLost:Connect(function(enter)
                focusLine.BackgroundTransparency = 1
                if config.Callback then config.Callback(textInput.Text, enter) end
            end)

            return card
        end

        return TabAPI
    end

    function Cheiz:AddSearchFeatures(config)
        local BottomFrame = Instance.new("Frame")
        BottomFrame.Name = randomizeName(8)
        BottomFrame.Size = UDim2.new(1, 0, 0, 26)
        BottomFrame.Position = UDim2.new(0, 0, 1, 8)
        BottomFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
        BottomFrame.BackgroundTransparency = elementAlpha
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
    end

    local activeInput, dragStart, startPos, isDragging = nil, nil, nil, false
    Header.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and activeInput == nil then
            activeInput = input
            dragStart = input.Position
            startPos = MainBase.Position
            isDragging = false
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input == activeInput then activeInput = nil; isDragging = false end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == activeInput and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if not isDragging and (math.abs(delta.X) > windowConfig.DragThreshold or math.abs(delta.Y) > windowConfig.DragThreshold) then
                isDragging = true
            end
            if isDragging then
                MainBase.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                savedPosition = MainBase.Position
            end
        end
    end)

    return WindowAPI
end

return Cheiz
