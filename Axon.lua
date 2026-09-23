local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local KEY_URL = "https://pastebin.com/raw/3uCkC0Lw"
local GET_KEY_URL = "https://pastebin.com/3uCkC0Lw"

local ACCENT = Color3.fromRGB(255, 170, 0)
local TEXT = Color3.fromRGB(230, 230, 230)
local DIM = Color3.fromRGB(150, 150, 150)
local GREEN = Color3.fromRGB(80, 220, 80)
local RED = Color3.fromRGB(255, 80, 80)

-- ================== KEY SYSTEM ==================
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "AxonKey"
KeyGui.ResetOnSpawn = false
KeyGui.IgnoreGuiInset = true
KeyGui.DisplayOrder = 10000
KeyGui.Parent = PlayerGui

local KBG = Instance.new("Frame")
KBG.Size = UDim2.new(1, 0, 1, 0)
KBG.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
KBG.BorderSizePixel = 0
KBG.BackgroundTransparency = 0.15
KBG.Parent = KeyGui

local KBox = Instance.new("Frame")
KBox.AnchorPoint = Vector2.new(0.5, 0.5)
KBox.Size = UDim2.new(0, 400, 0, 280)
KBox.Position = UDim2.new(0.5, 0, 0.5, 0)
KBox.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
KBox.BorderSizePixel = 0
KBox.Parent = KeyGui

local KStroke = Instance.new("UIStroke")
KStroke.Color = ACCENT
KStroke.Thickness = 1.5
KStroke.Parent = KBox

local KTitle = Instance.new("TextLabel")
KTitle.Size = UDim2.new(1, 0, 0, 40)
KTitle.Position = UDim2.new(0, 0, 0, 20)
KTitle.BackgroundTransparency = 1
KTitle.Text = "AXON ULTRA"
KTitle.TextColor3 = ACCENT
KTitle.Font = Enum.Font.Code
KTitle.TextSize = 26
KTitle.Parent = KBox

local KSub = Instance.new("TextLabel")
KSub.Size = UDim2.new(1, 0, 0, 18)
KSub.Position = UDim2.new(0, 0, 0, 60)
KSub.BackgroundTransparency = 1
KSub.Text = "введи ключ для доступа"
KSub.TextColor3 = DIM
KSub.Font = Enum.Font.Code
KSub.TextSize = 11
KSub.Parent = KBox

local KInput = Instance.new("TextBox")
KInput.Size = UDim2.new(0.8, 0, 0, 36)
KInput.Position = UDim2.new(0.1, 0, 0, 88)
KInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KInput.BorderSizePixel = 0
KInput.Text = ""
KInput.PlaceholderText = "ключ..."
KInput.TextColor3 = TEXT
KInput.PlaceholderColor3 = Color3.fromRGB(90, 90, 90)
KInput.Font = Enum.Font.Code
KInput.TextSize = 14
KInput.ClearTextOnFocus = false
KInput.Parent = KBox

local KBtn = Instance.new("TextButton")
KBtn.Size = UDim2.new(0.8, 0, 0, 36)
KBtn.Position = UDim2.new(0.1, 0, 0, 130)
KBtn.BackgroundColor3 = ACCENT
KBtn.BorderSizePixel = 0
KBtn.Text = "ВОЙТИ"
KBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
KBtn.Font = Enum.Font.Code
KBtn.TextSize = 14
KBtn.Parent = KBox

local CheckBtn = Instance.new("TextButton")
CheckBtn.Size = UDim2.new(0.38, 0, 0, 30)
CheckBtn.Position = UDim2.new(0.1, 0, 0, 172)
CheckBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CheckBtn.BorderSizePixel = 0
CheckBtn.Text = "ПРОВЕРИТЬ"
CheckBtn.TextColor3 = GREEN
CheckBtn.Font = Enum.Font.Code
CheckBtn.TextSize = 11
CheckBtn.Parent = KBox

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Size = UDim2.new(0.38, 0, 0, 30)
GetKeyBtn.Position = UDim2.new(0.52, 0, 0, 172)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
GetKeyBtn.BorderSizePixel = 0
GetKeyBtn.Text = "ПОЛУЧИТЬ"
GetKeyBtn.TextColor3 = ACCENT
GetKeyBtn.Font = Enum.Font.Code
GetKeyBtn.TextSize = 11
GetKeyBtn.Parent = KBox

