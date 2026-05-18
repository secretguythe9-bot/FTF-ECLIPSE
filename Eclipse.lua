local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
    Title = "FTF Eclipse",
    Footer = "version: 2.2",
    Icon = "97649528750741",
    CornerRadius = 6,
    NotifySide = "Right",
    ShowCustomCursor = true,
    SearchbarSize = UDim2.fromScale(0.9, 1),
    Size = UDim2.fromOffset(670, 570)
})

local Tabs = {
    Esp = Window:AddTab("Highlights", "flame", "Visual outlines to highlights players & objects"),
    Setting = Window:AddTab("Misc", "box", "Extra functionality"),
    Visual = Window:AddTab("Profile", "video", "Adjust FOV, camera and nickname visuals"),
    Progress = Window:AddTab("Progress", "clock-fading", "progress information for objects and humanoids"),
    Textures = Window:AddTab("Textures", "map", "Texture and material customization tools"),
    Cloud = Window:AddTab("Atmosphere", "cloudy", "Customize fog, shadows and environmental visuals"),
    CrossHair = Window:AddTab("CrossHair", "mouse-pointer", "Custom Cursors"),
    Sound = Window:AddTab("Sounds", "list-music", "Distorted sounds & All sounds characters"),
    ["UI Settings"] = Window:AddTab("UI Settings", "palette", "Configuration UI"),
}

local function getBeast()
    local players = game.Players:GetPlayers()

    for i = 1, #players do
        local player = players[i]
        local character = player.Character

        if character and character:FindFirstChild("Hammer") then
            return player
        end
    end
end

local modoAtual = "Fill"

local function aplicarHighlight(obj, cor)
    local highlight = obj:FindFirstChild("Highlight")
    if not highlight then
        highlight = Instance.new("Highlight", obj)
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end

    if modoAtual == "Outline" then
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 0
        highlight.OutlineColor = cor
        highlight.FillColor = cor

    elseif modoAtual == "Fill" then
        highlight.FillTransparency = 0.4
        highlight.OutlineTransparency = 0
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillColor = cor
    end
end

local EspBox = Tabs.Esp:AddLeftGroupbox("Objects", "monitor")

local computerHighlight = false
computerCache = {}

