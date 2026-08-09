-- Kanezanz Script (MM2: Fixed Fly, Inf Jump, Fling & Godmode)
local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    Workspace = game:GetService("Workspace"),
    UserInputService = game:GetService("UserInputService")
}

local LocalPlayer = Services.Players.LocalPlayer

-- ระบบหาที่เก็บ UI ที่ปลอดภัย
local CoreGui = game:GetService("CoreGui")
local ParentContainer = (gethui and gethui()) or (syn and syn.protect_gui and syn.protect_gui(Instance.new("ScreenGui"))) or CoreGui

-- ล้าง UI เก่า
pcall(function()
    if ParentContainer:FindFirstChild("KanezanzMM2UI") then
        ParentContainer.KanezanzMM2UI:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KanezanzMM2UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = ParentContainer

-- ปุ่มเปิด-ปิด [K]
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "KanezanzToggle"
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0.04, 0, 0.3, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.Text = "K"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 22
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Active = true
ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

-- หน้าต่างหลัก
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 420, 0, 380)
MainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 25, 40)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local FrameStroke = Instance.new("UIStroke", MainFrame)
FrameStroke.Thickness = 2
FrameStroke.Color = Color3.fromRGB(0, 150, 255)

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "Kanezanz MM2 🇹🇭"
Title.TextColor3 = Color3.fromRGB(0, 210, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- แถบเลือกแท็บฝั่งซ้าย
local TabBar = Instance.new("Frame")
TabBar.Parent = MainFrame
TabBar.Size = UDim2.new(0, 120, 1, -45)
TabBar.Position = UDim2.new(0, 8, 0, 38)
TabBar.BackgroundColor3 = Color3.fromRGB(25, 40, 65)
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 8)

local TabList = Instance.new("UIListLayout", TabBar)
TabList.Padding = UDim.new(0, 6)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local TabPadding = Instance.new("UIPadding", TabBar)
TabPadding.PaddingTop = UDim.new(0, 8)

-- พื้นที่แสดงเนื้อหาฝั่งขวา
local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainFrame
ContentArea.Size = UDim2.new(1, -142, 1, -45)
ContentArea.Position = UDim2.new(0, 134, 0, 38)
ContentArea.BackgroundTransparency = 1

local function createPage()
    local page = Instance.new("ScrollingFrame", ContentArea)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 0, 360)
    page.ScrollBarThickness = 4
    page.Visible = false
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    return page
end

local Tab1Page = createPage()
local Tab2Page = createPage()
Tab1Page.Visible = true

local function createTabButton(text, pageToShow)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.BackgroundColor3 = Color3.fromRGB(20, 32, 50)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        Tab1Page.Visible = false
        Tab2Page.Visible = false
        pageToShow.Visible = true
        
        for _, child in pairs(TabBar:GetChildren()) do
            if child:IsA("TextButton") then
                child.TextColor3 = Color3.fromRGB(180, 180, 180)
                child.BackgroundColor3 = Color3.fromRGB(20, 32, 50)
            end
        end
        btn.TextColor3 = Color3.fromRGB(0, 220, 255)
        btn.BackgroundColor3 = Color3.fromRGB(35, 70, 110)
    end)
    return btn
end

local Tab1Btn = createTabButton("🎮 ทั่วไป", Tab1Page)
Tab1Btn.TextColor3 = Color3.fromRGB(0, 220, 255)
Tab1Btn.BackgroundColor3 = Color3.fromRGB(35, 70, 110)

createTabButton("🔪 ระบบ MM2", Tab2Page)

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(22, 45, 75)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(0, 120, 200)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

-- ==================== แท็บ 1: เกมทั่วไป ====================
local isFlying = false
local flySpeed = 50
local flyPart

createButton(Tab1Page, "บินอิสระ (WASD) : ปิด ❌", function(btn)
    isFlying = not isFlying
    btn.Text = "บินอิสระ (WASD) : " .. (isFlying and "เปิด ✅" or "ปิด ❌")
    btn.TextColor3 = isFlying and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if isFlying and hrp then
        if flyPart then flyPart:Destroy() end
        flyPart = Instance.new("Part", workspace)
        flyPart.Size = Vector3.new(1, 1, 1)
        flyPart.Transparency = 1
        flyPart.CanCollide = false
        flyPart.CFrame = hrp.CFrame
        
        local bv = Instance.new("BodyVelocity", flyPart)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        
        task.spawn(function()
            while isFlying and flyPart and char and char:FindFirstChild("Humanoid") do
                local cam = workspace.CurrentCamera
                local moveDir = Vector3.new()
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.new(0, 1, 0) end
                
                bv.Velocity = moveDir * flySpeed
                hrp.CFrame = CFrame.new(flyPart.Position, flyPart.Position + cam.CFrame.LookVector)
                hrp.Velocity = Vector3.new(0, 0, 0)
                Services.RunService.RenderStepped:Wait()
            end
            if flyPart then flyPart:Destroy() flyPart = nil end
        end)
    else
        if flyPart then flyPart:Destroy() flyPart = nil end
    end
end)

