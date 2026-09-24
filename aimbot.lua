local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    AimActive = false,
    IncludeTeammates = false,
    CheckObstructions = true,
    AimRange = 50,
    AimTargetBone = "Head",
    ShowRangeCircle = true
}

local Accent = Color3.fromRGB(255, 85, 70)
local Background = Color3.fromRGB(16, 18, 24)
local Panel = Color3.fromRGB(24, 27, 35)
local Element = Color3.fromRGB(31, 35, 45)
local Text = Color3.fromRGB(242, 244, 248)
local Dimmed = Color3.fromRGB(145, 151, 164)

local parentGui = (gethui and gethui()) or game:GetService("CoreGui")

local oldGui = parentGui:FindFirstChild("FireHubAimbot")
if oldGui then oldGui:Destroy() end

local blur = Instance.new("BlurEffect")
blur.Name = "FireHubBlur"
blur.Size = 0
blur.Parent = Lighting

local Gui = Instance.new("ScreenGui")
Gui.Name = "FireHubAimbot"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = parentGui

-- Floating image
local Floating = Instance.new("ImageLabel")
Floating.Name = "FloatingLogo"
Floating.AnchorPoint = Vector2.new(0.5, 0.5)
Floating.Position = UDim2.fromScale(0.5, 0.5)
Floating.Size = UDim2.fromOffset(200, 200)
Floating.BackgroundTransparency = 1
Floating.Image = "rbxassetid://111131527895569"
Floating.ImageTransparency = 0.7
Floating.ZIndex = 0
Floating.Parent = Gui

task.spawn(function()
    local t = 0
    while Floating and Floating.Parent do
        t = t + 0.05
        local rot = math.sin(t) * 10
        local yOff = math.sin(t * 1.5) * 15
        local scale = 1 + math.sin(t * 2) * 0.05
        Floating.Rotation = rot
        Floating.Position = UDim2.new(0.5, 0, 0.5, yOff)
        Floating.Size = UDim2.fromOffset(200 * scale, 200 * scale)
        task.wait(0.03)
    end
end)

local Shadow = Instance.new("Frame")
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.Position = UDim2.fromScale(0.5, 0.5)
Shadow.Size = UDim2.fromOffset(0, 0)
Shadow.BackgroundColor3 = Color3.new(0, 0, 0)
Shadow.BackgroundTransparency = 0.35
Shadow.BorderSizePixel = 0
Shadow.ZIndex = 1
Shadow.Parent = Gui
Instance.new("UICorner", Shadow).CornerRadius = UDim.new(0, 14)

local Main = Instance.new("Frame")
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.Size = UDim2.fromOffset(0, 0)
Main.BackgroundColor3 = Background
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.ZIndex = 2
Main.Parent = Gui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Accent
Stroke.Thickness = 1.5
Stroke.Transparency = 0.15
Stroke.Parent = Main

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 20, 27)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 22, 27))
})
Gradient.Rotation = 35
Gradient.Parent = Main

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 48)
Top.BackgroundTransparency = 1
Top.ZIndex = 3
Top.Parent = Main

local Logo = Instance.new("Frame")
Logo.Position = UDim2.fromOffset(12, 10)
Logo.Size = UDim2.fromOffset(28, 28)
Logo.BackgroundColor3 = Accent
Logo.BorderSizePixel = 0
Logo.ZIndex = 4
Logo.Parent = Top
Instance.new("UICorner", Logo).CornerRadius = UDim.new(0, 8)

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.fromScale(1, 1)
LogoText.BackgroundTransparency = 1
LogoText.Text = "F"
LogoText.TextColor3 = Color3.new(1, 1, 1)
LogoText.Font = Enum.Font.GothamBold
LogoText.TextSize = 16
LogoText.ZIndex = 5
LogoText.Parent = Logo

local Title = Instance.new("TextLabel")
Title.Position = UDim2.fromOffset(48, 9)
Title.Size = UDim2.new(1, -100, 0, 18)
Title.BackgroundTransparency = 1
Title.Text = "Fire Hub Aimbot"
Title.TextColor3 = Text
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 4
Title.Parent = Top

local Subtitle = Instance.new("TextLabel")
Subtitle.Position = UDim2.fromOffset(49, 28)
Subtitle.Size = UDim2.new(1, -100, 0, 12)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Universal Aimbot"
Subtitle.TextColor3 = Dimmed
Subtitle.TextSize = 9
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.ZIndex = 4
Subtitle.Parent = Top

