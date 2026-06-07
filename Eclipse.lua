do
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local CoreGui = game:GetService("CoreGui")
    
    if CoreGui:FindFirstChild("FTF_Maintenance") then
        CoreGui.FTF_Maintenance:Destroy()
    end

    local MaintenanceGui = Instance.new("ScreenGui", CoreGui)
    MaintenanceGui.Name = "FTF_Maintenance"
    MaintenanceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MaintenanceGui.ResetOnSpawn = false
    MaintenanceGui.IgnoreGuiInset = true
    MaintenanceGui.DisplayOrder = 999

    local BG = Instance.new("Frame", MaintenanceGui)
    BG.Size = UDim2.new(1, 0, 1, 0)
    BG.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BG.BackgroundTransparency = 1

    local MainFrame = Instance.new("Frame", BG)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BackgroundTransparency = 1
    MainFrame.BorderSizePixel = 0
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    
    local stroke = Instance.new("UIStroke", MainFrame)
    stroke.Thickness = 3
    stroke.Transparency = 1
    stroke.Color = Color3.fromRGB(120, 0, 0)
    
    local glow = Instance.new("UIGradient", stroke)
    glow.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 0, 0))
    }
    glow.Rotation = 0

    local ContentFrame = Instance.new("Frame", MainFrame)
    ContentFrame.Size = UDim2.new(1, -40, 1, -85)
    ContentFrame.Position = UDim2.new(0, 20, 0, 20)
    ContentFrame.BackgroundTransparency = 1
    
    local listLayout = Instance.new("UIListLayout", ContentFrame)
    listLayout.Padding = UDim.new(0, 10)
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local Title = Instance.new("TextLabel", ContentFrame)
    Title.Size = UDim2.new(1, 0, 0, 28)
    Title.BackgroundTransparency = 1
    Title.Text = "FTF ECLIPSE EM MANUTENÇÃO"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22
    Title.TextColor3 = Color3.fromRGB(255, 40, 40)
    Title.TextTransparency = 1
    Title.TextStrokeTransparency = 1
    Title.LayoutOrder = 1

    local Text1 = Instance.new("TextLabel", ContentFrame)
    Text1.Size = UDim2.new(1, 0, 0, 48)
    Text1.BackgroundTransparency = 1
    Text1.Text = "Estou trabalhando para trazer a melhor atualização possível. No momento estou muito doente, mas continuarei me esforçando para que o FTF Eclipse continue evoluindo."
    Text1.Font = Enum.Font.Gotham
    Text1.TextSize = 14
    Text1.TextColor3 = Color3.fromRGB(220, 220, 220)
    Text1.TextWrapped = true
    Text1.TextTransparency = 1
    Text1.LayoutOrder = 2

    local HubTitle = Instance.new("TextLabel", ContentFrame)
    HubTitle.Size = UDim2.new(1, 0, 0, 18)
    HubTitle.BackgroundTransparency = 1
    HubTitle.Text = "NOVO HUB CHEGANDO:"
    HubTitle.Font = Enum.Font.GothamBold
    HubTitle.TextSize = 15
    HubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    HubTitle.TextTransparency = 1
    HubTitle.LayoutOrder = 3

    local Text2 = Instance.new("TextLabel", ContentFrame)
    Text2.Size = UDim2.new(1, 0, 0, 62)
    Text2.BackgroundTransparency = 1
    Text2.Text = "Estamos reconstruindo o FTF Eclipse do zero com uma interface totalmente nova, mais rápida e otimizada. O novo hub terá sistema de configurações salvas na nuvem, keyless para usuários verificados, auto-update sem precisar reexecutar e suporte completo para mobile + PC."
    Text2.Font = Enum.Font.Gotham
    Text2.TextSize = 14
    Text2.TextColor3 = Color3.fromRGB(220, 220, 220)
    Text2.TextWrapped = true
    Text2.TextTransparency = 1
    Text2.LayoutOrder = 4

    local Text3 = Instance.new("TextLabel", ContentFrame)
    Text3.Size = UDim2.new(1, 0, 0, 48)
    Text3.BackgroundTransparency = 1
    Text3.Text = "Mesmo enfrentando dificuldades, não pretendo abandonar o projeto, cada melhoria está sendo feita com dedicação para oferecer uma experiência cada vez melhor para todos.\n\nObrigado pela paciência, compreensão e apoio."
    Text3.Font = Enum.Font.Gotham
    Text3.TextSize = 14
    Text3.TextColor3 = Color3.fromRGB(220, 220, 220)
    Text3.TextWrapped = true
    Text3.TextTransparency = 1
    Text3.LayoutOrder = 5

    local ButtonHolder = Instance.new("Frame", MainFrame)
    ButtonHolder.AnchorPoint = Vector2.new(0.5, 0)
    ButtonHolder.Position = UDim2.new(0.5, 0, 1, -50)
    ButtonHolder.Size = UDim2.new(0, 280, 0, 35)
    ButtonHolder.BackgroundTransparency = 1

    local btnLayout = Instance.new("UIListLayout", ButtonHolder)
    btnLayout.FillDirection = Enum.FillDirection.Horizontal
    btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    btnLayout.Padding = UDim.new(0, 10)

    local DiscordBtn = Instance.new("TextButton", ButtonHolder)
    DiscordBtn.Size = UDim2.new(0, 130, 1, 0)
    DiscordBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    DiscordBtn.BackgroundTransparency = 1
    DiscordBtn.Text = "DISCORD"
    DiscordBtn.Font = Enum.Font.GothamBold
    DiscordBtn.TextSize = 14
    DiscordBtn.TextColor3 = Color3.fromRGB(88, 101, 242)
    DiscordBtn.TextTransparency = 1
    DiscordBtn.BorderSizePixel = 0
    Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0, 6)
    
    local DiscordStroke = Instance.new("UIStroke", DiscordBtn)
    DiscordStroke.Color = Color3.fromRGB(88, 101, 242)
    DiscordStroke.Thickness = 1
    DiscordStroke.Transparency = 1

    DiscordBtn.MouseEnter:Connect(function()
        TweenService:Create(DiscordBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(88, 101, 242), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    DiscordBtn.MouseLeave:Connect(function()
        TweenService:Create(DiscordBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40), TextColor3 = Color3.fromRGB(88, 101, 242)}):Play()
    end)

    DiscordBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard("https://discord.gg/7ePgap2Jc")
            DiscordBtn.Text = "COPIADO!"
            task.wait(1)
            DiscordBtn.Text = "DISCORD"
        end
    end)

    local ExitBtn = Instance.new("TextButton", ButtonHolder)
    ExitBtn.Size = UDim2.new(0, 130, 1, 0)
    ExitBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ExitBtn.BackgroundTransparency = 1
    ExitBtn.Text = "EXIT"
    ExitBtn.Font = Enum.Font.GothamBold
    ExitBtn.TextSize = 14
    ExitBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
    ExitBtn.TextTransparency = 1
    ExitBtn.BorderSizePixel = 0
    Instance.new("UICorner", ExitBtn).CornerRadius = UDim.new(0, 6)
    
    local BtnStroke = Instance.new("UIStroke", ExitBtn)
    BtnStroke.Color = Color3.fromRGB(255, 60, 60)
    BtnStroke.Thickness = 1
    BtnStroke.Transparency = 1

    ExitBtn.MouseEnter:Connect(function()
        TweenService:Create(ExitBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 60, 60), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    ExitBtn.MouseLeave:Connect(function()
        TweenService:Create(ExitBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40), TextColor3 = Color3.fromRGB(255, 60, 60)}):Play()
    end)

    ExitBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0)}):Play()
        TweenService:Create(BG, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        MaintenanceGui:Destroy()
        if blur then blur:Destroy() end
        if borderConnection then borderConnection:Disconnect() end
    end)

    TweenService:Create(BG, TweenInfo.new(0.4), {BackgroundTransparency = 0.4}):Play()
    task.wait(0.1)
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 540, 0, 360),
        BackgroundTransparency = 0.05
    }):Play()
    TweenService:Create(stroke, TweenInfo.new(0.5), {Transparency = 0}):Play()
    
    task.wait(0.2)
    for _, obj in ipairs(ContentFrame:GetChildren()) do
        if obj:IsA("TextLabel") then
            TweenService:Create(obj, TweenInfo.new(0.3), {TextTransparency = 0, TextStrokeTransparency = 0.7}):Play()
            task.wait(0.05)
        end
    end
    
    task.wait(0.1)
    TweenService:Create(DiscordBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0.2, TextTransparency = 0}):Play()
    TweenService:Create(DiscordStroke, TweenInfo.new(0.3), {Transparency = 0.3}):Play()
    TweenService:Create(ExitBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0.2, TextTransparency = 0}):Play()
    TweenService:Create(BtnStroke, TweenInfo.new(0.3), {Transparency = 0.3}):Play()

    local borderConnection
    borderConnection = RunService.Heartbeat:Connect(function()
        if not MainFrame.Parent then
            borderConnection:Disconnect()
            return
        end
        glow.Rotation = glow.Rotation + 1
        if glow.Rotation >= 360 then glow.Rotation = 0 end
        
        local pulse = math.sin(tick() * 2) * 0.3 + 0.7
        stroke.Color = Color3.fromRGB(120 + pulse * 135, 0, 0)
    end)
end
