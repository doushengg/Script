local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local startTime = os.time()
local startRebirths = player.leaderstats.Rebirths.Value
local displayName = player.DisplayName

WindUI:AddTheme({
    Name = "Light",
    Accent = "#f4f4f5",
    Dialog = "#f4f4f5",
    Outline = "#000000", 
    Text = "#000000",
    Placeholder = "#666666",
    Background = "#f0f0f0",
    Button = "#000000",
    Icon = "#000000",
})

WindUI:SetNotificationLower(true)

local themes = {"Light"}
local currentThemeIndex = 1

if not getgenv().TransparencyEnabled then
    getgenv().TransparencyEnabled = true
end

local Window = WindUI:CreateWindow({
    Title = "Team | Vuzo Zilux",
    Icon = "rbxassetid://76676105086715", 
    Author = "By ZorVex",
    Folder = "Vz Hub",
    Size = UDim2.fromOffset(500, 350),
    Transparent = getgenv().TransparencyEnabled,
    Theme = "Light",
    Resizable = true,
    SideBarWidth = 150,
    BackgroundImageTransparency = 0.8,
    HideSearchBar = true,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            currentThemeIndex = currentThemeIndex + 1
            if currentThemeIndex > #themes then
                currentThemeIndex = 1
            end
            
            local newTheme = themes[currentThemeIndex]
            WindUI:SetTheme(newTheme)
           
            WindUI:Notify({
                Title = "ZorVex | Leader Of Vuzo Zilux",
                Duration = 8
            })
        end,
    },
})

Window:SetIconSize(55)

Window:EditOpenButton({
    Enabled = false
})

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UIBUTTON"
ScreenGui.Parent = game.CoreGui
ScreenGui.IgnoreGuiInset = true 

local ImgBtn = Instance.new("ImageButton")
ImgBtn.Parent = ScreenGui
ImgBtn.Size = UDim2.new(0, 70, 0, 70)
ImgBtn.AnchorPoint = Vector2.new(1, 0) 
ImgBtn.Position = UDim2.new(0.9, -20, 0, 50) 
ImgBtn.BackgroundTransparency = 1
ImgBtn.Image = "rbxassetid://88635292278521" 
ImgBtn.ZIndex = 9999

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = ImgBtn
local isOpen = true

ImgBtn.MouseButton1Click:Connect(function()
    local shrink = TweenService:Create(ImgBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 60, 0, 60)
    })
    local grow = TweenService:Create(ImgBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 70, 0, 70)
    })
    shrink:Play()
    shrink.Completed:Wait()
    grow:Play()
    
    Window:Toggle()
    isOpen = not isOpen
end)

local dragging = false
local dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    ImgBtn.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end
ImgBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ImgBtn.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
ImgBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement 
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

local a = game:GetService("ReplicatedStorage")
local b = game:GetService("Players")
local c = b.LocalPlayer

do
    Window:Tag({
        Title = "--> VIP Strength<--",
        Color = Color3.fromHex("#000000")
    })
end

for _, portal in pairs(game:GetDescendants()) do
    if portal.Name == "RobloxForwardPortals" then
        portal:Destroy()
    end
end

if _G.AdRemovalConnection then
    _G.AdRemovalConnection:Disconnect()
end

_G.AdRemovalConnection = game.DescendantAdded:Connect(function(descendant)
    if descendant.Name == "RobloxForwardPortals" then
        descendant:Destroy()
    end
end)

WindUI:Notify({
    Title = "Ads Delete",
    Content = "Portal Ads Delete"
})

local VIP_Tab = Window:Tab({
Title = "Strength",
Icon = "chevrons-left-right-ellipsis"})

local VIP_SET = VIP_Tab:Section({
Title = "Settings",
Icon = "sliders-horizontal"})

local sizeValue = 1

VIP_Tab:Input({
    Title = "Set Size",
    Placeholder = "Enter Your Size",
    Callback = function(text)
        local num = tonumber(text)
        if num then
            sizeValue = num
        end
    end
})

VIP_Tab:Toggle({
    Title = "Auto Size",
    Callback = function(bool)
        _G.autoSizeActive = bool
        if bool then
            task.spawn(function()
                while _G.autoSizeActive and task.wait() do
                    game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", sizeValue)
                end
            end)
        end
    end
})