local Close = Instance.new("TextButton")
Close.AnchorPoint = Vector2.new(1, 0)
Close.Position = UDim2.new(1, -10, 0, 10)
Close.Size = UDim2.fromOffset(26, 26)
Close.BackgroundTransparency = 1
Close.Text = "×"
Close.TextColor3 = Dimmed
Close.TextSize = 20
Close.Font = Enum.Font.Gotham
Close.AutoButtonColor = false
Close.ZIndex = 5
Close.Parent = Top

local Content = Instance.new("Frame")
Content.Position = UDim2.fromOffset(12, 54)
Content.Size = UDim2.new(1, -24, 1, -66)
Content.BackgroundTransparency = 1
Content.ZIndex = 3
Content.Parent = Main

local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 20)
Header.BackgroundTransparency = 1
Header.Text = "Aimbot"
Header.TextColor3 = Text
Header.TextSize = 18
Header.Font = Enum.Font.GothamBold
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.ZIndex = 4
Header.Parent = Content

local HeaderLine = Instance.new("Frame")
HeaderLine.Position = UDim2.new(0, 0, 0, 24)
HeaderLine.Size = UDim2.new(1, 0, 0, 1)
HeaderLine.BackgroundColor3 = Element
HeaderLine.BorderSizePixel = 0
HeaderLine.ZIndex = 4
HeaderLine.Parent = Content

local function createRow(y, height)
    local row = Instance.new("Frame")
    row.Position = UDim2.new(0, 0, 0, y)
    row.Size = UDim2.new(1, 0, 0, height)
    row.BackgroundColor3 = Element
    row.BorderSizePixel = 0
    row.ZIndex = 4
    row.Parent = Content
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(48, 52, 64)
    s.Transparency = 0.25
    s.Parent = row
    return row
end

local function createLabel(parent, title, desc)
    local label = Instance.new("TextLabel")
    label.Name = "TitleLabel"
    label.AnchorPoint = Vector2.new(0, 0.5)
    label.Position = UDim2.new(0, 10, desc and 0.35 or 0.5, 0)
    label.Size = UDim2.new(1, -66, 0, 16)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Text
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.ZIndex = 10
    label.Parent = parent

    if desc then
        local d = Instance.new("TextLabel")
        d.Name = "DescLabel"
        d.AnchorPoint = Vector2.new(0, 0.5)
        d.Position = UDim2.new(0, 10, 0.7, 0)
        d.Size = UDim2.new(1, -66, 0, 14)
        d.BackgroundTransparency = 1
        d.Text = desc
        d.TextColor3 = Dimmed
        d.TextSize = 9
        d.Font = Enum.Font.Gotham
        d.TextXAlignment = Enum.TextXAlignment.Left
        d.TextYAlignment = Enum.TextYAlignment.Center
        d.ZIndex = 10
        d.Parent = parent
    end
end

local function createToggle(row, key)
    local button = Instance.new("TextButton")
    button.AnchorPoint = Vector2.new(1, 0.5)
    button.Position = UDim2.new(1, -10, 0.5, 0)
    button.Size = UDim2.fromOffset(40, 21)
    button.BackgroundColor3 = Color3.fromRGB(48, 52, 62)
    button.Text = ""
    button.AutoButtonColor = false
    button.ZIndex = 10
    button.Parent = row
    Instance.new("UICorner", button).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(0, 11, 0.5, 0)
    knob.Size = UDim2.fromOffset(15, 15)
    knob.BackgroundColor3 = Color3.fromRGB(215, 218, 224)
    knob.BorderSizePixel = 0
    knob.ZIndex = 11
    knob.Parent = button
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local function refresh()
        local enabled = Settings[key]
        TweenService:Create(button, TweenInfo.new(0.18), {
            BackgroundColor3 = enabled and Accent or Color3.fromRGB(48, 52, 62)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
            Position = enabled and UDim2.new(1, -11, 0.5, 0) or UDim2.new(0, 11, 0.5, 0)
        }):Play()
    end

    button.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        refresh()
    end)

    refresh()
    return button
end

local AimRow = createRow(32, 46)
createLabel(AimRow, "Enable Aimbot", "Tracks the nearest target")
createToggle(AimRow, "AimActive")

local TeamRow = createRow(84, 46)
createLabel(TeamRow, "Ignore Teammates", "Skip players on your team")
createToggle(TeamRow, "IncludeTeammates")

local WallRow = createRow(136, 46)
createLabel(WallRow, "Check Walls", "Only visible players")
createToggle(WallRow, "CheckObstructions")

local RangeShowRow = createRow(188, 46)
createLabel(RangeShowRow, "Show Range", "Display aim range")
createToggle(RangeShowRow, "ShowRangeCircle")

