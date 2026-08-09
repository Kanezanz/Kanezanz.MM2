-- Kanezanz MM2 (No Fly Version)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("KanezanzMM2UI") then
    PlayerGui.KanezanzMM2UI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "KanezanzMM2UI"
ScreenGui.ResetOnSpawn = false

-- ปุ่มเปิด/ปิด MENU
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

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -10, 1, -45)
Scroll.Position = UDim2.new(0, 5, 0, 40)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 380)
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

-- 1. กระโดดไม่จำกัด
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

-- 2. เดินทะลุกำแพง
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

-- 3. อมตะ
local isGod = false
addBtn("🛡️ อมตะ (Godmode) : ปิด ❌", function(btn)
    isGod = not isGod
    btn.Text = "🛡️ อมตะ (Godmode) : " .. (isGod and "เปิด ✅" or "ปิด ❌")
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

-- 4. ดึงทุกคนมาฆ่า
addBtn("🔪 ดึงทุกคนมาฆ่าทีเดียว", function()
    pcall(function()
        local char = LocalPlayer.Character
        local knife = char and char:FindFirstChild("Knife") or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Knife"))
        if not knife then return end
        if knife.Parent == LocalPlayer.Backpack then char.Humanoid:EquipTool(knife) end
        local hrp = char.HumanoidRootPart
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 0, -2.5)
            end
        end
        task.wait(0.05)
        knife:Activate()
    end)
end)

-- 5. วาร์ปเก็บปืน
addBtn("🎯 วาร์ปไปเก็บปืนที่ตกพื้น", function()
    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj.Name == "GunDrop" or (obj:IsA("Tool") and obj.Name == "Gun") then
                hrp.CFrame = obj.Handle.CFrame
                break
            end
        end
    end)
end)

-- 6. ยิงฆาตกรออโต้
addBtn("🔫 ยิงฆาตกรอัตโนมัติ (ถือปืน)", function()
    pcall(function()
        local char = LocalPlayer.Character
        local gun = char and char:FindFirstChild("Gun") or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Gun"))
        if not gun then return end
        if gun.Parent == LocalPlayer.Backpack then char.Humanoid:EquipTool(gun) end
        
        local target = nil
        for _, p in pairs(Players:GetPlayers()) do
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

-- ฟังก์ชัน Fling พื้นฐาน
local function executeFling(targetPlayer)
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

        local startTime = tick()
        while tick() - startTime < 1 do
            if not targetHRP or not targetHRP.Parent then break end
            hrp.CFrame = targetHRP.CFrame
            RunService.RenderStepped:Wait()
        end

        bV:Destroy()
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.CFrame = oldCFrame
        if hum then hum.PlatformStand = false end
    end)
end

-- 7. Fling ฆาตกร
addBtn("🌀 Fling ฆาตกร", function()
    task.spawn(function()
        local target = nil
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if p.Character:FindFirstChild("Knife") or (p.Backpack and p.Backpack:FindFirstChild("Knife")) then
                    target = p
                    break
                end
            end
        end
        if target then executeFling(target) end
    end)
end)

-- 8. Fling นายอำเภอ
addBtn("🌀 Fling นายอำเภอ", function()
    task.spawn(function()
        local target = nil
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if p.Character:FindFirstChild("Gun") or (p.Backpack and p.Backpack:FindFirstChild("Gun")) then
                    target = p
                    break
                end
            end
        end
        if target then executeFling(target) end
    end)
end)
