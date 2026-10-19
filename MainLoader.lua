--[================================================================================]--
--                               CHEIZ HUB UI LIBRARY                                 --
--                               Full Source Code                                   --
--[================================================================================]--

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

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
        SliderThreshold = 6,
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
    if protectGui then protectGui(ScreenGui) end
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

    local mainAlpha = windowConfig.Transparent and windowConfig.BackgroundTransparency or 0

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
        card.BackgroundTransparency = 0
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
            fadeOut.Completed:Connect(function() card:Destroy() end)
        end)
    end

    local MainBase = Instance.new("Frame")
    MainBase.Name = randomizeName(8)
    MainBase.Size = UDim2.fromOffset(430, 300)
    MainBase.AnchorPoint = Vector2.new(0.5, 0.55)
    MainBase.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainBase.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
    MainBase.BackgroundTransparency = mainAlpha
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
    Header.BackgroundTransparency = 0
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
    CloseBtn.BackgroundTransparency = 0
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
                BackgroundTransparency = mainAlpha
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
        FloatBtnFrame.BackgroundTransparency = 0
        FloatBtnFrame.BorderSizePixel = 0
        FloatBtnFrame.ZIndex = 50
        FloatBtnFrame.Parent = ScreenGui

        local FloatCorner = Instance.new("UICorner")
        FloatCorner.CornerRadius = UDim.new(0, 8)
        FloatCorner.Parent = FloatBtnFrame

        local FloatStroke = Instance.new("UIStroke")
        FloatStroke.Color = Color3.fromRGB(0, 0, 0)
        FloatStroke.Thickness = 1.5
        FloatStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        FloatStroke.Parent = FloatBtnFrame

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
                    local origSize = windowConfig.IconSize
                    local smallSize = UDim2.fromOffset(origSize.X.Offset * 0.82, origSize.Y.Offset * 0.82)
                    local tweenDown = TweenService:Create(FloatBtnFrame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = smallSize})
                    local tweenUp = TweenService:Create(FloatBtnFrame, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = origSize})
                    tweenDown:Play()
                    tweenDown.Completed:Connect(function() tweenUp:Play() end)

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
    DialogueOverlay.ZIndex = 200
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
        menuFrame.BackgroundTransparency = 0
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

        if dynamicLabels["FPS"] then
            task.spawn(function()
                while menuFrame and menuFrame.Parent do
                    if dynamicLabels["FPS"] then
                        dynamicLabels["FPS"].Text = tostring(math.floor(workspace:GetRealPhysicsFPS()))
                    end
                    task.wait(0.5)
                end
            end)
        end

        if config.Draggable == nil or config.Draggable then
            local fActive, fStart, fPos, fDragging = nil, nil, nil, false
            menuFrame.InputBegan:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and fActive == nil then
                    fActive = input
                    fStart = input.Position
                    fPos = menuFrame.Position
                    fDragging = false
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input == fActive then fActive = nil; fDragging = false end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if input == fActive and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local delta = input.Position - fStart
                    if not fDragging and (math.abs(delta.X) > 5 or math.abs(delta.Y) > 5) then
                        fDragging = true
                    end
                    if fDragging then
                        menuFrame.Position = UDim2.new(fPos.X.Scale, fPos.X.Offset + delta.X, fPos.Y.Scale, fPos.Y.Offset + delta.Y)
                    end
                end
            end)
        end

        return menuFrame
    end

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
                btn.BackgroundTransparency = 0
                btn.TextColor3 = Color3.fromRGB(10, 15, 30)
                applyTabGradient(btn)
            else
                btn.BackgroundColor3 = Color3.fromRGB(20, 24, 34)
                btn.BackgroundTransparency = 0
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
        btn.BackgroundTransparency = 0
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

            return {
                SetTitle = function(self, t)
                    sectionTitle = t
                    sectionBtn.Text = (expanded and "v " or "> ") .. sectionTitle
                end
            }
        end

        function TabAPI:AddLabel(config)
            local card = Instance.new("Frame")
            card.Name = "Card_" .. (config.Title or "Label")
            card.Size = UDim2.new(1, -4, 0, 32)
            card.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
            card.BackgroundTransparency = 0
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

            return {
                SetTitle = function(self, newTitle)
                    textLabel.Text = newTitle
                end
            }
        end

        function TabAPI:AddButton(config)
            local card = Instance.new("Frame")
            card.Name = "Card_" .. (config.Title or "Button")
            card.Size = UDim2.new(1, -4, 0, 34)
            card.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
            card.BackgroundTransparency = 0
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
            actionBtn.BackgroundTransparency = 0
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

            return {
                SetTitle = function(self, newTitle)
                    title.Text = newTitle
                end,
                SetButtonText = function(self, newBtnText)
                    actionBtn.Text = newBtnText
                end
            }
        end

        function TabAPI:AddKeybind(config)
            local titleText = config.Title or "Keybind"
            local defaultKey = config.Default or Enum.KeyCode.E
            local callback = config.Callback

            local card = Instance.new("Frame")
            card.Name = "Card_" .. titleText
            card.Size = UDim2.new(1, -4, 0, 34)
            card.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
            card.BackgroundTransparency = 0
            card.BorderSizePixel = 0
            card.Parent = scrollPage

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(0, 0, 0)
            stroke.Thickness = 1.5
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = card

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -100, 1, 0)
            title.Position = UDim2.fromOffset(10, 0)
            title.BackgroundTransparency = 1
            title.Text = titleText
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.TextSize = 13
            title.Font = Enum.Font.GothamBold
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = card
            applyTextGradient(title)

            local keyBtn = Instance.new("TextButton")
            keyBtn.Size = UDim2.fromOffset(75, 22)
            keyBtn.Position = UDim2.new(1, -85, 0.5, -11)
            keyBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
            keyBtn.BackgroundTransparency = 0
            keyBtn.Text = defaultKey.Name
            keyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            keyBtn.TextSize = 11
            keyBtn.Font = Enum.Font.GothamBold
            keyBtn.Parent = card

            local kbStroke = Instance.new("UIStroke")
            kbStroke.Color = Color3.fromRGB(0, 0, 0)
            kbStroke.Thickness = 1.5
            kbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            kbStroke.Parent = keyBtn

            local currentKey = defaultKey
            local listening = false

            keyBtn.MouseButton1Click:Connect(function()
                if listening then return end
                listening = true
                keyBtn.Text = "..."
                local conn
                conn = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        keyBtn.Text = currentKey.Name
                        listening = false
                        conn:Disconnect()
                    end
                end)
            end)

            UserInputService.InputBegan:Connect(function(input, gpe)
                if not gpe and currentKey and input.KeyCode == currentKey then
                    if callback then callback(currentKey) end
                end
            end)

            return {
                SetTitle = function(self, newTitle)
                    title.Text = newTitle
                end
            }
        end

        function TabAPI:AddToggle(config)
            local titleText = config.Title or "Toggle"
            local descText = config.Desc or ""
            local defaultState = config.Default or false
            local callback = config.Callback
            local dropdownConfig = config.Dropdown

            local hasDesc = descText ~= ""
            local baseHeight = hasDesc and 44 or 34

            local card = Instance.new("Frame")
            card.Name = "Card_" .. titleText
            card.Size = UDim2.new(1, -4, 0, baseHeight)
            card.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
            card.BackgroundTransparency = 0
            card.BorderSizePixel = 0
            card.ClipsDescendants = true
            card.Parent = scrollPage

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(0, 0, 0)
            stroke.Thickness = 1.5
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = card

            local topHeader = Instance.new("Frame")
            topHeader.Size = UDim2.new(1, 0, 0, baseHeight)
            topHeader.BackgroundTransparency = 1
            topHeader.Parent = card

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -65, 0, 16)
            title.Position = UDim2.fromOffset(10, hasDesc and 4 or 9)
            title.BackgroundTransparency = 1
            title.Text = titleText
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.TextSize = 13
            title.Font = Enum.Font.GothamBold
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = topHeader
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
                desc.Parent = topHeader
            end

            local toggleBox = Instance.new("Frame")
            toggleBox.Size = UDim2.fromOffset(38, 20)
            toggleBox.Position = UDim2.new(1, -48, 0.5, -10)
            toggleBox.BackgroundColor3 = defaultState and Color3.fromRGB(25, 120, 240) or Color3.fromRGB(30, 35, 48)
            toggleBox.BackgroundTransparency = 0
            toggleBox.BorderSizePixel = 0
            toggleBox.Parent = topHeader

            local boxStroke = Instance.new("UIStroke")
            boxStroke.Color = Color3.fromRGB(0, 0, 0)
            boxStroke.Thickness = 1.5
            boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            boxStroke.Parent = toggleBox

            local knob = Instance.new("Frame")
            knob.Size = UDim2.fromOffset(14, 14)
            knob.Position = defaultState and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.BackgroundTransparency = 0
            knob.BorderSizePixel = 0
            knob.Parent = toggleBox

            local clickBtn = Instance.new("TextButton")
            clickBtn.Size = UDim2.fromScale(1, 1)
            clickBtn.BackgroundTransparency = 1
            clickBtn.Text = ""
            clickBtn.Parent = topHeader

            local dropContainer = nil
            local dropIsOpen = false

            if dropdownConfig then
                local dropTitleText = dropdownConfig.Title or "Select Option"
                local options = dropdownConfig.Options or {}
                local isMulti = dropdownConfig.Multi or false
                local disableSearch = dropdownConfig.DisableSearch or false
                local defaultOpt = dropdownConfig.Default or (isMulti and {} or options[1])
                local selectedValues = {}

                if isMulti then
                    if type(defaultOpt) == "table" then
                        for _, v in ipairs(defaultOpt) do selectedValues[v] = true end
                    end
                else
                    if defaultOpt then selectedValues[defaultOpt] = true end
                end

                dropContainer = Instance.new("Frame")
                dropContainer.Size = UDim2.new(1, -16, 0, 0)
                dropContainer.Position = UDim2.fromOffset(8, baseHeight + 2)
                dropContainer.BackgroundTransparency = 1
                dropContainer.ClipsDescendants = true
                dropContainer.Parent = card

                local triggerBtn = Instance.new("Frame")
                triggerBtn.Size = UDim2.new(1, 0, 0, 30)
                triggerBtn.BackgroundColor3 = Color3.fromRGB(12, 15, 22)
                triggerBtn.BackgroundTransparency = 0
                triggerBtn.Parent = dropContainer

                local triggerStroke = Instance.new("UIStroke")
                triggerStroke.Color = Color3.fromRGB(0, 0, 0)
                triggerStroke.Thickness = 1.5
                triggerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                triggerStroke.Parent = triggerBtn

                local dropTitleLbl = Instance.new("TextLabel")
                dropTitleLbl.Size = UDim2.new(1, -135, 1, 0)
                dropTitleLbl.Position = UDim2.fromOffset(8, 0)
                dropTitleLbl.BackgroundTransparency = 1
                dropTitleLbl.Text = dropTitleText
                dropTitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                dropTitleLbl.TextSize = 12
                dropTitleLbl.Font = Enum.Font.GothamSemibold
                dropTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
                dropTitleLbl.Parent = triggerBtn
                applyTextGradient(dropTitleLbl)

                local rightTrigger = Instance.new("Frame")
                rightTrigger.Size = UDim2.fromOffset(115, 22)
                rightTrigger.Position = UDim2.new(1, -122, 0.5, -11)
                rightTrigger.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
                rightTrigger.BackgroundTransparency = 0
                rightTrigger.Parent = triggerBtn

                local rtStroke = Instance.new("UIStroke")
                rtStroke.Color = Color3.fromRGB(0, 0, 0)
                rtStroke.Thickness = 1.5
                rtStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                rtStroke.Parent = rightTrigger

                local function getDropText()
                    if isMulti then
                        local t = {}
                        for _, opt in ipairs(options) do if selectedValues[opt] then table.insert(t, opt) end end
                        return #t > 0 and table.concat(t, ", ") or "Select..."
                    else
                        for k, v in pairs(selectedValues) do if v then return tostring(k) end end
                        return "Select..."
                    end
                end

                local labelText = Instance.new("TextLabel")
                labelText.Size = UDim2.new(1, -20, 1, 0)
                labelText.Position = UDim2.fromOffset(6, 0)
                labelText.BackgroundTransparency = 1
                labelText.Text = getDropText()
                labelText.TextColor3 = Color3.fromRGB(255, 255, 255)
                labelText.TextSize = 11
                labelText.Font = Enum.Font.GothamSemibold
                labelText.TextXAlignment = Enum.TextXAlignment.Left
                labelText.Parent = rightTrigger
                applyTextGradient(labelText)

                local arrowText = Instance.new("TextLabel")
                arrowText.Size = UDim2.new(0, 16, 1, 0)
                arrowText.Position = UDim2.new(1, -18, 0, 0)
                arrowText.BackgroundTransparency = 1
                arrowText.Text = "v"
                arrowText.TextColor3 = Color3.fromRGB(20, 110, 240)
                arrowText.TextSize = 12
                arrowText.Font = Enum.Font.GothamSemibold
                arrowText.Parent = rightTrigger

                local dropClickArea = Instance.new("TextButton")
                dropClickArea.Size = UDim2.fromScale(1, 1)
                dropClickArea.BackgroundTransparency = 1
                dropClickArea.Text = ""
                dropClickArea.Parent = rightTrigger

                local expandedContent = Instance.new("Frame")
                expandedContent.Size = UDim2.new(1, 0, 0, 0)
                expandedContent.Position = UDim2.fromOffset(0, 34)
                expandedContent.BackgroundTransparency = 1
                expandedContent.Parent = dropContainer

                local searchBox = nil
                local searchHeight = 0
                if not disableSearch then
                    searchHeight = 26
                    searchBox = Instance.new("TextBox")
                    searchBox.Size = UDim2.new(1, 0, 0, 24)
                    searchBox.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
                    searchBox.BackgroundTransparency = 0
                    searchBox.Text = ""
                    searchBox.PlaceholderText = "Search options..."
                    searchBox.PlaceholderColor3 = Color3.fromRGB(110, 120, 140)
                    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                    searchBox.TextSize = 11
                    searchBox.Font = Enum.Font.GothamSemibold
                    searchBox.Parent = expandedContent

                    local sStroke = Instance.new("UIStroke")
                    sStroke.Color = Color3.fromRGB(0, 0, 0)
                    sStroke.Thickness = 1.5
                    sStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    sStroke.Parent = searchBox
                end

                local gridContainer = Instance.new("ScrollingFrame")
                gridContainer.Size = UDim2.new(1, 0, 1, -searchHeight)
                gridContainer.Position = UDim2.fromOffset(0, searchHeight + (searchHeight > 0 and 4 or 0))
                gridContainer.BackgroundTransparency = 1
                gridContainer.BorderSizePixel = 0
                gridContainer.CanvasSize = UDim2.fromScale(0, 0)
                gridContainer.ScrollBarThickness = 2
                gridContainer.Parent = expandedContent

                local gridLayout = Instance.new("UIGridLayout")
                gridLayout.CellSize = UDim2.fromOffset(128, 24)
                gridLayout.CellPadding = UDim2.fromOffset(4, 4)
                gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
                gridLayout.Parent = gridContainer

                gridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    gridContainer.CanvasSize = UDim2.fromOffset(0, gridLayout.AbsoluteContentSize.Y + 4)
                end)

                local function renderNestedOptions(filterText)
                    for _, child in ipairs(gridContainer:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end

                    local filteredCount = 0
                    for _, opt in ipairs(options) do
                        if filterText == "" or opt:lower():find(filterText:lower()) then
                            filteredCount = filteredCount + 1
                            local optBtn = Instance.new("TextButton")
                            optBtn.Size = UDim2.fromOffset(128, 24)
                            optBtn.BackgroundColor3 = Color3.fromRGB(12, 16, 24)
                            optBtn.BackgroundTransparency = 0
                            optBtn.Text = ""
                            optBtn.Parent = gridContainer

                            local optStroke = Instance.new("UIStroke")
                            optStroke.Color = Color3.fromRGB(0, 0, 0)
                            optStroke.Thickness = 1
                            optStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                            optStroke.Parent = optBtn

                            local selected = selectedValues[opt] == true

                            local selectionBox = Instance.new("Frame")
                            selectionBox.Size = UDim2.fromOffset(12, 12)
                            selectionBox.Position = UDim2.new(0, 5, 0.5, -6)
                            selectionBox.BackgroundColor3 = selected and Color3.fromRGB(25, 120, 240) or Color3.fromRGB(14, 16, 22)
                            selectionBox.BorderSizePixel = 0
                            selectionBox.Parent = optBtn

                            local boxStroke2 = Instance.new("UIStroke")
                            boxStroke2.Color = Color3.fromRGB(0, 0, 0)
                            boxStroke2.Thickness = 1.5
                            boxStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                            boxStroke2.Parent = selectionBox

                            local optLabel = Instance.new("TextLabel")
                            optLabel.Size = UDim2.new(1, -22, 1, 0)
                            optLabel.Position = UDim2.fromOffset(20, 0)
                            optLabel.BackgroundTransparency = 1
                            optLabel.Text = opt
                            optLabel.TextColor3 = selected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
                            optLabel.TextSize = 10
                            optLabel.Font = Enum.Font.GothamSemibold
                            optLabel.TextXAlignment = Enum.TextXAlignment.Left
                            optLabel.Parent = optBtn

                            optBtn.MouseButton1Click:Connect(function()
                                if isMulti then
                                    selectedValues[opt] = not selectedValues[opt]
                                    labelText.Text = getDropText()
                                    renderNestedOptions(searchBox and searchBox.Text or "")
                                    if dropdownConfig.Callback then
                                        local list = {}
                                        for k, v in pairs(selectedValues) do if v then table.insert(list, k) end end
                                        dropdownConfig.Callback(list)
                                    end
                                else
                                    selectedValues = {[opt] = true}
                                    labelText.Text = opt
                                    renderNestedOptions(searchBox and searchBox.Text or "")
                                    dropIsOpen = false
                                    arrowText.Text = "v"
                                    TweenService:Create(card, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                        Size = UDim2.new(1, -4, 0, baseHeight + 40)
                                    }):Play()
                                    TweenService:Create(dropContainer, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                        Size = UDim2.new(1, -16, 0, 34)
                                    }):Play()
                                    if dropdownConfig.Callback then dropdownConfig.Callback(opt) end
                                end
                            end)
                        end
                    end

                    local rows = math.ceil(filteredCount / 3)
                    local gridH = math.max(rows * 28, 28)
                    expandedContent.Size = UDim2.new(1, 0, 0, searchHeight + (searchHeight > 0 and 4 or 0) + gridH)
                end

                renderNestedOptions("")

                dropClickArea.MouseButton1Click:Connect(function()
                    dropIsOpen = not dropIsOpen
                    arrowText.Text = dropIsOpen and "^" or "v"

                    local rows = math.ceil(#options / 3)
                    local contentH = searchHeight + (searchHeight > 0 and 4 or 0) + math.max(rows * 28, 28)
                    local fullDropH = 34 + contentH

                    local targetCardH = dropIsOpen and (baseHeight + fullDropH + 6) or (baseHeight + 40)
                    local targetDropH = dropIsOpen and fullDropH or 34

                    TweenService:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, -4, 0, targetCardH)
                    }):Play()
                    TweenService:Create(dropContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, -16, 0, targetDropH)
                    }):Play()
                end)
            end

            local toggled = defaultState

            local function updateState(newState)
                toggled = newState
                toggleBox.BackgroundColor3 = toggled and Color3.fromRGB(25, 120, 240) or Color3.fromRGB(30, 35, 48)
                knob.Position = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)

                if dropContainer then
                    if toggled then
                        dropIsOpen = false
                        TweenService:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Size = UDim2.new(1, -4, 0, baseHeight + 40)
                        }):Play()
                        TweenService:Create(dropContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Size = UDim2.new(1, -16, 0, 34)
                        }):Play()
                        dropContainer.Visible = true
                    else
                        dropIsOpen = false
                        TweenService:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Size = UDim2.new(1, -4, 0, baseHeight)
                        }):Play()
                        TweenService:Create(dropContainer, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Size = UDim2.new(1, -16, 0, 0)
                        }):Play()
                        task.delay(0.2, function()
                            if not toggled then dropContainer.Visible = false end
                        end)
                    end
                end

                if callback then callback(toggled) end
            end

            if dropContainer then
                if toggled then
                    dropContainer.Visible = true
                    card.Size = UDim2.new(1, -4, 0, baseHeight + 40)
                    dropContainer.Size = UDim2.new(1, -16, 0, 34)
                else
                    dropContainer.Visible = false
                    dropContainer.Size = UDim2.new(1, -16, 0, 0)
                end
            end

            clickBtn.MouseButton1Click:Connect(function()
                updateState(not toggled)
            end)

            return {
                SetTitle = function(self, newTitle)
                    title.Text = newTitle
                end,
                SetDesc = function(self, newDesc)
                    if desc then
                        desc.Text = newDesc
                    end
                end,
                SetToggle = function(self, newState)
                    updateState(newState)
                end
            }
        end

        function TabAPI:AddDropdown(config)
            local titleText = config.Title or "Dropdown"
            local options = config.Options or {}
            local disableSearch = config.DisableSearch or false
            local multi = config.Multi or false
            local defaultOption = config.Default or (multi and {} or options[1])
            local callback = config.Callback

            local card = Instance.new("Frame")
            card.Name = "Card_" .. titleText
            card.Size = UDim2.new(1, -4, 0, 34)
            card.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
            card.BackgroundTransparency = 0
            card.BorderSizePixel = 0
            card.ClipsDescendants = true
            card.Parent = scrollPage

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(0, 0, 0)
            stroke.Thickness = 1.5
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = card

            local topHeader = Instance.new("Frame")
            topHeader.Size = UDim2.new(1, 0, 0, 34)
            topHeader.BackgroundTransparency = 1
            topHeader.Parent = card

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -135, 1, 0)
            title.Position = UDim2.fromOffset(10, 0)
            title.BackgroundTransparency = 1
            title.Text = titleText
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.TextSize = 13
            title.Font = Enum.Font.GothamSemibold
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = topHeader
            applyTextGradient(title)

            local triggerBtn = Instance.new("Frame")
            triggerBtn.Size = UDim2.fromOffset(120, 22)
            triggerBtn.Position = UDim2.new(1, -130, 0.5, -11)
            triggerBtn.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
            triggerBtn.BackgroundTransparency = 0
            triggerBtn.Parent = topHeader

            local focusLine = Instance.new("Frame")
            focusLine.Size = UDim2.new(1, 0, 0, 2)
            focusLine.Position = UDim2.new(0, 0, 1, -2)
            focusLine.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
            focusLine.BorderSizePixel = 0
            focusLine.Parent = triggerBtn

            local triggerStroke = Instance.new("UIStroke")
            triggerStroke.Color = Color3.fromRGB(0, 0, 0)
            triggerStroke.Thickness = 1.5
            triggerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            triggerStroke.Parent = triggerBtn

            local labelText = Instance.new("TextLabel")
            labelText.Size = UDim2.new(1, -20, 1, 0)
            labelText.Position = UDim2.fromOffset(6, 0)
            labelText.BackgroundTransparency = 1
            labelText.Text = type(defaultOption) == "table" and table.concat(defaultOption, ", ") or tostring(defaultOption)
            labelText.TextColor3 = Color3.fromRGB(255, 255, 255)
            labelText.TextSize = 11
            labelText.Font = Enum.Font.GothamSemibold
            labelText.TextXAlignment = Enum.TextXAlignment.Left
            labelText.Parent = triggerBtn
            applyTextGradient(labelText)

            local arrowText = Instance.new("TextLabel")
            arrowText.Size = UDim2.new(0, 16, 1, 0)
            arrowText.Position = UDim2.new(1, -18, 0, 0)
            arrowText.BackgroundTransparency = 1
            arrowText.Text = "v"
            arrowText.TextColor3 = Color3.fromRGB(20, 110, 240)
            arrowText.TextSize = 12
            arrowText.Font = Enum.Font.GothamSemibold
            arrowText.Parent = triggerBtn

            local clickArea = Instance.new("TextButton")
            clickArea.Size = UDim2.fromScale(1, 1)
            clickArea.BackgroundTransparency = 1
            clickArea.Text = ""
            clickArea.Parent = triggerBtn

            local expandedContent = Instance.new("Frame")
            expandedContent.Size = UDim2.new(1, -16, 0, 0)
            expandedContent.Position = UDim2.fromOffset(8, 36)
            expandedContent.BackgroundTransparency = 1
            expandedContent.Parent = card

            local searchBox = nil
            local searchHeight = 0
            if not disableSearch then
                searchHeight = 26
                searchBox = Instance.new("TextBox")
                searchBox.Size = UDim2.new(1, 0, 0, 24)
                searchBox.Position = UDim2.fromOffset(0, 0)
                searchBox.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
                searchBox.BackgroundTransparency = 0
                searchBox.Text = ""
                searchBox.PlaceholderText = "Search options..."
                searchBox.PlaceholderColor3 = Color3.fromRGB(110, 120, 140)
                searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                searchBox.TextSize = 11
                searchBox.Font = Enum.Font.GothamSemibold
                searchBox.Parent = expandedContent

                local searchFocusLine = Instance.new("Frame")
                searchFocusLine.Size = UDim2.new(1, 0, 0, 2)
                searchFocusLine.Position = UDim2.new(0, 0, 1, -2)
                searchFocusLine.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
                searchFocusLine.BorderSizePixel = 0
                searchFocusLine.Parent = searchBox

                searchBox.Focused:Connect(function() searchFocusLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255) end)
                searchBox.FocusLost:Connect(function() searchFocusLine.BackgroundColor3 = Color3.fromRGB(50, 120, 220) end)

                local searchStroke = Instance.new("UIStroke")
                searchStroke.Color = Color3.fromRGB(0, 0, 0)
                searchStroke.Thickness = 1.5
                searchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                searchStroke.Parent = searchBox
            end

            local gridContainer = Instance.new("ScrollingFrame")
            gridContainer.Size = UDim2.new(1, 0, 1, -searchHeight)
            gridContainer.Position = UDim2.fromOffset(0, searchHeight + (searchHeight > 0 and 4 or 0))
            gridContainer.BackgroundTransparency = 1
            gridContainer.BorderSizePixel = 0
            gridContainer.CanvasSize = UDim2.fromScale(0, 0)
            gridContainer.ScrollBarThickness = 2
            gridContainer.Parent = expandedContent

            local gridLayout = Instance.new("UIGridLayout")
            gridLayout.CellSize = UDim2.fromOffset(128, 24)
            gridLayout.CellPadding = UDim2.fromOffset(4, 4)
            gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
            gridLayout.Parent = gridContainer

            gridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                gridContainer.CanvasSize = UDim2.fromOffset(0, gridLayout.AbsoluteContentSize.Y + 4)
            end)

            local selectedValues = {}
            if multi then
                if type(defaultOption) == "table" then
                    for _, v in ipairs(defaultOption) do selectedValues[v] = true end
                elseif defaultOption then
                    selectedValues[defaultOption] = true
                end
            else
                selectedValues[defaultOption] = true
            end

            local function isSelected(opt) return selectedValues[opt] == true end

            local renderOptions
            local expanded = false

            local function setExpandState(state)
                expanded = state
                local totalContentHeight = expandedContent.AbsoluteSize.Y
                local targetHeight = expanded and (40 + totalContentHeight) or 34
                TweenService:Create(card, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, -4, 0, targetHeight)
                }):Play()
                arrowText.Text = expanded and "^" or "v"
            end

            renderOptions = function(filterText)
                for _, child in ipairs(gridContainer:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end

                local filteredCount = 0
                for _, opt in ipairs(options) do
                    if filterText == "" or opt:lower():find(filterText:lower()) then
                        filteredCount = filteredCount + 1
                        
                        local optBtn = Instance.new("TextButton")
                        optBtn.Size = UDim2.fromOffset(128, 24)
                        optBtn.BackgroundColor3 = Color3.fromRGB(12, 16, 24)
                        optBtn.BackgroundTransparency = 0
                        optBtn.Text = ""
                        optBtn.Parent = gridContainer

                        local optStroke = Instance.new("UIStroke")
                        optStroke.Color = Color3.fromRGB(0, 0, 0)
                        optStroke.Thickness = 1
                        optStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                        optStroke.Parent = optBtn

                        local selected = isSelected(opt)

                        local selectionBox = Instance.new("Frame")
                        selectionBox.Size = UDim2.fromOffset(12, 12)
                        selectionBox.Position = UDim2.new(0, 5, 0.5, -6)
                        selectionBox.BackgroundColor3 = selected and Color3.fromRGB(25, 120, 240) or Color3.fromRGB(14, 16, 22)
                        selectionBox.BorderSizePixel = 0
                        selectionBox.Parent = optBtn

                        local boxStroke = Instance.new("UIStroke")
                        boxStroke.Color = Color3.fromRGB(0, 0, 0)
                        boxStroke.Thickness = 1.5
                        boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                        boxStroke.Parent = selectionBox

                        local optLabel = Instance.new("TextLabel")
                        optLabel.Size = UDim2.new(1, -22, 1, 0)
                        optLabel.Position = UDim2.fromOffset(20, 0)
                        optLabel.BackgroundTransparency = 1
                        optLabel.Text = opt
                        optLabel.TextColor3 = selected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
                        optLabel.TextSize = 10
                        optLabel.Font = Enum.Font.GothamSemibold
                        optLabel.TextXAlignment = Enum.TextXAlignment.Left
                        optLabel.Parent = optBtn

                        optBtn.MouseButton1Click:Connect(function()
                            if multi then
                                selectedValues[opt] = not selectedValues[opt]
                                local list = {}
                                for k, v in pairs(selectedValues) do
                                    if v then table.insert(list, k) end
                                end
                                labelText.Text = (#list > 0) and table.concat(list, ", ") or "None"
                                renderOptions(searchBox and searchBox.Text or "")
                                if callback then callback(list) end
                            else
                                selectedValues = {[opt] = true}
                                labelText.Text = opt
                                renderOptions(searchBox and searchBox.Text or "")
                                setExpandState(false)
                                if callback then callback(opt) end
                            end
                        end)
                    end
                end

                local rows = math.ceil(filteredCount / 3)
                local gridHeight = math.max(rows * 28, 28)
                expandedContent.Size = UDim2.new(1, -16, 0, searchHeight + (searchHeight > 0 and 4 or 0) + gridHeight)
            end

            renderOptions("")

            if searchBox then
                searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                    renderOptions(searchBox.Text)
                end)
            end

            clickArea.MouseButton1Click:Connect(function()
                setExpandState(not expanded)
            end)

            return {
                SetTitle = function(self, newTitle)
                    title.Text = newTitle
                end,
                SetValues = function(self, newOpts)
                    options = newOpts
                    renderOptions(searchBox and searchBox.Text or "")
                end
            }
        end

        function TabAPI:AddSlider(config)
            local titleText = config.Title or "Slider"
            local minVal = config.Min or 0
            local maxVal = config.Max or 100
            local defaultVal = config.Default or 50
            local callback = config.Callback

            local card = Instance.new("Frame")
            card.Name = "Card_" .. titleText
            card.Size = UDim2.new(1, -4, 0, 34)
            card.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
            card.BackgroundTransparency = 0
            card.BorderSizePixel = 0
            card.Parent = scrollPage

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(0, 0, 0)
            stroke.Thickness = 1.5
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = card

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -180, 1, 0)
            title.Position = UDim2.fromOffset(10, 0)
            title.BackgroundTransparency = 1
            title.Text = titleText
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.TextSize = 13
            title.Font = Enum.Font.GothamSemibold
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = card
            applyTextGradient(title)

            local valBox = Instance.new("TextBox")
            valBox.Size = UDim2.fromOffset(48, 20)
            valBox.Position = UDim2.new(1, -170, 0.5, -10)
            valBox.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
            valBox.BackgroundTransparency = 0
            valBox.Text = tostring(defaultVal)
            valBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            valBox.TextSize = 11
            valBox.Font = Enum.Font.GothamSemibold
            valBox.Parent = card

            local valBoxFocusLine = Instance.new("Frame")
            valBoxFocusLine.Size = UDim2.new(1, 0, 0, 2)
            valBoxFocusLine.Position = UDim2.new(0, 0, 1, -2)
            valBoxFocusLine.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
            valBoxFocusLine.BorderSizePixel = 0
            valBoxFocusLine.Parent = valBox

            valBox.Focused:Connect(function()
                valBoxFocusLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            end)
            valBox.FocusLost:Connect(function()
                valBoxFocusLine.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
            end)

            local boxStroke = Instance.new("UIStroke")
            boxStroke.Color = Color3.fromRGB(0, 0, 0)
            boxStroke.Thickness = 1.5
            boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            boxStroke.Parent = valBox

            local sliderBar = Instance.new("Frame")
            sliderBar.Size = UDim2.new(0, 110, 0, 8)
            sliderBar.Position = UDim2.new(1, -114, 0.5, -4)
            sliderBar.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
            sliderBar.BackgroundTransparency = 0
            sliderBar.BorderSizePixel = 0
            sliderBar.Parent = card

            local barStroke = Instance.new("UIStroke")
            barStroke.Color = Color3.fromRGB(0, 0, 0)
            barStroke.Thickness = 1.5
            barStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            barStroke.Parent = sliderBar

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(25, 120, 240)
            fill.BorderSizePixel = 0
            fill.Parent = sliderBar

            local handle = Instance.new("Frame")
            handle.Size = UDim2.fromOffset(6, 14)
            handle.Position = UDim2.new(1, -3, 0.5, -7)
            handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            handle.BorderSizePixel = 0
            handle.Parent = fill

            local handleStroke = Instance.new("UIStroke")
            handleStroke.Color = Color3.fromRGB(0, 0, 0)
            handleStroke.Thickness = 1.5
            handleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            handleStroke.Parent = handle

            local sliderBtn = Instance.new("TextButton")
            sliderBtn.Size = UDim2.fromScale(1, 1)
            sliderBtn.BackgroundTransparency = 1
            sliderBtn.Text = ""
            sliderBtn.Parent = sliderBar

            local currentValue = defaultVal
            local activeInput = nil
            local touchStartPos = nil
            local dragging = false

            local function updateValue(val)
                currentValue = math.clamp(math.floor(val), minVal, maxVal)
                local pos = (currentValue - minVal) / (maxVal - minVal)
                fill.Size = UDim2.new(pos, 0, 1, 0)
                valBox.Text = tostring(currentValue)
                if callback then callback(currentValue) end
            end

            local function updateFromInput(inputPos)
                local barPos = sliderBar.AbsolutePosition.X
                local barSize = sliderBar.AbsoluteSize.X
                local pos = math.clamp((inputPos - barPos) / barSize, 0, 1)
                updateValue(minVal + ((maxVal - minVal) * pos))
            end

            valBox.FocusLost:Connect(function()
                local num = tonumber(valBox.Text)
                if num then
                    updateValue(num)
                else
                    valBox.Text = tostring(currentValue)
                end
            end)

            sliderBtn.InputBegan:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and activeInput == nil then
                    activeInput = input
                    touchStartPos = input.Position
                    dragging = false
                    updateFromInput(input.Position.X)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input == activeInput then
                    activeInput = nil
                    dragging = false
                    if scrollPage and scrollPage:IsA("ScrollingFrame") then
                        scrollPage.ScrollingEnabled = true
                    end
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if input == activeInput and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local delta = input.Position - touchStartPos
                    if not dragging then
                        if math.abs(delta.X) > windowConfig.SliderThreshold then
                            dragging = true
                            if scrollPage and scrollPage:IsA("ScrollingFrame") then
                                scrollPage.ScrollingEnabled = false
                            end
                        end
                    end
                    if dragging then
                        updateFromInput(input.Position.X)
                    end
                end
            end)

            return {
                SetTitle = function(self, newTitle)
                    title.Text = newTitle
                end,
                SetValue = function(self, val)
                    updateValue(val)
                end
            }
        end

        function TabAPI:AddTextBox(config)
            local card = Instance.new("Frame")
            card.Name = "Card_" .. (config.Title or "TextBox")
            card.Size = UDim2.new(1, -4, 0, config.Desc and 52 or 42)
            card.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
            card.BackgroundTransparency = 0
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
            textBoxBg.BackgroundTransparency = 0
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

            return {
                SetTitle = function(self, newTitle)
                    title.Text = newTitle
                end
            }
        end

        return TabAPI
    end

    function Cheiz:AddSearchFeatures(config)
        local disableSearchGlobal = config and config.DisableSearchGlobal or false

        local BottomFrame = Instance.new("Frame")
        BottomFrame.Name = randomizeName(8)
        BottomFrame.Size = UDim2.new(1, 0, 0, 26)
        BottomFrame.Position = UDim2.new(0, 0, 1, 8)
        BottomFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
        BottomFrame.BackgroundTransparency = 0
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
        searchFocusLine.BorderSizePixel = 0
        searchFocusLine.Parent = BottomFrame

        SearchBox.Focused:Connect(function() searchFocusLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255) end)
        SearchBox.FocusLost:Connect(function() searchFocusLine.BackgroundColor3 = Color3.fromRGB(50, 120, 220) end)

        SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            local filterText = SearchBox.Text:lower()
            if disableSearchGlobal then
                for name, page in pairs(Pages) do
                    if name == ActiveTab then
                        for _, child in ipairs(page:GetChildren()) do
                            if child:IsA("Frame") and child.Name:find("Card_") then
                                child.Visible = (filterText == "" or child.Name:lower():find(filterText))
                            end
                        end
                    end
                end
            else
                local firstMatchTab = nil
                for name, page in pairs(Pages) do
                    local tabMatched = false
                    for _, child in ipairs(page:GetChildren()) do
                        if child:IsA("Frame") and child.Name:find("Card_") then
                            local matched = (filterText == "" or child.Name:lower():find(filterText))
                            child.Visible = matched
                            if matched and filterText ~= "" then tabMatched = true end
                        end
                    end
                    if tabMatched and not firstMatchTab then firstMatchTab = name end
                end
                if firstMatchTab and filterText ~= "" and firstMatchTab ~= ActiveTab then
                    SwitchTab(firstMatchTab)
                end
            end
        end)
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