local isInfJump = false
Services.UserInputService.JumpRequest:Connect(function()
    if isInfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

createButton(Tab1Page, "กระโดดไม่จำกัด (Inf Jump) : ปิด ❌", function(btn)
    isInfJump = not isInfJump
    btn.Text = "กระโดดไม่จำกัด (Inf Jump) : " .. (isInfJump and "เปิด ✅" or "ปิด ❌")
    btn.TextColor3 = isInfJump and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
end)

local isNoclip = false
Services.RunService.Stepped:Connect(function()
    if isNoclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)
createButton(Tab1Page, "เดินทะลุกำแพง : ปิด ❌", function(btn)
    isNoclip = not isNoclip
    btn.Text = "เดินทะลุกำแพง : " .. (isNoclip and "เปิด ✅" or "ปิด ❌")
end)

local isGodMode = false
createButton(Tab1Page, "🛡️ อมตะ (Godmode) : ปิด ❌", function(btn)
    isGodMode = not isGodMode
    btn.Text = "🛡️ อมตะ (Godmode) : " .. (isGodMode and "เปิด ✅" or "ปิด ❌")
    btn.TextColor3 = isGodMode and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
    
    task.spawn(function()
        while isGodMode do
            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.MaxHealth = math.huge
                    hum.Health = math.huge
                end
            end)
            task.wait(0.5)
        end
    end)
end)

local function executeFlingOnTarget(targetPlayer)
    pcall(function()
        local char = LocalPlayer.Character
        local targetChar = targetPlayer.Character
        if not char or not targetChar then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then return end

        local oldCFrame = hrp.CFrame
        if hum then hum.PlatformStand = true end

        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end

        local bV = Instance.new("BodyVelocity", hrp)
        bV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bV.Velocity = Vector3.new(99999, 99999, 99999)

        local bA = Instance.new("BodyAngularVelocity", hrp)
        bA.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bA.AngularVelocity = Vector3.new(99999, 99999, 99999)

        local startTime = tick()
        while tick() - startTime < 1.2 do
            if not targetHRP or not targetHRP.Parent then break end
            hrp.CFrame = targetHRP.CFrame * CFrame.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2))
            Services.RunService.RenderStepped:Wait()
        end

        bV:Destroy()
        bA:Destroy()
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.RotVelocity = Vector3.new(0, 0, 0)
        hrp.CFrame = oldCFrame
        if hum then hum.PlatformStand = false end
    end)
end

-- ==================== แท็บ 2: ระบบ MM2 ====================
createButton(Tab2Page, "🔪 ดึงทุกคนมาฆ่าทีเดียว", function()
    pcall(function()
        local char = LocalPlayer.Character
        local knife = char and char:FindFirstChild("Knife") or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Knife"))
        if not knife then return end
        if knife.Parent == LocalPlayer.Backpack then char.Humanoid:EquipTool(knife) end
        local hrp = char.HumanoidRootPart
        for _, p in pairs(Services.Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 0, -2.5)
            end
        end
        task.wait(0.05)
        knife:Activate()
    end)
end)

createButton(Tab2Page, "🎯 วาร์ปไปเก็บปืนที่ตกพื้น", function()
    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for _, obj in pairs(Services.Workspace:GetChildren()) do
            if obj.Name == "GunDrop" or (obj:IsA("Tool") and obj.Name == "Gun") then
                hrp.CFrame = obj.Handle.CFrame
                break
            end
        end
    end)
end)

createButton(Tab2Page, "🔫 ยิงฆาตกรอัตโนมัติ (ถือปืน)", function()
    pcall(function()
        local char = LocalPlayer.Character
        local gun = char and char:FindFirstChild("Gun") or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Gun"))
        if not gun then return end
        if gun.Parent == LocalPlayer.Backpack then char.Humanoid:EquipTool(gun) end
        
        local target = nil
        for _, p in pairs(Services.Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if p.Character:FindFirstChild("Knife") or (p.Backpack and p.Backpack:FindFirstChild("Knife")) then
                    target = p.Character
                    break
                end
            end
        end
        
        if target and target:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            hrp.CFrame = CFrame.new(hrp.Position, target.HumanoidRootPart.Position)
            task.wait(0.1)
            gun:Activate()
        end
    end)
end)

createButton(Tab2Page, "🌀 Fling ฆาตกร", function()
    task.spawn(function()
        local targetPlayer = nil
        for _, p in pairs(Services.Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if p.Character:FindFirstChild("Knife") or (p.Backpack and p.Backpack:FindFirstChild("Knife")) then
                    targetPlayer = p
                    break
                end
            end
        end
        if targetPlayer then
            executeFlingOnTarget(targetPlayer)
        end
    end)
end)

createButton(Tab2Page, "🌀 Fling นายอำเภอ", function()
    task.spawn(function()
        local targetPlayer = nil
        for _, p in pairs(Services.Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if p.Character:FindFirstChild("Gun") or (p.Backpack and p.Backpack:FindFirstChild("Gun")) then
                    targetPlayer = p
                    break
                end
            end
        end
        if targetPlayer then
            executeFlingOnTarget(targetPlayer)
        end
    end)
end)