VIP_Tab:Toggle({
    Title = "Anti-AFK",
    Callback = function(state)
        if state then
            local VirtualUser = game:GetService("VirtualUser")

            _G.afkGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
            _G.afkGui.Name = "AntiAFKGui"
            _G.afkGui.ResetOnSpawn = false

            local timer = Instance.new("TextLabel", _G.afkGui)
            timer.Size = UDim2.new(0, 200, 0, 30)
            timer.Position = UDim2.new(1, -210, 0, 20)
            timer.Text = "0:00:00"
            timer.TextColor3 = Color3.fromRGB(255, 255, 255)
            timer.Font = Enum.Font.GothamBold
            timer.TextSize = 25
            timer.BackgroundTransparency = 1
            timer.TextTransparency = 0
            
            local timerStroke = Instance.new("UIStroke", timer)
            timerStroke.Thickness = 1
            timerStroke.Color = Color3.fromRGB(39, 39, 39)

            local startTime = tick()

            task.spawn(function()
                while _G.afkGui and _G.afkGui.Parent do
                    local elapsed = tick() - startTime
                    local h = math.floor(elapsed / 3600)
                    local m = math.floor((elapsed % 3600) / 60)
                    local s = math.floor(elapsed % 60)
                    timer.Text = string.format("%02d:%02d:%02d", h, m, s)
                    task.wait(1)
                end
            end)
            
            _G.afkConnection = player.Idled:Connect(function()
                VirtualUser:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
            end)
        else
            if _G.afkConnection then
                _G.afkConnection:Disconnect()
                _G.afkConnection = nil
            end
            if _G.afkGui then
                _G.afkGui:Destroy()
                _G.afkGui = nil
            end
        end
    end
})

local Strength = VIP_Tab:Section({
Title = "Fast Strength",
Icon = "skull"})

VIP_Tab:Input({
    Title = "Set Repetition",
    Placeholder = "Set Fast Strength",
    Callback = function(text)
        local num = tonumber(text)
        if num then
            repCount = num
        end
    end
})

VIP_Tab:Toggle({
    Title = "Push Strength",
    Callback = function(l)
        getgenv().PushStrengthEnabled = l
        
        if l then
            local k = function(petName)
                for _, n in pairs(c.petsFolder.Unique:GetChildren()) do
                    if n.Name == petName then
                        a.rEvents.equipPetEvent:FireServer("equipPet", n)
                    end
                end
            end
            
            task.spawn(function()
                while getgenv().PushStrengthEnabled do
                    k("Swift Samurai")
                    for y = 1, repCount do
                        if not getgenv().PushStrengthEnabled then break end
                        c.muscleEvent:FireServer("rep")
                    end
                    task.wait()
                end
            end)
        end
    end
})


VIP_Tab:Button({
    Title = "Delete Frames",
    Callback = function()
        for _, obj in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
            if obj.Name:match("Frame$") then
                obj:Destroy()
            end
        end
        WindUI:Notify({Title = "Success", Content = "Frame Delete 100% Fps Boost"})
    end
})

local VIP_ONLYYY11 = VIP_Tab:Section({
Title = "Emote VIP",
Icon = "sparkles"})

local emoteList = {
    ["Godlike Emote"] = 106493972274585,
    ["Old Town Road"] = 3390820390,
    ["Applaud"] = 507768388,
    ["Hello"] = 3583743333
}

local selectedEmoteName = "Godlike Emote"

local targetDropdown = VIP_Tab:Dropdown({
    Title = "Select Emote",
    Values = {"Godlike Emote", "Old Town Road", "Applaud", "Hello"},
    Callback = function(value)
        selectedEmoteName = value
    end
})

VIP_Tab:Button({
    Title = "Emote VIP",
    Callback = function()
        local emoteId = emoteList[selectedEmoteName]
        
        WindUI:Notify({
            Title = "Emote Started", 
            Content = "Playing: " .. selectedEmoteName
        })

        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character then return end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local desc = humanoid and humanoid:FindFirstChildOfClass("HumanoidDescription")

        if humanoid and desc then
            desc:SetEmotes({
                [selectedEmoteName] = {emoteId}
            })

            local function forcePlayEmote(name)
                local animator = humanoid:FindFirstChildOfClass("Animator")
                
                if animator then
                    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                        track:Stop(0.1)
                    end
                end

                local success, err = pcall(function()
                    humanoid:PlayEmote(name)
                end)

                if success then
                    task.defer(function()
                        if animator then
                            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                                track.Priority = Enum.AnimationPriority.Action4
                                track.Looped = true
                            end
                        end
                    end)
                end
            end

            forcePlayEmote(selectedEmoteName)
        end
    end
})