EspBox:AddToggle("Computer", {
    Text = "Computer",
    Default = false,
    Callback = function(state)
        computerHighlight = state
        if computerHighlight and game.ReplicatedStorage:FindFirstChild("CurrentMap") and game.ReplicatedStorage.CurrentMap.Value then
            local map = game.ReplicatedStorage.CurrentMap.Value
            computerCache = {}
            local children = map:GetChildren()
            for i = 1, #children do
                local obj = children[i]
                if obj.Name == "ComputerTable" then
                    computerCache[#computerCache+1] = obj
                end
            end
            task.spawn(function()
                while computerHighlight do
                    task.wait(1)

                    pcall(function()
                        for i = 1, #computerCache do
                            local computer = computerCache[i]
                            local highlight = computer:FindFirstChild("Highlight")
                            if not highlight then
                                aplicarHighlight(computer, Color3.fromRGB(0, 0, 230))
                            end
                            if highlight and computer:FindFirstChild("Screen") then
                                local c = computer.Screen.Color
                                local r, g, b = c.R, c.G, c.B
                                local cor
                                if r >= g and r >= b then
                                    cor = Color3.fromRGB(230, 0, 0)
                                elseif g >= r and g >= b then
                                    cor = Color3.fromRGB(0, 230, 0)
                                else
                                    cor = Color3.fromRGB(0, 0, 230)
                                end
                                aplicarHighlight(computer, cor)
                            end
                        end
                    end)
                end

                for i = 1, #computerCache do
                    local computer = computerCache[i]
                    if computer:FindFirstChild("Highlight") then
                        computer.Highlight:Destroy()
                    end
                end
            end)
        else
            if computerCache then
                for i = 1, #computerCache do
                    local computer = computerCache[i]
                    if computer and computer:FindFirstChild("Highlight") then
                        computer.Highlight:Destroy()
                    end
                end
            end
            computerCache = {}
        end
    end
})

local capsuleHighlight = false
capsuleCache = {}

EspBox:AddToggle("Capsule", {
    Text = "Capsule",
    Default = false,
    Callback = function(state)
        capsuleHighlight = state
        if capsuleHighlight then
            capsuleCache = {}
            local descendants = workspace:GetDescendants()
            for i = 1, #descendants do
                local obj = descendants[i]
                if obj.Name == "FreezePod" then
                    capsuleCache[#capsuleCache+1] = obj
                end
            end
            task.spawn(function()
                while capsuleHighlight do
                    task.wait(1)

                    pcall(function()
                        for i = 1, #capsuleCache do
                            local capsule = capsuleCache[i]
                            if capsule then
                                aplicarHighlight(capsule, Color3.fromRGB(0, 170, 255))
                            end
                        end
                    end)
                end

                for i = 1, #capsuleCache do
                    local capsule = capsuleCache[i]
                    if capsule and capsule:FindFirstChild("Highlight") then
                        capsule.Highlight:Destroy()
                    end
                end
                capsuleCache = {}
            end)
        else
            for i = 1, #capsuleCache do
                local capsule = capsuleCache[i]
                if capsule and capsule:FindFirstChild("Highlight") then
                    capsule.Highlight:Destroy()
                end
            end
            capsuleCache = {}
        end
    end
})

local exitHighlight = false
exitCache = {}

EspBox:AddToggle("Exit", {
    Text = "Exit",
    Default = false,
    Callback = function(state)
        exitHighlight = state
        if exitHighlight then
            exitCache = {}
            local descendants = workspace:GetDescendants()
            for i = 1, #descendants do
                local obj = descendants[i]
                if obj.Name == "ExitDoor" then
                    exitCache[#exitCache+1] = obj
                end
            end
            task.spawn(function()
                while exitHighlight do
                    task.wait(1)

                    pcall(function()
                        for i = 1, #exitCache do
                            local exit = exitCache[i]
                            if exit then
                                aplicarHighlight(exit, Color3.fromRGB(255, 255, 0))
                            end
                        end
                    end)
                end

                for i = 1, #exitCache do
                    local exit = exitCache[i]
                    if exit and exit:FindFirstChild("Highlight") then
                        exit.Highlight:Destroy()
                    end
                end
                exitCache = {}
            end)
        else
            for i = 1, #exitCache do
                local exit = exitCache[i]
                if exit and exit:FindFirstChild("Highlight") then
                    exit.Highlight:Destroy()
                end
            end
            exitCache = {}
        end
    end
})

local doorBillboardGui = false
doorCache = {}

EspBox:AddToggle("Door", {
    Text = "Door",
    Default = false,
    Callback = function(state)
        doorBillboardGui = state

        if doorBillboardGui then
            doorCache = {}

            local descendants = workspace:GetDescendants()
            for i = 1, #descendants do
                local door = descendants[i]
                if door.Name == "SingleDoor" or door.Name == "DoubleDoor" then
                    doorCache[#doorCache+1] = door
                end
            end

            task.spawn(function()
                while doorBillboardGui do
                    task.wait(1)

                    pcall(function()
                        for i = 1, #doorCache do
                            local door = doorCache[i]
                            if door and door.Parent then
                                local billboardGui = door:FindFirstChild("DoorESPGui")

                                if not billboardGui then
                                    billboardGui = Instance.new("BillboardGui")
                                    billboardGui.Name = "DoorESPGui"
                                    billboardGui.Parent = door
                                    billboardGui.Adornee = door
                                    billboardGui.Size = UDim2.new(0, 100, 0, 50)
                                    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
                                    billboardGui.AlwaysOnTop = true

                                    local textLabel = Instance.new("TextLabel")
                                    textLabel.Parent = billboardGui
                                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                                    textLabel.BackgroundTransparency = 1
                                    textLabel.Font = Enum.Font.GothamBold
                                    textLabel.TextSize = 9
                                    textLabel.TextStrokeTransparency = 0
                                    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                    textLabel.Text = ""
                                    textLabel.AutoLocalize = false
                                end

                                local textLabel = billboardGui:FindFirstChildOfClass("TextLabel")
                                if textLabel and door:FindFirstChild("DoorTrigger") then
                                    local action = door.DoorTrigger:FindFirstChild("ActionSign")
                                    if action then
                                        if action.Value == 11 then
                                            textLabel.Text = "OPEN"
                                            textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                                        elseif action.Value == 10 then
                                            textLabel.Text = "CLOSE"
                                            textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                                        end
                                    end
                                end
                            end
                        end
                    end)
                end

                for i = 1, #doorCache do
                    local door = doorCache[i]
                    if door and door:FindFirstChild("DoorESPGui") then
                        door.DoorESPGui:Destroy()
                    end
                end
            end)

        else
            for i = 1, #doorCache do
                local door = doorCache[i]
                if door and door:FindFirstChild("DoorESPGui") then
                    door.DoorESPGui:Destroy()
                end
            end
            doorCache = {}
        end
    end
})

local EspBox = Tabs.Esp:AddLeftGroupbox("Highlights Settings", "scan-eye")

EspBox:AddButton("Outline", {
    Text = "Outline",
    Callback = function()
        modoAtual = "Outline"
    end
})

EspBox:AddButton("Fill", {
    Text = "Fill",
    Callback = function()
        modoAtual = "Fill"
    end
})

local EspPlayersBox = Tabs.Esp:AddRightGroupbox("Players", "user")

local playerHighlight = false
playerCache = {}
playerConnections = {}

EspPlayersBox:AddToggle("Highlight ESP", {
    Text = "Highlight ESP",
    Default = false,
    Callback = function(state)
        playerHighlight = state
        if playerHighlight then
            playerCache = {}
            playerConnections = {}

            local function addPlayerESP(player)
                if player == game.Players.LocalPlayer then return end
                playerCache[#playerCache+1] = player
            end

            local function removePlayerESP(player)
                for i = 1, #playerCache do
                    if playerCache[i] == player then
                        table.remove(playerCache, i)
                        break
                    end
                end
                if player.Character and player.Character:FindFirstChild("Highlight") then
                    player.Character.Highlight:Destroy()
                end
            end

            local players = game.Players:GetPlayers()
            for i = 1, #players do
                addPlayerESP(players[i])
            end

            playerConnections[#playerConnections+1] = game.Players.PlayerAdded:Connect(function(player)
                if playerHighlight then addPlayerESP(player) end
            end)

            playerConnections[#playerConnections+1] = game.Players.PlayerRemoving:Connect(function(player)
                removePlayerESP(player)
            end)

            task.spawn(function()
                while playerHighlight do
                    task.wait(1)

                    pcall(function()
                        for i = 1, #playerCache do
                            local player = playerCache[i]
                            if player.Character then
                                local char = player.Character
                                if player == getBeast() then
                                    aplicarHighlight(char, Color3.fromRGB(255, 0, 0))
                                else
                                    aplicarHighlight(char, Color3.fromRGB(0, 255, 0))
                                end
                            end
                        end
                    end)
                end

                for i = 1, #playerCache do
                    local player = playerCache[i]
                    if player.Character and player.Character:FindFirstChild("Highlight") then
                        player.Character.Highlight:Destroy()
                    end
                end

                for i = 1, #playerConnections do
                    playerConnections[i]:Disconnect()
                end

                playerCache = {}
                playerConnections = {}
            end)

        else
            for i = 1, #playerConnections do
                playerConnections[i]:Disconnect()
            end

            for i = 1, #playerCache do
                local player = playerCache[i]
                if player.Character and player.Character:FindFirstChild("Highlight") then
                    player.Character.Highlight:Destroy()
                end
            end

            playerCache = {}
            playerConnections = {}
        end
    end
})

local playerBox = false
playerBoxCache = {}
playerBoxConnections = {}

EspPlayersBox:AddToggle("Box ESP", {
    Text = "Box ESP",
    Default = false,
    Callback = function(state)
        pcall(function()
            playerBox = state

            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer

            local function isBoxPart(part)
                if not part:IsA("BasePart") then return false end
                if part.Name == "HumanoidRootPart" then return false end
                if part:FindFirstAncestorOfClass("Accessory") then return false end

                local model = part:FindFirstAncestorOfClass("Model")
                if not model then return false end

                local humanoid = model:FindFirstChildOfClass("Humanoid")
                if not humanoid then return false end
                if humanoid.RigType ~= Enum.HumanoidRigType.R6 then return false end

                local name = part.Name
                return name == "Head" or name == "Torso" or name == "Left Arm" or name == "Right Arm" or name == "Left Leg" or name == "Right Leg"
            end

            local function clearESP(character)
                local list = playerBoxCache[character]
                if list then
                    for i = 1, #list do
                        local obj = list[i]
                        if obj then pcall(function() obj:Destroy() end) end
                    end
                    playerBoxCache[character] = nil
                end
            end

            local function applyBoxESP(player, character, color)
                if not character then return end

                local cached = playerBoxCache[character]
                if cached then
                    for i = 1, #cached do
                        local obj = cached[i]

                        pcall(function()
                            if obj:IsA("BoxHandleAdornment") then
                                obj.Color3 = color
                            end
                        end)
                    end
                    return
                end

                playerBoxCache[character] = {}
                local list = playerBoxCache[character]

                local parts = character:GetDescendants()
                for i = 1, #parts do
                    local part = parts[i]

                    if isBoxPart(part) then
                        pcall(function()
                            local box = Instance.new("BoxHandleAdornment")
                            box.Adornee = part
                            box.AlwaysOnTop = true
                            box.ZIndex = 10
                            box.Size = part.Size
                            box.Transparency = 0.3
                            box.Color3 = color
                            box.Parent = part

                            list[#list + 1] = box
                        end)
                    end
                end
            end

            if state then
                local playerList = Players:GetPlayers()

                playerBoxConnections.loop = task.spawn(function()
                    while playerBox do
                        task.wait(1)

                        for i = 1, #playerList do
                            local player = playerList[i]

                            if player ~= LocalPlayer and player.Character then
                                local color
                                if getBeast and player == getBeast() then
                                    color = Color3.fromRGB(210, 0, 0)
                                else
                                    color = Color3.fromRGB(0, 210, 0)
                                end

                                pcall(function()
                                    applyBoxESP(player, player.Character, color)
                                end)
                            end
                        end
                    end
                end)

                playerBoxConnections.added = Players.PlayerAdded:Connect(function(player)
                    playerList[#playerList + 1] = player
                end)

                playerBoxConnections.removing = Players.PlayerRemoving:Connect(function(player)
                    if player.Character then
                        pcall(function()
                            clearESP(player.Character)
                        end)
                    end

                    for i = 1, #playerList do
                        if playerList[i] == player then
                            table.remove(playerList, i)
                            break
                        end
                    end
                end)

            else
                for character, list in next, playerBoxCache do
                    for i = 1, #list do
                        local obj = list[i]
                        if obj then pcall(function() obj:Destroy() end) end
                    end
                    playerBoxCache[character] = nil
                end

                if playerBoxConnections.loop then
                    task.cancel(playerBoxConnections.loop)
                    playerBoxConnections.loop = nil
                end

                if playerBoxConnections.added then
                    playerBoxConnections.added:Disconnect()
                    playerBoxConnections.added = nil
                end

                if playerBoxConnections.removing then
                    playerBoxConnections.removing:Disconnect()
                    playerBoxConnections.removing = nil
                end
            end
        end)
    end
})

local playerNameESP = false
playerNameCache = {}
playerNameConnections = {}

EspPlayersBox:AddToggle("Name ESP", {
    Text = "Name ESP",
    Default = false,
    Callback = function(state)
        pcall(function()
            playerNameESP = state

            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer

            local function clearESP(character)
                local obj = playerNameCache[character]
                if obj then
                    pcall(function()
                        obj:Destroy()
                    end)
                    playerNameCache[character] = nil
                end
            end

            local function applyNameESP(player, character, color)
                if not character then return end

                local head = character:FindFirstChild("Head")
                if not head then return end

                local existing = playerNameCache[character]
                if existing then
                    pcall(function()
                        existing.TextLabel.TextColor3 = color
                        existing.TextLabel.Text = player.Name
                    end)
                    return
                end

                local billboard = Instance.new("BillboardGui")
                billboard.Name = "NameESP"
                billboard.Adornee = head
                billboard.AlwaysOnTop = true
                billboard.Size = UDim2.new(0, 100, 0, 25)
                billboard.StudsOffset = Vector3.new(0, 2.5, 0)

                local text = Instance.new("TextLabel")
                text.Size = UDim2.new(1, 0, 1, 0)
                text.BackgroundTransparency = 1
                text.TextSize = 12
                text.Font = Enum.Font.SourceSansBold
                text.Text = player.Name
                text.TextColor3 = color
                text.Parent = billboard

                billboard.Parent = head

                playerNameCache[character] = billboard
            end

            if state then
                local playerList = Players:GetPlayers()

                playerNameConnections.loop = task.spawn(function()
                    while playerNameESP do
                        task.wait(1)

                        for i = 1, #playerList do
                            local player = playerList[i]

                            if player ~= LocalPlayer and player.Character then
                                local color
                                if getBeast and player == getBeast() then
                                    color = Color3.fromRGB(210, 0, 0)
                                else
                                    color = Color3.fromRGB(0, 210, 0)
                                end

                                pcall(function()
                                    applyNameESP(player, player.Character, color)
                                end)
                            end
                        end
                    end
                end)

                playerNameConnections.added = Players.PlayerAdded:Connect(function(player)
                    playerList[#playerList + 1] = player
                end)

                playerNameConnections.removing = Players.PlayerRemoving:Connect(function(player)
                    if player.Character then
                        pcall(function()
                            clearESP(player.Character)
                        end)
                    end

                    for i = 1, #playerList do
                        if playerList[i] == player then
                            table.remove(playerList, i)
                            break
                        end
                    end
                end)

            else
                for character, obj in next, playerNameCache do
                    if obj then
                        pcall(function()
                            obj:Destroy()
                        end)
                    end
                    playerNameCache[character] = nil
                end

                if playerNameConnections.loop then
                    task.cancel(playerNameConnections.loop)
                    playerNameConnections.loop = nil
                end

                if playerNameConnections.added then
                    playerNameConnections.added:Disconnect()
                    playerNameConnections.added = nil
                end

                if playerNameConnections.removing then
                    playerNameConnections.removing:Disconnect()
                    playerNameConnections.removing = nil
                end
            end
        end)
    end
})

local beastIlluminationEnabled = false
local beastConnections = {}

EspPlayersBox:AddToggle("BeastGlowUp", {
    Text = "Beast GlowUp",
    Default = false,

    Callback = function(enabled)
        beastIlluminationEnabled = enabled

        for _, c in ipairs(beastConnections) do
            c:Disconnect()
        end
        table.clear(beastConnections)

        if not enabled then
            for _, p in ipairs(game.Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("Head") then
                    local g = p.Character.Head:FindFirstChild("BeastGlow")
                    if g then g:Destroy() end
                end
            end
            return
        end

        local function apply(char)
            local head = char:FindFirstChild("Head")
            if not head then return end

            local function update()
                local bp = char:FindFirstChild("BeastPowers")
                local glow = head:FindFirstChild("BeastGlow")

                if bp then
                    if not glow then
                        glow = Instance.new("PointLight")
                        glow.Name = "BeastGlow"
                        glow.Color = Color3.fromRGB(0,255,255)
                        glow.Brightness = 8
                        glow.Range = 25
                        glow.Parent = head
                    end
                else
                    if glow then glow:Destroy() end
                end
            end

            update()

            table.insert(beastConnections, char.ChildAdded:Connect(update))
            table.insert(beastConnections, char.ChildRemoved:Connect(update))
        end

        for _, p in ipairs(game.Players:GetPlayers()) do
            if p.Character then apply(p.Character) end

            table.insert(beastConnections,
                p.CharacterAdded:Connect(apply)
            )
        end
    end
}) 

local SettingBox = Tabs.Setting:AddLeftGroupbox("Sensitivity", "columns-3-cog")

SettingBox:AddLabel("This is for Mobile.")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local CONFIG = {
    MIN = 0.1,
    MAX = 10,
    DEFAULT = 1
}

local SensX = CONFIG.DEFAULT
local SensY = CONFIG.DEFAULT

pcall(function()
    local playerScripts = player:WaitForChild("PlayerScripts")
    local playerModule = playerScripts:WaitForChild("PlayerModule")
    local cameraModule = playerModule:WaitForChild("CameraModule")
    local cameraInput = cameraModule:WaitForChild("CameraInput")

    local cameraInputModule = require(cameraInput)

    if cameraInputModule and cameraInputModule.getRotation then
        local oldGetRotation = cameraInputModule.getRotation

        cameraInputModule.getRotation = function(disableRotation)
            local rotation = oldGetRotation(disableRotation)

            if UserInputService.TouchEnabled then
                return Vector2.new(
                    rotation.X * SensX,
                    rotation.Y * SensY
                )
            end

            return rotation
        end
    end
end)

SettingBox:AddSlider("SensitivityX", {
    Text = "Sensitivity X",
    Default = CONFIG.DEFAULT,
    Min = CONFIG.MIN,
    Max = CONFIG.MAX,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        SensX = Value
    end
})

SettingBox:AddSlider("SensitivityY", {
    Text = "Sensitivity Y",
    Default = CONFIG.DEFAULT,
    Min = CONFIG.MIN,
    Max = CONFIG.MAX,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        SensY = Value
    end
})

SettingBox:AddButton({
    Text = "Reset Sensitivity",
    Func = function()
        SensX = CONFIG.DEFAULT
        SensY = CONFIG.DEFAULT

        Library.Options["SensitivityX"]:SetValue(CONFIG.DEFAULT)
        Library.Options["SensitivityY"]:SetValue(CONFIG.DEFAULT)
    end
})

local SettingBox = Tabs.Setting:AddLeftGroupbox("Walkspeed", "sport-shoe")

local player = game.Players.LocalPlayer

local enabled = false
local speedValue = 16

local connection

local function applySpeed()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    if connection then
        connection:Disconnect()
        connection = nil
    end

    if enabled then
        humanoid.WalkSpeed = speedValue

        connection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if enabled and humanoid.WalkSpeed ~= speedValue then
                humanoid.WalkSpeed = speedValue
            end
        end)
    else
        humanoid.WalkSpeed = 16
    end
end

player.CharacterAdded:Connect(function()
    task.wait(1)
    applySpeed()
end)

SettingBox:AddToggle("WalkspeedToggle", {
    Text = "Enable Walkspeed",
    Default = false,

    Callback = function(value)
        enabled = value
        applySpeed()
    end
})

SettingBox:AddSlider("WalkSpeedSlider", {
    Text = "Speed",
    Default = 16,
    Min = 16,
    Max = 120,

    Callback = function(value)
        speedValue = value

        if enabled then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = speedValue
                end
            end
        end
    end
})

local SettingBox = Tabs.Setting:AddLeftGroupbox("High Jump", "waves-arrow-up")

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local enabled = false
local jumpPowerValue = 120

local defaultJumpPower = nil
local defaultUseJumpPower = nil
local defaultJumpHeight = nil

local function applyJump()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    if defaultJumpPower == nil then
        defaultJumpPower = humanoid.JumpPower
        defaultUseJumpPower = humanoid.UseJumpPower
        defaultJumpHeight = humanoid.JumpHeight
    end

    if enabled then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = jumpPowerValue
    else
        humanoid.UseJumpPower = defaultUseJumpPower

        if defaultUseJumpPower then
            humanoid.JumpPower = defaultJumpPower
        else
            humanoid.JumpHeight = defaultJumpHeight
        end
    end
end

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    applyJump()
end)

SettingBox:AddToggle("HighJumpToggle", {
    Text = "Enable High Jump",
    Default = false,

    Callback = function(value)
        enabled = value
        applyJump()
    end
})

SettingBox:AddSlider("HighJumpSlider", {
    Text = "Jump Power",
    Default = 120,
    Min = 50,
    Max = 200,

    Callback = function(value)
        jumpPowerValue = value
        if enabled then
            applyJump()
        end
    end
})

local SettingBox = Tabs.Setting:AddRightGroupbox("Rejoining", "external-link")

local TeleportService = game:GetService("TeleportService")
local player = game.Players.LocalPlayer

SettingBox:AddButton({
    Text = "Rejoin",
    Func = function()
        TeleportService:Teleport(game.PlaceId, player)
    end
})

local SettingBox = Tabs.Setting:AddRightGroupbox("Tracking", "locate-fixed")

_G.AimbotActive = false
_G.AimbotTarget = nil
_G.AimbotConnection = nil
_G.KeyConnection = nil
_G.PlayerRemovingConnection = nil
_G.ButtonConnection = nil

local function disconnectAll()
    if _G.AimbotConnection then
        _G.AimbotConnection:Disconnect()
        _G.AimbotConnection = nil
    end
    if _G.KeyConnection then
        _G.KeyConnection:Disconnect()
        _G.KeyConnection = nil
    end
    if _G.PlayerRemovingConnection then
        _G.PlayerRemovingConnection:Disconnect()
        _G.PlayerRemovingConnection = nil
    end
    if _G.ButtonConnection then
        _G.ButtonConnection:Disconnect()
        _G.ButtonConnection = nil
    end
end

SettingBox:AddToggle("Aimbot", {
    Text = "Aimbot",
    Default = false,
    Callback = function(state)
        _G.AimbotActive = state

        if state then
            local Players = game:GetService("Players")
            local UserInputService = game:GetService("UserInputService")
            local RunService = game:GetService("RunService")
            local LocalPlayer = Players.LocalPlayer
            local Camera = workspace.CurrentCamera

            local existingGui = LocalPlayer.PlayerGui:FindFirstChild("AimbotToggle")
            if existingGui then
                existingGui:Destroy()
            end

            disconnectAll()

            local ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Name = "AimbotToggle"
            ScreenGui.ResetOnSpawn = false
            ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "Toggle"
            ToggleButton.Parent = ScreenGui
            ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            ToggleButton.BackgroundTransparency = 0.3
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Position = UDim2.new(0, 10, 0.5, -21)
            ToggleButton.Size = UDim2.new(0, 105, 0, 46)
            ToggleButton.Font = Enum.Font.GothamBold
            ToggleButton.Text = "OFF"
            ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleButton.TextSize = 16
            ToggleButton.Active = true
            ToggleButton.Draggable = not _G.AimbotLocked
            ToggleButton.AutoLocalize = false

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 8)
            Corner.Parent = ToggleButton

            local function stopAimbot()
                if _G.AimbotConnection then
                    _G.AimbotConnection:Disconnect()
                    _G.AimbotConnection = nil
                end
                _G.AimbotTarget = nil
                if ToggleButton and ToggleButton.Parent then
                    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                    ToggleButton.Text = "OFF"
                end
            end

            local function startAimbot()
                if _G.AimbotConnection then
                    _G.AimbotConnection:Disconnect()
                end

                _G.AimbotConnection = RunService.Heartbeat:Connect(function()
                    if _G.AimbotTarget and _G.AimbotTarget.Character and _G.AimbotTarget.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local targetPart = _G.AimbotTarget.Character.HumanoidRootPart
                        local localPart = LocalPlayer.Character.HumanoidRootPart
                        local distance = (targetPart.Position - localPart.Position).Magnitude

                        if distance <= 70 then
                            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
                        else
                            stopAimbot()
                        end
                    else
                        stopAimbot()
                    end
                end)

                if ToggleButton and ToggleButton.Parent then
                    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
                    ToggleButton.Text = "ON"
                end
            end

            local function findClosestPlayer()
                local closestPlayer = nil
                local shortestDistance = math.huge
                local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

                local players = Players:GetPlayers()
                for i = 1, #players do
                    local player = players[i]
                    if player ~= LocalPlayer and player.Character then
                        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                        if humanoidRootPart then
                            local screenPos, onScreen = Camera:WorldToScreenPoint(humanoidRootPart.Position)
                            if onScreen then
                                local distance2D = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                                local distance3D = (humanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

                                if distance2D < shortestDistance and distance3D <= 70 then
                                    shortestDistance = distance2D
                                    closestPlayer = player
                                end
                            end
                        end
                    end
                end

                return closestPlayer
            end

            _G.KeyConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end

                if input.KeyCode == Enum.KeyCode.F then
                    if _G.AimbotTarget then
                        stopAimbot()
                    else
                        local closestPlayer = findClosestPlayer()
                        if closestPlayer then
                            _G.AimbotTarget = closestPlayer
                            startAimbot()
                        end
                    end
                end
            end)

            _G.ButtonConnection = ToggleButton.MouseButton1Click:Connect(function()
                if _G.AimbotTarget then
                    stopAimbot()
                else
                    local closestPlayer = findClosestPlayer()
                    if closestPlayer then
                        _G.AimbotTarget = closestPlayer
                        startAimbot()
                    end
                end
            end)

            _G.PlayerRemovingConnection = Players.PlayerRemoving:Connect(function(player)
                if player == _G.AimbotTarget then
                    stopAimbot()
                end
            end)
        else
            disconnectAll()
            _G.AimbotTarget = nil

            local gui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("AimbotToggle")
            if gui then
                gui:Destroy()
            end
        end
    end
})

_G.AimbotLocked = false

SettingBox:AddToggle("AimbotLockToggle", {
    Text = "Aimbot Lock Toggle",
    Default = false,
    Callback = function(state)
        _G.AimbotLocked = state

        local gui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("AimbotToggle")
        if gui then
            local button = gui:FindFirstChild("Toggle")
            if button then
                button.Draggable = not state
            end
        end
    end
})

local SettingBox = Tabs.Setting:AddRightGroupbox("Extender", "wind")

_G.HitboxSize = Vector3.new(5.5, 6, 5.5)
_G.originalHitboxSizes = {}
_G.hitboxConnections = {}
_G.processedCharacters = {}
_G.HitboxEnabled = false

local function clamp(n)
	n = tonumber(n)
	if not n then return nil end
	if n > 10 then n = 10 end
	if n < 1 then n = 1 end
	return n
end

local function applyHitboxToAll()
	if not _G.HitboxEnabled then return end

	local players = game.Players:GetPlayers()
	for i = 1, #players do
		local player = players[i]
		if player ~= game.Players.LocalPlayer and player.Character then
			local hrp = player.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				local key = player.Character:GetDebugId()
				if not _G.originalHitboxSizes[key] then
					_G.originalHitboxSizes[key] = hrp.Size
				end
				local size = _G.HitboxSize
				hrp.Size = size
			end
		end
	end
end

SettingBox:AddInput("Hitbox Size", {
	Text = "Hitbox Size",
	Placeholder = "Ex: 5, 7, 6 (max 10)",
	Callback = function(text)
		text = string.gsub(text, "%s+", "")
		local x, y, z = string.match(text, "([%d%.]+),([%d%.]+),([%d%.]+)")

		if x and y and z then
			x = clamp(x)
			y = clamp(y)
			z = clamp(z)

			if x and y and z then
				_G.HitboxSize = Vector3.new(x, y, z)
			else
				_G.HitboxSize = Vector3.new(5.5, 6, 5.5)
			end
		else
			_G.HitboxSize = Vector3.new(5.5, 6, 5.5)
		end

		applyHitboxToAll()
	end
})

SettingBox:AddToggle("Hitbox Expander", {
	Text = "Hitbox Expander",
	Default = false,
	Callback = function(state)
		_G.HitboxEnabled = state

		local function updateHitbox(character)
			if not character then return end
			local hrp = character:FindFirstChild("HumanoidRootPart")
			if not hrp then return end

			local key = character:GetDebugId()

			if state then
				if _G.processedCharacters[key] then return end
				_G.processedCharacters[key] = true

				if not _G.originalHitboxSizes[key] then
					_G.originalHitboxSizes[key] = hrp.Size
				end

				hrp.Size = _G.HitboxSize
				hrp.Transparency = 0.85
				hrp.CanCollide = false
				hrp.Massless = false
				hrp.Color = Color3.fromRGB(0,0,0)
				hrp.Material = Enum.Material.SmoothPlastic
			else
				if _G.originalHitboxSizes[key] then
					hrp.Size = _G.originalHitboxSizes[key]
					hrp.Transparency = 1
					_G.originalHitboxSizes[key] = nil
				end
				_G.processedCharacters[key] = nil
			end
		end

		local function limparCache(character)
			if not character then return end
			local key = character:GetDebugId()
			_G.processedCharacters[key] = nil
			_G.originalHitboxSizes[key] = nil
		end

		local function setupCharacter(character)
			if not character then return end
			task.wait(0.5)
			updateHitbox(character)
			_G.hitboxConnections[#_G.hitboxConnections+1] = character.AncestryChanged:Connect(function()
				limparCache(character)
			end)
		end

		local function desconectarTudo()
			for i = 1, #_G.hitboxConnections do
				local connection = _G.hitboxConnections[i]
				if typeof(connection) == "RBXScriptConnection" then
					pcall(function() connection:Disconnect() end)
				end
				_G.hitboxConnections[i] = nil
			end
			_G.hitboxConnections = {}
		end

		if state then
			desconectarTudo()

			local players = game.Players:GetPlayers()
			for i = 1, #players do
				local player = players[i]
				if player ~= game.Players.LocalPlayer and player.Character then
					setupCharacter(player.Character)
				end
				_G.hitboxConnections[#_G.hitboxConnections+1] = player.CharacterAdded:Connect(function(character)
					setupCharacter(character)
				end)
			end

			_G.hitboxConnections[#_G.hitboxConnections+1] = game.Players.PlayerAdded:Connect(function(player)
				_G.hitboxConnections[#_G.hitboxConnections+1] = player.CharacterAdded:Connect(function(character)
					setupCharacter(character)
				end)
			end)

			_G.hitboxConnections[#_G.hitboxConnections+1] = game.Players.PlayerRemoving:Connect(function(player)
				if player.Character then
					limparCache(player.Character)
				end
			end)
		else
			desconectarTudo()

			local players = game.Players:GetPlayers()
			for i = 1, #players do
				local player = players[i]
				if player ~= game.Players.LocalPlayer and player.Character then
					updateHitbox(player.Character)
				end
			end

			_G.originalHitboxSizes = {}
			_G.processedCharacters = {}
		end
	end
})

local p,rs = game.Players.LocalPlayer, game:GetService("RunService")

local on,name,level,icon = false,"MaybeKayque",100,""
local icons = {
    VIP="rbxassetid://1188562340", QA="rbxassetid://18940008283",
    CON="rbxassetid://18940005647", Casey="rbxassetid://131476591459702",
    DEV="rbxassetid://18940006678", MrWindy="rbxassetid://18937953345",
    MOD="rbxassetid://105155010224102"
}

local n,l,i,orig = nil,nil,nil,{}

local function setup()
    local f = p.PlayerGui:WaitForChild("ScreenGui").PlayerNamesFrame:WaitForChild(p.Name.."PlayerFrame")
    n,l = f.NameLabel,f.LevelLabel
    for _,v in ipairs(f:GetDescendants()) do
        if v:IsA("ImageLabel") or v:IsA("ImageButton") then i=v break end
    end
    orig.n,orig.l,orig.i = n.Text,l.Text,i and i.Image
end

local function update()
    for _,v in ipairs(p.PlayerGui:GetDescendants()) do
        if (v:IsA("TextLabel") or v:IsA("TextButton")) and v.Text~="" then
            orig[v]=orig[v] or v.Text
            if on and v.Text:find(p.Name) then
                local base = orig[v]:gsub(p.Name,""):gsub("%s+"," "):gsub("^%s+",""):gsub("%s+$","")
                v.Text = base=="" and name or (name.." "..base)
            elseif not on then
                v.Text = orig[v]
            end
        end
    end
end

local function apply()
    if not n then return end
    if on then
        n.Text, l.Text = name, tostring(level)
        if i and icon~="" then i.Image = icon end
    else
        n.Text, l.Text = orig.n, orig.l
        if i and orig.i then i.Image = orig.i end
    end
    update()
end

rs.RenderStepped:Connect(function()
    if on and n then
        n.Text, l.Text = name, tostring(level)
        if i and icon~="" then i.Image = icon end
        update()
    end
end)

p.CharacterAdded:Connect(function(c)
    task.wait(.5)
    local h=c:FindFirstChildOfClass("Humanoid")
    if h then h.DisplayName = on and name or p.DisplayName end
end)

task.spawn(function() setup() apply() end)

-- UI
local box = Tabs.Visual:AddLeftTabbox()
local tab = box:AddTab("Nick")

tab:AddToggle("Spoof", {
    Text="Hide username", Default=false,
    Callback=function(v) on=v apply() end
})

tab:AddInput("Name", {
    Text="Username", Default="MaybeKayque", Finished=true,
    Callback=function(v) name=v if on then apply() end end
})

tab:AddInput("Level", {
    Text="Level", Default="100", Finished=true,
    Callback=function(v) level=tonumber(v) or 100 if on then apply() end end
})

tab:AddDropdown("Icon", {
    Text="Icon",
    Values={"None","VIP","QA","CON","Casey","DEV","MrWindy","MOD"},
    Default="None",
    Callback=function(v) icon = (v=="None" and "" or icons[v]) if on then apply() end end
})

local VisualBox = Tabs.Visual:AddRightGroupbox("Fov Camera", "fullscreen")

local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local FOVEnabled, fovValue, defaultFOV = false, 70, 70

RunService.RenderStepped:Connect(function()
	camera.FieldOfView = FOVEnabled and fovValue or defaultFOV
end)

VisualBox:AddToggle("FOVToggle", {
	Text = "Enable Wide FOV",
	Default = false,
	Callback = function(v)
		FOVEnabled = v
	end
})

VisualBox:AddSlider("FOVSlider", {
	Text = "FOV",
	Default = 70,
	Min = 70,
	Max = 120,
	Callback = function(v)
		fovValue = v
	end
})

local ProgressBox = Tabs.Progress:AddLeftGroupbox("Objects", "monitor")

local enabled = false

local P = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Run = game:GetService("RunService")
local W = workspace

local comps = {}

ProgressBox:AddToggle("ComputerProgress", {
Text = "Computer Progress",
Default = false,

Callback = function(v)  
    enabled = v  

    if not v then  
        for _,d in pairs(comps) do  
            if d.gui then  
                d.gui:Destroy()  
            end  
        end  
        comps = {}  
    end  
end

})

local function make(pc)

local g = Instance.new("BillboardGui")  
g.Name = "ComputerProgressGui"  
g.Size = UDim2.new(0,120,0,18)  
g.StudsOffset = Vector3.new(0,3.5,0)  
g.AlwaysOnTop = true  
g.Enabled = enabled  
g.Parent = pc  

local txt = Instance.new("TextLabel", g)  
txt.Size = UDim2.new(1,0,0.5,0)  
txt.BackgroundTransparency = 1  
txt.TextScaled = true  
txt.Font = Enum.Font.GothamBold  
txt.TextColor3 = Color3.new(1,1,1)  
txt.TextStrokeTransparency = 0.4  
txt.Text = "0%"  

local bg = Instance.new("Frame", g)  
bg.Position = UDim2.new(0,0,0.55,0)  
bg.Size = UDim2.new(1,0,0.35,0)  
bg.BackgroundColor3 = Color3.fromRGB(20,20,20)  
bg.BorderSizePixel = 0  
Instance.new("UICorner", bg).CornerRadius = UDim.new(1,0)  

local bar = Instance.new("Frame", bg)  
bar.Size = UDim2.new(0,0,1,0)  
bar.BorderSizePixel = 0  
bar.BackgroundColor3 = Color3.fromRGB(255,255,255)  
Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)  

comps[pc] = {  
	gui = g,  
	bar = bar,  
	txt = txt,  
	p = 0,  
	d = false  
}

end

local function progress(pc)
local m = 0

for _,p in pairs(pc:GetChildren()) do  
	if p:IsA("BasePart") and p.Name:find("ComputerTrigger") then  
		for _,t in pairs(p:GetTouchingParts()) do  
			local pl = P:GetPlayerFromCharacter(t.Parent)  
			local s = pl and pl:FindFirstChild("TempPlayerStatsModule")  
			local ap = s and s:FindFirstChild("ActionProgress")  
			local r = s and s:FindFirstChild("Ragdoll")  

			if ap and r and not r.Value then  
				m = math.max(m, ap.Value)  
			end  
		end  
	end  
end  

return m

end

Run.Heartbeat:Connect(function()
if not enabled then return end

for pc,d in pairs(comps) do  
	if not d.d then  
		d.p = math.max(d.p, progress(pc))  
		d.bar.Size = UDim2.new(d.p,0,1,0)  

		if d.p >= 1 then  
			d.d = true  
			d.txt.Text = "COMPLETED"  
			d.txt.TextColor3 = Color3.fromRGB(0,255,0)  
			d.bar.BackgroundColor3 = Color3.fromRGB(0,255,0)  
		else  
			d.txt.Text = string.format("%.1f%%", d.p * 100)  
		end  
	end  
end

end)

task.spawn(function()
while true do
if enabled then
local m = RS:WaitForChild("CurrentMap").Value
local map = W:FindFirstChild(tostring(m))

if map then  
			for _,o in pairs(map:GetChildren()) do  
				if o.Name == "ComputerTable" and not comps[o] then  
					make(o)  
				end  
			end  
		end  
	end  

	task.wait(1)  
end

end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local WS = game:GetService("Workspace")

local doors, conns = {}, {}
local running = false

ProgressBox:AddToggle("Door", {
    Text = "Door Timer",
    Default = false,

    Callback = function(v)
        running = v

        if not v then
            for _,c in pairs(conns) do pcall(function() c:Disconnect() end) end
            for _,g in pairs(doors) do if g then g:Destroy() end end
            table.clear(conns)
            table.clear(doors)
            return
        end

        local function getProgress(plr)
            local stats = plr:FindFirstChild("TempPlayerStatsModule")
            local ap = stats and stats:FindFirstChild("ActionProgress")
            return ap and ap.Value or 0
        end

        local function setup(d)
            if doors[d] or d.Name ~= "SingleDoor" then return end

            local p = d:FindFirstChildWhichIsA("BasePart", true)
            if not p then return end

            local g = Instance.new("BillboardGui")
            g.Size = UDim2.fromOffset(90,22)
            g.AlwaysOnTop = true
            g.Adornee = p

            g.StudsOffsetWorldSpace = Vector3.new(0, 0, 0.1)

            g.Parent = p

            local t = Instance.new("TextLabel", g)
            t.Size = UDim2.new(1,0,0.45,0)
            t.BackgroundTransparency = 1
            t.TextScaled = true
            t.Font = Enum.Font.GothamMedium
            t.TextColor3 = Color3.fromRGB(255,210,140)
            t.TextStrokeTransparency = 0.6
            t.Text = "0.0%"

            local bg = Instance.new("Frame", g)
            bg.Size = UDim2.new(1,0,0.35,0)
            bg.Position = UDim2.new(0,0,0.6,0)
            bg.BackgroundColor3 = Color3.fromRGB(25,15,5)
            bg.BackgroundTransparency = 0.5
            bg.BorderSizePixel = 0

            local bar = Instance.new("Frame", bg)
            bar.Size = UDim2.new(0,0,1,0)
            bar.BackgroundColor3 = Color3.fromRGB(170,100,40)
            bar.BorderSizePixel = 0

            local progress = 0

            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not running or not d.Parent then
                    if conn then conn:Disconnect() end
                    if g then g:Destroy() end
                    doors[d] = nil
                    return
                end

                local best = 0

                for _,plr in ipairs(Players:GetPlayers()) do
                    local char = plr.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")

                    if hrp and (hrp.Position - p.Position).Magnitude <= 12 then
                        local prog = getProgress(plr)
                        if prog > best then
                            best = prog
                        end
                    end
                end

                if best <= 0 then
                    progress = 0
                else
                    progress = best
                    if progress >= 0.999 then
                        progress = 1
                    end
                end

                progress = math.clamp(progress,0,1)

                bar:TweenSize(UDim2.new(progress,0,1,0), "Out", "Quad", 0.1, true)

                t.Text = string.format("%.1f%%", progress*100)
            end)

            table.insert(conns, conn)
            doors[d] = g
        end

        table.insert(conns, task.spawn(function()
            while running do
                for _,v in ipairs(WS:GetDescendants()) do
                    if v.Name == "SingleDoor" and not doors[v] then
                        setup(v)
                    end
                end
                task.wait(1.5)
            end
        end))
    end
})

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local W = workspace

local enabled = false
local doors = {}
local folder

local function getProgress(plr)
	local m = plr:FindFirstChild("TempPlayerStatsModule")
	if m then
		local ok, mod = pcall(require, m)
		if ok and mod.GetValue then
			local ok2, val = pcall(function()
				return mod:GetValue("ActionProgress")
			end)
			if ok2 then return val end
		end
	end
	return 0
end

local function addDoor(d)
	if doors[d] then return end

	local part = d.PrimaryPart or d:FindFirstChildWhichIsA("BasePart")
	if not part then return end

	local g = Instance.new("BillboardGui", folder)
	g.Size = UDim2.new(0,140,0,40)
	g.StudsOffset = Vector3.new(0,5,0)
	g.AlwaysOnTop = true
	g.Adornee = part

	local t = Instance.new("TextLabel", g)
	t.Size = UDim2.new(1,0,0.6,0)
	t.BackgroundTransparency = 1
	t.Text = "EXIT"
	t.TextScaled = true
	t.Font = Enum.Font.GothamBold
	t.TextColor3 = Color3.new(1,1,1)

	local bg = Instance.new("Frame", g)
	bg.Size = UDim2.new(0.8,0,0,6)
	bg.Position = UDim2.new(0.1,0,0.7,0)
	bg.BackgroundColor3 = Color3.fromRGB(20,20,20)

	local f = Instance.new("Frame", bg)
	f.Size = UDim2.new(0,0,1,0)
	f.BackgroundColor3 = Color3.fromRGB(255,170,0)

	doors[d] = {p=part,t=t,f=f}
end

ProgressBox:AddToggle("ExitDoor", {
	Text = "ExitDoor Timer",
	Default = false,
	Callback = function(v)
		enabled = v

		if not v then
			if folder then folder:Destroy() end
			doors = {}
			return
		end

		folder = Instance.new("Folder", CoreGui)

		for _,o in pairs(W:GetDescendants()) do
			if o:IsA("Model") and o.Name=="ExitDoor" then
				addDoor(o)
			end
		end

		W.DescendantAdded:Connect(function(o)
			if enabled and o:IsA("Model") and o.Name=="ExitDoor" then
				task.wait(0.2)
				addDoor(o)
			end
		end)

		task.spawn(function()
			while enabled do
				task.wait(0.1)

				for d,data in pairs(doors) do
					if not d.Parent then continue end

					local best = 0
					local using = false

					for _,plr in pairs(Players:GetPlayers()) do
						local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
						if hrp then
							local dist = (hrp.Position - data.p.Position).Magnitude
							if dist <= 10 then
								local prog = getProgress(plr)
								if prog > 0 then
									using = true
									best = math.max(best, prog)
								end
							end
						end
					end

					local prog = using and best or 0
					data.f.Size = UDim2.new(prog,0,1,0)
					data.t.Text = prog>0 and ("OPENING: "..math.floor(prog*100).."%") or "EXIT"
				end
			end
		end)
	end
})

ProgressBox:AddToggle("DetectorWalkspeed", {
    Text = "Walkspeed",
    Default = false,

    Callback = function(Value)
        local players = game:GetService("Players")
        local runService = game:GetService("RunService")
        local localPlayer = players.LocalPlayer

        _G.WalkspeedEnabled = Value

        if not Value then
            for _, plr in pairs(players:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("Head") then
                    local tag = plr.Character.Head:FindFirstChild("SpeedTag")
                    if tag then tag:Destroy() end
                end
            end

            if _G.WalkspeedConnections then
                for _, connection in pairs(_G.WalkspeedConnections) do
                    conn:Disconnect()
                end
            end

            _G.WalkspeedConnections = {}
            return
        end

        _G.WalkspeedConnections = {}

        local function createSpeedTag(character)
            if not _G.WalkspeedEnabled then return end
            if not character then return end
            
            local player = players:GetPlayerFromCharacter(character)
            if player == localPlayer then return end
            
            local humanoid = character:FindFirstChild("Humanoid")
            local head = character:FindFirstChild("Head")
            
            if head and humanoid and not head:FindFirstChild("SpeedTag") then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "SpeedTag"
                billboard.Size = UDim2.new(0, 17, 0, 17)
                billboard.StudsOffset = Vector3.new(0, 1.8, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = head
                billboard.Adornee = head

                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                textLabel.TextStrokeTransparency = 0.2
                textLabel.TextScaled = true
                textLabel.Font = Enum.Font.GothamBold
                textLabel.Parent = billboard

                local connection
                connection = runService.RenderStepped:Connect(function()
                    if not _G.WalkspeedEnabled then
                        connection:Disconnect()
                        billboard:Destroy()
                        return
                    end

                    if not character:IsDescendantOf(game) or not humanoid or not head then
                        connection:Disconnect()
                        billboard:Destroy()
                        return
                    end

                    local moving = humanoid.MoveDirection.Magnitude

                    if moving > 0 then
                        textLabel.Text = tostring(math.floor(humanoid.WalkSpeed))
                    else
                        textLabel.Text = "0"
                    end
                end)

                table.insert(_G.WalkspeedConnections, connection)
            end
        end

        local function monitorPlayer(plr)
            if not _G.WalkspeedEnabled then return end

            local connection = plr.CharacterAdded:Connect(function(char)
                task.wait(0.5)
                createSpeedTag(char)
            end)

            table.insert(_G.WalkspeedConnections, conn)

            if plr.Character then
                createSpeedTag(plr.Character)
            end
        end

        for _, plr in pairs(players:GetPlayers()) do
            monitorPlayer(plr)
        end

        local connection = players.PlayerAdded:Connect(monitorPlayer)
        table.insert(_G.WalkspeedConnections, connection)

        task.spawn(function()
            while _G.WalkspeedEnabled do
                task.wait(2)

                for _, plr in pairs(players:GetPlayers()) do
                    if not _G.WalkspeedEnabled then break end

                    if plr ~= localPlayer
                    and plr.Character
                    and plr.Character:FindFirstChild("Head")
                    and not plr.Character.Head:FindFirstChild("SpeedTag") then
                        createSpeedTag(plr.Character)
                    end
                end
            end
        end)
    end
})

local ProgressBox = Tabs.Progress:AddRightGroupbox("Humanoid", "user")

ProgressBox:AddToggle("BeastPower", {
    Text = "Beast Power",
    Default = false,

    Callback = function(Value)

        if _G.BeastPowerLoop then
            _G.BeastPowerLoop = false
        end

        local CoreGui = game:GetService("CoreGui")
        if CoreGui:FindFirstChild("BeastPowerGui") then
            CoreGui.BeastPowerGui:Destroy()
        end

        if not Value then return end

        local Players = game:GetService("Players")
        local LP = Players.LocalPlayer

        local gui = Instance.new("ScreenGui")
        gui.Name = "BeastPowerGui"
        gui.Parent = CoreGui

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0,200,0,20)
        label.Position = UDim2.new(0.5,-100,0.88,0)
        label.BackgroundColor3 = Color3.fromRGB(0,0,0)
        label.BackgroundTransparency = 0.35
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.Text = ""
        label.Parent = gui

        local readyShown = false
        _G.BeastPowerLoop = true

        local function getBeast()
            for _,p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("BeastPowers") then
                    return p.Character.BeastPowers
                end
            end
        end

        task.spawn(function()
            while _G.BeastPowerLoop do
                task.wait(0.05)

                local bp = getBeast()

                if bp then
                    gui.Enabled = true

                    local percent = bp:FindFirstChild("PowerProgressPercent")

                    if percent then
                        local value = math.floor(percent.Value * 100)

                        if value >= 100 then
                            if not readyShown then
                                label.TextColor3 = Color3.fromRGB(0,255,0)
                                label.Text = "Full"
                                readyShown = true
                            end

                        elseif value >= 70 then
                            label.TextColor3 = Color3.fromRGB(255,170,0)
                            label.Text = "Runner Back In: "..value.."%"
                            readyShown = false

                        else
                            label.TextColor3 = Color3.fromRGB(255,0,0)
                            label.Text = "Runner Back In: "..value.."%"
                            readyShown = false
                        end
                    end

                else
                    gui.Enabled = false
                    readyShown = false
                end
            end
        end)
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

_G.BeastPower2_Session = _G.BeastPower2_Session or 0
_G.BeastPower2_Connections = _G.BeastPower2_Connections or {}

local function disconnectAll()
    for _, c in ipairs(_G.BeastPower2_Connections) do
        pcall(function() c:Disconnect() end)
    end
    _G.BeastPower2_Connections = {}
end

local function clearAll()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local g = head:FindFirstChild("RP")
                if g then g:Destroy() end
            end
        end
    end
end

ProgressBox:AddToggle("BeastPower", {
    Text = "Beast Power V2",
    Default = false,

    Callback = function(Value)

        _G.BeastPower2_Session += 1
        local mySession = _G.BeastPower2_Session

        disconnectAll()
        clearAll()

        if not Value then return end

        local running = true
        local toggle = true

        table.insert(_G.BeastPower2_Connections,
            UserInputService.InputBegan:Connect(function(input, gp)
                if not gp and input.KeyCode == Enum.KeyCode.V then
                    toggle = not toggle
                end
            end)
        )

        local function mkBBG(head)
            if head and not head:FindFirstChild("RP") then
                local g = Instance.new("BillboardGui")
                g.Name = "RP"
                g.Size = UDim2.new(0, 100, 0, 30)
                g.StudsOffset = Vector3.new(0, 3, 0)
                g.AlwaysOnTop = true
                g.Parent = head

                local l = Instance.new("TextLabel")
                l.Size = UDim2.new(1, 0, 1, 0)
                l.BackgroundTransparency = 1
                l.TextColor3 = Color3.new(1,1,1)
                l.TextScaled = true
                l.Font = Enum.Font.Cartoon
                l.Text = "0%"
                l.Parent = g
            end
        end

        local function rmBBG(head)
            if head then
                local g = head:FindFirstChild("RP")
                if g then g:Destroy() end
            end
        end

        local function setupBP(character)

            if not running or mySession ~= _G.BeastPower2_Session then return end

            local con1 = character.ChildAdded:Connect(function(child)
                if child.Name == "BeastPowers" then
                    local head = character:FindFirstChild("Head")
                    if head then mkBBG(head) end
                end
            end)

            local con2 = character.ChildRemoved:Connect(function(child)
                if child.Name == "BeastPowers" then
                    local head = character:FindFirstChild("Head")
                    if head then rmBBG(head) end
                end
            end)

            table.insert(_G.BeastPower2_Connections, con1)
            table.insert(_G.BeastPower2_Connections, con2)

            local hb
            hb = RunService.Heartbeat:Connect(function()
                if not running or mySession ~= _G.BeastPower2_Session then
                    hb:Disconnect()
                    return
                end

                local head = character:FindFirstChild("Head")
                if not head then return end

                local bp = character:FindFirstChild("BeastPowers")

                if not bp then
                    rmBBG(head)
                    return
                end

                local g = head:FindFirstChild("RP")
                if not g then
                    mkBBG(head)
                    g = head:FindFirstChild("RP")
                end

                if g then
                    g.Enabled = toggle

                    local l = g:FindFirstChildOfClass("TextLabel")
                    local v = bp:FindFirstChild("PowerProgressPercent")

                    if l and v then
                        l.Text = tostring(math.floor(v.Value * 100)) .. "%"
                    else
                        l.Text = "0%"
                    end
                end
            end)

            table.insert(_G.BeastPower2_Connections, hb)
        end

        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                setupBP(player.Character)
            end

            table.insert(_G.BeastPower2_Connections,
                player.CharacterAdded:Connect(function(char)
                    task.wait(1)
                    setupBP(char)
                end)
            )
        end

        table.insert(_G.BeastPower2_Connections,
            Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function(char)
                    task.wait(1)
                    setupBP(char)
                end)
            end)
        )
    end
})

ProgressBox:AddDivider()

ProgressBox:AddToggle("LifeTime", {
    Text = "Life Time",
    Default = false,

    Callback = function(v)
        local P, R, LP = game:GetService("Players"), game:GetService("RunService"), game:GetService("Players").LocalPlayer
        _G.Life = v

        if not v then
            for _,p in pairs(P:GetPlayers()) do
                local c=p.Character
                local part=c and (c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart"))
                local g=part and part:FindFirstChild("LifeTag")
                if g then g:Destroy() end
            end
            if _G.LifeC then for _,c in pairs(_G.LifeC) do pcall(function() c:Disconnect() end) end end
            _G.LifeC={}
            return
        end

        _G.LifeC={}

        local function beast(p)
            local s=p:FindFirstChild("TempPlayerStatsModule",true)
            return s and s:FindFirstChild("IsBeast") and s.IsBeast.Value
        end

        local function col(v)
            return v>=400 and Color3.fromRGB(80,160,255) or v>=200 and Color3.fromRGB(255,210,80) or Color3.fromRGB(255,80,80)
        end

        local function tag(c)
            if not _G.Life then return end
            local p=P:GetPlayerFromCharacter(c)
            if not p or p==LP then return end

            local part=c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart")
            local s=p:FindFirstChild("TempPlayerStatsModule",true)
            local hp=s and s:FindFirstChild("Health")

            if part and hp and not part:FindFirstChild("LifeTag") then
                local b=Instance.new("BillboardGui",part)
                b.Name="LifeTag" b.Size=UDim2.new(0,60,0,20) b.StudsOffset=Vector3.new(0,3,0) b.AlwaysOnTop=true

                local t=Instance.new("TextLabel",b)
                t.Size=UDim2.new(1,0,1,0) t.BackgroundTransparency=1 t.TextScaled=true t.Font=Enum.Font.Arcade t.TextStrokeTransparency=0.4

                local sVal=500
                local conn
                conn=R.RenderStepped:Connect(function(dt)
                    if not _G.Life or not c.Parent then conn:Disconnect() b:Destroy() return end

                    if beast(p) then
                        t.Text="000s" t.TextColor3=Color3.fromRGB(255,0,0) sVal=500 return
                    end

                    if hp.Value>0 then
                        local target=math.floor(math.clamp(hp.Value,0,100)/100*500)
                        sVal+= (target-sVal)*math.clamp(dt*1.2,0,1)
                        local v=math.floor(sVal+0.5)
                        t.Text=v.."s" t.TextColor3=col(v)
                    else
                        t.Text="" sVal=500
                    end
                end)

                table.insert(_G.LifeC,conn)
            end
        end

        local function hook(p)
            table.insert(_G.LifeC,p.CharacterAdded:Connect(function(c) task.wait(0.3) tag(c) end))
            if p.Character then tag(p.Character) end
        end

        for _,p in pairs(P:GetPlayers()) do hook(p) end
        table.insert(_G.LifeC,P.PlayerAdded:Connect(hook))

        task.spawn(function()
            while _G.Life do
                task.wait(2)
                for _,p in pairs(P:GetPlayers()) do
                    local c=p.Character
                    local part=c and (c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart"))
                    if p~=LP and part and not part:FindFirstChild("LifeTag") then tag(c) end
                end
            end
        end)
    end
})

ProgressBox:AddToggle("SpawnTime", {
    Text = "Spawn time",
    Default = false,

    Callback = function(v)

        if _G.BTC then _G.BTC:Disconnect() end
        if _G.BCC then _G.BCC:Disconnect() end

        local cg = game:GetService("CoreGui")
        local lp = game.Players.LocalPlayer

        local old = cg:FindFirstChild("BeastTimerGui")
        if old then old:Destroy() end
        if not v then return end

        local rs, ts, ds = game:GetService("RunService"), game:GetService("TweenService"), game:GetService("Debris")

        local gui = Instance.new("ScreenGui", cg)
        gui.Name, gui.DisplayOrder = "BeastTimerGui", 999

        local l = Instance.new("TextLabel", gui)
        l.AnchorPoint = Vector2.new(.5,.5)
        l.Position = UDim2.new(.5,0,.5,0)
        l.Size = UDim2.new(0,350,0,80)
        l.BackgroundTransparency = 1
        l.TextSize = 36
        l.Font = Enum.Font.SpecialElite
        l.TextStrokeTransparency = .2
        l.TextStrokeColor3 = Color3.fromRGB(120,0,0)
        l.Visible = false

        local function drip(t,c)
            for i=1,math.random(2,4) do
                local d = l:Clone()
                d.Parent = gui
                d.Text, d.TextColor3 = t, c
                d.Position = l.Position + UDim2.new(0,math.random(-6,6),0,0)

                ts:Create(d,TweenInfo.new(.8),{
                    Position = d.Position + UDim2.new(0,0,0,math.random(35,60)),
                    TextTransparency = 1
                }):Play()

                ds:AddItem(d,1)
            end
        end

        local last, active, tleft = nil,false,0
        local TELEPORT = 20
        local DURATION = 16

        local function isBeast()
            local m = lp:FindFirstChild("TempPlayerStatsModule")
            return m and require(m).IsBeast
        end

        _G.BTC = rs.Heartbeat:Connect(function(dt)
            local c = lp.Character
            local h = c and c:FindFirstChild("HumanoidRootPart")
            if not h then return end

            if isBeast() then l.Visible, active = false, false return end

            if last and not active and (h.Position-last).Magnitude > TELEPORT then
                active, tleft = true, DURATION
                l.Visible = true
            end

            last = h.Position

            if active then
                tleft -= dt

                if tleft <= 0 then
                    active = false
                    l.Text = "A Fera foi solta..."
                    l.TextSize = 28
                    l.TextColor3 = Color3.new(1,1,1)
                    l.TextTransparency = 1
                    l.Visible = true

                    ts:Create(l,TweenInfo.new(1),{TextTransparency=0}):Play()

                    task.spawn(function()
                        for i=1,30 do
                            drip(l.Text,Color3.fromRGB(180,0,0))
                            task.wait(.1)
                        end
                    end)

                    task.delay(3.5,function() if not active then l.Visible=false end end)

                else
                    local c = tleft<=5 and Color3.fromRGB(255,40,40) or Color3.new(1,1,1)
                    l.TextColor3, l.TextStrokeColor3 = c, Color3.fromRGB(120,0,0)
                    l.Text = string.format("%.2f", tleft)

                    if tleft<=5 and math.random()<.6 then
                        drip(l.Text,c)
                    end
                end
            end
        end)

        _G.BCC = lp.CharacterAdded:Connect(function()
            active,last = false,nil
            l.Visible = false
        end)

    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
local DURATION = 28

local active = {}
local enabled = false
local loopConnection

local function humanoid(p)
    return p.Character and p.Character:FindFirstChildOfClass("Humanoid")
end

local function ragdoll(p)
    local h = humanoid(p)
    if not h then return false end
    return h.PlatformStand or h:GetState() == Enum.HumanoidStateType.Physics
end

local function captured(p)
    local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
    return hrp and hrp.Anchored
end

local function glowColor()
    local t = tick()
    local pulse = (math.sin(t * 5) + 1) / 2

    local dark = Color3.fromRGB(90, 0, 20)
    local bright = Color3.fromRGB(220, 30, 50)

    return dark:Lerp(bright, pulse)
end

local gui = Instance.new("ScreenGui")
gui.Name = "RagdollCounterGui"
gui.ResetOnSpawn = false
gui.Parent = LP:WaitForChild("PlayerGui")

local list = Instance.new("Frame", gui)
list.Size = UDim2.new(0,240,0,300)
list.Position = UDim2.new(1,-20,1,-20)
list.AnchorPoint = Vector2.new(1,1)
list.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", list)
layout.VerticalAlignment = Enum.VerticalAlignment.Bottom

local function billboard(p)
    local h = p.Character and p.Character:FindFirstChild("Head")
    if not h then return end

    local old = h:FindFirstChild("RC")
    if old then old:Destroy() end

    local bb = Instance.new("BillboardGui")
    bb.Name = "RC"
    bb.Size = UDim2.new(2.5,0,0.7,0)
    bb.StudsOffset = Vector3.new(0,1.9,0)
    bb.AlwaysOnTop = true
    bb.Parent = h

    local t = Instance.new("TextLabel")
    t.Size = UDim2.fromScale(1,1)
    t.BackgroundTransparency = 1
    t.TextScaled = true
    t.Font = Enum.Font.SpecialElite
    t.TextStrokeTransparency = 0.1
    t.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    t.Parent = bb

    return t
end

local function start(p)
    if active[p] then return end
    active[p] = {
        start = tick(),
        billboard = billboard(p)
    }

    local txt = Instance.new("TextLabel", list)
    txt.Size = UDim2.new(1,0,0,32)
    txt.BackgroundTransparency = 1
    txt.TextScaled = true
    txt.Font = Enum.Font.SpecialElite
    txt.TextXAlignment = Enum.TextXAlignment.Right
    txt.RichText = true
    active[p].label = txt
end

local function runLoop()
    loopConnection = RunService.Heartbeat:Connect(function()

        if not enabled then return end

        for _, p in ipairs(Players:GetPlayers()) do

            if ragdoll(p) and not captured(p) then
                start(p)

                local data = active[p]
                if data then

                    local t = math.max(DURATION - (tick() - data.start), 0)
                    local c = glowColor()
                    local timeText = string.format("%.2f", t)
                   
                    if data.billboard then
                        data.billboard.Text = timeText
                        data.billboard.TextColor3 = c
                    end
                   
                    if data.label then
                        data.label.Text =
                            '<font color="rgb(255,255,255)">' .. p.Name .. '</font> - ' ..
                            '<font color="rgb(' ..
                            math.floor(c.R*255) .. ',' ..
                            math.floor(c.G*255) .. ',' ..
                            math.floor(c.B*255) ..
                            ')">' .. timeText .. '</font>'
                    end
                end
            else
                if active[p] then
                    if active[p].label then active[p].label:Destroy() end
                    if p.Character and p.Character:FindFirstChild("Head") then
                        local bb = p.Character.Head:FindFirstChild("RC")
                        if bb then bb:Destroy() end
                    end
                    active[p] = nil
                end
            end
        end
    end)
end

ProgressBox:AddToggle("GetUp", {
    Text = "GetUp Timer",
    Default = false,

    Callback = function(Value)
        enabled = Value

        if Value then
            runLoop()
        else
            if loopConnection then
                loopConnection:Disconnect()
                loopConnection = nil
            end

            for p, data in pairs(active) do
                if data.label then data.label:Destroy() end
                if p.Character and p.Character:FindFirstChild("Head") then
                    local bb = p.Character.Head:FindFirstChild("RC")
                    if bb then bb:Destroy() end
                end
            end

            table.clear(active)
        end
    end
})

local TexturesBox = Tabs.Textures:AddLeftGroupbox("Double Jump Effects", "bubbles")

local currentTexture = nil
local connection = nil

local function save(v)
    if not v:GetAttribute("OldTexture") then
        v:SetAttribute("OldTexture", v.Texture)
    end
end

local function applyAll()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
            save(v)
            if currentTexture then
                v.Texture = currentTexture
            end
        end
    end
end

local function start()
    if connection then connection:Disconnect() end

    connection = workspace.DescendantAdded:Connect(function(v)
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
            save(v)
            if currentTexture then
                v.Texture = currentTexture
            end
        end
    end)
end

local function restoreAll()
    if connection then
        connection:Disconnect()
        connection = nil
    end

    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
            local old = v:GetAttribute("OldTexture")
            if old then
                v.Texture = old
            end
        end
    end

    currentTexture = nil
end

TexturesBox:AddButton("Default", {
    Text = "Default",
    Callback = function()
        restoreAll()
    end
})

local function createEffectButton(name, id)
    TexturesBox:AddButton(name, {
        Text = name,
        Callback = function()
            currentTexture = id
            applyAll()
            start()
        end
    })
end

createEffectButton("FacilityGamer Cat", "rbxassetid://98980064486234")
createEffectButton("Nezuko", "rbxassetid://98285238714079")
createEffectButton("Gengar", "rbxassetid://124320703202272")
createEffectButton("Green Flame", "rbxassetid://125577376734114")
createEffectButton("Hello Kitty", "rbxassetid://133484432928988")
createEffectButton("Heart Minecraft", "rbxassetid://88121396536824")
createEffectButton("Skeleton Army", "rbxassetid://88014445293756")
createEffectButton("Pokemon", "rbxassetid://127357504054794")
createEffectButton("Pikachu", "rbxassetid://112770541700961")
createEffectButton("Pikachu Exe", "rbxassetid://85484998460643")
createEffectButton("Sharingan", "rbxassetid://119906553877197")
createEffectButton("Fire Skull", "rbxassetid://88821202537004")

local TexturesBox = Tabs.Textures:AddRightGroupbox("Textures", "image")

local fpsEnabled = false
local saved = {}

TexturesBox:AddToggle("FpsBoost", {
    Text = "FPS Boost",
    Default = false,

    Callback = function(Value)
        fpsEnabled = Value

        local Players = game:GetService("Players")
        local Lighting = game:GetService("Lighting")
        local Terrain = workspace:FindFirstChildOfClass("Terrain")

        if Value then
            saved.Quality = settings().Rendering.QualityLevel

            if Terrain then
                saved.Water = {
                    WaveSize = Terrain.WaterWaveSize,
                    WaveSpeed = Terrain.WaterWaveSpeed,
                    Reflectance = Terrain.WaterReflectance,
                    Transparency = Terrain.WaterTransparency
                }
            end

            saved.Parts = {}
            saved.Decals = {}
            saved.Effects = {}

            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("BasePart") then
                    saved.Parts[v] = {
                        Material = v.Material,
                        Reflectance = v.Reflectance
                    }
                    v.Material = Enum.Material.Plastic
                    v.Reflectance = 0
                end

                if v:IsA("Decal") or v:IsA("Texture") then
                    saved.Decals[v] = v.Transparency
                    v.Transparency = 1
                end

                if v:IsA("ParticleEmitter")
                or v:IsA("Trail")
                or v:IsA("Smoke")
                or v:IsA("Fire")
                or v:IsA("Sparkles") then
                    saved.Effects[v] = v.Enabled
                    v.Enabled = false
                end
            end

            for _, v in pairs(Lighting:GetDescendants()) do
                if v:IsA("PostEffect") then
                    saved.Effects[v] = v.Enabled
                    v.Enabled = false
                end
            end

            saved.ExplosionConnection = workspace.DescendantAdded:Connect(function(v)
                if v:IsA("Explosion") then
                    v.Visible = false
                end
            end)

            if Terrain then
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
                Terrain.WaterReflectance = 0
                Terrain.WaterTransparency = 1
            end

            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

            print("FPS Boost ON")

        else

            for v, data in pairs(saved.Parts or {}) do
                if v and v.Parent then
                    v.Material = data.Material
                    v.Reflectance = data.Reflectance
                end
            end

            for v, trans in pairs(saved.Decals or {}) do
                if v and v.Parent then
                    v.Transparency = trans
                end
            end

            for v, state in pairs(saved.Effects or {}) do
                if v and v.Parent then
                    v.Enabled = state
                end
            end

            if Terrain and saved.Water then
                Terrain.WaterWaveSize = saved.Water.WaveSize
                Terrain.WaterWaveSpeed = saved.Water.WaveSpeed
                Terrain.WaterReflectance = saved.Water.Reflectance
                Terrain.WaterTransparency = saved.Water.Transparency
            end

            settings().Rendering.QualityLevel = saved.Quality or Enum.QualityLevel.Automatic

            if saved.ExplosionConnection then
                saved.ExplosionConnection:Disconnect()
            end

            print("FPS Boost OFF (restaurado)")
        end
    end
})

local faces = {"Front", "Back", "Bottom", "Top", "Right", "Left"}

local materials = {
    Wood = "3258599312", WoodPlanks = "8676581022",
    Brick = "8558400252", Cobblestone = "5003953441",
    Concrete = "7341687607", DiamondPlate = "6849247561",
    Fabric = "118776397", Granite = "4722586771",
    Grass = "4722588177", Ice = "3823766459",
    Marble = "62967586", Metal = "62967586",
    Sand = "152572215"
}

local tamanhoDoBloco = 4 
local enabled = false

local originalData = {}
local connection

local function processPart(part)
    if part:IsA("BasePart") then
        local textureId = materials[part.Material.Name]

        if textureId then
            if not originalData[part] then
                originalData[part] = {
                    Material = part.Material
                }
            end

            for _, face in ipairs(faces) do
                local newTexture = Instance.new("Texture")
                newTexture.Name = "MinecraftTexture"
                newTexture.Texture = "rbxassetid://" .. textureId
                newTexture.Face = Enum.NormalId[face]
                newTexture.StudsPerTileU = tamanhoDoBloco
                newTexture.StudsPerTileV = tamanhoDoBloco
                newTexture.Color3 = part.Color
                newTexture.Transparency = part.Transparency
                newTexture.Parent = part
            end

            part.Material = Enum.Material.SmoothPlastic
        end
    end
end

local function restoreParts()
    for part, data in pairs(originalData) do
        if part and part.Parent then
            part.Material = data.Material

            for _, obj in ipairs(part:GetChildren()) do
                if obj:IsA("Texture") and obj.Name == "MinecraftTexture" then
                    obj:Destroy()
                end
            end
        end
    end

    originalData = {}
end

TexturesBox:AddToggle("Minecraft", {
    Text = "Minecraft",
    Default = false,
    Callback = function(state)
        enabled = state

        if enabled then
            for _, obj in ipairs(workspace:GetDescendants()) do
                processPart(obj)
            end

            connection = workspace.DescendantAdded:Connect(function(newObj)
                if enabled then
                    task.defer(function()
                        processPart(newObj)
                    end)
                end
            end)
        else
            if connection then
                connection:Disconnect()
                connection = nil
            end

            restoreParts()
        end
    end
})

local Players = game:GetService("Players")

local CINZA = Color3.fromRGB(160,160,160)

local enabled = false
local original = {}
local connections = {}

local function estaEmPastaIgnorada(obj)
    local current = obj
    while current do
        if current.Name == "PackedHammer"
        or current.Name == "PackedGemstone"
        or current.Name == "Hammer"
        or current.Name == "Gemstone" then
            return true
        end
        current = current.Parent
    end
    return false
end

local function salvar(character)
    if original[character] then return end

    local data = {}

    for _, obj in ipairs(character:GetDescendants()) do
        if obj:IsA("BasePart") then
            data[obj] = {
                Color = obj.Color,
                Material = obj.Material,
                Reflectance = obj.Reflectance
            }

        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            data[obj] = {Texture = obj.Texture}

        elseif obj:IsA("MeshPart") then
            data[obj] = {
                TextureID = obj.TextureID,
                Color = obj.Color,
                Material = obj.Material
            }

        elseif obj:IsA("SpecialMesh") then
            data[obj] = {
                TextureId = obj.TextureId,
                VertexColor = obj.VertexColor
            }

        elseif obj:IsA("Shirt") then
            data[obj] = {ShirtTemplate = obj.ShirtTemplate}

        elseif obj:IsA("Pants") then
            data[obj] = {PantsTemplate = obj.PantsTemplate}

        elseif obj:IsA("ShirtGraphic") then
            data[obj] = {Graphic = obj.Graphic}
        end
    end

    original[character] = data
end

local function aplicar(character)
    salvar(character)

    local data = original[character]
    if not data then return end

    for obj, _ in pairs(data) do
        if obj and obj.Parent and not estaEmPastaIgnorada(obj) then

            if obj:IsA("BasePart") then
                obj.Color = CINZA
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
            end

            if obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Texture = ""
            end

            if obj:IsA("MeshPart") then
                obj.TextureID = ""
                obj.Color = CINZA
                obj.Material = Enum.Material.SmoothPlastic
            end

            if obj:IsA("SpecialMesh") then
                obj.TextureId = ""
                obj.VertexColor = Vector3.new(0.63,0.63,0.63)
            end

            if obj:IsA("Shirt") then
                obj.ShirtTemplate = ""
            end

            if obj:IsA("Pants") then
                obj.PantsTemplate = ""
            end

            if obj:IsA("ShirtGraphic") then
                obj.Graphic = ""
            end
        end
    end
end

local function restaurar(character)
    local data = original[character]
    if not data then return end

    for obj, props in pairs(data) do
        if obj and obj.Parent then

            if obj:IsA("BasePart") then
                obj.Color = props.Color
                obj.Material = props.Material
                obj.Reflectance = props.Reflectance
            end

            if obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Texture = props.Texture or ""
            end

            if obj:IsA("MeshPart") then
                obj.TextureID = props.TextureID or ""
                obj.Color = props.Color
                obj.Material = props.Material
            end

            if obj:IsA("SpecialMesh") then
                obj.TextureId = props.TextureId or ""
                obj.VertexColor = props.VertexColor
            end

            if obj:IsA("Shirt") then
                obj.ShirtTemplate = props.ShirtTemplate or obj.ShirtTemplate
            end

            if obj:IsA("Pants") then
                obj.PantsTemplate = props.PantsTemplate or obj.PantsTemplate
            end

            if obj:IsA("ShirtGraphic") then
                obj.Graphic = props.Graphic or obj.Graphic
            end
        end
    end
end

local function onCharacter(char)
    if enabled then
        aplicar(char)
    end
end

local function start()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then
            onCharacter(plr.Character)
        end

        table.insert(connections,
            plr.CharacterAdded:Connect(onCharacter)
        )
    end

    table.insert(connections,
        Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(onCharacter)
        end)
    )
end

local function stop()
    for char, _ in pairs(original) do
        restaurar(char)
    end

    table.clear(original)

    for _, c in ipairs(connections) do
        c:Disconnect()
    end
    table.clear(connections)
end

TexturesBox:AddToggle("RemoveSkin", {
    Text = "Remove Skin",
    Default = false,

    Callback = function(state)
        enabled = state

        if state then
            start()
        else
            stop()
        end
    end
})

local CloudBox = Tabs.Cloud:AddLeftGroupbox("Flashlight", "flashlight")

local Brightness2 = 1

CloudBox:AddToggle("Flashlight", {
	Text = "Enable",
	Default = false,

	Callback = function(Value)
		local Players = game:GetService("Players")
		local LocalPlayer = Players.LocalPlayer

		local char = LocalPlayer.Character
		if not char then return end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		if Value then
			local old = hrp:FindFirstChild("Light")
			if old then
				old:Destroy()
			end

			local light = Instance.new("PointLight")
			light.Name = "Light"
			light.Range = 120
			light.Shadows = false
			light.Brightness = Brightness2
			light.Parent = hrp
		else
			local old = hrp:FindFirstChild("Light")
			if old then
				old:Destroy()
			end
		end
	end,
})

CloudBox:AddSlider("Brightness2", {
	Text = "Brightness",
	Default = 1,
	Min = 0,
	Max = 1,
	Rounding = 2,

	Callback = function(Value)
		Brightness2 = Value

		local Players = game:GetService("Players")
		local LocalPlayer = Players.LocalPlayer

		local char = LocalPlayer.Character
		if not char then return end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		local light = hrp:FindFirstChild("Light")
		if light then
			light.Brightness = Value
		end
	end,
})

local CloudBox = Tabs.Cloud:AddLeftGroupbox("Calibrator", "monitor")

local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local FILE_NAME = "ColorCalibration.json"

local defaultData = {
    Enabled = false,
    Color = {255, 255, 255},
    Brightness = 0,
    Contrast = 0,
    Saturation = 0
}

local function canUseFile()
    return writefile and readfile and isfile
end

local function loadData()
    if canUseFile() and isfile(FILE_NAME) then
        local success, loaded = pcall(function()
            return HttpService:JSONDecode(readfile(FILE_NAME))
        end)

        if success and typeof(loaded) == "table" then
            loaded.Enabled = loaded.Enabled or false
            loaded.Color = loaded.Color or table.clone(defaultData.Color)

            if loaded.Brightness == nil then
                loaded.Brightness = defaultData.Brightness
            end

            if loaded.Contrast == nil then
                loaded.Contrast = defaultData.Contrast
            end

            if loaded.Saturation == nil then
                loaded.Saturation = defaultData.Saturation
            end

            return loaded
        end
    end

    return table.clone(defaultData)
end

local lastSavedJSON = ""

local function saveData(data)
    if not canUseFile() then
        return
    end

    local success, newJSON = pcall(function()
        return HttpService:JSONEncode(data)
    end)

    if not success then
        return
    end

    if newJSON == lastSavedJSON then
        return
    end

    lastSavedJSON = newJSON

    pcall(function()
        writefile(FILE_NAME, newJSON)
    end)
end

local data = loadData()
lastSavedJSON = HttpService:JSONEncode(data)

local filtro

local function destroyFilter()
    if filtro then
        filtro:Destroy()
        filtro = nil
    end

    local old = Lighting:FindFirstChild("FiltroBranco")

    if old then
        old:Destroy()
    end
end

local function getFilter()
    if not filtro or not filtro.Parent then
        filtro = Lighting:FindFirstChild("FiltroBranco")

        if not filtro then
            filtro = Instance.new("ColorCorrectionEffect")
            filtro.Name = "FiltroBranco"
            filtro.Parent = Lighting
        end
    end

    return filtro
end

local function applyFilter()
    if not data.Enabled then
        destroyFilter()
        return
    end

    local filtro = getFilter()

    filtro.TintColor = Color3.fromRGB(
        data.Color[1],
        data.Color[2],
        data.Color[3]
    )

    filtro.Brightness = data.Brightness
    filtro.Contrast = data.Contrast
    filtro.Saturation = data.Saturation
end

destroyFilter()

CloudBox:AddToggle("Calibrator", {
    Text = "Enable",
    Default = data.Enabled,

    Callback = function(state)
        data.Enabled = state

        if state then
            applyFilter()
        else
            destroyFilter()
        end

        saveData(data)
    end,
})

CloudBox:AddButton({
    Text = "Reset all",

    Func = function()
        data = table.clone(defaultData)

        if data.Enabled then
            applyFilter()
        else
            destroyFilter()
        end

        saveData(data)
    end,
})

CloudBox:AddLabel("Color"):AddColorPicker("ColorPicker", {
    Default = Color3.fromRGB(
        data.Color[1],
        data.Color[2],
        data.Color[3]
    ),

    Title = "Color",

    Callback = function(Value)
        data.Color = {
            math.clamp(math.round(Value.R * 255), 0, 255),
            math.clamp(math.round(Value.G * 255), 0, 255),
            math.clamp(math.round(Value.B * 255), 0, 255)
        }

        if data.Enabled then
            applyFilter()
        end

        saveData(data)
    end,
})

CloudBox:AddSlider("Brightness", {
    Text = "Brightness",
    Default = data.Brightness,
    Min = -1,
    Max = 1,
    Rounding = 2,

    Callback = function(Value)
        data.Brightness = Value

        if data.Enabled then
            applyFilter()
        end

        saveData(data)
    end,
})

CloudBox:AddSlider("Contrast", {
    Text = "Contrast",
    Default = data.Contrast,
    Min = -1,
    Max = 1,
    Rounding = 2,

    Callback = function(Value)
        data.Contrast = Value

        if data.Enabled then
            applyFilter()
        end

        saveData(data)
    end,
})

CloudBox:AddSlider("Saturation", {
    Text = "Saturation",
    Default = data.Saturation,
    Min = -1,
    Max = 1,
    Rounding = 2,

    Callback = function(Value)
        data.Saturation = Value

        if data.Enabled then
            applyFilter()
        end

        saveData(data)
    end,
})

if data.Enabled then
    applyFilter()
end

local CloudBox = Tabs.Cloud:AddRightGroupbox("Cloud", "cloud")

CloudBox:AddLabel("Delay in 15 seconds.")

CloudBox:AddButton({
    Text = "Black Fog",
    Func = function()
        task.wait(15)
        local lighting = game:GetService("Lighting")
        local atmosphere = lighting:FindFirstChildOfClass("Atmosphere")
        local sky = lighting:FindFirstChildOfClass("Sky")

        local isAirport = workspace:FindFirstChild("Airport by deadlybones28")
        local isFacility = workspace:FindFirstChild("Facility_0 by MrWindy")

        if atmosphere then
            if atmosphere.Color ~= Color3.fromRGB(0,0,0) then
                atmosphere.Color = Color3.fromRGB(0,0,0)
            end
        end

        if atmosphere and isAirport then
            if atmosphere.Glare ~= 1.64 then
                atmosphere.Glare = 1.64
            end
            if atmosphere.Decay ~= Color3.fromRGB(255,255,255) then
                atmosphere.Decay = Color3.fromRGB(255,255,255)
            end
            if atmosphere.Density ~= 0.9 then
                atmosphere.Density = 0.9
            end
        end

        if atmosphere and not isAirport then
            if atmosphere.Glare ~= 0 then
                atmosphere.Glare = 0
            end
            if atmosphere.Decay ~= Color3.fromRGB(0,0,0) then
                atmosphere.Decay = Color3.fromRGB(0,0,0)
            end
        end

        if atmosphere then
            if atmosphere.Haze ~= 2.46 then
                atmosphere.Haze = 2.46
            end
            if atmosphere.Offset ~= 0 then
                atmosphere.Offset = 0
            end
        end

        if atmosphere and isFacility then
            if atmosphere.Density ~= 0.85 then
                atmosphere.Density = 0.85
            end
        end

        if atmosphere and not isFacility and not isAirport then
            if atmosphere.Density ~= 0.76 then
                atmosphere.Density = 0.76
            end
        end

        if sky then
            if sky.MoonAngularSize ~= 10 then
                sky.MoonAngularSize = 10
            end
        end

        if sky then
            if sky.StarCount ~= 0 then
                sky.StarCount = 0
            end
        end
    end
})

CloudBox:AddButton({
    Text = "Remove Fog",
    Func = function()
        task.wait(15)
        local lighting = game:GetService("Lighting")
        local atmosphere = lighting:FindFirstChildOfClass("Atmosphere")
        local sky = lighting:FindFirstChildOfClass("Sky")

        if atmosphere then
            if atmosphere.Color ~= Color3.fromRGB(0,0,0) then
                atmosphere.Color = Color3.fromRGB(0,0,0)
            end
        end

        if atmosphere then
            if atmosphere.Glare ~= 0 then
                atmosphere.Glare = 0
            end
        end

        if atmosphere then
            if atmosphere.Haze ~= 2.46 then
                atmosphere.Haze = 2.46
            end
        end

        if atmosphere then
            if atmosphere.Decay ~= Color3.fromRGB(0,0,0) then
                atmosphere.Decay = Color3.fromRGB(0,0,0)
            end
        end

        if atmosphere then
            if atmosphere.Density ~= 0 then
                atmosphere.Density = 0
            end
        end

        if atmosphere then
            if atmosphere.Offset ~= 0 then
                atmosphere.Offset = 0
            end
        end

        if sky then
            if sky.MoonAngularSize ~= 10 then
                sky.MoonAngularSize = 10
            end
        end

        if sky then
            if sky.StarCount ~= 0 then
                sky.StarCount = 0
            end
        end
    end
})

local CloudBox = Tabs.Cloud:AddRightGroupbox("Shadow Settings", "leaf")

CloudBox:AddButton("Enable Shadows", {
	Text = "Enable Shadows",
	Callback = function()
		local Lighting = game:GetService("Lighting")
		Lighting.GlobalShadows = true
	end
})

CloudBox:AddButton("Disable Shadows", {
	Text = "Disable Shadows",
	Callback = function()
		local Lighting = game:GetService("Lighting")
		Lighting.GlobalShadows = false
	end
})

local CrossHairBox = Tabs.CrossHair:AddLeftGroupbox("Cursor Settings", "mouse-pointer-2")

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local State = {
    TouchMode = false,
    Crosshair = nil,
    Touches = {},
    Connections = {},
    Size = 30
}

local function clearConnections()
    for _, c in pairs(State.Connections) do
        if c then c:Disconnect() end
    end
    State.Connections = {}
end

local function getFixedPosition(pos)
    local inset = GuiService:GetGuiInset()
    return Vector2.new(pos.X, pos.Y + inset.Y)
end

local function createTouchCrosshair(base)
    local clone = base:Clone()
    clone.Parent = base.Parent
    clone.Visible = true
    clone.AnchorPoint = Vector2.new(0.5, 0.5)
    clone.Size = UDim2.new(0, State.Size, 0, State.Size)
    return clone
end

local function detectCrosshair(gui)
    for _, v in ipairs(gui:GetDescendants()) do
        if v:IsA("ImageLabel") and v.Image ~= "" then
            State.Crosshair = v
            v.Size = UDim2.new(0, State.Size, 0, State.Size)

            if State.TouchMode then
                v.Visible = false
            else
                v.Visible = true
                v.Position = UDim2.new(0.5, 0, 0.5, 0)
            end
            break
        end
    end
end

playerGui.ChildAdded:Connect(function(child)
    if child:IsA("ScreenGui") then
        task.wait(0.1)
        detectCrosshair(child)
    end
end)

local function startTouchSystem()
    clearConnections()

    table.insert(State.Connections,
        UIS.TouchStarted:Connect(function(input)
            if not State.TouchMode or not State.Crosshair then return end

            local clone = createTouchCrosshair(State.Crosshair)
            State.Touches[input] = clone

            local pos = getFixedPosition(input.Position)
            clone.Position = UDim2.fromOffset(pos.X, pos.Y)
        end)
    )

    table.insert(State.Connections,
        UIS.TouchMoved:Connect(function(input)
            if not State.TouchMode then return end

            local cross = State.Touches[input]
            if cross then
                local pos = getFixedPosition(input.Position)
                cross.Position = UDim2.fromOffset(pos.X, pos.Y)
            end
        end)
    )

    table.insert(State.Connections,
        UIS.TouchEnded:Connect(function(input)
            if State.Touches[input] then
                State.Touches[input]:Destroy()
                State.Touches[input] = nil
            end
        end)
    )
end

startTouchSystem()

CrossHairBox:AddToggle("TouchMode", {
    Text = "Shows all touchscreen",
    Default = false,

    Callback = function(value)
        State.TouchMode = value

        if value then
            if State.Crosshair then
                State.Crosshair.Visible = false
            end
        else
            for _, v in pairs(State.Touches) do
                if v then v:Destroy() end
            end
            State.Touches = {}

            if State.Crosshair then
                State.Crosshair.Visible = true
                State.Crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
            end
        end
    end
})

CrossHairBox:AddSlider("CrosshairSize", {
    Text = "Crosshair Size",
    Default = 30,
    Min = 10,
    Max = 80,
    Rounding = 0,

    Callback = function(value)
        State.Size = value

        if State.Crosshair then
            State.Crosshair.Size = UDim2.new(0, value, 0, value)
        end
    end
})

CrossHairBox:AddButton("Default", {
    Text = "Default",
    
    Callback = function()
        for _, v in ipairs(playerGui:GetChildren()) do
            if v:IsA("ScreenGui") then
                if v.Name:lower():find("crosshair")
                or v.Name:lower():find("cursor")
                or v.Name == "CustomCursorGui" then
                    v:Destroy()
                end
            end
        end

        UIS.MouseIconEnabled = true
        State.Crosshair = nil
        State.Size = 30

        if Options and Options.CrosshairSize then
            Options.CrosshairSize:SetValue(30)
        end

        print("Resetado!")
    end
})

local CrossHairBox = Tabs.CrossHair:AddLeftGroupbox("Facility Gamer", "cross")

CrossHairBox:AddButton("ArrowFarWhite V1", {
    Text = "Arrow Far White V1",

    Callback = function()
        local old = playerGui:FindFirstChild("CustomCursorGui")
        if old then old:Destroy() end

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "CustomCursorGui"
        screenGui.IgnoreGuiInset = true
        screenGui.Parent = playerGui

        local cursorImage = Instance.new("ImageLabel")
        cursorImage.Size = UDim2.new(0, 20, 0, 20)
        cursorImage.BackgroundTransparency = 1
        cursorImage.Image = "rbxassetid://2614612882"
        cursorImage.AnchorPoint = Vector2.new(0.5, 0.5)
        cursorImage.Position = UDim2.new(0.5, 0, 0.5, 0)
        cursorImage.Parent = screenGui

        UIS.MouseIconEnabled = false

        print("Cursor carregado!")
    end
})

CrossHairBox:AddButton("ArrowFar", {
    Text = "ArrowFar Green",
    Callback = function()
        local player = game.Players.LocalPlayer

        local old = player:FindFirstChild("PlayerGui"):FindFirstChild("CrosshairGui")
        if old then
            old:Destroy()
        end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = player:WaitForChild("PlayerGui")

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 32, 0, 32)
        crosshair.BackgroundTransparency = 1
        crosshair.Image = "rbxassetid://127864951260720"
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Parent = gui

        local function updateCenter()
            local camera = workspace.CurrentCamera
            local viewport = camera.ViewportSize
            crosshair.Position = UDim2.new(0, viewport.X / 2, 0, viewport.Y / 2)
        end

        updateCenter()
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateCenter)
    end
})

CrossHairBox:AddButton("ArrowFarPurple", {
    Text = "ArrowFar Purple",
    Callback = function()
        local player = game.Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")

        local old = pg:FindFirstChild("CrosshairGui")
        if old then old:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 32, 0, 32)
        crosshair.BackgroundTransparency = 1
        crosshair.Image = "rbxassetid://78294835549441"
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        crosshair.Parent = gui
    end
})

CrossHairBox:AddButton("CursorWhite", {
    Text = "Cursor White",

    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")

        local old = pg:FindFirstChild("CrosshairGui")
        if old then old:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 40, 0, 40)
        crosshair.BackgroundTransparency = 1
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        crosshair.Parent = gui

        pcall(function()
            crosshair.Image = "rbxassetid://78187737793256"
        end)
    end
})

local CrossHairBox = Tabs.CrossHair:AddRightGroupbox("LuanFq", "layers")

CrossHairBox:AddButton("L", {
    Text = "L",

    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")

        local old = pg:FindFirstChild("CrosshairGui")
        if old then old:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 20, 0, 20)
        crosshair.BackgroundTransparency = 1
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        crosshair.Parent = gui

        pcall(function()
            crosshair.Image = "rbxassetid://82887870034056"
        end)
    end
})

CrossHairBox:AddButton("Pomni", {
    Text = "Pomni",

    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")

        local old = pg:FindFirstChild("CrosshairGui")
        if old then old:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 30, 0, 30)
        crosshair.BackgroundTransparency = 1
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        crosshair.Parent = gui

        pcall(function()
            crosshair.Image = "rbxassetid://111669428109199"
        end)
    end
})

CrossHairBox:AddButton("Karambit", {
    Text = "Karambit",

    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")

        local old = pg:FindFirstChild("CrosshairGui")
        if old then old:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 40, 0, 40)
        crosshair.BackgroundTransparency = 1
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        crosshair.Parent = gui

        pcall(function()
            crosshair.Image = "rbxassetid://134671002501092"
        end)
    end
})

CrossHairBox:AddButton("ButtonRed", {
    Text = "Button Red",

    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")

        local old = pg:FindFirstChild("CrosshairGui")
        if old then old:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 10, 0, 10)
        crosshair.BackgroundTransparency = 1
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        crosshair.Parent = gui

        pcall(function()
            crosshair.Image = "rbxassetid://88338831467302"
        end)
    end
})

CrossHairBox:AddButton("ButtonRose", {
    Text = "Button Rose",

    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")

        local old = pg:FindFirstChild("CrosshairGui")
        if old then old:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 20, 0, 20)
        crosshair.BackgroundTransparency = 1
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        crosshair.Parent = gui

        pcall(function()
            crosshair.Image = "rbxassetid://107141720811781"
        end)
    end
})