local RangeRow = createRow(240, 46)
local RangeTitle = Instance.new("TextLabel")
RangeTitle.AnchorPoint = Vector2.new(0, 0.5)
RangeTitle.Position = UDim2.new(0, 10, 0.3, 0)
RangeTitle.Size = UDim2.new(1, -80, 0, 16)
RangeTitle.BackgroundTransparency = 1
RangeTitle.Text = "Aim Range"
RangeTitle.TextColor3 = Text
RangeTitle.TextSize = 12
RangeTitle.Font = Enum.Font.GothamMedium
RangeTitle.TextXAlignment = Enum.TextXAlignment.Left
RangeTitle.ZIndex = 10
RangeTitle.Parent = RangeRow

local RangeNumber = Instance.new("TextLabel")
RangeNumber.AnchorPoint = Vector2.new(1, 0.5)
RangeNumber.Position = UDim2.new(1, -12, 0.3, 0)
RangeNumber.Size = UDim2.fromOffset(40, 16)
RangeNumber.BackgroundTransparency = 1
RangeNumber.Text = tostring(Settings.AimRange)
RangeNumber.TextColor3 = Accent
RangeNumber.TextSize = 11
RangeNumber.Font = Enum.Font.GothamBold
RangeNumber.TextXAlignment = Enum.TextXAlignment.Right
RangeNumber.ZIndex = 10
RangeNumber.Parent = RangeRow

local SliderBack = Instance.new("Frame")
SliderBack.Position = UDim2.new(0, 10, 0, 32)
SliderBack.Size = UDim2.new(1, -20, 0, 4)
SliderBack.BackgroundColor3 = Color3.fromRGB(52, 56, 67)
SliderBack.BorderSizePixel = 0
SliderBack.ZIndex = 10
SliderBack.Parent = RangeRow
Instance.new("UICorner", SliderBack).CornerRadius = UDim.new(1, 0)

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new((Settings.AimRange - 10) / 490, 0, 1, 0)
SliderFill.BackgroundColor3 = Accent
SliderFill.BorderSizePixel = 0
SliderFill.ZIndex = 11
SliderFill.Parent = SliderBack
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

local SliderKnob = Instance.new("Frame")
SliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
SliderKnob.Position = UDim2.new((Settings.AimRange - 10) / 490, 0, 0.5, 0)
SliderKnob.Size = UDim2.fromOffset(11, 11)
SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderKnob.BorderSizePixel = 0
SliderKnob.ZIndex = 12
SliderKnob.Parent = SliderBack
Instance.new("UICorner", SliderKnob).CornerRadius = UDim.new(1, 0)

local sliderDragging = false
local function updateSlider(x)
    local alpha = math.clamp((x - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
    local value = math.floor(10 + alpha * 490 + 0.5)
    Settings.AimRange = value
    RangeNumber.Text = tostring(value)
    SliderFill.Size = UDim2.new(alpha, 0, 1, 0)
    SliderKnob.Position = UDim2.new(alpha, 0, 0.5, 0)
end

SliderBack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
        updateSlider(input.Position.X)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSlider(input.Position.X)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = false
    end
end)

local TargetRow = createRow(292, 46)
createLabel(TargetRow, "Target Part", "Body part to aim at")

local TargetButton = Instance.new("TextButton")
TargetButton.AnchorPoint = Vector2.new(1, 0.5)
TargetButton.Position = UDim2.new(1, -10, 0.5, 0)
TargetButton.Size = UDim2.fromOffset(90, 28)
TargetButton.BackgroundColor3 = Color3.fromRGB(40, 44, 54)
TargetButton.Text = Settings.AimTargetBone
TargetButton.TextColor3 = Text
TargetButton.TextSize = 11
TargetButton.Font = Enum.Font.GothamMedium
TargetButton.AutoButtonColor = false
TargetButton.ZIndex = 10
TargetButton.Parent = TargetRow
Instance.new("UICorner", TargetButton).CornerRadius = UDim.new(0, 6)

local DropdownOpen = false
local Drop = Instance.new("Frame")
Drop.Position = UDim2.new(1, -100, 0, 338)
Drop.Size = UDim2.fromOffset(90, 0)
Drop.BackgroundColor3 = Panel
Drop.BorderSizePixel = 0
Drop.ClipsDescendants = true
Drop.ZIndex = 20
Drop.Parent = Content
Instance.new("UICorner", Drop).CornerRadius = UDim.new(0, 6)
local DropStroke = Instance.new("UIStroke")
DropStroke.Color = Accent
DropStroke.Transparency = 0.35
DropStroke.Parent = Drop

local function makeOption(name, y)
    local b = Instance.new("TextButton")
    b.Position = UDim2.fromOffset(4, y)
    b.Size = UDim2.new(1, -8, 0, 24)
    b.BackgroundColor3 = Element
    b.Text = name
    b.TextColor3 = Text
    b.TextSize = 11
    b.Font = Enum.Font.GothamMedium
    b.AutoButtonColor = false
    b.ZIndex = 21
    b.Parent = Drop
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b.MouseButton1Click:Connect(function()
        Settings.AimTargetBone = name
        TargetButton.Text = name
        DropdownOpen = false
        TweenService:Create(Drop, TweenInfo.new(0.2), {
            Size = UDim2.fromOffset(90, 0)
        }):Play()
    end)
end

makeOption("Head", 4)
makeOption("Torso", 32)

TargetButton.MouseButton1Click:Connect(function()
    DropdownOpen = not DropdownOpen
    TweenService:Create(Drop, TweenInfo.new(0.22), {
        Size = DropdownOpen and UDim2.fromOffset(90, 60) or UDim2.fromOffset(90, 0)
    }):Play()
end)

local dragging = false
local dragStart
local startPos

Top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
        Shadow.Position = Main.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local closed = false
Close.MouseEnter:Connect(function()
    TweenService:Create(Close, TweenInfo.new(0.15), {TextColor3 = Accent}):Play()
end)

Close.MouseLeave:Connect(function()
    TweenService:Create(Close, TweenInfo.new(0.15), {TextColor3 = Dimmed}):Play()
end)

Close.MouseButton1Click:Connect(function()
    if closed then return end
    closed = true
    TweenService:Create(blur, TweenInfo.new(0.25), {Size = 0}):Play()
    TweenService:Create(Shadow, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.fromOffset(0, 0)
    }):Play()
    local t = TweenService:Create(Main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.fromOffset(0, 0)
    })
    t:Play()
    t.Completed:Wait()
    Gui:Destroy()
    if blur then blur:Destroy() end
