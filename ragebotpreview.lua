local repS = cloneref(game:GetService("ReplicatedStorage"))
local plrs = cloneref(game:GetService("Players"))
local runS = cloneref(game:GetService("RunService"))
local ws = cloneref(game:GetService("Workspace"))
local uis = cloneref(game:GetService("UserInputService"))
local TweenService = cloneref(game:GetService("TweenService"))

local lplr = plrs.LocalPlayer
local playerGui = lplr:WaitForChild("PlayerGui")

local util = require(repS.Modules.Utility)
local enum = require(repS.Modules.EnumLibrary)
local FighterController = require(lplr.PlayerScripts.Controllers.FighterController)
local SpectateController = require(lplr.PlayerScripts.Controllers:WaitForChild("SpectateController"))

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Notifiactions"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999999999
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local container = Instance.new("Frame")
container.Name = "Notifiaction"
container.Size = UDim2.new(0, 320, 0, 500)
container.Position = UDim2.new(0.5, 0, 0.95, 0)
container.AnchorPoint = Vector2.new(0.5, 1)
container.BackgroundTransparency = 1
container.Parent = screenGui

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = container

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "RagebotStatus"
statusLabel.Size = UDim2.new(0, 400, 0, 20)
statusLabel.AnchorPoint = Vector2.new(0.5, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextSize = 14
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.Text = "ragebot: off"
statusLabel.Parent = screenGui

local statusStroke = Instance.new("UIStroke")
statusStroke.Color = Color3.fromRGB(0, 0, 0)
statusStroke.Thickness = 1
statusStroke.Parent = statusLabel

local function createNotif(titleText, bodyText, duration)
    duration = duration or 2

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 48)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(35, 35, 35)
    stroke.Thickness = 1
    stroke.Transparency = 0.7
    stroke.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 18)
    title.Position = UDim2.new(0, 10, 0, 4)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.SourceSansBold
    title.Text = titleText
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextTransparency = 1
    title.Parent = frame

    local body = Instance.new("TextLabel")
    body.Size = UDim2.new(1, -20, 0, 16)
    body.Position = UDim2.new(0, 10, 0, 22)
    body.BackgroundTransparency = 1
    body.Font = Enum.Font.SourceSans
    body.Text = bodyText
    body.TextColor3 = Color3.fromRGB(180, 180, 190)
    body.TextSize = 13
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.TextTransparency = 1
    body.Parent = frame

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 0, 2)
    progressBar.Position = UDim2.new(0, 0, 1, -2)
    progressBar.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
    progressBar.BorderSizePixel = 0
    progressBar.BackgroundTransparency = 1
    progressBar.Parent = frame

    local fadeInInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(frame, fadeInInfo, {BackgroundTransparency = 0.2}):Play()
    TweenService:Create(stroke, fadeInInfo, {Transparency = 0}):Play()
    TweenService:Create(title, fadeInInfo, {TextTransparency = 0}):Play()
    TweenService:Create(body, fadeInInfo, {TextTransparency = 0}):Play()
    TweenService:Create(progressBar, fadeInInfo, {BackgroundTransparency = 0.25}):Play()

    local progressTweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    TweenService:Create(progressBar, progressTweenInfo, {Size = UDim2.new(0, 0, 0, 2)}):Play()

    task.delay(duration, function()
        local fadeOutInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local fadeTween = TweenService:Create(frame, fadeOutInfo, {BackgroundTransparency = 1})
        
        TweenService:Create(stroke, fadeOutInfo, {Transparency = 1}):Play()
        TweenService:Create(title, fadeOutInfo, {TextTransparency = 1}):Play()
        TweenService:Create(body, fadeOutInfo, {TextTransparency = 1}):Play()
        TweenService:Create(progressBar, fadeOutInfo, {BackgroundTransparency = 1}):Play()

        fadeTween:Play()
        fadeTween.Completed:Connect(function()
            frame:Destroy()
        end)
    end)
end

getgenv().Config = {
    Enabled = true,
    WeaponSlot = "Primary",
    
    EnableVoidhide = false,      
    AttackDuration = 0.2,         
    VoidDuration = 0.44,           
    
    CustomOffsetMode = "None",
    Underground = false,        

    EnablePrediction = false,    
    PredictionFactor = 0.035,   
    
    EnableNotifications = true,
    NotifDuration = 1.25
}

local slots = {
    Primary = 1,
    Secondary = 2,
    Melee = 3
}

local function getSlotNumber()
    return slots[getgenv().Config.WeaponSlot] or 3
end

task.spawn(function()
    local localFighter = FighterController.LocalFighter
    while not localFighter do
        task.wait(0.1)
        localFighter = FighterController.LocalFighter
    end
    pcall(function()
        localFighter:EquipItem(getSlotNumber())
    end)
end)

task.spawn(function()
    while true do
        task.wait(0.01)
        if not getgenv().Config.Enabled then continue end
        local localFighter = FighterController.LocalFighter
        if localFighter then
            pcall(function()
                localFighter:EquipItem(getSlotNumber())
            end)
        end
    end
end)