CrossHairBox:AddButton("ButtonViolet", {
    Text = "Button Violet",

    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")

        local old = pg:FindFirstChild("CrosshairGui")
        if old then old:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 20, 0, 20)
        crosshair.BackgroundTransparency = 1
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        crosshair.Parent = gui

        pcall(function()
            crosshair.Image = "rbxassetid://123251498254248"
        end)
    end
})

CrossHairBox:AddButton("ButtonCyan", {
    Text = "Button Cyan",

    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")

        local old = pg:FindFirstChild("CrosshairGui")
        if old then old:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 20, 0, 20)
        crosshair.BackgroundTransparency = 1
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        crosshair.Parent = gui

        pcall(function()
            crosshair.Image = "rbxassetid://98472165787527"
        end)
    end
})

CrossHairBox:AddButton("ButtonYellow", {
    Text = "Button Yellow",

    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")

        local old = pg:FindFirstChild("CrosshairGui")
        if old then old:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 20, 0, 20)
        crosshair.BackgroundTransparency = 1
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        crosshair.Parent = gui

        pcall(function()
            crosshair.Image = "rbxassetid://124717991062973"
        end)
    end
})

CrossHairBox:AddButton("ButtonBlue", {
    Text = "Button Blue",

    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")

        local old = pg:FindFirstChild("CrosshairGui")
        if old then old:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 20, 0, 20)
        crosshair.BackgroundTransparency = 1
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        crosshair.Parent = gui

        pcall(function()
            crosshair.Image = "rbxassetid://79131555594807"
        end)
    end
})

