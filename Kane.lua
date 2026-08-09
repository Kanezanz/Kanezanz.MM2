-- Kanezanz Script (Dual Tab UI & Smart Warning Fling System)
local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    Workspace = game:GetService("Workspace"),
    UserInputService = game:GetService("UserInputService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage")
}

local LocalPlayer = Services.Players.LocalPlayer

-- ตารางบันทึกรายชื่อคนที่โดน Fling ไปแล้วในรอบนี้
local FlingHistory = {}

-- เช็คการเกิด/ตาย เพื่อรีเซ็ตประวัติเมื่อจบ/เริ่มรอบใหม่
Services.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        FlingHistory[player.UserId] = nil
    end)
end)

for _, p in pairs(Services.Players:GetPlayers()) do
    p.CharacterAdded:Connect(function()
        FlingHistory[p.UserId] = nil
    end)
end

-- หาพื้นที่ Parent สำหรับสร้าง UI บน Delta
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
    if ParentContainer:FindFirstChild("KanezanzDualTabUI") then
        ParentContainer.KanezanzDualTabUI:Destroy()
    end
end)

-- 1. ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KanezanzDualTabUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = ParentContainer

-- 2. ปุ่มวงกลมสีฟ้า [K] เปิด-ปิด
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

-- 3. หน้าต่างหลัก (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 320, 0, 320)
MainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
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

-- หัวข้อสคริปต์
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "Kanezanz Script 🇹🇭"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- 4. แถบเลือกโหมดด้านซ้าย (Side Tab Bar)
local TabBar = Instance.new("Frame")
TabBar.Parent = MainFrame
TabBar.Size = UDim2.new(0, 95, 1, -40)
TabBar.Position = UDim2.new(0, 5, 0, 35)
TabBar.BackgroundColor3 = Color3.fromRGB(15, 28, 48)

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 8)
TabBarCorner.Parent = TabBar

local TabList = Instance.new("UIListLayout")
TabList.Parent = TabBar
TabList.Padding = UDim.new(0, 5)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- พื้นที่แสดงเนื้อหาด้านขวา (Content Area)
local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainFrame
ContentArea.Size = UDim2.new(1, -115, 1, -40)
ContentArea.Position = UDim2.new(0, 105, 0, 35)
ContentArea.BackgroundTransparency = 1

-- หน้าแท็บ 1 และ 2
local Tab1Page = Instance.new("ScrollingFrame")
Tab1Page.Parent = ContentArea
Tab1Page.Size = UDim2.new(1, 0, 1, 0)
Tab1Page.BackgroundTransparency = 1
Tab1Page.CanvasSize = UDim2.new(0, 0, 0, 310)
Tab1Page.ScrollBarThickness = 3
Tab1Page.Visible = true

local Tab1List = Instance.new("UIListLayout")
Tab1List.Parent = Tab1Page
Tab1List.Padding = UDim.new(0, 5)

local Tab2Page = Instance.new("ScrollingFrame")
Tab2Page.Parent = ContentArea
Tab2Page.Size = UDim2.new(1, 0, 1, 0)
Tab2Page.BackgroundTransparency = 1
Tab2Page.CanvasSize = UDim2.new(0, 0, 0, 250)
Tab2Page.ScrollBarThickness = 3
Tab2Page.Visible = false

local Tab2List = Instance.new("UIListLayout")
Tab2List.Parent = Tab2Page
Tab2List.Padding = UDim.new(0, 6)

-- ปุ่มสลับแท็บ
local Tab1Btn = Instance.new("TextButton")
Tab1Btn.Parent = TabBar
Tab1Btn.Size = UDim2.new(0.9, 0, 0, 35)
Tab1Btn.Text = "🎮 เกมทั่วไป"
Tab1Btn.TextColor3 = Color3.fromRGB(0, 200, 255)
Tab1Btn.BackgroundColor3 = Color3.fromRGB(20, 45, 75)
Tab1Btn.Font = Enum.Font.SourceSansBold
Tab1Btn.TextSize = 13

local Tab1BtnCorner = Instance.new("UICorner")
Tab1BtnCorner.CornerRadius = UDim.new(0, 6)
Tab1BtnCorner.Parent = Tab1Btn

local Tab2Btn = Instance.new("TextButton")
Tab2Btn.Parent = TabBar
Tab2Btn.Size = UDim2.new(0.9, 0, 0, 35)
Tab2Btn.Text = "🌀 ปั่น Fling"
Tab2Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
Tab2Btn.BackgroundColor3 = Color3.fromRGB(15, 30, 50)
Tab2Btn.Font = Enum.Font.SourceSansBold
Tab2Btn.TextSize = 13

local Tab2BtnCorner = Instance.new("UICorner")
Tab2BtnCorner.CornerRadius = UDim.new(0, 6)
Tab2BtnCorner.Parent = Tab2Btn