local VIP_ONLYY = VIP_Tab:Section({
Title = "Only VIP",
Icon = "gem"})

local function activateProteinEgg()
    local character = player.Character
    if not character then return end
    
    local tool = character:FindFirstChild("Protein Egg") or player.Backpack:FindFirstChild("Protein Egg")
    
    if tool and c.muscleEvent then
        c.muscleEvent:FireServer("proteinEgg", tool)
    end
end

local running = false

task.spawn(function()
    while true do
        if running then
            activateProteinEgg()
            task.wait(1800)
        else
            task.wait(1)
        end
    end
end)

VIP_Tab:Toggle({
    Title = "Auto Eat Egg | 30mins",
    Desc = " Get 2x Strength | 30 Minute",
    Callback = function(state)
        running = state
        if state then
            activateProteinEgg()
        end
    end
})

VIP_Tab:Button({
    Title = "Teleport To Jungle",
    Callback = function()
        local o = function(p)
            local q = workspace.machinesFolder:FindFirstChild(p)
            if not q then
                for r, s in pairs(workspace:GetChildren()) do
                    if s:IsA("Folder") and s.Name:find("machines") then
                        q = s:FindFirstChild(p)
                        if q then break end
                    end
                end
            end
            return q
        end

        local t = function()
            local u = game:GetService("VirtualInputManager")
            u:SendKeyEvent(true, "E", false, game)
            task.wait(.1)
            u:SendKeyEvent(false, "E", false, game)
        end
        
        local z = o("Jungle Bar Lift")
        if z and z:FindFirstChild("interactSeat") and c.Character and c.Character:FindFirstChild("HumanoidRootPart") then
            for i = 1, 3 do
                c.Character.HumanoidRootPart.CFrame = z.interactSeat.CFrame * CFrame.new(0, 3, 0)
                task.wait(.01)
                t()
                task.wait(.1)
            end
        end
    end
})

local positions = {
    Zone1 = CFrame.new(7.37152624, 181.829956, -1163.31775, -0.999853373, -1.50258028e-08, 0.0171243865, -1.68823515e-08, 1, -1.0827096e-07, -0.0171243865, -1.08544178e-07, -0.999853373),
    Zone2 = CFrame.new(1950.79, 2.29, 6183.52)
}

-- Satu Loop Utama untuk semua teleport (Lebih Hemat Performa)
task.spawn(function()
    while true do
        if currentTarget then
            pcall(function() -- Menggunakan pcall agar script tidak mati jika karakter mati
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    -- Cek jika jarak lebih dari 5 unit dari target
                    if (hrp.Position - currentTarget.Position).Magnitude > 1 then
                        hrp.CFrame = currentTarget
                    end
                end
            end)
        end
        task.wait(0.01) -- 0.1 sudah cukup cepat dan tidak bikin lag
    end
end)

VIP_Tab:Toggle({
    Title = "Fly Mode",
    Callback = function(enabled)
        currentTarget = enabled and positions.Zone1 or nil
    end
})

VIP_Tab:Toggle({
    Title = "Save Mode",
    Callback = function(enabled)
        currentTarget = enabled and positions.Zone2 or nil
    end
})

local ZorVexStatus = {}
ZorVexStatus.__index = ZorVexStatus

function ZorVexStatus.new(mainWindow)
    local self = setmetatable({}, ZorVexStatus)
    self.Window = mainWindow
    self.StatsTab = nil
    self.PlayerDropdown = nil
    self.SelectedPlayer = game.Players.LocalPlayer
    self.PlayerOriginalStats = {}
    self.UseCompact = true 
    self.StatsLabel = nil
    self.GainedLabel = nil

    self:CreateStatsUI()
    self:InitPlayerStats()
    self:StartAutoRefresh()

    return self
end

function ZorVexStatus:FormatNumber(n)
    n = tonumber(n) or 0
    if not self.UseCompact then
        local formatted = tostring(math.floor(n))
        while true do  
            local k
            formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
            if (k == 0) then break end
        end
        return formatted
    end
    if n < 1000 then return tostring(math.floor(n)) end
    local symbols = {"", "k", "M", "B", "T", "Qa", "Qi"}
    local symbolIndex = math.floor(math.log10(n) / 3)
    if symbolIndex >= #symbols then symbolIndex = #symbols - 1 end
    local power = 10 ^ (symbolIndex * 3)
    local value = n / power
    local finalValue = math.floor(value * 10) / 10
    local formatted = string.format("%.1f", finalValue):gsub("%.0$", "")
    return formatted .. symbols[symbolIndex + 1]
