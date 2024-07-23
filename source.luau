local HttpService = game:GetService("HttpService")
local PlaceId = game.PlaceId

local function getUpdate()
    local universeUrl = "https://apis.roblox.com/universes/v1/places/" .. PlaceId .. "/universe"

    local success, response =
        pcall(
        function()
            return game:HttpGet(universeUrl)
        end
    )

    if success then
        local data = HttpService:JSONDecode(response)

        if data and data.universeId then
            local universeId = data.universeId
            local updateUrl = "https://games.roblox.com/v1/games?universeIds=" .. universeId

            success, response =
                pcall(
                function()
                    return game:HttpGet(updateUrl)
                end
            )

            if success then
                data = HttpService:JSONDecode(response)

                if data and data.data and #data.data > 0 then
                    local gameDetails = data.data[1] -- Lua tables are 1-indexed
                    local updatedTime = gameDetails.updated
                    return updatedTime
                end
            end
        end
    end

    return nil
end

local scriptUpdate = "2024-07-19T21:28:52.863Z"
local currentUpdate = getUpdate()

if currentUpdate ~= scriptUpdate then
    print("Current Update Is " .. currentUpdate)
    error("New update. Wait for a new one in the discord. https://discord.gg/aSUewbrN")
end

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/PorkDevMode/trump-client/main/Ui.luau"))()