local function getLocalTeam()
    local duel = SpectateController.CurrentDuelSubject
    local localDueler = duel and duel:GetDueler(lplr)
    local localTeam = localDueler and localDueler:Get("TeamID") or nil
    if localTeam ~= nil then
        return localTeam
    end
    return lplr:GetAttribute("TeamID")
end

local function isEnemy(player)
    if player == lplr then return false end
    local localTeam = getLocalTeam()
    local duel = SpectateController.CurrentDuelSubject
    if localTeam and duel and duel.Duelers then
        for _, dueler in duel.Duelers do
            if dueler.Player == player then
                local team = dueler:Get("TeamID")
                return team ~= localTeam
            end
        end
    end
    local pTeam = player:GetAttribute("TeamID")
    if pTeam and localTeam then
        return pTeam ~= localTeam
    end
    return true
end

local activeListeners = {}

local function listenToHumanoid(player, humanoid)
    if activeListeners[player] then
        activeListeners[player]:Disconnect()
    end

    local lastHealth = humanoid.Health

    activeListeners[player] = humanoid.HealthChanged:Connect(function(newHealth)
        if getgenv().Config.EnableNotifications and getgenv().Config.Enabled then
            if newHealth < lastHealth then
                local damageDealt = math.floor((lastHealth - newHealth) + 0.5)
                if damageDealt > 0 then
                    local msg = string.format("Hit %s for %d damage.", player.DisplayName or player.Name, damageDealt)
                    createNotif("Aetherium", msg, getgenv().Config.NotifDuration or 2)
                end
            end
        end
        lastHealth = newHealth
    end)
end

local function trackPlayer(player)
    if player == lplr then return end
    
    local function onCharacterAdded(char)
        local humanoid = char:WaitForChild("Humanoid", 5)
        if humanoid then
            listenToHumanoid(player, humanoid)
        end
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end

for _, player in plrs:GetPlayers() do
    trackPlayer(player)
end

plrs.PlayerAdded:Connect(trackPlayer)
plrs.PlayerRemoving:Connect(function(player)
    if activeListeners[player] then
        activeListeners[player]:Disconnect()
        activeListeners[player] = nil
    end
end)

local function getHvHTarget()
    local char = lplr.Character
    if not char then return nil, nil, nil end
    local myRoot = char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil, nil, nil end
    
    local bestPlayer = nil
    local bestRoot = nil
    local bestHead = nil
    local bestDist = math.huge

    for _, player in plrs:GetPlayers() do
        if not isEnemy(player) then continue end
        local pChar = player.Character
        if not pChar then continue end
        local pRoot = pChar:FindFirstChild("HumanoidRootPart")
        local pHead = pChar:FindFirstChild("Head")
        local pHum = pChar:FindFirstChildWhichIsA("Humanoid")
        if not (pRoot and pHead and pHum and pHum.Health > 0) then continue end

        local dist = (myRoot.Position - pRoot.Position).Magnitude

        if dist < bestDist then
            bestDist = dist
            bestPlayer = player
            bestRoot = pRoot
            bestHead = pHead
        end
    end
    return bestPlayer, bestRoot, bestHead
end

local function hasKnifeViewModel(targetPlayer)
    if not targetPlayer then return false end
    local viewModels = ws:FindFirstChild("ViewModels")
    if not viewModels then return false end
    local targetName = targetPlayer.Name
    for _, model in viewModels:GetChildren() do
        if model:IsA("Model") 
           and string.find(model.Name, targetName, 1, true) 
           and string.find(model.Name, "Knife", 1, true) then
            return true
        end
    end
    return false
end

local stateStartTime = tick()
local isVoidSpamming = false
local currentDesyncCF = nil

runS.RenderStepped:Connect(function()
    local mousePos = uis:GetMouseLocation()
    statusLabel.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y + 22)
end)