end

function ZorVexStatus:InitPlayerStats()
    local Players = game:GetService("Players")
    
    -- Inisialisasi untuk player yang sudah ada saat script dijalankan
    for _, plr in ipairs(Players:GetPlayers()) do
        task.spawn(function()
            plr:WaitForChild("leaderstats", 10)
            task.wait(1) -- Jeda agar data replikasi dari server stabil
            self:StoreOriginalStats(plr)
        end)
    end

    -- Inisialisasi untuk player yang baru join ke server
    Players.PlayerAdded:Connect(function(plr)
        local ls = plr:WaitForChild("leaderstats", 20)
        if ls then
            -- JEDA KRUSIAL: Menunggu data "Strength/Stats" asli player ter-load dari database game
            -- Jika tanpa wait, script mengambil angka 0, lalu sedetik kemudian jadi 10M (menyebabkan Gained +10M)
            task.wait(2) 
            self:StoreOriginalStats(plr)
            self:UpdateDropdown()
        end
    end)

    Players.PlayerRemoving:Connect(function(plr)
        if self.SelectedPlayer == plr then
            self.SelectedPlayer = Players.LocalPlayer
        end
        self.PlayerOriginalStats[plr] = nil
        self:UpdateDropdown()
    end)
end

function ZorVexStatus:StoreOriginalStats(plr)
    -- Sistem Pengunci: Jika data awal sudah ada, JANGAN ditimpa lagi.
    if not plr or self.PlayerOriginalStats[plr] then return end
    
    local statsTable = {}
    local ls = plr:FindFirstChild("leaderstats")
    
    -- Catat nilai yang ada sekarang sebagai "Original" (Titik Nol)
    if ls then
        for _, s in ipairs(ls:GetChildren()) do
            if s:IsA("NumberValue") or s:IsA("IntValue") then
                statsTable[s.Name] = s.Value or 0
            end
        end
    end

    -- Catat stats tambahan
    local extras = {"Durability", "Agility"}
    for _, name in ipairs(extras) do
        local obj = plr:FindFirstChild(name)
        statsTable[name] = obj and obj.Value or 0
    end

    -- Simpan permanen sampai player keluar
    self.PlayerOriginalStats[plr] = statsTable
end

function ZorVexStatus:CreateStatsUI()
    self.StatsTab = self.Window:Tab({
        Title = "Stats",
        Icon = "trending-up"
    })
    
    local configSection = self.StatsTab:Section({
        Title = "View Stats Player",
        Icon = "trending-up"
    })

    self.StatsTab:Button({
        Title = "Change Version Stats",
        Desc = "Change V1 Compact & V2 Details ",
        Callback = function()
            self.UseCompact = not self.UseCompact
            local statusDesc = self.UseCompact and "Compact Mode" or "Detail Mode"
            if WindUI then
                WindUI:Notify({
                    Title = "Type Stats Change",
                    Content = "Use " .. statusDesc,
                    Duration = 1.5,
                    Icon = "settings-2"
                })
            end
        end
    })

    self:UpdateDropdown()

    local displaySection = self.StatsTab:Section({
        Title = "View Stats V1 And View Stats V2",
    })

    self.StatsLabel = self.StatsTab:Paragraph({
        Title = "Loading stats...",
        Desc = ""
    })

    self.GainedLabel = self.StatsTab:Paragraph({
        Title = "Gained: 0",
        Desc = ""
    })
end

function ZorVexStatus:UpdateDropdown()
    local Players = game:GetService("Players")
    local playerNames = {}
    
    for _, plr in ipairs(Players:GetPlayers()) do
        table.insert(playerNames, plr.Name)
    end

    if self.PlayerDropdown then
        self.PlayerDropdown:Refresh(playerNames)
    else
        self.PlayerDropdown = self.StatsTab:Dropdown({
            Title = "Select Player Target",
            Values = playerNames,
            Callback = function(v)
                self.SelectedPlayer = Players:FindFirstChild(v) or Players.LocalPlayer
            end
        })
    end