local Esp = loadstring(game:HttpGet("https://raw.githubusercontent.com/PorkDevMode/trump-client/main/esp.luau"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local regularTitanTransparency = 0
local regularTitanColor = Color3.new(0.066667, 0.258824, 0.039216)
local regularTitanNapeSize = Vector3.new(6.5, 4.2, 3.2)

local titanShifterTransparency = 0
local titanShifterColor = Color3.new(150, 0, 150)
local titanShifterNapeSizes = {
    FemaleTitan = Vector3.new(6.5, 4.2, 3.2),
    ArmoredTitan = Vector3.new(0, 0, 0),
    JawTitan = Vector3.new(6.5, 4.2, 3.2),
    ColossalTitan = Vector3.new(15, 15, 15),
    BeastTitan = Vector3.new(6.5, 4.2, 3.2),
    CartTitan = Vector3.new(6.5, 4.2, 3.2),
    AttackTitan = Vector3.new(6.5, 4.2, 3.2)
}

local modifyShifterLegSize = false
local titanShifterLegTransparency = 0
local titanShifterLegColor = Color3.new(150, 0, 150)
local titanShifterLegSizes = {
    FemaleTitan = Vector3.new(5, 6.46109, 5.4386),
    ArmoredTitan = Vector3.new(5, 6.46109, 5.4386),
    JawTitan = Vector3.new(5, 6.46109, 5.4386),
    ColossalTitan = Vector3.new(0, 0, 0),
    BeastTitan = Vector3.new(5, 6.46109, 5.4386),
    CartTitan = Vector3.new(5, 6.46109, 5.4386),
    AttackTitan = Vector3.new(5, 6.46109, 5.4386)
}

local modifyShifterEyeSize = false
local titanShifterEyeColor = Color3.new(1, 1, 1)
local titanShifterEyeTransparency = 0
local titanShifterEyeSizes = {
    FemaleTitan = Vector3.new(5, 6.46109, 5.4386),
    ArmoredTitan = Vector3.new(5, 6.46109, 5.4386),
    JawTitan = Vector3.new(5, 6.46109, 5.4386),
    ColossalTitan = Vector3.new(0, 0, 0),
    BeastTitan = Vector3.new(5, 6.46109, 5.4386),
    CartTitan = Vector3.new(5, 6.46109, 5.4386),
    AttackTitan = Vector3.new(5, 6.46109, 5.4386)
}

local WarriorList = {}

local SoldierList = {}

local Loop = true

local IsSpinningAnimation = false
local GodmodeEnabled
local ModifyRegularTitans = false
local ModifyTitanShifters = false
local NoHookTension = false
local RefillingGas = false
local InfiniteBlades = false
local InfiniteStamina = false
local ModifyWS = false
local ws = 16
local horseGodMode = false
local horseInfiniteStamina = false
local horseSpeed = false
local horseSpeedValue = 30
local modifyHorses = false
local noForceStun = false
local reloadingBlades = false

-- Function that loops through all mindless titans that are spawned, Gets the event folder that contains things like grab and deletes the entire folder. Then Modifys nape transparency, size and color. the color and transparency are not customizable yet
local function modifyRegularTitans()
    local titanlist = workspace:FindFirstChild("OnGameTitans")
    if titanlist then
        for _, titan in pairs(titanlist:GetChildren()) do
            local events = titan:FindFirstChild("Events")
            if events then
                events:Destroy()
            end

            local titanNape = titan:FindFirstChild("Nape")
            local titanEyes = titan:FindFirstChild("Eyes")
            if titanNape then
                titanNape.Transparency = regularTitanTransparency
                titanNape.Color = regularTitanColor
                titanNape.Size = regularTitanNapeSize
            end

            if titanEyes then
                titanEyes.Transparency = regularTitanTransparency
                titanEyes.Color = regularTitanColor
                titanEyes.Size = Vector3.new(3.36423, 4.5, 4.28958)
            end
        end
    end
end

local function modifyTitanShifters()
    local titans = {
        "FemaleTitan",
        "ArmoredTitan",
        "JawTitan",
        "ColossalTitan",
        "BeastTitan",
        "CartTitan",
        "AttackTitan"
    }

    for _, titanName in ipairs(titans) do
        local foundTitans = {}

        for _, child in ipairs(workspace:GetChildren()) do
            if child.Name == titanName then
                table.insert(foundTitans, child)
            end
        end
        for _, titan in ipairs(foundTitans) do
            local snape = titan:FindFirstChild("SNape")
            local seyes = titan:FindFirstChild("SEyes")
            if snape then
                snape.Size = titanShifterNapeSizes[titanName]
                snape.Transparency = titanShifterTransparency
                snape.Color = titanShifterColor
            end

            if seyes then
                seyes.Size = titanShifterEyeSizes[titanName]
                seyes.Transparency = titanShifterEyeTransparency
                seyes.Color = titanShifterEyeColor
            end

            if modifyShifterLegSize then
                local lleg = titan:FindFirstChild("LLegTendons")
                local rleg = titan:FindFirstChild("RLegTendons")

                if lleg and rleg then
                    lleg.Size = titanShifterLegSizes[titanName]
                    lleg.Transparency = titanShifterLegTransparency
                    lleg.Color = titanShifterLegColor

                    rleg.Size = titanShifterLegSizes[titanName]
                    rleg.Transparency = titanShifterLegTransparency
                    rleg.Color = titanShifterLegColor
                end
            end
        end
    end
end

local function modifyRiddenHorse()
    local onGameHorses = workspace:FindFirstChild("OnGameHorses")

    if onGameHorses then
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")

            if humanoid then
                for i, horse in pairs(onGameHorses:GetChildren()) do
                    local horseHumanoid = horse:FindFirstChild("Humanoid")
                    local carriage = horse:FindFirstChild("Carriage")

                    if carriage then
                        horseHumanoid = carriage.Humanoid
                    end

                    if horseHumanoid then
                        if horseHumanoid.Health > 0 then
                            local horseOwner = horseHumanoid.Owner.Value

                            if horseOwner == LocalPlayer.Name and horseHumanoid.Mounted.Value == true then
                                local config = horseHumanoid.Parent.Configuration

                                local god = horseHumanoid.God
                                local Stam = config.Stamina
                                local speed = config.CurrentSpeed
                                local maxspeed = config.MaxSpeed

                                if god and horseGodMode then
                                    if god.Value == false then
                                        god.Value = true
                                    end
                                end

                                if Stam and horseInfiniteStamina then
                                    Stam.Value = 4000
                                end

                                if speed and maxspeed and horseSpeed then
                                    speed.Value = horseSpeedValue
                                    maxspeed.Value = horseSpeedValue
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local function resetHookTension()
    local Char = LocalPlayer.Character
    if Char then
        local humanoid = Char:FindFirstChild("Humanoid")
        if humanoid then
            local TensionR = Char:FindFirstChild("Humanoid"):FindFirstChild("Gear"):FindFirstChild("HookTensionR")
            local TensionL = Char:FindFirstChild("Humanoid"):FindFirstChild("Gear"):FindFirstChild("HookTensionL")

            if TensionR then
                TensionR.Value = 0
            end

            if TensionL then
                TensionL.Value = 0
            end
        end
    end
end

local function displayStateAboveHead(player, state)
    local playerChar = player.Character
    if not playerChar then
        return
    end
    if player.Team == LocalPlayer.Team then
        return
    end

    local existingGui = playerChar:FindFirstChild("StateGui")
    if existingGui then
        existingGui:Destroy()
    end

    if state ~= "Default" then
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "StateGui"
        billboardGui.Size = UDim2.new(0, 300, 0, 75)
        billboardGui.StudsOffset = Vector3.new(0, 5, 0)
        billboardGui.AlwaysOnTop = true
        billboardGui.Parent = playerChar

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = state
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextSize = 36
        textLabel.TextStrokeTransparency = 0.5
        textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

        if state == "Countering" then
            textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        elseif state == "Kicking" then
            textLabel.TextColor3 = Color3.fromRGB(89, 0, 255)
        elseif state == "Blade" then
            textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        elseif state == "TitanBlocking" then
            textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        elseif state == "TitanRoaring" then
            textLabel.TextColor3 = Color3.fromRGB(105, 60, 114)
        elseif state == "TitanStunned" then
            textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        elseif state == "TitanHeavying" then
            textLabel.TextColor3 = Color3.fromRGB(255, 253, 123)
        end

        textLabel.Parent = billboardGui
    end
end

local function retrievePlayerStates()
    local players = game:GetService("Players")
    local LocalPlayer = players.LocalPlayer

    for _, player in pairs(players:GetPlayers()) do
        local playerChar = player.Character
        local playerHumanoid = playerChar:FindFirstChild("Humanoid")
        local localHumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if playerChar and playerHumanoid and localHumanoidRootPart then
            local playerHumanoidRootPart = playerChar:FindFirstChild("HumanoidRootPart")
            local snape = playerChar:FindFirstChild("SNape")
            if playerHumanoidRootPart and not snape then
                local distance = (localHumanoidRootPart.Position - playerHumanoidRootPart.Position).Magnitude
                if distance <= 1000 then
                    local counterState = playerHumanoid:FindFirstChild("Counter")
                    local kickState = playerHumanoid:FindFirstChild("KickAttacking")
                    local bladeState = playerHumanoid:FindFirstChild("BladeAttacking")

                    if counterState and kickState and bladeState then
                        local counterValue = counterState.Value
                        local kickValue = kickState.Value
                        local bladeValue = bladeState.Value

                        local state
                        if counterValue then
                            state = "Countering"
                        elseif kickValue then
                            state = "Kicking"
                        elseif bladeValue then
                            state = "Blade"
                        else
                            state = "Default"
                        end

                        if player.Team == LocalPlayer.Team then
                            return
                        end
                        displayStateAboveHead(player, state)
                    end
                end
            elseif snape and playerHumanoidRootPart then
                if player.Team == LocalPlayer.Team then
                    return
                end
                local Shifting = playerHumanoid.Shifting

                local blocking = Shifting.Blocking
                local heavying = Shifting.HeavyAttack
                local roaring = Shifting.Roar
                local stunned = Shifting.Roar

                local state

                if blocking then
                    state = "TitanBlocking"
                elseif heavying then
                    state = "TitanHeavying"
                elseif roaring then
                    state = "TitanRoaring"
                elseif stunned then
                    state = "TitanStunned"
                else
                    state = "Default"
                end

                displayStateAboveHead(player, state)
            end
        end
    end
end

local function refillStamina()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            local stamina = humanoid:FindFirstChild("Stamina")

            if stamina then
                stamina.Value = 2400
            end
        end
    end
end

-- Function to make you invincible against titans and fire, Does not work against shifters / humans.
local function enableGodMode(bool)
    local char = LocalPlayer.Character
    local humanoid = char:FindFirstChild("Humanoid")
    local gear = humanoid:FindFirstChild("Gear")
    if char and humanoid.Health > 0 and gear then
        local GodMode = char:FindFirstChild("Humanoid"):FindFirstChild("God")

        if GodMode then
            GodMode.Value = bool
        end
    end
end

local function refillGas()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") and char.Humanoid:FindFirstChild("Gear") then
        local gear = char.Humanoid.Gear
        if gear.Gas.Value ~= 2000 then
            gear.Gas.Value = 2000
        end
    end
end

-- Really fucky on solara, updates an array containing alive players. but gui breaks when u try and make a dropdown. Gui switch would be needed and that is not satisfactory because this also works on solara.
--[[
local function updateTpList()
    table.clear(alivePlayers)
    for i, player in pairs(Players:GetChildren()) do
        local Humanoid = player.Character:FindFirstChild("HumanoidRootPart")
        if Humanoid then
            table.insert(alivePlayers, player.Name)
            playerDropdown:Update(alivePlayers)
        end
    end
end
]]
local function executeIy()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", true))()
end

local function executeDex()
    loadstring(
        game:HttpGet(
            "https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua",
            true
        )
    )()
end

local function executeRspy()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpyBeta.lua", true))()
end

local function executeAspy()
    loadstring(
        game:HttpGet("https://raw.githubusercontent.com/PorkDevMode/AnimationSpy/main/AnimationLogger.luau", true)
    )()
end

local function enableSkills()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            local gear = humanoid:FindFirstChild("Gear")
            if gear then
                for _, skill in pairs(gear.Skills:GetChildren()) do
                    skill.Value = true
                end

                local gui = LocalPlayer:FindFirstChild("PlayerGui")
                if gui then
                    gui.SkillsGui.Enabled = true
                    gui.SkillsGui.BladeThrow.Enabled = true
                    gui.SkillsGui.Counter.Enabled = true
                    gui.SkillsGui.Dodge.Enabled = true
                    gui.SkillsGui.Impulse.Enabled = true
                    gui.SkillsGui.SuperJump.Enabled = true
                    gui.SkillsGui.HandCut.Enabled = true
                    gui.SkillsGui.HandCutMk2.Enabled = true

                    for _, v in pairs(gui.SkillsGui:GetChildren()) do
                        if v.Enabled == true then
                            print(v.Name .. " is enabled.")
                        end
                        if v.enabled ~= true then
                            print(v.Name .. " is not enabled.")
                        end
                    end
                end
            end
        end
    end
end

local function retrieveShifterScript(Char)
    local PossibleNames = {"FELocal", "ATLocal", "JALocal", "ARLocal", "BELocal", "CALocal", "COLocal"}

    for _, Name in ipairs(PossibleNames) do
        local Script = Char:FindFirstChild(Name)
        if Script then
            return Script
        end
    end
    return nil
end

local nostun
local lastWs

local function setWalkspeed()
    local character = LocalPlayer.Character

    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = ws
            local shifterScript = retrieveShifterScript(character)

            if shifterScript then
                local Stats = shifterScript.Stats

                local walkingSpeed = Stats:FindFirstChild("WalkingSpeed")
                local joggingSpeed = Stats:FindFirstChild("JoggingSpeed")
                local sprintingSpeed = Stats:FindFirstChild("SprintingSpeed")

                if walkingSpeed then
                    walkingSpeed:Destroy()
                end
                if joggingSpeed then
                    joggingSpeed:Destroy()
                end
                if sprintingSpeed then
                    sprintingSpeed:Destroy()
                end
            end
        end
    end
end

local function getWs()
    local character = LocalPlayer.Character

    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            local walkspeed = humanoid.WalkSpeed

            if walkspeed > 0 then
                lastWs = walkspeed
            end
        end
    end
end

local function resetWs()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")

        if humanoid and humanoid.Heath > 0 and humanoid.WalkSpeed > 0 then
            local snape = character:FindFirstChild("SNape")

            if snape then
                local shifterScript = retrieveShifterScript(character)
                if shifterScript then
                    local Stats = shifterScript.Stats

                    local walkingSpeed = Stats:FindFirstChild("WalkingSpeed")
                    local joggingSpeed = Stats:FindFirstChild("JoggingSpeed")
                    local sprintingSpeed = Stats:FindFirstChild("SprintingSpeed")

                    if walkingSpeed then
                        walkingSpeed:Destroy()
                    end
                    if joggingSpeed then
                        joggingSpeed:Destroy()
                    end
                    if sprintingSpeed then
                        sprintingSpeed:Destroy()
                    end
                end

                humanoid.WalkSpeed = lastWs
            end
        end
    end
end

local function reloadBlades()
    if LocalPlayer.Character then
        local gear = LocalPlayer.Character:FindFirstChild("Gear")

        if gear then
            gear.Events.BladeReload:FireServer()
        end
    end
end

local function noForceShiftStun()
    local character = LocalPlayer.Character
    local humanoid = character:FindFirstChild("Humanoid")

    if character and humanoid then
        local shifter = retrieveShifterScript(character)

        if shifter then
            local forced = shifter.Stats.ForceShifted

            if forced.Value == true then
                forced.Value = false
            end
        end
    end
end

local function deleteShiftingTime()
    local char = LocalPlayer.Character
    local ShifterScript = retrieveShifterScript(char)

    if ShifterScript then
        local Stats = ShifterScript:FindFirstChild("Stats")
        local Time = Stats:FindFirstChild("Time")

        if Time then
            Time:Destroy()
        end
    end
end

local function playAnimation(AnimID, speed)
    local char = LocalPlayer.Character
    local humanoid = char:FindFirstChild("Humanoid")

    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. AnimID

    local animationTrack = humanoid:LoadAnimation(animation)

    if speed then
        animationTrack:AdjustSpeed(speed)
    end

    animationTrack:Play()
end

local function restoreBlades()
    if LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.Gear.Blades.Value = 8
    end
end

local function tpEvent(Place)
    local placeObject = workspace:FindFirstChild(Place)
    if placeObject then
        local location = placeObject:FindFirstChild("HumanoidRootPart")
        if location then
            local teleportFunction = game:GetService("ReplicatedStorage"):FindFirstChild("ServerTeleportFunction")
            if teleportFunction then
                teleportFunction:InvokeServer(location)
            end
        end
    end
end

local function setJumpHeight(value)
    local character = LocalPlayer.Character
    if character then
        local humanoid = character.Humanoid
        if humanoid then
            humanoid.JumpPower = value
        end
    end
end

local function notifyShifter()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            print("Attempting shifter search.")
            local shifterHolder = player.Character:FindFirstChild("ShifterHolder")
            if shifterHolder then
                Rayfield:Notify(
                    {
                        Title = "Shifter Found!",
                        Content = player.Name .. " is the " .. shifterHolder.Value,
                        Duration = 6.5,
                        Image = 4483362458,
                        Actions = {
                            Ignore = {
                                Name = "I get it",
                                Callback = function()
                                end
                            }
                        }
                    }
                )

                print(player.Name .. " is the " .. shifterHolder.Name)
            end
        end
    end
end

local function UpdatePlayerLists()
    WarriorList = {}
    SoldierList = {}

    local TempWarriorList = {}
    local TempSoldierList = {}

    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local shifterHolder = player.Character:FindFirstChild("ShifterHolder")
            local name = player.Name
            if shifterHolder then
                TempWarriorList.name = shifterHolder.Value .. "Titan"
            else
                table.insert(TempSoldierList, name)
            end
        end
    end

    WarriorList = TempWarriorList
    SoldierList = TempSoldierList
end

-- Main loop, if anyone has any way to improve performance than do so.

local function mainLoop()
    if Loop then
        if ModifyRegularTitans then
            modifyRegularTitans()
        end

        if ModifyTitanShifters then
            modifyTitanShifters()
        end

        if NoHookTension then
            resetHookTension()
        end

        if InfiniteStamina then
            refillStamina()
        end

        if RefillingGas then
            refillGas()
        end

        if InfiniteBlades then
            restoreBlades()
        end

        if ModifyWS then
            setWalkspeed()
        end

        if GodmodeEnabled then
            enableGodMode(true)
        end

        if not GodmodeEnabled then
            enableGodMode(false)
        end

        if modifyHorses then
            modifyRiddenHorse()
        end

        if noForceStun then
            noForceShiftStun()
        end

        if reloadingBlades then
            reloadBlades()
        end

        if nostun then
            resetWs()
            getWs()
        end

        retrievePlayerStates()
        UpdatePlayerLists()
    end
end

local lastAnimTime = 0
local animInterval = 0.5

local function AnimLoop(deltaTime)
    if Loop then
        if IsSpinningAnimation then
            local currentTime = tick()
            if currentTime - lastAnimTime >= animInterval then
                playAnimation(9415324870, 10)
                lastAnimTime = currentTime
            end
        end
    end
end

connection = RunService.Heartbeat:Connect(mainLoop)
animconnection = RunService.Heartbeat:Connect(AnimLoop)

-- Creates the base window for the gui
local window =
    Rayfield:CreateWindow(
    {
        Name = "Trump Client V1",
        LoadingTitle = "Initializing Trump Client V1...",
        LoadingSubtitle = "Please wait",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "TrumpClientConfigV1",
            FileName = "TrumpClientGUIV1"
        },
        Discord = {
            Enabled = true,
            Invite = "B75D6wnq",
            RememberJoins = false
        }
    }
)

-- Creates all the tabs, gui documentation is at https://docs.sirius.menu/rayfield/configuration/booting-library
-- Do not use sections, they are broken with wave. add any toggles to the tabs
local playerTab = window:CreateTab("Player Options", 4483362458) -- The second parameter is an icon ID
local titanTab = window:CreateTab("Titan Options", 4483362458)
local shifterNapeTab = window:CreateTab("Shifter Nape", 4483362458)
local shifterLegTab = window:CreateTab("Shifter Leg", 4483362458)
local shifterEyeTab = window:CreateTab("Shifter Eye")
local warriorTab = window:CreateTab("Warrior Options", 4483362458)
local rageTab = window:CreateTab("Rage Options (EXTREMELY BLATANT)", 4483362458)

-- Player section.
--- FEATURES THAT WILL BE ADDED: Godmode either by adding health or make you unable to be hit by players, Infinite blades, Infinite thunderspears, Stop hood from being forced off, Prevent players from hooking you.

-- A toggle that replenishes fuel, should replenish only when its at half or so to save performance.
playerTab:CreateToggle(
    {
        Name = "Constant Refill Gas",
        CurrentValue = RefillingGas,
        Flag = "GasRefilling",
        Callback = function(value)
            RefillingGas = value
        end
    }
)

playerTab:CreateToggle(
    {
        Name = "Constant Refill Blades",
        CurrentValue = InfiniteBlades,
        Flag = "InfiniteBlades",
        Callback = function(Value)
            InfiniteBlades = Value
        end
    }
)

playerTab:CreateToggle(
    {
        Name = "Auto Reload Blades",
        CurrentValue = reloadingBlades,
        Flag = "reloadingBlades",
        Callback = function(value)
            reloadingBlades = value
        end
    }
)

playerTab:CreateKeybind(
    {
        Name = "Refill Gas",
        CurrentKeybind = "Y",
        HoldToInteract = false,
        Flag = "RefillGasBind",
        Callback = function()
            refillGas()
        end
    }
)

playerTab:CreateKeybind(
    {
        Name = "Refill Blades",
        CurrentKeybind = "I",
        HoldToInteract = false,
        Flag = "RefillBladeBind",
        Callback = function()
            restoreBlades()
        end
    }
)

-- Function to reset hooktension to none in the main loop, Allowing you to hook onto things with no time limit.
playerTab:CreateToggle(
    {
        Name = "Infinite Hook Duration",
        CurrentValue = NoHookTension,
        Flag = "InfiniteHook",
        Callback = function(value)
            NoHookTension = value
        end
    }
)

-- A button that enables godmode, should also be a toggle like i mentioned about gas below.
playerTab:CreateToggle(
    {
        Name = "God Mode (TURN OFF TO SHIFT)",
        CurrentValue = GodmodeEnabled,
        Flag = "GodModeEnabled",
        Callback = function(value)
            GodmodeEnabled = value
        end
    }
)

playerTab:CreateToggle(
    {
        Name = "Modify Horse",
        CurrentValue = modifyHorses,
        Flag = "ModifyHorses",
        Callback = function(value)
            modifyHorses = value
        end
    }
)

playerTab:CreateToggle(
    {
        Name = "Infinite Horse Stamina",
        CurrentValue = horseInfiniteStamina,
        Flag = "InfiniteHorseStamina",
        Callback = function(value)
            horseInfiniteStamina = value
        end
    }
)

playerTab:CreateToggle(
    {
        Name = "Horse God Mode",
        CurrentValue = horseGodMode,
        Flag = "HorseGodMode",
        Callback = function(value)
            horseGodMode = value
        end
    }
)

playerTab:CreateButton(
    {
        Name = "Enable Skills",
        Callback = function()
            if LocalPlayer.Character then
                enableSkills()
            end
        end
    }
)

playerTab:CreateButton(
    {
        Name = "Show Shifter Names",
        Callback = function()
            notifyShifter()
        end
    }
)

playerTab:CreateButton(
    {
        Name = "Disable client",
        Callback = function()
            Loop = false
            Rayfield:Destroy()
        end
    }
)

-- TitanTab Section
-- FEATURES THAT WILL BE ADDED: Nape hitbox color.

-- Add a toggle for activating regular titan modification
titanTab:CreateToggle(
    {
        Name = "Modify Regular Titans",
        CurrentValue = ModifyRegularTitans,
        Flag = "ModifyRegularTitansToggle",
        Callback = function(value)
            ModifyRegularTitans = value
        end
    }
)

titanTab:CreateColorPicker(
    {
        Name = "Regular Titan Nape Colour",
        Color = regularTitanColor,
        Flag = "RegularTitanNapeColour",
        Callback = function(value)
            regularTitanColor = value
        end
    }
)

titanTab:CreateSlider(
    {
        Name = "Regular Titan Nape Transparency",
        Range = {0, 1},
        Increment = 0.01,
        Suffix = "Transparency",
        Flag = "RegularNapeTransparency",
        CurrentValue = regularTitanTransparency,
        Callback = function(value)
            regularTitanTransparency = value
        end
    }
)

titanTab:CreateSlider(
    {
        Name = "Regular Titan Nape Size X",
        Range = {0.1, 35},
        Increment = 0.1,
        Suffix = "Size X",
        Flag = "SizeX",
        CurrentValue = regularTitanNapeSize.X,
        Callback = function(Value)
            regularTitanNapeSize = Vector3.new(Value, regularTitanNapeSize.Y, regularTitanNapeSize.Z)
        end
    }
)

titanTab:CreateSlider(
    {
        Name = "Regular Titan Nape Size Y",
        Range = {0.1, 35},
        Increment = 0.1,
        Suffix = "Size Y",
        Flag = "SizeY",
        CurrentValue = regularTitanNapeSize.Y,
        Callback = function(Value)
            regularTitanNapeSize = Vector3.new(regularTitanNapeSize.X, Value, regularTitanNapeSize.Z)
        end
    }
)

titanTab:CreateSlider(
    {
        Name = "Regular Titan Nape Size Z",
        Range = {0.1, 35},
        Increment = 0.1,
        Suffix = "Size Z",
        Flag = "SizeZ",
        CurrentValue = regularTitanNapeSize.Z,
        Callback = function(Value)
            regularTitanNapeSize = Vector3.new(regularTitanNapeSize.X, regularTitanNapeSize.Y, Value)
        end
    }
)

-- Toggles shifter nape modification
shifterNapeTab:CreateToggle(
    {
        Name = "Modify Shifter's'",
        CurrentValue = ModifyTitanShifters,
        Flag = "ModifyShifterToggle",
        Callback = function(value)
            ModifyTitanShifters = value
        end
    }
)

shifterNapeTab:CreateColorPicker(
    {
        Name = "Titan Shifter Nape Colour",
        Color = titanShifterColor,
        Flag = "ShifterNapeColour",
        Callback = function(value)
            titanShifterColor = value
        end
    }
)

shifterNapeTab:CreateSlider(
    {
        Name = "Titan Shifter Nape Transparency",
        Range = {0, 1},
        Increment = 0.01,
        Suffix = "Shifter Transparency",
        Flag = "ShifterNapeTransparency",
        CurrentValue = titanShifterTransparency,
        Callback = function(value)
            titanShifterTransparency = value
        end
    }
)

-- Loops through titan nape sizes and creates sliders for each of the shifters nape's
for titanName, defaultSize in pairs(titanShifterNapeSizes) do
    local titanShifterNapeSize = defaultSize

    shifterNapeTab:CreateSlider(
        {
            Name = titanName .. " Nape Size X",
            Range = {0.1, 20},
            Increment = 0.1,
            Suffix = titanName .. " Size x",
            Flag = titanName .. "NapeSizeX",
            CurrentValue = titanShifterNapeSize.X,
            Callback = function(Value)
                titanShifterNapeSize = Vector3.new(Value, titanShifterNapeSize.Y, titanShifterNapeSize.Z)
                titanShifterNapeSizes[titanName] = titanShifterNapeSize
            end
        }
    )

    shifterNapeTab:CreateSlider(
        {
            Name = titanName .. " Nape Size Y",
            Range = {0.1, 20},
            Increment = 0.1,
            Suffix = titanName .. " Size Y",
            Flag = titanName .. "NapeSizeY",
            CurrentValue = titanShifterNapeSize.Y,
            Callback = function(Value)
                titanShifterNapeSize = Vector3.new(titanShifterNapeSize.X, Value, titanShifterNapeSize.Z)
                titanShifterNapeSizes[titanName] = titanShifterNapeSize
            end
        }
    )

    shifterNapeTab:CreateSlider(
        {
            Name = titanName .. " Nape Size Z",
            Range = {0.1, 20},
            Increment = 0.1,
            Suffix = titanName .. " Size Z",
            Flag = titanName .. "NapeSizeZ",
            CurrentValue = titanShifterNapeSize.Z,
            Callback = function(Value)
                titanShifterNapeSize = Vector3.new(titanShifterNapeSize.X, titanShifterNapeSize.Y, Value)
                titanShifterNapeSizes[titanName] = titanShifterNapeSize
            end
        }
    )
end

-- Toggles shifter Leg modification
shifterLegTab:CreateToggle(
    {
        Name = "Modify Titan Shifters Leg's",
        CurrentValue = ModifyTitanShifters,
        Flag = "ModifyShifterLegToggle",
        Callback = function(value)
            modifyShifterLegSize = value
        end
    }
)

shifterLegTab:CreateColorPicker(
    {
        Name = "Titan Shifter Leg Colour",
        Color = titanShifterLegColor,
        Flag = "ShifterLegColour",
        Callback = function(value)
            titanShifterLegColor = value
        end
    }
)

shifterLegTab:CreateSlider(
    {
        Name = "Titan Shifter Leg Transparency",
        Range = {0, 1},
        Increment = 0.01,
        Suffix = "Shifter Leg Transparency",
        Flag = "ShifterLegTransparency",
        CurrentValue = titanShifterLegTransparency,
        Callback = function(value)
            titanShifterLegTransparency = value
        end
    }
)

-- Loops through titan nape sizes and creates sliders for each of the shifters nape's
for titanName, defaultSize in pairs(titanShifterLegSizes) do
    local titanShifterLegSize = defaultSize

    shifterLegTab:CreateSlider(
        {
            Name = titanName .. " Leg Size X",
            Range = {0.1, 20},
            Increment = 0.1,
            Suffix = titanName .. " Leg Size x",
            Flag = titanName .. "LegSizeX",
            CurrentValue = titanShifterLegSize.X,
            Callback = function(Value)
                titanShifterLegSize = Vector3.new(Value, titanShifterLegSize.Y, titanShifterLegSize.Z)
                titanShifterLegSizes[titanName] = titanShifterLegSize
            end
        }
    )

    shifterLegTab:CreateSlider(
        {
            Name = titanName .. " Leg Size Y",
            Range = {0.1, 20},
            Increment = 0.1,
            Suffix = titanName .. " Leg Y",
            Flag = titanName .. "NapeSizeY",
            CurrentValue = titanShifterLegSize.Y,
            Callback = function(Value)
                titanShifterLegSize = Vector3.new(titanShifterLegSize.X, Value, titanShifterLegSize.Z)
                titanShifterLegSizes[titanName] = titanShifterLegSize
            end
        }
    )

    shifterLegTab:CreateSlider(
        {
            Name = titanName .. " Leg Size Z",
            Range = {0.1, 20},
            Increment = 0.1,
            Suffix = titanName .. " Leg Size Z",
            Flag = titanName .. "NapeSizeZ",
            CurrentValue = titanShifterLegSize.Z,
            Callback = function(Value)
                titanShifterLegSize = Vector3.new(titanShifterLegSize.X, titanShifterLegSize.Y, Value)
                titanShifterLegSizes[titanName] = titanShifterLegSize
            end
        }
    )
end

-- Toggles shifter Leg modification
shifterEyeTab:CreateToggle(
    {
        Name = "Modify Titan Shifter Eyes",
        CurrentValue = modifyShifterEyeSize,
        Flag = "ModifyShifterEyeToggle",
        Callback = function(value)
            modifyShifterEyeSize = value
        end
    }
)

shifterEyeTab:CreateColorPicker(
    {
        Name = "Titan Shifter Eye Colour",
        Color = titanShifterEyeColor,
        Flag = "ShifterEyeColour",
        Callback = function(value)
            titanShifterEyeColor = value
        end
    }
)

shifterEyeTab:CreateSlider(
    {
        Name = "Titan Shifter Eye Transparency",
        Range = {0, 1},
        Increment = 0.01,
        Suffix = "Shifter Eye Transparency",
        Flag = "ShifterEyeTransparency",
        CurrentValue = titanShifterEyeTransparency,
        Callback = function(value)
            titanShifterEyeTransparency = value
        end
    }
)

-- Loops through titan nape sizes and creates sliders for each of the shifters nape's
for titanName, defaultSize in pairs(titanShifterEyeSizes) do
    local titanShifterEyeSize = defaultSize

    shifterEyeTab:CreateSlider(
        {
            Name = titanName .. " Eye Size X",
            Range = {0.1, 15},
            Increment = 0.1,
            Suffix = titanName .. " Eye Size x",
            Flag = titanName .. "EyeSizeX",
            CurrentValue = titanShifterEyeSize.X,
            Callback = function(Value)
                titanShifterEyeSize = Vector3.new(Value, titanShifterEyeSize.Y, titanShifterEyeSize.Z)
                titanShifterEyeSizes[titanName] = titanShifterEyeSize
            end
        }
    )

    shifterEyeTab:CreateSlider(
        {
            Name = titanName .. " Eye Size Y",
            Range = {0.1, 15},
            Increment = 0.1,
            Suffix = titanName .. " Eye Y",
            Flag = titanName .. "EyeSizeY",
            CurrentValue = titanShifterEyeSize.Y,
            Callback = function(Value)
                titanShifterEyeSize = Vector3.new(titanShifterEyeSize.X, Value, titanShifterEyeSize.Z)
                titanShifterEyeSizes[titanName] = titanShifterEyeSize
            end
        }
    )

    shifterEyeTab:CreateSlider(
        {
            Name = titanName .. " Eye Size Z",
            Range = {0.1, 15},
            Increment = 0.1,
            Suffix = titanName .. " Eye Size Z",
            Flag = titanName .. "EyeSizeZ",
            CurrentValue = titanShifterEyeSize.Z,
            Callback = function(Value)
                titanShifterEyeSize = Vector3.new(titanShifterEyeSize.X, titanShifterEyeSize.Y, Value)
                titanShifterEyeSizes[titanName] = titanShifterEyeSize
            end
        }
    )
end

-- Warrior tab section, for thing while you are in shift mode.
-- FEATURES THAT WILL BE ADDED: No cooldowns, Custom titan animation. EG: Jaw titan animation on the colossal. Infinite shifter stamina.

warriorTab:CreateToggle(
    {
        Name = "Infinite Stamina",
        CurrentValue = InfiniteStamina,
        Flag = "TitanStamina",
        Callback = function(value)
            InfiniteStamina = value
        end
    }
)

warriorTab:CreateToggle(
    {
        Name = "No Force Shift Stun",
        CurrentValue = noForceStun,
        Flag = "NoForceStun",
        Callback = function(value)
            noForceStun = value
        end
    }
)

warriorTab:CreateButton(
    {
        Name = "Infinite Shifter Time",
        Callback = function()
            deleteShiftingTime()
        end
    }
)

-- Rage tab section, for things that will get u banned ez

rageTab:CreateInput(
    {
        Name = "Teleport To Player",
        PlaceholderText = "Player Name",
        RemoveTextAfterFocusLost = true,
        Callback = function(Text)
            tpEvent(Text)
        end
    }
)

rageTab:CreateInput(
    {
        Name = "Set Jump Height (Titan/Human)",
        PlaceholderText = "1",
        RemoveTextAfterFocusLost = true,
        Callback = function(value)
            setJumpHeight(value)
        end
    }
)

rageTab:CreateInput(
    {
        Name = "Play Animation Id (Titan/Human)",
        PlaceholderText = "Animation Id",
        RemoveTextAfterFocusLost = true,
        Callback = function(value)
            playAnimation(value)
        end
    }
)

rageTab:CreateButton(
    {
        Name = "Play Jaw Animation (Titan/Human)",
        Callback = function()
            playAnimation(16547084642) -- Jaw animation id
        end
    }
)

rageTab:CreateButton(
    {
        Name = "Play Pushup Animation (Titan/Human)",
        Callback = function()
            playAnimation(17124879492) -- Jaw animation id
        end
    }
)

rageTab:CreateToggle(
    {
        Name = "Spin Animation (Titan/Human)",
        CurrentValue = IsSpinningAnimation,
        Callback = function(Value)
            IsSpinningAnimation = Value
        end
    }
)

rageTab:CreateToggle(
    {
        Name = "Modify Walkspeed",
        CurrentValue = ModifyWS,
        Callback = function(Value)
            ModifyWS = Value
        end
    }
)

rageTab:CreateSlider(
    {
        Name = "Walkspeed",
        Range = {0.1, 60},
        Increment = 0.1,
        Suffix = nil,
        Flag = "WalkspeedValue",
        CurrentValue = ws,
        Callback = function(Value)
            ws = Value
        end
    }
)

rageTab:CreateToggle(
    {
        Name = "Horse Speed",
        CurrentValue = horseSpeed,
        Callback = function(value)
            horseSpeed = value
        end
    }
)

rageTab:CreateSlider(
    {
        Name = "Horse Walkspeed",
        Range = {0.1, 600},
        Increment = 0.1,
        Suffix = nil,
        Flag = "HorseWalkspeedValue",
        CurrentValue = horseSpeedValue,
        Callback = function(value)
            horseSpeedValue = value
        end
    }
)

rageTab:CreateToggle(
    {
        Name = "No Shifter Stun",
        CurrentValue = nostun,
        CallBack = function(value)
            nostun = value
        end
    }
)

rageTab:CreateButton(
    {
        Name = "Execute Infinite Yield",
        Callback = function()
            executeIy()
        end
    }
)

rageTab:CreateButton(
    {
        Name = "Execute Dark Dex",
        Callback = function()
            executeDex()
        end
    }
)

rageTab:CreateButton(
    {
        Name = "Execute Remote Spy",
        Callback = function()
            executeRspy()
        end
    }
)

rageTab:CreateButton(
    {
        Name = "Execute Animator Spy",
        Callback = function()
            executeAspy()
        end
    }
)

local Toggled = false
local Sprinting = false
local flightSpeed = 5
local flightSprintSpeed = 20

rageTab:CreateKeybind(
    {
        Name = "Toggle Fly",
        CurrentKeybind = "6",
        HoldToInteract = false,
        Flag = "FlightBindFlag",
        Callback = function(value)
            if game.Players.LocalPlayer.Character then
                Toggled = not Toggled
                if Toggled then
                    LastPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                    game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true
                else
                    LastPos = nil
                    game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
                end
            end
        end
    }
)

rageTab:CreateSlider(
    {
        Name = "Flight Speed",
        Range = {1, 20},
        Increment = 0.1,
        Suffix = nil,
        Flag = "FlightSpeed",
        CurrentValue = flightSpeed,
        Callback = function(Value)
            flightSpeed = Value
        end
    }
)

rageTab:CreateKeybind(
    {
        Name = "Fast Fly",
        CurrentKeybind = "7",
        HoldToInteract = true,
        Flag = "FastFlightBindFlag",
        Callback = function(value)
            if Toggled then
                Sprinting = value
            end
        end
    }
)

rageTab:CreateSlider(
    {
        Name = "Fast Fly Speed",
        Range = {20, 50},
        Increment = 0.1,
        Suffix = nil,
        Flag = "FastFlySpeed",
        CurrentValue = flightSprintSpeed,
        Callback = function(value)
            flightSprintSpeed = value
        end
    }
)

rageTab:CreateButton(
    {
        Name = "See Through Walls",
        Callback = function()
            pcall(
                function()
                    game.Players.LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
                end
            )
        end
    }
)

local Settings = {
    Speed = flightSpeed,
    SprintSpeed = flightSprintSpeed,
    ForwardKey = Enum.KeyCode.W,
    LeftKey = Enum.KeyCode.A,
    BackwardKey = Enum.KeyCode.S,
    RightKey = Enum.KeyCode.D,
    UpKey = Enum.KeyCode.E,
    DownKey = Enum.KeyCode.Q
}

local Screen = Instance.new("ScreenGui", game.CoreGui)
local Distance = Instance.new("TextLabel", Screen)
Distance.BackgroundTransparency = 1
Distance.Size = UDim2.new(0, 10, 0, 10)
Distance.ZIndex = 2
Distance.Text = "0"
Distance.TextStrokeTransparency = .5
Distance.TextSize = 20
Distance.TextStrokeColor3 = Color3.fromRGB(33, 33, 33)
Distance.Font = Enum.Font.Gotham
Distance.TextColor3 = Color3.new(1, 1, 1)
Distance.TextXAlignment = Enum.TextXAlignment.Left
Distance.TextYAlignment = Enum.TextYAlignment.Top

local Mouse = game.Players.LocalPlayer:GetMouse()
local Direction = Vector3.new(0, 0, 0)
local InterpolatedDir = Direction
local Tilt = 0
local InterpolatedTilt = Tilt
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LastPos = nil

function Lerp(a, b, t)
    return a + (b - a) * t
end

function KeyHandler(actionName, userInputState)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if actionName == "Forward" then
            Tilt = userInputState == Enum.UserInputState.Begin and -20 or 0
            Direction = Vector3.new(Direction.x, Direction.y, userInputState == Enum.UserInputState.Begin and -1 or 0)
        elseif actionName == "Left" then
            Direction = Vector3.new(userInputState == Enum.UserInputState.Begin and -1 or 0, Direction.y, Direction.z)
        elseif actionName == "Backward" then
            Tilt = userInputState == Enum.UserInputState.Begin and 20 or 0
            Direction = Vector3.new(Direction.x, Direction.y, userInputState == Enum.UserInputState.Begin and 1 or 0)
        elseif actionName == "Right" then
            Direction = Vector3.new(userInputState == Enum.UserInputState.Begin and 1 or 0, Direction.y, Direction.z)
        elseif actionName == "Up" then
            Direction = Vector3.new(Direction.x, userInputState == Enum.UserInputState.Begin and 1 or 0, Direction.z)
        elseif actionName == "Down" then
            Direction = Vector3.new(Direction.x, userInputState == Enum.UserInputState.Begin and -1 or 0, Direction.z)
        end
    end
end

game:GetService("UserInputService").InputBegan:Connect(
    function(inputObject, gameProcessedEvent)
        if inputObject.KeyCode == Settings.ForwardKey then
            KeyHandler("Forward", Enum.UserInputState.Begin, inputObject)
        elseif inputObject.KeyCode == Settings.LeftKey then
            KeyHandler("Left", Enum.UserInputState.Begin, inputObject)
        elseif inputObject.KeyCode == Settings.BackwardKey then
            KeyHandler("Backward", Enum.UserInputState.Begin, inputObject)
        elseif inputObject.KeyCode == Settings.RightKey then
            KeyHandler("Right", Enum.UserInputState.Begin, inputObject)
        elseif inputObject.KeyCode == Settings.UpKey then
            KeyHandler("Up", Enum.UserInputState.Begin, inputObject)
        elseif inputObject.KeyCode == Settings.DownKey then
            KeyHandler("Down", Enum.UserInputState.Begin, inputObject)
        end
    end
)

game:GetService("UserInputService").InputEnded:Connect(
    function(inputObject, gameProcessedEvent)
        if inputObject.KeyCode == Settings.ForwardKey then
            KeyHandler("Forward", Enum.UserInputState.End, inputObject)
        elseif inputObject.KeyCode == Settings.LeftKey then
            KeyHandler("Left", Enum.UserInputState.End, inputObject)
        elseif inputObject.KeyCode == Settings.BackwardKey then
            KeyHandler("Backward", Enum.UserInputState.End, inputObject)
        elseif inputObject.KeyCode == Settings.RightKey then
            KeyHandler("Right", Enum.UserInputState.End, inputObject)
        elseif inputObject.KeyCode == Settings.UpKey then
            KeyHandler("Up", Enum.UserInputState.End, inputObject)
        elseif inputObject.KeyCode == Settings.DownKey then
            KeyHandler("Down", Enum.UserInputState.End, inputObject)
        end
    end
)

RunService.RenderStepped:Connect(
    function()
        if
            Toggled and game.Players.LocalPlayer.Character and
                game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and
                Loop
         then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Velocity = Vector3.new(0, 0, 0)
                end
            end
            local RootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
            if LastPos then
                Distance.Text = math.floor((LastPos - RootPart.Position).Magnitude + 0.5)
                if (LastPos - RootPart.Position).Magnitude >= 350 then
                    Distance.TextColor3 = Color3.new(1, 0, 0)
                else
                    Distance.TextColor3 = Color3.new(1, 1, 1)
                end
            else
                Distance.TextColor3 = Color3.new(1, 1, 1)
                Distance.Text = "0"
            end
            InterpolatedDir =
                InterpolatedDir:Lerp((Direction * (Sprinting and Settings.SprintSpeed or Settings.Speed)), 0.2)
            InterpolatedTilt = Lerp(InterpolatedTilt, Tilt * (Sprinting and 2 or 1), Tilt == 0 and 0.2 or 0.1)
            RootPart.CFrame =
                RootPart.CFrame:Lerp(
                CFrame.new(RootPart.Position, RootPart.Position + Mouse.UnitRay.Direction) *
                    CFrame.Angles(0, math.rad(0), 0) *
                    CFrame.new(InterpolatedDir) *
                    CFrame.Angles(math.rad(InterpolatedTilt), 0, 0),
                0.2
            )
        else
            Distance.TextColor3 = Color3.new(1, 1, 1)
            Distance.Text = "0"
        end
    end
)

-- lock on stuff

local Camera = workspace.CurrentCamera
local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local isLock = false
local maxDistance = 100
local targetIndex = 1
local targets = {}
local cameraOffset = Vector3.new(0, 8, 0)

if not Char.Humanoid:FindFirstChild("Gear") then
    Camera.CameraSubject = Char:FindFirstChild("Humanoid")
    Camera.CameraType = Enum.CameraType.Custom
end

local function updateTargets()
    targets = {}
    for _, player in pairs(Players:GetPlayers()) do
        local snape = player.Character:FindFirstChild("SNape")
        local dead = player.Character.Humanoid:FindFirstChild("Dead")
        if
            player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and
                not snape and
                not (dead and dead.Value) and
                player.Team ~= LocalPlayer.Team
         then
            table.insert(targets, player)
        end
    end
end

local function getBestTarget()
    local bestTarget = nil
    local bestScore = math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in pairs(targets) do
        local enemyHumanoidRootPart = player.Character.HumanoidRootPart
        local distance = (Char.HumanoidRootPart.Position - enemyHumanoidRootPart.Position).Magnitude

        if distance <= maxDistance and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local screenPos, onScreen = Camera:WorldToScreenPoint(enemyHumanoidRootPart.Position)
            if onScreen then
                local cursorDistance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                local score = distance + cursorDistance

                if score < bestScore then
                    bestScore = score
                    bestTarget = player
                end
            end
        end
    end

    return bestTarget
end

UserInputService.InputBegan:Connect(
    function(input, typing)
        if typing then
            return
        end
        if input.KeyCode == Enum.KeyCode.Backquote then
            isLock = not isLock
            if not isLock then
                Camera.CameraType = Enum.CameraType.Custom
                Camera.CameraSubject = Char:FindFirstChild("Humanoid")
            else
                updateTargets()
                targetIndex = 0
            end
        elseif input.KeyCode == Enum.KeyCode.RightBracket then
            if isLock then
                targetIndex = targetIndex % #targets + 1
            end
        end
    end
)

LocalPlayer.CharacterAdded:Connect(
    function(newChar)
        Char = newChar
        if not Char.Humanoid:FindFirstChild("Gear") then
            Camera.CameraSubject = Char:FindFirstChild("Humanoid")
            Camera.CameraType = Enum.CameraType.Custom
        end
    end
)

RunService.RenderStepped:Connect(
    function()
        if isLock and Loop then
            if targetIndex == 0 then
                local bestTarget = getBestTarget()
                for i, target in ipairs(targets) do
                    if target == bestTarget then
                        targetIndex = i
                        break
                    end
                end
            end

            local target = targets[targetIndex]

            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local targetPart = target.Character.HumanoidRootPart
                local cameraPos = Char.HumanoidRootPart.Position + cameraOffset
                local targetCFrame = CFrame.new(cameraPos, targetPart.Position)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 0.1)
            else
                targetIndex = 0
            end
        else
            if Char and Char:FindFirstChild("HumanoidRootPart") and not Char.Humanoid:FindFirstChild("Gear") then
                Camera.CameraSubject = Char:FindFirstChild("Humanoid")
                Camera.CameraType = Enum.CameraType.Custom
                local campos = Char.HumanoidRootPart.Position + (Camera.CFrame.Position - Camera.Focus.Position)
                local smoothCFrame = Camera.CFrame:Lerp(CFrame.new(campos, Char.HumanoidRootPart.Position), 0.1)
                Camera.CFrame = smoothCFrame
            end
        end
    end
)