runS.Heartbeat:Connect(function()
    if not getgenv().Config.Enabled then
        statusLabel.Text = "ragebot: off"
        return
    end

    local currentTime = tick()
    local voidhideEnabled = getgenv().Config.EnableVoidhide
    local targetPlayer, targetRoot, targetHead = getHvHTarget()

    if not targetPlayer then
        isVoidSpamming = true
    elseif voidhideEnabled then
        if isVoidSpamming then
            if currentTime - stateStartTime >= (getgenv().Config.VoidDuration or 2) then
                isVoidSpamming = false
                stateStartTime = currentTime
            end
        else
            if currentTime - stateStartTime >= (getgenv().Config.AttackDuration or 3) then
                isVoidSpamming = true
                stateStartTime = currentTime
            end
        end
    else
        isVoidSpamming = false
    end

    currentDesyncCF = nil
    
    if isVoidSpamming then
        local signX = (math.random(0, 1) == 0) and -1 or 1
        local signY = (math.random(0, 1) == 0) and -1 or 1
        local signZ = (math.random(0, 1) == 0) and -1 or 1

        local voidPos = Vector3.new(
            math.random(1e14, 3e14) * signX,
            math.random(1e14, 3e14) * signY,
            math.random(1e14, 3e14) * signZ
        )

        if targetHead then
            currentDesyncCF = CFrame.lookAt(voidPos, targetHead.Position)
        else
            currentDesyncCF = CFrame.new(voidPos)
        end

        statusLabel.Text = "ragebot: voidspamming..."
    elseif targetRoot and targetHead then
        local desyncPos
        
        if getgenv().Config.Underground then
            desyncPos = (targetRoot.CFrame * CFrame.new(0, -4, 0)).Position
        else
            local offsetMode = getgenv().Config.CustomOffsetMode or "Original"
            
            if offsetMode == "Above" then
                desyncPos = (targetRoot.CFrame * CFrame.new(0, 4, 0)).Position
            elseif offsetMode == "Below" then
                desyncPos = (targetRoot.CFrame * CFrame.new(0, -4, 0)).Position
            elseif offsetMode == "Jitter" then
                desyncPos = (targetRoot.CFrame * CFrame.new(math.random(-4,4), math.random(-4,4), math.random(-4,4))).Position
            elseif offsetMode == "Jitter+" then
                desyncPos = (targetRoot.CFrame * CFrame.new(math.random(-8,8), math.random(-8,8), math.random(-8,8))).Position
            elseif offsetMode == "Behind" then
                desyncPos = (targetRoot.CFrame * CFrame.new(0, 1, 0)).Position
            elseif offsetMode == "None" then
                desyncPos = targetRoot.Position
            else
                if hasKnifeViewModel(targetPlayer) then
                    desyncPos = (targetRoot.CFrame * CFrame.new(0, 6, 0)).Position
                else
                    desyncPos = (targetRoot.CFrame * CFrame.new(0, 1, 2)).Position
                end
            end
        end
        
        currentDesyncCF = CFrame.lookAt(desyncPos, targetHead.Position)
        statusLabel.Text = string.format("ragebot: attacking %s", targetPlayer.DisplayName or targetPlayer.Name)
    else
        statusLabel.Text = "ragebot: off"
    end

    if currentDesyncCF and lplr.Character then
        local myRoot = lplr.Character:FindFirstChild("HumanoidRootPart")
        if myRoot then
            local oldCF = myRoot.CFrame
            local oldVel = myRoot.Velocity
            local oldRotVel = myRoot.RotVelocity
            myRoot.CFrame = currentDesyncCF
            runS:BindToRenderStep("__restore", 101, function()
                if myRoot then
                    myRoot.CFrame = oldCF
                    myRoot.Velocity = oldVel
                    myRoot.RotVelocity = oldRotVel
                end
                runS:UnbindFromRenderStep("__restore")
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait()
        if not getgenv().Config.Enabled then continue end

        local targetPlayer, targetRoot, targetHead = getHvHTarget()
        if not targetPlayer or not targetHead or not targetRoot then continue end
        if not lplr.Character or not lplr.Character:FindFirstChild("HumanoidRootPart") then continue end
        if not FighterController or not FighterController.LocalFighter then continue end
        
        local item = FighterController.LocalFighter.EquippedItem
        if not item then continue end

        local targetedPosition = targetHead.Position
        if getgenv().Config.EnablePrediction then
            local predFactor = getgenv().Config.PredictionFactor or 0.035
            targetedPosition = targetedPosition + (targetRoot.Velocity * predFactor)
        end

        local originPos = currentDesyncCF and currentDesyncCF.Position or targetRoot.Position
        local aimCF = CFrame.lookAt(originPos, targetedPosition)
        local targetCF = targetHead.CFrame
        
        local randomOffset = Vector3.new(
            (math.random() - 0.5) * 0.1,
            (math.random() - 0.5) * 0.1,
            (math.random() - 0.5) * 0.1
        )
        local aimedPos = targetedPosition + randomOffset
        local objSpaceHeadOffset = targetHead.CFrame:ToObjectSpace(CFrame.new(aimedPos))
        
        local cameradata = {}
        cameradata[utf8.char(1)] = {
            [utf8.char(0)] = util:EncodeCFrame(aimCF),
            [utf8.char(1)] = util:EncodeCFrame(targetCF),
            [utf8.char(2)] = targetHead,
            [utf8.char(3)] = util:EncodeCFrame(objSpaceHeadOffset)
        }
        
        pcall(function()
            repS.Remotes.Replication.Fighter.UseItem:FireServer(
                item:Get("ObjectID"),
                enum:ToEnum("StartShooting"),
                cameradata,
                nil
            )
        end)
    end
end)

print("gtest 123")
createNotif("Aetherium", "Hey, it's me it's Verity Ragebot loaded", 3)
createNotif("Aetherium", "Notification Stacking test 123", 3)