local KStatus = Instance.new("TextLabel")
KStatus.Size = UDim2.new(1, 0, 0, 18)
KStatus.Position = UDim2.new(0, 0, 0, 210)
KStatus.BackgroundTransparency = 1
KStatus.Text = ""
KStatus.TextColor3 = DIM
KStatus.Font = Enum.Font.Code
KStatus.TextSize = 11
KStatus.Parent = KBox

local Hint = Instance.new("TextLabel")
Hint.Size = UDim2.new(1, 0, 0, 30)
Hint.Position = UDim2.new(0, 0, 0, 235)
Hint.BackgroundTransparency = 1
Hint.Text = "проверить — без запуска\nполучить — ссылка на ключи"
Hint.TextColor3 = Color3.fromRGB(90, 90, 90)
Hint.Font = Enum.Font.Code
Hint.TextSize = 9
Hint.TextWrapped = true
Hint.Parent = KBox

local function checkKey(callback)
    local enteredKey = KInput.Text
    if enteredKey == "" then
        KStatus.Text = "введи ключ"
        KStatus.TextColor3 = RED
        if callback then callback(false) end
        return
    end

    KStatus.Text = "проверка..."
    KStatus.TextColor3 = ACCENT

    task.spawn(function()
        local ok, result = pcall(function()
            return game:HttpGet(KEY_URL, true)
        end)

        if not ok or not result then
            KStatus.Text = "ошибка загрузки"
            KStatus.TextColor3 = RED
            if callback then callback(false) end
            return
        end

        local valid = false
        for line in string.gmatch(result, "[^\r\n]+") do
            local trimmed = line:gsub("^%s+", ""):gsub("%s+$", "")
            if string.lower(trimmed) == string.lower(enteredKey) then
                valid = true
                break
            end
        end

        if valid then
            KStatus.Text = "ключ верный!"
            KStatus.TextColor3 = GREEN
        else
            KStatus.Text = "неверный ключ"
            KStatus.TextColor3 = RED
        end

        if callback then callback(valid) end
    end)
end

CheckBtn.MouseButton1Click:Connect(function()
    checkKey(nil)
end)

GetKeyBtn.MouseButton1Click:Connect(function()
    pcall(function() setclipboard(GET_KEY_URL) end)
    KStatus.Text = "ссылка скопирована"
    KStatus.TextColor3 = ACCENT
end)