local CrossHairBox = Tabs.CrossHair:AddRightGroupbox("Sword Minecraft", "sword")

CrossHairBox:AddButton("SwordDiamond", {
    Text = "Sword Diamond",

    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")

        local old = pg:FindFirstChild("CrosshairGui")
        if old then old:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 20, 0, 20)
        crosshair.BackgroundTransparency = 1
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        crosshair.Parent = gui

        pcall(function()
            crosshair.Image = "rbxassetid://128172876968221"
        end)
    end
})

CrossHairBox:AddButton("SwordYellow", {
    Text = "Sword Yellow",

    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")

        local old = pg:FindFirstChild("CrosshairGui")
        if old then old:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 20, 0, 20)
        crosshair.BackgroundTransparency = 1
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        crosshair.Parent = gui

        pcall(function()
            crosshair.Image = "rbxassetid://108999407533236"
        end)
    end
})

CrossHairBox:AddButton("SwordNetherite", {
    Text = "Sword Netherite",

    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")

        local old = pg:FindFirstChild("CrosshairGui")
        if old then old:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 20, 0, 20)
        crosshair.BackgroundTransparency = 1
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        crosshair.Parent = gui

        pcall(function()
            crosshair.Image = "rbxassetid://133609476736972"
        end)
    end
})

CrossHairBox:AddButton("SwordEsmerald", {
    Text = "Sword Esmerald",

    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")

        local old = pg:FindFirstChild("CrosshairGui")
        if old then old:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 20, 0, 20)
        crosshair.BackgroundTransparency = 1
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        crosshair.Parent = gui

        pcall(function()
            crosshair.Image = "rbxassetid://73733909030062"
        end)
    end
})

