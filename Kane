-- Kanezanz Script (Delta Mobile - Cyan Theme & 100% Instant Silent Aim)
local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    Workspace = game:GetService("Workspace"),
    ReplicatedStorage = game:GetService("ReplicatedStorage")
}

local LocalPlayer = Services.Players.LocalPlayer

-- ระบบหา Parent UI บน Delta (กันโดนสแกนลบ)
local function getUIContainer()
    if gethui then
        return gethui()
    elseif game:GetService("CoreGui"):FindFirstChild("RobloxGui") then
        return game:GetService("CoreGui")
    else
        return LocalPlayer:WaitForChild("PlayerGui")
    end
end

local ParentContainer = getUIContainer()

-- ลบ UI เก่าออกก่อน
pcall(function()
    if ParentContainer:FindFirstChild("KanezanzThaiUI") then
        ParentContainer.KanezanzThaiUI:Destroy()
    end
end)

-- 1. Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KanezanzThaiUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = ParentContainer

-- 2. ปุ่มเปิด-ปิดทรงกลม สีฟ้า
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "KanezanzToggle"
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.04, 0, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.Text = "K"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 24
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Active = true
ToggleBtn.Draggable = true

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 2
ToggleStroke.Color = Color3.fromRGB(150, 230, 255)
ToggleStroke.Parent = ToggleBtn

-- 3. หน้าต่างหลัก (Cyan Sky-Blue)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 230, 0, 290)
MainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 35)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 10)
FrameCorner.Parent = MainFrame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Thickness = 2
FrameStroke.Color = Color3.fromRGB(0, 150, 255)
FrameStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Kanezanz Script 🇹🇭"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout")
UIList.Parent = MainFrame
UIList.Padding = UDim.new(0, 6)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local function createButton(defaultText, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Size = UDim2.new(0.9, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(15, 35, 60)
    btn.Text = defaultText
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 15

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(0, 120, 200)
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

-- ==================== ระบบยิงฆาตกรทะลุกำแพง 100% ====================
local function killMurdererWallbang()
    pcall(function()
        local murderer = nil
        -- ตามหาฆาตกร
        for _, p in pairs(Services.Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                if p.Character:FindFirstChild("Knife") or (p:FindFirstChild("Backpack") and p.Backpack:FindFirstChild("Knife")) then
                    murderer = p
                    break
                end
            end
        end

        if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
            local char = LocalPlayer.Character
            local gun = char:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
            
            if gun then
                -- ควักปืนออกมาสวมใส่ทันที
                if gun.Parent == LocalPlayer.Backpack then
                    char.Humanoid:EquipTool(gun)
                    task.wait(0.02)
                end

                local targetPart = murderer.Character:FindFirstChild("Head") or murderer.Character.HumanoidRootPart
                local targetPos = targetPart.Position

                -- ส่งสัญญาณ RemoteEvent ยิงตรงพิกัดฆาตกรทันที (ยิงทะลุกำแพงจากที่เดิม)
                if gun:FindFirstChild("Shoot") then
                    gun.Shoot:FireServer(targetPos)
                elseif gun:FindFirstChild("KnifeServer") then
                    gun.KnifeServer:FireServer(targetPos)
                else
                    local shootRemote = gun:FindFirstChildOfClass("RemoteEvent") or Services.ReplicatedStorage:FindFirstChild("ShootGun", true)
                    if shootRemote then
                        shootRemote:FireServer(targetPos, targetPart)
                    else
                        gun:Activate()
                    end
                end
            end
        end
    end)
end

-- ==================== ระบบวาร์ปไปเอาปืน 0.05 วิ แล้วกลับ ====================
local function fastGetGunAndReturn()
    pcall(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end

        local hrp = char.HumanoidRootPart
        local gunDrop = nil

        for _, obj in pairs(Services.Workspace:GetDescendants()) do
            if obj.Name == "GunDrop" or (obj:IsA("Tool") and obj.Name:lower():find("gun")) then
                if obj:IsA("BasePart") then
                    gunDrop = obj
                    break
                elseif obj:FindFirstChild("Handle") then
                    gunDrop = obj.Handle
                    break
                end
            end
        end

        if gunDrop then
            local originalCFrame = hrp.CFrame
            hrp.CFrame = gunDrop.CFrame + Vector3.new(0, 1, 0)
            task.wait(0.05)
            hrp.CFrame = originalCFrame
        end
    end)
end

-- ==================== ปุ่มเมนูภาษาไทย ====================

-- 1. เดินทะลุกำแพง (Noclip)
local isNoclip = false
Services.RunService.Stepped:Connect(function()
    if isNoclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

createButton("1. เดินทะลุกำแพง : ปิด ❌", function(btn)
    isNoclip = not isNoclip
    btn.Text = "1. เดินทะลุกำแพง : " .. (isNoclip and "เปิด ✅" or "ปิด ❌")
    btn.TextColor3 = isNoclip and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = isNoclip and Color3.fromRGB(0, 60, 90) or Color3.fromRGB(15, 35, 60)
end)

-- 2. อมตะ (Godmode)
local isGod = false
createButton("2. อมตะ (กันตาย) : ปิด ❌", function(btn)
    isGod = not isGod
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, not isGod)
    end
    btn.Text = "2. อมตะ (กันตาย) : " .. (isGod and "เปิด ✅" or "ปิด ❌")
    btn.TextColor3 = isGod and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = isGod and Color3.fromRGB(0, 60, 90) or Color3.fromRGB(15, 35, 60)
end)

-- 3. วาร์ปเอาปืนและกลับที่เดิม
createButton("3. วาร์ปเอาปืนและกลับที่เดิม", function()
    fastGetGunAndReturn()
end)

-- 4. วาร์ปเก็บปืนออโต้
local isAutoGun = false
task.spawn(function()
    while task.wait(0.2) do
        if isAutoGun then
            fastGetGunAndReturn()
        end
    end
end)

createButton("4. วาร์ปเก็บปืนออโต้ : ปิด ❌", function(btn)
    isAutoGun = not isAutoGun
    btn.Text = "4. วาร์ปเก็บปืนออโต้ : " .. (isAutoGun and "เปิด ✅" or "ปิด ❌")
    btn.TextColor3 = isAutoGun and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = isAutoGun and Color3.fromRGB(0, 60, 90) or Color3.fromRGB(15, 35, 60)
end)

-- 5. ยิงฆาตกรทะลุกำแพง อัตโนมัติ (ดับ 100%)
local isAutoShoot = false
task.spawn(function()
    while task.wait(0.15) do
        if isAutoShoot then
            killMurdererWallbang()
        end
    end
end)

createButton("5. ยิงฆาตกรออโต้ : ปิด ❌", function(btn)
    isAutoShoot = not isAutoShoot
    btn.Text = "5. ยิงฆาตกรออโต้ : " .. (isAutoShoot and "เปิด ✅" or "ปิด ❌")
    btn.TextColor3 = isAutoShoot and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = isAutoShoot and Color3.fromRGB(0, 60, 90) or Color3.fromRGB(15, 35, 60)
end)