-- ================== AXON ULTRA ==================
local function launchAxonUltra()
    local LoadGui = Instance.new("ScreenGui")
    LoadGui.Name = "AxonLoad"
    LoadGui.ResetOnSpawn = false
    LoadGui.IgnoreGuiInset = true
    LoadGui.DisplayOrder = 10000
    LoadGui.Parent = PlayerGui

    local LoadBG = Instance.new("Frame")
    LoadBG.Size = UDim2.new(1, 0, 1, 0)
    LoadBG.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    LoadBG.BorderSizePixel = 0
    LoadBG.BackgroundTransparency = 1
    LoadBG.Parent = LoadGui

    local LoadBox = Instance.new("Frame")
    LoadBox.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadBox.Size = UDim2.new(0, 380, 0, 160)
    LoadBox.Position = UDim2.new(0.5, 0, 0.5, 0)
    LoadBox.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    LoadBox.BorderSizePixel = 0
    LoadBox.BackgroundTransparency = 1
    LoadBox.Parent = LoadGui

    local LBStroke = Instance.new("UIStroke")
    LBStroke.Color = ACCENT
    LBStroke.Thickness = 1
    LBStroke.Transparency = 1
    LBStroke.Parent = LoadBox

    local LoadTitle = Instance.new("TextLabel")
    LoadTitle.Size = UDim2.new(1, 0, 0, 50)
    LoadTitle.Position = UDim2.new(0, 0, 0, 20)
    LoadTitle.BackgroundTransparency = 1
    LoadTitle.Text = "AXON ULTRA"
    LoadTitle.TextColor3 = ACCENT
    LoadTitle.TextTransparency = 1
    LoadTitle.Font = Enum.Font.Code
    LoadTitle.TextSize = 36
    LoadTitle.Parent = LoadBox

    local LoadSub = Instance.new("TextLabel")
    LoadSub.Size = UDim2.new(1, 0, 0, 20)
    LoadSub.Position = UDim2.new(0, 0, 0, 68)
    LoadSub.BackgroundTransparency = 1
    LoadSub.Text = "universal command hub"
    LoadSub.TextColor3 = DIM
    LoadSub.TextTransparency = 1
    LoadSub.Font = Enum.Font.Code
    LoadSub.TextSize = 11
    LoadSub.Parent = LoadBox

    local LB_BG = Instance.new("Frame")
    LB_BG.Size = UDim2.new(0.8, 0, 0, 8)
    LB_BG.Position = UDim2.new(0.1, 0, 0, 105)
    LB_BG.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    LB_BG.BorderSizePixel = 0
    LB_BG.BackgroundTransparency = 1
    LB_BG.Parent = LoadBox

    local LB = Instance.new("Frame")
    LB.Size = UDim2.new(0, 0, 1, 0)
    LB.BackgroundColor3 = ACCENT
    LB.BorderSizePixel = 0
    LB.Parent = LB_BG

    local LP = Instance.new("TextLabel")
    LP.Size = UDim2.new(1, 0, 0, 16)
    LP.Position = UDim2.new(0, 0, 0, 118)
    LP.BackgroundTransparency = 1
    LP.Text = "0%"
    LP.TextColor3 = DIM
    LP.TextTransparency = 1
    LP.Font = Enum.Font.Code
    LP.TextSize = 10
    LP.Parent = LoadBox

    task.spawn(function()
        local ti = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(LoadBG, ti, {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(LoadBox, ti, {BackgroundTransparency = 0}):Play()
        TweenService:Create(LBStroke, ti, {Transparency = 0}):Play()
        TweenService:Create(LoadTitle, ti, {TextTransparency = 0}):Play()
        TweenService:Create(LoadSub, ti, {TextTransparency = 0}):Play()
        TweenService:Create(LB_BG, ti, {BackgroundTransparency = 0}):Play()
        TweenService:Create(LP, ti, {TextTransparency = 0}):Play()

        for i = 0, 100, 2 do
            LB.Size = UDim2.new(i / 100, 0, 1, 0)
            LP.Text = i .. "%"
            task.wait(0.012)
        end
        task.wait(0.2)

        local out = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        TweenService:Create(LoadBG, out, {BackgroundTransparency = 1}):Play()
        TweenService:Create(LoadBox, out, {BackgroundTransparency = 1}):Play()
        TweenService:Create(LBStroke, out, {Transparency = 1}):Play()
        TweenService:Create(LoadTitle, out, {TextTransparency = 1}):Play()
        TweenService:Create(LoadSub, out, {TextTransparency = 1}):Play()
        TweenService:Create(LB_BG, out, {BackgroundTransparency = 1}):Play()
        TweenService:Create(LB, out, {BackgroundTransparency = 1}):Play()
        TweenService:Create(LP, out, {TextTransparency = 1}):Play()
        task.wait(0.6)
        LoadGui:Destroy()
    end)

    task.wait(2)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AxonUltra"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 9999
    ScreenGui.Parent = PlayerGui

    local Main = Instance.new("Frame")
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Size = UDim2.new(0, 680, 0, 220)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.Parent = ScreenGui

    local MS = Instance.new("UIStroke")
    MS.Color = ACCENT
    MS.Thickness = 1
    MS.Parent = Main

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 22)
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 8, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "AXON ULTRA — universal"
    Title.TextColor3 = ACCENT
    Title.Font = Enum.Font.Code
    Title.TextSize = 11
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 22, 0, 22)
    CloseBtn.Position = UDim2.new(1, -24, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = RED
    CloseBtn.Font = Enum.Font.Code
    CloseBtn.TextSize = 12
    CloseBtn.Parent = TitleBar

    local Log = Instance.new("ScrollingFrame")
    Log.Size = UDim2.new(1, -8, 1, -58)
    Log.Position = UDim2.new(0, 4, 0, 26)
    Log.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Log.BorderSizePixel = 0
    Log.ScrollBarThickness = 2
    Log.ScrollBarImageColor3 = ACCENT
    Log.CanvasSize = UDim2.new(0, 0, 0, 0)
    Log.Parent = Main

    local LogLayout = Instance.new("UIListLayout")
    LogLayout.Padding = UDim.new(0, 1)
    LogLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LogLayout.Parent = Log

    local CmdBar = Instance.new("Frame")
    CmdBar.Size = UDim2.new(1, -8, 0, 26)
    CmdBar.Position = UDim2.new(0, 4, 1, -30)
    CmdBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    CmdBar.BorderSizePixel = 0
    CmdBar.Parent = Main

    local Prefix = Instance.new("TextLabel")
    Prefix.Size = UDim2.new(0, 20, 1, 0)
    Prefix.Position = UDim2.new(0, 4, 0, 0)
    Prefix.BackgroundTransparency = 1
    Prefix.Text = ">"
    Prefix.TextColor3 = ACCENT
    Prefix.Font = Enum.Font.Code
    Prefix.TextSize = 12
    Prefix.Parent = CmdBar

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1, -28, 1, 0)
    Input.Position = UDim2.new(0, 22, 0, 0)
    Input.BackgroundTransparency = 1
    Input.Text = ""
    Input.PlaceholderText = "on god · off fly · help"
    Input.TextColor3 = TEXT
    Input.PlaceholderColor3 = Color3.fromRGB(90, 90, 90)
    Input.Font = Enum.Font.Code
    Input.TextSize = 11
    Input.TextXAlignment = Enum.TextXAlignment.Left
    Input.ClearTextOnFocus = false
    Input.Parent = CmdBar

    local S = {}
    local espObj = {}
    local flyConn, bv, bg = nil, nil, nil
    local godConn, antiFlingConn, autoHealConn, autoJumpConn, autoClickConn = nil, nil, nil, nil, nil
    local antiVoidConn, spinConn, auraConn, auraPart = nil, nil, nil, nil

    local function log(text, color)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, -4, 0, 13)
        l.BackgroundTransparency = 1
        l.Text = text
        l.TextColor3 = color or TEXT
        l.Font = Enum.Font.Code
        l.TextSize = 10
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = Log
        task.wait()
        Log.CanvasSize = UDim2.new(0, 0, 0, LogLayout.AbsoluteContentSize.Y + 6)
        Log.CanvasPosition = Vector2.new(0, LogLayout.AbsoluteContentSize.Y)
    end

    local function getChar() return LocalPlayer.Character end

    local function setSpeed(v)
        local c = getChar()
        if c then local h = c:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = v end end
    end

    local function setJump(v)
        local c = getChar()
        if c then local h = c:FindFirstChildOfClass("Humanoid") if h then h.UseJumpPower = true h.JumpPower = v end end
    end

    local function toggleGod(state)
        S.god = state
        if state then
            if godConn then godConn:Disconnect() end
            godConn = RunService.Heartbeat:Connect(function()
                local c = getChar()
                if c then
                    local h = c:FindFirstChildOfClass("Humanoid")
                    if h then h.MaxHealth = math.huge h.Health = math.huge end
                    if not c:FindFirstChild("ForceField") then
                        local ff = Instance.new("ForceField") ff.Visible = false ff.Parent = c
                    end
                end
            end)
        else
            if godConn then godConn:Disconnect() godConn = nil end
        end
    end

    local function toggleFly(state)
        S.fly = state
        local c = getChar()
        if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        local h = c:FindFirstChildOfClass("Humanoid")
        if not hrp or not h then return end
        if state then
            h.PlatformStand = true
            bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = hrp
            bg = Instance.new("BodyGyro")
            bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            bg.P = 1000 bg.D = 50 bg.Parent = hrp
            flyConn = RunService.Heartbeat:Connect(function()
                local m = Vector3.new(0, 0, 0)
                local cam = workspace.CurrentCamera
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then m = m + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then m = m - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then m = m - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then m = m + cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then m = m + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then m = m - Vector3.new(0, 1, 0) end
                if m.Magnitude > 0 then m = m.Unit * 80 end
                bv.Velocity = m bg.CFrame = cam.CFrame
            end)
        else
            h.PlatformStand = false
            if bv then bv:Destroy() bv = nil end
            if bg then bg:Destroy() bg = nil end
            if flyConn then flyConn:Disconnect() flyConn = nil end
        end
    end

    local function toggleESP(state)
        S.esp = state
        if state then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and not espObj[p] then
                    local h = Instance.new("Highlight")
                    h.FillColor = ACCENT
                    h.OutlineColor = Color3.new(1, 1, 1)
                    h.FillTransparency = 0.5
                    h.OutlineTransparency = 0
                    h.Adornee = p.Character
                    h.Parent = p.Character
                    espObj[p] = h
                end
            end
        else
            for _, h in pairs(espObj) do if h then h:Destroy() end end
            espObj = {}
        end
    end

    local function toggleAntiFling(state)
        S.antiFling = state
        if state then
            if antiFlingConn then antiFlingConn:Disconnect() end
            antiFlingConn = RunService.Heartbeat:Connect(function()
                local c = getChar()
                if c then
                    local hrp = c:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _, v in ipairs(hrp:GetChildren()) do
                            if v:IsA("BodyVelocity") or v:IsA("BodyAngularVelocity") or v:IsA("BodyForce") then v:Destroy() end
                        end
                    end
                    local h = c:FindFirstChildOfClass("Humanoid")
                    if h then h.PlatformStand = false end
                end
            end)
        else
            if antiFlingConn then antiFlingConn:Disconnect() antiFlingConn = nil end
        end
    end

    local function toggleAutoHeal(state)
        S.autoHeal = state
        if state then
            if autoHealConn then autoHealConn:Disconnect() end
            autoHealConn = RunService.Heartbeat:Connect(function()
                local c = getChar()
                if c then
                    local h = c:FindFirstChildOfClass("Humanoid")
                    if h and h.Health < h.MaxHealth then h.Health = h.MaxHealth end
                end
            end)
        else
            if autoHealConn then autoHealConn:Disconnect() autoHealConn = nil end
        end
    end

    local function toggleAutoJump(state)
        S.autoJump = state
        if state then
            if autoJumpConn then autoJumpConn:Disconnect() end
            autoJumpConn = RunService.Heartbeat:Connect(function()
                local c = getChar()
                if c then local h = c:FindFirstChildOfClass("Humanoid") if h then h.Jump = true end end
            end)
        else
            if autoJumpConn then autoJumpConn:Disconnect() autoJumpConn = nil end
        end
    end

    local function toggleAutoClick(state)
        S.autoClick = state
        if state then
            if autoClickConn then autoClickConn:Disconnect() end
            autoClickConn = RunService.Heartbeat:Connect(function()
                pcall(function() VirtualUser:ClickButton1(Vector2.new(0, 0)) end)
            end)
        else
            if autoClickConn then autoClickConn:Disconnect() autoClickConn = nil end
        end
    end

    local function toggleAntiVoid(state)
        S.antiVoid = state
        if state then
            if antiVoidConn then antiVoidConn:Disconnect() end
            antiVoidConn = RunService.Heartbeat:Connect(function()
                local c = getChar()
                if c then
                    local hrp = c:FindFirstChild("HumanoidRootPart")
                    if hrp and hrp.Position.Y < -50 then hrp.CFrame = CFrame.new(0, 50, 0) end
                end
            end)
        else
            if antiVoidConn then antiVoidConn:Disconnect() antiVoidConn = nil end
        end
    end

    local function toggleSpin(state)
        S.spin = state
        if state then
            spinConn = RunService.Heartbeat:Connect(function()
                local c = getChar()
                if c then
                    local hrp = c:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(20), 0) end
                end
            end)
        else
            if spinConn then spinConn:Disconnect() spinConn = nil end
        end
    end

    local function toggleAura(state)
        S.aura = state
        if state then
            auraPart = Instance.new("Part")
            auraPart.Size = Vector3.new(6, 6, 6)
            auraPart.Shape = Enum.PartType.Ball
            auraPart.Material = Enum.Material.Neon
            auraPart.Color = ACCENT
            auraPart.Anchored = true
            auraPart.CanCollide = false
            auraPart.Transparency = 0.5
            auraPart.Parent = workspace
            auraConn = RunService.Heartbeat:Connect(function()
                local c = getChar()
                if c and auraPart then
                    local hrp = c:FindFirstChild("HumanoidRootPart")
                    if hrp then auraPart.Position = hrp.Position end
                end
            end)
        else
            if auraConn then auraConn:Disconnect() auraConn = nil end
            if auraPart then auraPart:Destroy() auraPart = nil end
        end
    end

    local features = {
        god = {name="god", cb=toggleGod, aliases={"god","godmode","immortal"}},
        fly = {name="fly", cb=toggleFly, aliases={"fly"}},
        esp = {name="esp", cb=toggleESP, aliases={"esp"}},
        noclip = {name="noclip", cb=function(v) S.noclip = v end, aliases={"noclip"}},
        jump = {name="inf jump", cb=function(v) S.infJump = v end, aliases={"jump","infjump","infinitejump","ij"}},
        antifling = {name="anti fling", cb=toggleAntiFling, aliases={"antifling","af"}},
        autoheal = {name="auto heal", cb=toggleAutoHeal, aliases={"autoheal","heal"}},
        autoJump = {name="auto jump", cb=toggleAutoJump, aliases={"autojump","aj"}},
        autoclick = {name="auto click", cb=toggleAutoClick, aliases={"autoclick","ac"}},
        antivoid = {name="anti void", cb=toggleAntiVoid, aliases={"antivoid","av"}},
        spin = {name="spin", cb=toggleSpin, aliases={"spin"}},
        aura = {name="aura", cb=toggleAura, aliases={"aura"}},
    }

    local function findFeature(name)
        name = string.lower(name):gsub("%s", "")
        for _, f in pairs(features) do
            for _, a in ipairs(f.aliases) do
                if a == name then return f end
            end
        end
        return nil
    end

    local function handleCmd(cmd)
        local words = {}
        for w in string.gmatch(cmd, "%S+") do table.insert(words, w) end
        if #words == 0 then return end
        local first = string.lower(words[1])

        if first == "help" then
            log("-- команды --", ACCENT)
            log("on <фича> / off <фича>", TEXT)
            log("speed <n> · jump <n> · gravity <n>", TEXT)
            log("tp <ник> · reset · clear · features", TEXT)
            return
        end

        if first == "clear" then
            for _, c in ipairs(Log:GetChildren()) do
                if c:IsA("TextLabel") then c:Destroy() end
            end
            Log.CanvasSize = UDim2.new(0, 0, 0, 0)
            return
        end

        if first == "features" or first == "list" then
            log("-- доступные фичи --", ACCENT)
            for _, f in pairs(features) do
                log("  " .. f.name, DIM)
            end
            return
        end

        if first == "on" or first == "off" then
            local state = (first == "on")
            local featName = words[2]
            if not featName then log("[err] укажи фичу", RED) return end
            local f = findFeature(featName)
            if f then
                f.cb(state)
                log("[" .. (state and "ok" or "off") .. "] " .. f.name .. ": " .. (state and "ON" or "OFF"), state and GREEN or RED)
            else
                log("[err] фича не найдена: " .. featName, RED)
            end
            return
        end

        if first == "speed" then
            local v = tonumber(words[2]) or 100
            setSpeed(v) log("[ok] speed = " .. v, GREEN) return
        end
        if first == "jump" and words[2] and tonumber(words[2]) then
            local v = tonumber(words[2])
            setJump(v) log("[ok] jump = " .. v, GREEN) return
        end
        if first == "gravity" then
            local v = tonumber(words[2]) or 0
            workspace.Gravity = v log("[ok] gravity = " .. v, GREEN) return
        end
        if first == "tp" or first == "goto" then
            if words[2] then
                for _, p in ipairs(Players:GetPlayers()) do
                    if string.find(string.lower(p.Name), string.lower(words[2])) and p ~= LocalPlayer then
                        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local c = getChar()
                            if c and c:FindFirstChild("HumanoidRootPart") then
                                c.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                                log("[ok] tp к " .. p.Name, GREEN)
                            end
                        end
                        return
                    end
                end
                log("[err] не найден", RED)
            end
            return
        end
        if first == "reset" or first == "respawn" then
            local c = getChar()
            if c then local h = c:FindFirstChildOfClass("Humanoid") if h then h.Health = 0 end end
            log("[ok] respawn", GREEN) return
        end
        if first == "f3x" then
            log("[info] F3X загрузка...", ACCENT)
            task.spawn(function()
                pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/bqmb3/f3x-wrapper/main/loader.lua"))() end)
                log("[ok] F3X выдан", GREEN)
            end)
            return
        end
        if first == "fullbright" then
            Lighting.Brightness = 2
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            log("[ok] fullbright", GREEN) return
        end

        log("[err] неизвестная команда: " .. cmd, RED)
        log("напиши 'help'", DIM)
    end

    Input.FocusLost:Connect(function(enter)
        if enter then
            local txt = Input.Text
            if txt and txt ~= "" then
                log("> " .. txt, ACCENT)
                handleCmd(txt)
                Input.Text = ""
            end
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    RunService.Stepped:Connect(function()
        if S.noclip then
            local c = getChar()
            if c then
                for _, p in ipairs(c:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end
    end)

    UserInputService.JumpRequest:Connect(function()
        if S.infJump then
            local c = getChar()
            if c then
                local h = c:FindFirstChildOfClass("Humanoid")
                if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end
    end)

    Players.PlayerAdded:Connect(function(p)
        p.CharacterAdded:Connect(function()
            task.wait(1)
            if S.esp and p ~= LocalPlayer and p.Character and not espObj[p] then
                local h = Instance.new("Highlight")
                h.FillColor = ACCENT
                h.OutlineColor = Color3.new(1, 1, 1)
                h.FillTransparency = 0.5
                h.OutlineTransparency = 0
                h.Adornee = p.Character
                h.Parent = p.Character
                espObj[p] = h
            end
        end)
    end)

    Players.PlayerRemoving:Connect(function(p)
        if espObj[p] then espObj[p]:Destroy() espObj[p] = nil end
    end)

    log("-- AXON ULTRA --", ACCENT)
    log("on/off <фича> · 'features' · 'help'", DIM)
end

KBtn.MouseButton1Click:Connect(function()
    checkKey(function(valid)
        if valid then
            KBtn.Text = "ЗАГРУЗКА..."
            KStatus.Text = "ключ верный! загрузка..."
            task.wait(0.5)
            KeyGui:Destroy()
            launchAxonUltra()
        else
            KBtn.Text = "ВОЙТИ"
        end
    end)
end)