Tab1Btn.MouseButton1Click:Connect(function()
    Tab1Page.Visible = true
    Tab2Page.Visible = false
    Tab1Btn.TextColor3 = Color3.fromRGB(0, 200, 255)
    Tab1Btn.BackgroundColor3 = Color3.fromRGB(20, 45, 75)
    Tab2Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Tab2Btn.BackgroundColor3 = Color3.fromRGB(15, 30, 50)
end)

Tab2Btn.MouseButton1Click:Connect(function()
    Tab1Page.Visible = false
    Tab2Page.Visible = true
    Tab2Btn.TextColor3 = Color3.fromRGB(0, 200, 255)
    Tab2Btn.BackgroundColor3 = Color3.fromRGB(20, 45, 75)
    Tab1Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Tab1Btn.BackgroundColor3 = Color3.fromRGB(15, 30, 50)
end)

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(0.95, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(15, 35, 60)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 13

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

-- ==================== ระบบ Popup แจ้งเตือน ====================
local function showWarningDialog(playerName, onConfirm)
    local DialogFrame = Instance.new("Frame")
    DialogFrame.Name = "WarningDialog"
    DialogFrame.Parent = ScreenGui
    DialogFrame.Size = UDim2.new(0, 280, 0, 150)
    DialogFrame.Position = UDim2.new(0.5, -140, 0.4, -75)
    DialogFrame.BackgroundColor3 = Color3.fromRGB(20, 10, 15)
    DialogFrame.ZIndex = 10

    local DialogCorner = Instance.new("UICorner")
    DialogCorner.CornerRadius = UDim.new(0, 8)
    DialogCorner.Parent = DialogFrame

    local DialogStroke = Instance.new("UIStroke")
    DialogStroke.Thickness = 2
    DialogStroke.Color = Color3.fromRGB(255, 80, 80)
    DialogStroke.Parent = DialogFrame

    local Message = Instance.new("TextLabel")
    Message.Parent = DialogFrame
    Message.Size = UDim2.new(1, -20, 0, 60)
    Message.Position = UDim2.new(0, 10, 0, 10)
    Message.Text = "⚠️ คุณได้ Fling " .. playerName .. " ไปแล้ว หรือเป้าหมายไม่อยู่ในพื้นที่/ตายแล้ว!"
    Message.TextColor3 = Color3.fromRGB(255, 220, 100)
    Message.Font = Enum.Font.SourceSansBold
    Message.TextSize = 13
    Message.TextWrapped = true
    Message.BackgroundTransparency = 1
    Message.ZIndex = 11

    -- ปุ่ม 1: อะก็ได้ๆสงสาร
    local Option1 = Instance.new("TextButton")
    Option1.Parent = DialogFrame
    Option1.Size = UDim2.new(0.9, 0, 0, 30)
    Option1.Position = UDim2.new(0.05, 0, 0.48, 0)
    Option1.BackgroundColor3 = Color3.fromRGB(40, 70, 40)
    Option1.Text = "1. อะก็ได้ๆสงสาร (ไม่ Fling ต่อ)"
    Option1.TextColor3 = Color3.fromRGB(150, 255, 150)
    Option1.Font = Enum.Font.SourceSansBold
    Option1.TextSize = 12
    Option1.ZIndex = 11

    local Option1Corner = Instance.new("UICorner")
    Option1Corner.CornerRadius = UDim.new(0, 5)
    Option1Corner.Parent = Option1

    -- ปุ่ม 2: ไม่อะกูแค้น
    local Option2 = Instance.new("TextButton")
    Option2.Parent = DialogFrame
    Option2.Size = UDim2.new(0.9, 0, 0, 30)
    Option2.Position = UDim2.new(0.05, 0, 0.72, 0)
    Option2.BackgroundColor3 = Color3.fromRGB(90, 30, 30)
    Option2.Text = "2. ไม่อะกูแค้น (Fling เลย)"
    Option2.TextColor3 = Color3.fromRGB(255, 150, 150)
    Option2.Font = Enum.Font.SourceSansBold
    Option2.TextSize = 12
    Option2.ZIndex = 11

    local Option2Corner = Instance.new("UICorner")
    Option2Corner.CornerRadius = UDim.new(0, 5)
    Option2Corner.Parent = Option2

    Option1.MouseButton1Click:Connect(function()
        DialogFrame:Destroy()
    end)

    Option2.MouseButton1Click:Connect(function()
        DialogFrame:Destroy()
        onConfirm()
    end)
end

-- ==================== ระบบ Fling ปลอดภัย + เช็คการโดนซ้ำ ====================
local function executeFling(targetPlayer)
    pcall(function()
        local char = LocalPlayer.Character
        local targetChar = targetPlayer.Character
        if not char or not targetChar or not char:FindFirstChild("HumanoidRootPart") or not targetChar:FindFirstChild("HumanoidRootPart") then return end

        local hrp = char.HumanoidRootPart
        local hum = char:FindFirstChildOfClass("Humanoid")
        local targetHRP = targetChar.HumanoidRootPart
        local originalCFrame = hrp.CFrame

        -- บันทึกว่าเป้าหมายนี้โดน Fling แล้ว
        FlingHistory[targetPlayer.UserId] = true

        if hum then
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end

        local startTime = tick()
        while tick() - startTime < 1.2 do
            if not targetHRP or not targetHRP.Parent or not char or not hrp then break end
            
            if hum then
                hum.PlatformStand = false
            end

            hrp.Velocity = Vector3.new(99999, 99999, 99999)
            hrp.RotVelocity = Vector3.new(99999, 99999, 99999)
            hrp.CFrame = targetHRP.CFrame * CFrame.new(math.random(-1,1), math.random(-1,1), math.random(-1,1))
            Services.RunService.RenderStepped:Wait()
        end

        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.RotVelocity = Vector3.new(0, 0, 0)
        hrp.CFrame = originalCFrame

        if hum then
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end

local function flingTarget(targetPlayer)
    if not targetPlayer then return end

    local targetChar = targetPlayer.Character
    local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
    local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

    -- ตรวจสอบว่าเป้าหมายตายแล้ว / หลุดตกแมพ (Position.Y < -50) / หรือเคยโดน Fling ไปแล้วในรอบนี้
    local isDead = not targetHum or targetHum.Health <= 0
    local isOutOfMap = not targetHRP or targetHRP.Position.Y < -50
    local isAlreadyFlinged = FlingHistory[targetPlayer.UserId] == true

    if isDead or isOutOfMap or isAlreadyFlinged then
        showWarningDialog(targetPlayer.DisplayName, function()
            executeFling(targetPlayer)
        end)
    else
        executeFling(targetPlayer)
    end
end

local function getTargetByRole(roleName)
    for _, p in pairs(Services.Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if roleName == "Murderer" and (p.Character:FindFirstChild("Knife") or (p:FindFirstChild("Backpack") and p.Backpack:FindFirstChild("Knife"))) then
                return p
            elseif roleName == "Sheriff" and (p.Character:FindFirstChild("Gun") or (p:FindFirstChild("Backpack") and p.Backpack:FindFirstChild("Gun"))) then
                return p
            end
        end
    end
    return nil
end

-- ==================== ระบบวาร์ปเก็บปืนและยิงออโต้ ====================
local function fastGetGunAndReturn()
    pcall(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end

        local hrp = char.HumanoidRootPart
        local gunDrop = nil

        for _, obj in pairs(Services.Workspace:GetDescendants()) do
            if obj.Name == "GunDrop" or (obj:IsA("Tool") and obj.Name:lower():find("gun")) then
                if obj:IsA("BasePart") then gunDrop = obj break
                elseif obj:FindFirstChild("Handle") then gunDrop = obj.Handle break end
            end
        end

        if gunDrop then
            local originalCFrame = hrp.CFrame
            hrp.Velocity = Vector3.new(0, 0, 0)
            hrp.CFrame = gunDrop.CFrame * CFrame.new(0, 3.5, 0)
            task.wait(0.06)
            hrp.Velocity = Vector3.new(0, 0, 0)
            hrp.CFrame = originalCFrame
        end
    end)
end

local function shootAtMurderer()
    pcall(function()
        local murderer = getTargetByRole("Murderer")
        if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
            local char = LocalPlayer.Character
            local gun = char:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
            if gun then
                if gun.Parent == LocalPlayer.Backpack then
                    char.Humanoid:EquipTool(gun)
                    task.wait(0.02)
                end
                local targetPos = murderer.Character.HumanoidRootPart.Position
                if gun:FindFirstChild("Shoot") then gun.Shoot:FireServer(targetPos)
                elseif gun:FindFirstChild("KnifeServer") then gun.KnifeServer:FireServer(targetPos)
                else gun:Activate() end
            end
        end
    end)
end

-- ==================== แท็บ 1: ฟังชั่นเกมทั่วไป ====================

local isFlying = false
local flyBodyVel, flyBodyGyro
createButton(Tab1Page, "บิน (Fly) : ปิด ❌", function(btn)
    isFlying = not isFlying
    btn.Text = "บิน (Fly) : " .. (isFlying and "เปิด ✅" or "ปิด ❌")
    btn.TextColor3 = isFlying and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = isFlying and Color3.fromRGB(0, 60, 90) or Color3.fromRGB(15, 35, 60)

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    if isFlying then
        flyBodyVel = Instance.new("BodyVelocity")
        flyBodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBodyVel.Parent = hrp
        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBodyGyro.Parent = hrp

        task.spawn(function()
            while isFlying and char and char:FindFirstChild("Humanoid") do
                local cam = Services.Workspace.CurrentCamera
                flyBodyGyro.CFrame = cam.CFrame
                flyBodyVel.Velocity = cam.CFrame.LookVector * 50
                Services.RunService.RenderStepped:Wait()
            end
            if flyBodyVel then flyBodyVel:Destroy() end
            if flyBodyGyro then flyBodyGyro:Destroy() end
        end)
    else
        if flyBodyVel then flyBodyVel:Destroy() end
        if flyBodyGyro then flyBodyGyro:Destroy() end
    end
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
    btn.TextColor3 = isNoclip and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = isNoclip and Color3.fromRGB(0, 60, 90) or Color3.fromRGB(15, 35, 60)
end)

local isInfJump = false
Services.UserInputService.JumpRequest:Connect(function()
    if isInfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

createButton(Tab1Page, "กระโดดไม่จำกัด : ปิด ❌", function(btn)
    isInfJump = not isInfJump
    btn.Text = "กระโดดไม่จำกัด : " .. (isInfJump and "เปิด ✅" or "ปิด ❌")
    btn.TextColor3 = isInfJump and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = isInfJump and Color3.fromRGB(0, 60, 90) or Color3.fromRGB(15, 35, 60)
end)

local isGod = false
createButton(Tab1Page, "อมตะ (กันตาย) : ปิด ❌", function(btn)
    isGod = not isGod
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, not isGod)
    end
    btn.Text = "อมตะ (กันตาย) : " .. (isGod and "เปิด ✅" or "ปิด ❌")
    btn.TextColor3 = isGod and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = isGod and Color3.fromRGB(0, 60, 90) or Color3.fromRGB(15, 35, 60)
end)

createButton(Tab1Page, "วาร์ปเอาปืนและกลับที่เดิม", function()
    fastGetGunAndReturn()
end)

local isAutoGun = false
task.spawn(function()
    while task.wait(0.2) do
        if isAutoGun then fastGetGunAndReturn() end
    end
end)

createButton(Tab1Page, "วาร์ปเก็บปืนออโต้ : ปิด ❌", function(btn)
    isAutoGun = not isAutoGun
    btn.Text = "วาร์ปเก็บปืนออโต้ : " .. (isAutoGun and "เปิด ✅" or "ปิด ❌")
    btn.TextColor3 = isAutoGun and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = isAutoGun and Color3.fromRGB(0, 60, 90) or Color3.fromRGB(15, 35, 60)
end)

local isAutoShoot = false
task.spawn(function()
    while task.wait(0.2) do
        if isAutoShoot then shootAtMurderer() end
    end
end)

createButton(Tab1Page, "ยิงฆาตกรออโต้ : ปิด ❌", function(btn)
    isAutoShoot = not isAutoShoot
    btn.Text = "ยิงฆาตกรออโต้ : " .. (isAutoShoot and "เปิด ✅" or "ปิด ❌")
    btn.TextColor3 = isAutoShoot and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = isAutoShoot and Color3.fromRGB(0, 60, 90) or Color3.fromRGB(15, 35, 60)
end)

-- ==================== แท็บ 2: ระบบปั่น Fling ====================

createButton(Tab2Page, "Fling ฆาตกร (ผลักตกแมพ)", function()
    local target = getTargetByRole("Murderer")
    if target then flingTarget(target) end
end)

createButton(Tab2Page, "Fling นายอำเภอ (ผลักตกแมพ)", function()
    local target = getTargetByRole("Sheriff")
    if target then flingTarget(target) end
end)

local NameBox = Instance.new("TextBox")
NameBox.Parent = Tab2Page
NameBox.Size = UDim2.new(0.95, 0, 0, 32)
NameBox.BackgroundColor3 = Color3.fromRGB(20, 40, 65)
NameBox.PlaceholderText = "ใส่ชื่อผู้เล่นที่ต้องการ..."
NameBox.Text = ""
NameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
NameBox.Font = Enum.Font.SourceSans
NameBox.TextSize = 13

local NameBoxCorner = Instance.new("UICorner")
NameBoxCorner.CornerRadius = UDim.new(0, 6)
NameBoxCorner.Parent = NameBox

createButton(Tab2Page, "Fling ผู้เล่นที่ระบุชื่อ", function()
    local targetName = NameBox.Text:lower()
    if targetName ~= "" then
        for _, p in pairs(Services.Players:GetPlayers()) do
            if p ~= LocalPlayer and (p.Name:lower():find(targetName) or p.DisplayName:lower():find(targetName)) then
                flingTarget(p)
                break
            end
        end
    end
end)