end)

TweenService:Create(blur, TweenInfo.new(0.45), {Size = 8}):Play()

TweenService:Create(Shadow, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.fromOffset(384, 400)
}):Play()

local openTween = TweenService:Create(Main, TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.fromOffset(360, 376)
})
openTween:Play()

task.spawn(function()
    task.wait(0.35)
    TweenService:Create(Logo, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Rotation = 360
    }):Play()
end)

local RangeCircle
pcall(function()
    RangeCircle = Drawing.new("Circle")
    RangeCircle.Color = Accent
    RangeCircle.Thickness = 1.5
    RangeCircle.NumSides = 64
    RangeCircle.Filled = false
    RangeCircle.Transparency = 0.85
    RangeCircle.Visible = false
end)

local function SameTeam(player)
    return LocalPlayer.Team ~= nil and player.Team == LocalPlayer.Team
end

local function CanSee(targetPart)
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(origin, direction, params)
    return result ~= nil and result.Instance:IsDescendantOf(targetPart.Parent)
end

local function GetTargetPart(character)
    if Settings.AimTargetBone == "Head" then
        return character:FindFirstChild("Head")
    end
    return character:FindFirstChild("HumanoidRootPart")
        or character:FindFirstChild("UpperTorso")
        or character:FindFirstChild("Torso")
end

local targetList = {}
local sightCache = {}
local aimTimer = 0
local visibilityTimer = 0

RunService.RenderStepped:Connect(function(delta)
    if closed then return end

    aimTimer += delta
    visibilityTimer += delta

    local viewport = Camera.ViewportSize
    local center = Vector2.new(viewport.X / 2, viewport.Y / 2)

    if RangeCircle then
        RangeCircle.Visible = Settings.ShowRangeCircle
        RangeCircle.Radius = Settings.AimRange
        RangeCircle.Position = center
    end

    if aimTimer < 0.03 then return end
    aimTimer = 0
    targetList = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local targetPart = character and GetTargetPart(character)

            if humanoid and humanoid.Health > 0 and targetPart then
                local allowed = not (Settings.IncludeTeammates and SameTeam(player))
                if allowed then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local offset = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        if offset <= Settings.AimRange then
                            table.insert(targetList, {
                                Bone = targetPart,
                                Distance = offset,
                                Owner = player
                            })
                        end
                    end
                end
            end
        end
    end

    table.sort(targetList, function(a, b)
        return a.Distance < b.Distance
    end)

    if not Settings.AimActive then return end

    for _, target in ipairs(targetList) do
        if Settings.CheckObstructions then
            if visibilityTimer >= 0.12 then
                sightCache[target.Owner] = CanSee(target.Bone)
            end
            if not sightCache[target.Owner] then
                continue
            end
        end

        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, target.Bone.Position)
        break
    end

    if visibilityTimer >= 0.12 then
        visibilityTimer = 0
    end
end)

Players.PlayerRemoving:Connect(function(player)
    sightCache[player] = nil
end)
