-- Kanezanz MM2 Mobile UI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ล้างของเก่า
if PlayerGui:FindFirstChild("KanezanzMobileUI") then
    PlayerGui.KanezanzMobileUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "KanezanzMobileUI"
ScreenGui.ResetOnSpawn = false

-- ปุ่มเปิด/ปิด (ย้ายมุมซ้ายบนให้กดง่ายบนจอโทรศัพท์)
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
ToggleBtn.Text = "MENU"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 12
ToggleBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- หน้าต่างหลัก
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 320)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "Kanezanz MM2 (Mobile)"
Title.TextColor3 = Color3.fromRGB(0, 220, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- พื้นที่เลื่อนปุ่ม
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -10, 1, -45)
Scroll.Position = UDim2.new(0, 5, 0, 40)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 350)
Scroll.ScrollBarThickness = 4

local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 6)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function addBtn(text, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(35, 45, 60)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
end

-- ฟังก์ชันบิน (มือถือปรับให้ใช้ปุ่มกดเปิดปิดง่ายๆ)
local isFlying = false
local bv, bg
addBtn("บินอิสระ (Fly) : ปิด ❌", function(btn)
    isFlying = not isFlying
    btn.Text = "บินอิสระ (Fly) : " .. (isFlying and "เปิด ✅" or "ปิด ❌")
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if isFlying and hrp then
        bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            while isFlying and hrp and hrp.Parent do
                local cam = workspace.CurrentCamera
                bg.CFrame = cam.CFrame
                bv.Velocity = cam.CFrame.LookVector * 50
                RunService.RenderStepped:Wait()
            end
        end)
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

-- กระโดดไม่จำกัด
local isInfJump = false
addBtn("กระโดดไม่จำกัด : ปิด ❌", function(btn)
    isInfJump = not isInfJump
    btn.Text = "กระโดดไม่จำกัด : " .. (isInfJump and "เปิด ✅" or "ปิด ❌")
end)

UserInputService.JumpRequest:Connect(function()
    if isInfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- เดินทะลุ
addBtn("เดินทะลุกำแพง (Noclip)", function(btn)
    RunService.Stepped:Connect(function()
        if LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
    btn.Text = "เดินทะลุกำแพง : เปิดแล้ว ✅"
end)

-- อมตะ
local isGod = false
addBtn("อมตะ (Godmode) : ปิด ❌", function(btn)
    isGod = not isGod
    btn.Text = "อมตะ (Godmode) : " .. (isGod and "เปิด ✅" or "ปิด ❌")
    task.spawn(function()
        while isGod do
            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.MaxHealth = math.huge hum.Health = math.huge end
            end)
            task.wait(0.5)
        end
    end)
end)

-- Fling ฆาตกร
addBtn("🌀 Fling ฆาตกร", function()
    task.spawn(function()
        local target = nil
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if p.Character:FindFirstChild("Knife") or (p.Backpack and p.Backpack:FindFirstChild("Knife")) then
                    target = p.Character
                    break
                end
            end
        end
        if target and target:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local oldCF = hrp.CFrame
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = true end
            
            local bv = Instance.new("BodyVelocity", hrp)
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Velocity = Vector3.new(99999, 99999, 99999)
            
            local start = tick()
            while tick() - start < 1 and target:FindFirstChild("HumanoidRootPart") do
                hrp.CFrame = target.HumanoidRootPart.CFrame
                RunService.RenderStepped:Wait()
            end
            bv:Destroy()
            hrp.CFrame = oldCF
            if hum then hum.PlatformStand = false end
        end
    end)
end)

-- Fling นายอำเภอ
addBtn("🌀 Fling นายอำเภอ", function()
    task.spawn(function()
        local target = nil
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if p.Character:FindFirstChild("Gun") or (p.Backpack and p.Backpack:FindFirstChild("Gun")) then
                    target = p.Character
                    break
                end
            end
        end
        if target and target:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local oldCF = hrp.CFrame
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = true end
            
            local bv = Instance.new("BodyVelocity", hrp)
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Velocity = Vector3.new(99999, 99999, 99999)
            
            local start = tick()
            while tick() - start < 1 and target:FindFirstChild("HumanoidRootPart") do
                hrp.CFrame = target.HumanoidRootPart.CFrame
                RunService.RenderStepped:Wait()
            end
            bv:Destroy()
            hrp.CFrame = oldCF
            if hum then hum.PlatformStand = false end
        end
    end)
end)