end

function ZorVexStatus:RefreshStats()
    if not self.SelectedPlayer or not self.SelectedPlayer.Parent then
        self.SelectedPlayer = game.Players.LocalPlayer
    end

    local target = self.SelectedPlayer
    local statsText = ""
    local gainedText = ""
    local extras = {"Durability", "Agility"}
    local fontSizeBody = 18   
    local fontSizeTitle = 28 

    -- Proteksi jika StoreOriginalStats luput saat join
    if not self.PlayerOriginalStats[target] then
        self:StoreOriginalStats(target)
    end

    local ls = target:FindFirstChild("leaderstats")
    if ls then
        for _, stat in ipairs(ls:GetChildren()) do
            if stat:IsA("NumberValue") or stat:IsA("IntValue") then
                local val = stat.Value or 0
                local orig = (self.PlayerOriginalStats[target] and self.PlayerOriginalStats[target][stat.Name]) or val
                statsText = statsText .. '<font size="'..fontSizeBody..'"><b>' .. stat.Name .. ": " .. self:FormatNumber(val) .. "</b></font>\n"
                gainedText = gainedText .. '<font size="'..fontSizeBody..'"><b>' .. stat.Name .. ": +" .. self:FormatNumber(val - orig) .. "</b></font>\n"
            end
        end
    end

    for _, name in ipairs(extras) do
        local obj = target:FindFirstChild(name)
        local val = obj and obj.Value or 0
        local orig = (self.PlayerOriginalStats[target] and self.PlayerOriginalStats[target][name]) or val
        statsText = statsText .. '<font size="'..fontSizeBody..'"><b>' .. name .. ": " .. self:FormatNumber(val) .. "</b></font>\n"
        gainedText = gainedText .. '<font size="'..fontSizeBody..'"><b>' .. name .. ": +" .. self:FormatNumber(val - orig) .. "</b></font>\n"
    end

    pcall(function()
        if self.StatsLabel then
            self.StatsLabel:SetTitle('<font size="'..fontSizeTitle..'"><b>' .. target.DisplayName .. '</b></font>')
            self.StatsLabel:SetDesc(statsText)
        end
        if self.GainedLabel then
            self.GainedLabel:SetTitle('<font size="'..fontSizeTitle..'"><b>Stats Gained</b></font>')
            self.GainedLabel:SetDesc(gainedText)
        end
    end)
end

function ZorVexStatus:StartAutoRefresh()
    task.spawn(function()
        while true do
            task.wait(0.5)
            self:RefreshStats()
        end
    end)
end

local StatsSystem = ZorVexStatus.new(Window)

local teleportTab = Window:Tab({Title = "Teleport", Icon = "map-pin"})
local CustomSection = teleportTab:Section({Title = "Teleport Custom", Icon = "user-cog"})

local customPosInput = "0, 0, 0"
local lockCustomPos = false

teleportTab:Input({
    Title = "Target Position",
    Desc = "You Are Free To Teleport Anywhere",
    Placeholder = "Enter Costume Position",
    Callback = function(text)
        customPosInput = text
    end
})

teleportTab:Button({
    Title = "Get Your Position",
    Desc = "Copy Your Position",
    Callback = function()
        local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local pos = root.Position
            local formattedPos = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)
            
            setclipboard(formattedPos)
            
            if WindUI then
                WindUI:Notify({
                    Title = "Position Done Copy",
                    Content = "You Have Copy The Position",
                    Duration = 1,
                    Icon = "clipboard-check"
                })
            end
        end
    end
})

teleportTab:Toggle({
    Title = "Teleport Your Position",
    Value = false,
    Callback = function(state)
        lockCustomPos = state
        
        if state then
            task.spawn(function()
                while lockCustomPos do
                    local coords = {}
                    for val in string.gmatch(customPosInput, "[^,]+") do
                        table.insert(coords, tonumber(val))
                    end
                    
                    if #coords >= 3 then
                        local targetCF = CFrame.new(coords[1], coords[2], coords[3])
                        local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            root.CFrame = targetCF
                        end
                    end
                    task.wait(0.005)
                end
            end)
        end
    end
})

local TeleportSection = teleportTab:Section({Title = "Teleport Mode", Icon = "map-pin"})

local currentVersion = "Portal Telpeort"
local toggleStates = {}
local activeLoops = {}