CrossHairBox:AddButton("SwordRose", {
    Text = "Sword Rose",

    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")

        local old = pg:FindFirstChild("CrosshairGui")
        if old then old:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 20, 0, 20)
        crosshair.BackgroundTransparency = 1
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        crosshair.Parent = gui

        pcall(function()
            crosshair.Image = "rbxassetid://94442637068173"
        end)
    end
})

local CrossHairBox = Tabs.CrossHair:AddLeftGroupbox("Demon Slayer", "swords")

CrossHairBox:AddButton("Tanjiro", {
    Text = "Tanjiro",

    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")

        local old = pg:FindFirstChild("CrosshairGui")
        if old then old:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 40, 0, 40)
        crosshair.BackgroundTransparency = 1
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        crosshair.Parent = gui

        pcall(function()
            crosshair.Image = "rbxassetid://85372624608084"
        end)
    end
})

CrossHairBox:AddButton("TanjiroEarrings", {
    Text = "Tanjiro Earrings",

    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")

        local old = pg:FindFirstChild("CrosshairGui")
        if old then old:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 30, 0, 30)
        crosshair.BackgroundTransparency = 1
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        crosshair.Parent = gui

        pcall(function()
            crosshair.Image = "rbxassetid://129016541533877"
        end)
    end
})