local teleportData = {
    ["Portal Teleport"] = {
        {"Spawn", CFrame.new(2, 8, 115)}, {"Secret Area", CFrame.new(1947, 2, 6191)}, {"Tiny Island", CFrame.new(-34, 7, 1903)},
        {"Frozen", CFrame.new(-2600, 3, -403)}, {"Mythical", CFrame.new(2255, 7, 1071)}, {"Inferno", CFrame.new(-6768, 7, -1287)},
        {"Legend", CFrame.new(4604, 991, -3887)}, {"Muscle King", CFrame.new(-8646, 17, -5738)}, {"Jungle", CFrame.new(-8659, 6, 2384)}
    },
    ["Area Spawn"] = {
        {"Area Spawn V1", CFrame.new(-288.63, 34.37, -1242.75)}, {"Area Spawn V2", CFrame.new(198.11, 43.87, -1281.25)}, {"Area Spawn V3", CFrame.new(753.85, 37.22, -953.21)},
        {"Area Spawn V4", CFrame.new(867.29, 36.51, -153.79)}, {"Area Spawn V5", CFrame.new(911.35, 41.67, 328.53)}, {"Area Spawn V6", CFrame.new(176.71, 34.37, 678.06)},
        {"Area Spawn V7", CFrame.new(-278.76, 41.67, 803.21)}, {"Area Spawn V8", CFrame.new(-820.03, 34.37, 323.52)}, {"Area Spawn V9", CFrame.new(-864.29, 41.67, -148.20)}
    }, 
    ["Area Frost"] = {
        {"Frost V1", CFrame.new(-3632.78, 41.67, -611.01)}, {"Frost V2", CFrame.new(-3018.51, 34.37, -1133.93)}, {"Frost V3", CFrame.new(-2540.17, 41.67, -1139.82)},
        {"Frost V4", CFrame.new(-2076.97, 34.37, -572.28)}, {"Frost V5", CFrame.new(-2030.41, 41.67, -99.55)}, {"Frost V6", CFrame.new(-2549.26, 34.37, 314.38)},
        {"Frost V7", CFrame.new(-3024.51, 41.67, 322.30)}, {"Frost V8", CFrame.new(-3666.25, 34.37, -136.61)}, {"Frost V9", CFrame.new(-2846.15, 89.44, -406.46)}
    }, 
    ["Area Mythical"] = {
        {"Mythical V1", CFrame.new(1611.91, 41.67, 831.43)}, {"Mythical V2", CFrame.new(2231.55, 34.37, 307.55)}, {"Mythical V3", CFrame.new(2702.26, 41.67, 299.23)},
        {"Mythical V4", CFrame.new(3168.63, 34.37, 869.02)}, {"Mythical V5", CFrame.new(3216.70, 41.67, 1340.99)}, {"Mythical V6", CFrame.new(2697.76, 34.37, 1756.94)},
        {"Mythical V7", CFrame.new(2219.95, 41.67, 1765.28)}, {"Mythical V8", CFrame.new(1580.94, 34.37, 1304.18)}, {"Mythical V9", CFrame.new(1613.45, 41.67, 834.61)}
    },
    ["Area Inferno"] = {
        {"Inferno V1", CFrame.new(-6171.77, 41.67, -980.01)}, {"Inferno V2", CFrame.new(-6694.84, 34.37, -564.37)}, {"Inferno V3", CFrame.new(-7168.48, 41.67, -555.94)},
        {"Inferno V4", CFrame.new(-7808.35, 34.37, -998.05)}, {"Inferno V5", CFrame.new(-7775.84, 41.67, -1485.05)}, {"Inferno V6", CFrame.new(-7158.84, 34.37, -2013.57)},
        {"Inferno V7", CFrame.new(-6685.91, 41.67, -2022.32)}, {"Inferno V8", CFrame.new(-6223.72, 34.37, -1448.29)}, {"Inferno V9", CFrame.new(-6986.32, 89.65, -1287.44)}
    }, 
    ["Area Jungle"] = {
        {"jungle V1", CFrame.new(-7429.39, 137.64, 3539.27)}, {"jungle V2", CFrame.new(-7111.83, 137.06, 3076.58)}, {"jungle V3", CFrame.new(-7055.04, 102.05, 2162.77)},
        {"jungle V4", CFrame.new(-7733.45, 55.73, 1369.46)}, {"jungle V5", CFrame.new(-8480.99, 134.16, 1414.67)}, {"jungle V6", CFrame.new(-9138.68, 149.24, 1827.94)},
        {"jungle V7", CFrame.new(-9430.28, 53.89, 2438.14)}, {"jungle V8", CFrame.new(-8183.44, 76.41, 1383.64)}, {"jungle V9", CFrame.new(-8116.44, 223.95, 2397.24)}
    },
    ["Void Brawl"] = {
        {"Void Brawl V1", CFrame.new(3674.49, 36.89, -8295.16)}, {"Void Brawl V2", CFrame.new(3493.97, 43.50, -9086.34)}, {"Void Brawl V3", CFrame.new(3738.08, 44.34, -9585.31)},
        {"Void Brawl V4", CFrame.new(4338.64, 34.36, -9808.24)}, {"Void Brawl V5", CFrame.new(4930.11, 41.82, -9722.39)}, {"Void Brawl V6", CFrame.new(5391.56, 34.33, -9308.55)},
        {"Void Brawl V7", CFrame.new(5442.33, 41.82, -8625.02)}, {"Void Brawl V8", CFrame.new(5197.84, 41.72, -8176.37)}, {"Void Brawl V9", CFrame.new(4725.28, 37.66, -7899.020)}
    }, 
    ["Desert Brawl"] = {
        {"Desert Brawl V1", CFrame.new(1931.75, 40.69, -7161.35)}, {"Desert Brawl V2", CFrame.new(1684.34, 36.89, -6721.88)}, {"Desert Brawl V3", CFrame.new(1219.53, 33.80, -6438.87)},
        {"Desert Brawl V4", CFrame.new(720.85, 41.19, -6453.78)}, {"Desert Brawl V5", CFrame.new(164.57, 36.33, -6832.94)}, {"Desert Brawl V6", CFrame.new(-20.00, 42.37, -7631.01)},
        {"Desert Brawl V7", CFrame.new(232.82, 43.22, -8137.93)}, {"Desert Brawl V8", CFrame.new(819.16, 35.41, -8351.83)}, {"Desert Brawl V9", CFrame.new(1420.26, 39.57, -8256.59)}
    },
    ["Ori Brawl"] = {
        {"Ori Brawl V1", CFrame.new(-1139.72, 40.46, -5530.67)}, {"Ori Brawl V2", CFrame.new(-1606.91, 31.70, -5256.56)}, {"Ori Brawl V3", CFrame.new(-2098.54, 45.80, -5250.18)},
        {"Ori Brawl V4", CFrame.new(-2655.81, 32.86, -5641.19)}, {"Ori Brawl V5", CFrame.new(-2826.76, 40.16, -6442.06)}, {"Ori Brawl V6", CFrame.new(-2599.99, 40.03, -6931.56)},
        {"Ori Brawl V7", CFrame.new(-1389.05, 38.73, -7072.45)}, {"Ori Brawl V8", CFrame.new(-940.97, 36.17, -6660.76)}, {"Ori Brawl V9", CFrame.new(-1403.06, 39.54, -7063.23)}
    }
}