CrossHairBox:AddButton("Nezuko", {
    Text = "Nezuko",

    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")

        local old = pg:FindFirstChild("CrosshairGui")
        if old then old:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 40, 0, 40)
        crosshair.BackgroundTransparency = 1
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        crosshair.Parent = gui

        pcall(function()
            crosshair.Image = "rbxassetid://98285238714079"
        end)
    end
})

CrossHairBox:AddButton("NezukoBamboo", {
    Text = "Nezuko Bamboo",

    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")

        local old = pg:FindFirstChild("CrosshairGui")
        if old then old:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 30, 0, 30)
        crosshair.BackgroundTransparency = 1
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        crosshair.Parent = gui

        pcall(function()
            crosshair.Image = "rbxassetid://103861126846931"
        end)
    end
})

CrossHairBox:AddButton("Inosuke", {
    Text = "Inosuke",

    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")

        local old = pg:FindFirstChild("CrosshairGui")
        if old then old:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 40, 0, 40)
        crosshair.BackgroundTransparency = 1
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        crosshair.Parent = gui

        pcall(function()
            crosshair.Image = "rbxassetid://97417889091578"
        end)
    end
})

CrossHairBox:AddButton("InosukeKatana", {
    Text = "Inosuke Katana",

    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local pg = player:WaitForChild("PlayerGui")

        local old = pg:FindFirstChild("CrosshairGui")
        if old then old:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "CrosshairGui"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 30, 0, 30)
        crosshair.BackgroundTransparency = 1
        crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
        crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
        crosshair.Parent = gui

        pcall(function()
            crosshair.Image = "rbxassetid://85605196873114"
        end)
    end
})

local SoundBox = Tabs.Sound:AddLeftGroupbox("Settings", "cog")

local Players = game:GetService("Players")

local FootstepVolume = 1
local JumpVolume = 1
local FallVolume = 1

local function GetType(name)
    name = name:lower()

    if name:find("run") or name:find("walk") or name:find("step") or name:find("foot") then
        return "Footsteps"
    end

    if name:find("jump") then
        return "Jump"
    end

    if name:find("fall") or name:find("freefall") then
        return "Fall"
    end

    return nil
end

local function Apply(sound)
    if not sound:IsA("Sound") then return end

    local t = GetType(sound.Name)
    if not t then return end

    if t == "Footsteps" then
        sound.Volume = FootstepVolume
    elseif t == "Jump" then
        sound.Volume = JumpVolume
    elseif t == "Fall" then
        sound.Volume = FallVolume
    end
end

task.spawn(function()
    while task.wait(1) do
        for _, plr in ipairs(Players:GetPlayers()) do
            local char = plr.Character
            if char then
                for _, obj in ipairs(char:GetDescendants()) do
                    Apply(obj)
                end
            end
        end
    end
end)

SoundBox:AddSlider("FootstepVolumeSlider", {
    Text = "FootSteps Volume",
    Default = 1,
    Min = 0,
    Max = 10,
    Rounding = 1,

    Callback = function(value)
        FootstepVolume = value
        ApplyAllVolumes()
    end
})