teleportTab:Dropdown({
    Title = "Change Teleport Version",
    Desc = "Version Details",
    Values = {"Portal Teleport", "Area Spawn", "Area Frost", "Area Mythical", "Area Inferno", "Area Jungle", "Void Brawl", "Desert Brawl", "Ori Brawl"},
    Callback = function(v)
        currentVersion = v
        RefreshButtons()
    end
})

local ButtonSection = teleportTab:Section({ 
    Title = "Teleport",
    Icon = "list"
})

local function safeTeleport(cframe)
    local character = game.Players.LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = cframe end
end

local TeleportToggles = {}

for i = 1, 9 do
    toggleStates[i] = false
    TeleportToggles[i] = teleportTab:Toggle({
        Title = "Select Version Teleport",
        Desc = "Teleport Detail Mode",
        Value = false,
        Callback = function(state)
            toggleStates[i] = state
            
            if state then
                task.spawn(function()
                    while toggleStates[i] do
                        local data = teleportData[currentVersion][i]
                        if data then
                            safeTeleport(data[2])
                        end
                        task.wait(0.005)
                    end
                end)
            end
        end
    })
end

function RefreshButtons()
    local locations = teleportData[currentVersion]
    for i = 1, 9 do
        if locations[i] then
            TeleportToggles[i]:SetTitle(locations[i][1])
        end
    end
end

RefreshButtons()