SoundBox:AddSlider("JumpVolumeSlider", {
    Text = "Jump Volume",
    Default = 1,
    Min = 0,
    Max = 10,
    Rounding = 1,

    Callback = function(value)
        JumpVolume = value
        ApplyAllVolumes()
    end
})

SoundBox:AddSlider("FallVolumeSlider", {
    Text = "Fall Volume",
    Default = 1,
    Min = 0,
    Max = 10,
    Rounding = 1,

    Callback = function(value)
        FallVolume = value
        ApplyAllVolumes()
    end
})

SoundBox:AddButton({
    Text = "Reset Volumes",
    Func = function()
        FootstepVolume = 1
        JumpVolume = 1
        FallVolume = 1

        Library.Options["FootstepVolumeSlider"]:SetValue(1)
        Library.Options["JumpVolumeSlider"]:SetValue(1)
        Library.Options["FallVolumeSlider"]:SetValue(1)

        ApplyAllVolumes()
    end
})

task.defer(function()
    task.wait(2)
    ApplyAllVolumes()
end)

local function ApplySound(soundType, soundId)
    for _, plr in pairs(Players:GetPlayers()) do
        local character = plr.Character

        if character then
            for _, obj in pairs(character:GetDescendants()) do
                if obj:IsA("Sound") then
                    local name = obj.Name:lower()

                    if soundType == "Footsteps" then
                        if string.find(name, "run")
                        or string.find(name, "walk")
                        or string.find(name, "step") then
                            obj.SoundId = "rbxassetid://" .. soundId
                            obj.Volume = FootstepVolume
                        end
                    end
                    
                    if soundType == "Jump" then
                        if string.find(name, "jump") then
                            obj.SoundId = "rbxassetid://" .. soundId
                            obj.Volume = JumpVolume
                        end
                    end

                    if soundType == "Fall" then
                        if string.find(name, "fall") then
                            obj.SoundId = "rbxassetid://" .. soundId
                            obj.Volume = FallVolume
                        end
                    end
                end
            end
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(2)
        UpdateVolumes()
    end)
end)

for _, plr in pairs(Players:GetPlayers()) do
    plr.CharacterAdded:Connect(function()
        task.wait(2)
        UpdateVolumes()
    end)
end

SoundBox:AddButton({
    Text = "Reset Sounds",
    Func = function()
        ApplySound("Footsteps", "79392671800290")
        ApplySound("Jump", "80853972291847")
        ApplySound("Fall", "88947883822456")
    end
})

local NormalBox = Tabs.Sound:AddLeftGroupbox("Normal", "user")

NormalBox:AddButton({
    Text = "FootSteps",
    Func = function()
        ApplySound("Footsteps", "79392671800290")
    end
})

NormalBox:AddButton({
    Text = "Jump",
    Func = function()
        ApplySound("Jump", "80853972291847")
    end
})

NormalBox:AddButton({
    Text = "Fall",
    Func = function()
        ApplySound("Fall", "88947883822456")
    end
})

local FacilityBox = Tabs.Sound:AddRightGroupbox("Facility Gamer", "chef-hat")

FacilityBox:AddButton({
    Text = "FootSteps",
    Func = function()
        ApplySound("Footsteps", "131592620665625")
    end
})

FacilityBox:AddButton({
    Text = "Jump",
    Func = function()
        ApplySound("Jump", "89459688918065")
    end
})

local NoobBox = Tabs.Sound:AddRightGroupbox("NoobTwoPointOh", "bot")

NoobBox:AddButton({
    Text = "FootSteps",
    Func = function()
        ApplySound("Footsteps", "110709356093026")
    end
})

NoobBox:AddButton({
    Text = "Jump",
    Func = function()
        ApplySound("Jump", "124276657634407")
    end
})

local MorcegoBox = Tabs.Sound:AddLeftGroupbox("Tio Morcego", "moon")

MorcegoBox:AddButton({
    Text = "FootSteps",
    Func = function()
        ApplySound("Footsteps", "97458293386939")
    end
})

MorcegoBox:AddButton({
    Text = "Jump",
    Func = function()
        ApplySound("Jump", "72503238596964")
    end
})

MorcegoBox:AddButton({
    Text = "Fall",
    Func = function()
        ApplySound("Fall", "83702883984130")
    end
})

local FKPSBox = Tabs.Sound:AddRightGroupbox("FKPS", "skull")

FKPSBox:AddButton({
    Text = "FootSteps",
    Func = function()
        ApplySound("Footsteps", "97733831736820")
    end
})

FKPSBox:AddButton({
    Text = "Jump",
    Func = function()
        ApplySound("Jump", "86031664547378")
    end
})

FKPSBox:AddButton({
    Text = "Fall",
    Func = function()
        ApplySound("Fall", "78180192109919")
    end
})

local ExtrasBox = Tabs.Sound:AddLeftGroupbox("Extras", "boxes")

ExtrasBox:AddButton({
    Text = "Pew Jump",
    Func = function()
        ApplySound("Jump", "136299701781122")
    end
})

ExtrasBox:AddButton({
    Text = "Sharingan Jump",
    Func = function()
        ApplySound("Jump", "118102230060662")
    end
})

ExtrasBox:AddButton({
    Text = "Bubble Jump",
    Func = function()
        ApplySound("Jump", "129415490412106")
    end
})

ExtrasBox:AddButton({
    Text = "RF Jump",
    Func = function()
        ApplySound("Jump", "80276851298640")
    end
})

task.wait(2)
UpdateVolumes()

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

ThemeManager:SetFolder("ObsidianHub")
SaveManager:SetFolder("ObsidianHub/configs")

SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])

Library:Notify("Added new script Sensitivity & All sounds, new scripts soon!")
