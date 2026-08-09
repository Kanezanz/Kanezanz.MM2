-- Kanezanz Script (3 Tabs UI: General, Fling/Kill, Blue Lock Rivals)
local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    Workspace = game:GetService("Workspace"),
    UserInputService = game:GetService("UserInputService")
}

local LocalPlayer = Services.Players.LocalPlayer
local FlingHistory = {}

-- รีเซ็ตประวัติ Fling เมื่อผู้เล่นเกิดใหม่
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

-- 2. ปุ่มวงกลมสีฟ้า [K] เปิด-ปิด UI
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

-- 3. หน้าต่างหลัก (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 370, 0, 330)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 22, 38)
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
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "Kanezanz Script 🇹🇭"
Title.TextColor3 = Color3.fromRGB(0, 210, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- 4. แถบเลือกแท็บฝั่งซ้าย (Side Tab Bar)
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Parent = MainFrame
TabBar.Size = UDim2.new(0, 115, 1, -45)
TabBar.Position = UDim2.new(0, 8, 0, 38)
TabBar.BackgroundColor3 = Color3.fromRGB(18, 32, 54)

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 8)
TabBarCorner.Parent = TabBar

local TabList = Instance.new("UIListLayout")
TabList.Parent = TabBar
TabList.Padding = UDim.new(0, 6)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local TabPadding = Instance.new("UIPadding")
TabPadding.Parent = TabBar
TabPadding.PaddingTop = UDim.new(0, 8)

-- 5. พื้นที่แสดงเนื้อหาฝั่งขวา (Content Area)
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Parent = MainFrame
ContentArea.Size = UDim2.new(1, -137, 1, -45)
ContentArea.Position = UDim2.new(0, 129, 0, 38)
ContentArea.BackgroundTransparency = 1

-- หน้าแท็บต่างๆ
local Tab1Page = Instance.new("ScrollingFrame")
Tab1Page.Parent = ContentArea
Tab1Page.Size = UDim2.new(1, 0, 1, 0)
Tab1Page.BackgroundTransparency = 1
Tab1Page.CanvasSize = UDim2.new(0, 0, 0, 270)
Tab1Page.ScrollBarThickness = 3
Tab1Page.Visible = true

local Tab1List = Instance.new("UIListLayout")
Tab1List.Parent = Tab1Page
Tab1List.Padding = UDim.new(0, 5)

local Tab2Page = Instance.new("ScrollingFrame")
Tab2Page.Parent = ContentArea
Tab2Page.Size = UDim2.new(1, 0, 1, 0)
Tab2Page.BackgroundTransparency = 1
Tab2Page.CanvasSize = UDim2.new(0, 0, 0, 310)
Tab2Page.ScrollBarThickness = 3
Tab2Page.Visible = false

local Tab2List = Instance.new("UIListLayout")
Tab2List.Parent = Tab2Page
Tab2List.Padding = UDim.new(0, 6)

local Tab3Page = Instance.new("ScrollingFrame")
Tab3Page.Parent = ContentArea
Tab3Page.Size = UDim2.new(1, 0, 1, 0)
Tab3Page.BackgroundTransparency = 1
Tab3Page.CanvasSize = UDim2.new(0, 0, 0, 250)
Tab3Page.ScrollBarThickness = 3
Tab3Page.Visible = false

local Tab3List = Instance.new("UIListLayout")
Tab3List.Parent = Tab3Page
Tab3List.Padding = UDim.new(0, 6)

-- ปุ่มกดสลับแท็บ
local Tab1Btn = Instance.new("TextButton")
Tab1Btn.Parent = TabBar
Tab1Btn.Size = UDim2.new(0.9, 0, 0, 32)
Tab1Btn.Text = "🎮 เกมทั่วไป"
Tab1Btn.TextColor3 = Color3.fromRGB(0, 220, 255)
Tab1Btn.BackgroundColor3 = Color3.fromRGB(28, 55, 90)
Tab1Btn.Font = Enum.Font.SourceSansBold
Tab1Btn.TextSize = 12

local Tab1BtnCorner = Instance.new("UICorner")
Tab1BtnCorner.CornerRadius = UDim.new(0, 6)
Tab1BtnCorner.Parent = Tab1Btn

local Tab2Btn = Instance.new("TextButton")
Tab2Btn.Parent = TabBar
Tab2Btn.Size = UDim2.new(0.9, 0, 0, 32)
Tab2Btn.Text = "🌀 ปั่น/ฆ่าทุกคน"
Tab2Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
Tab2Btn.BackgroundColor3 = Color3.fromRGB(15, 28, 45)
Tab2Btn.Font = Enum.Font.SourceSansBold
Tab2Btn.TextSize = 12

local Tab2BtnCorner = Instance.new("UICorner")
Tab2BtnCorner.CornerRadius = UDim.new(0, 6)
Tab2BtnCorner.Parent = Tab2Btn

local Tab3Btn = Instance.new("TextButton")
Tab3Btn.Parent = TabBar
Tab3Btn.Size = UDim2.new(0.9, 0, 0, 32)
Tab3Btn.Text = "⚽ Blue Lock"
Tab3Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
Tab3Btn.BackgroundColor3 = Color3.fromRGB(15, 28, 45)
Tab3Btn.Font = Enum.Font.SourceSansBold
Tab3Btn.TextSize = 12

local Tab3BtnCorner = Instance.new("UICorner")
Tab3BtnCorner.CornerRadius = UDim.new(0, 6)
Tab3BtnCorner.Parent = Tab3Btn

Tab1Btn.MouseButton1Click:Connect(function()
    Tab1Page.Visible = true
    Tab2Page.Visible = false
    Tab3Page.Visible = false
    Tab1Btn.TextColor3 = Color3.fromRGB(0, 220, 255)
    Tab1Btn.BackgroundColor3 = Color3.fromRGB(28, 55, 90)
    Tab2Btn.TextColor3, Tab3Btn.TextColor3 = Color3.fromRGB(180, 180, 180), Color3.fromRGB(180, 180, 180)
    Tab2Btn.BackgroundColor3, Tab3Btn.BackgroundColor3 = Color3.fromRGB(15, 28, 45), Color3.fromRGB(15, 28, 45)
end)

Tab2Btn.MouseButton1Click:Connect(function()
    Tab1Page.Visible = false
    Tab2Page.Visible = true
    Tab3Page.Visible = false
    Tab2Btn.TextColor3 = Color3.fromRGB(0, 220, 255)
    Tab2Btn.BackgroundColor3 = Color3.fromRGB(28, 55, 90)
    Tab1Btn.TextColor3, Tab3Btn.TextColor3 = Color3.fromRGB(180, 180, 180), Color3.fromRGB(180, 180, 180)
    Tab1Btn.BackgroundColor3, Tab3Btn.BackgroundColor3 = Color3.fromRGB(15, 28, 45), Color3.fromRGB(15, 28, 45)
end)

Tab3Btn.MouseButton1Click:Connect(function()
    Tab1Page.Visible = false
    Tab2Page.Visible = false
    Tab3Page.Visible = true
    Tab3Btn.TextColor3 = Color3.fromRGB(0, 220, 255)
    Tab3Btn.BackgroundColor3 = Color3.fromRGB(28, 55, 90)
    Tab1Btn.TextColor3, Tab2Btn.TextColor3 = Color3.fromRGB(180, 180, 180), Color3.fromRGB(180, 180, 180)
    Tab1Btn.BackgroundColor3, Tab2Btn.BackgroundColor3 = Color3.fromRGB(15, 28, 45), Color3.fromRGB(15, 28, 45)
end)

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(0.95, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(20, 42, 70)
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

    local Option1 = Instance.new("TextButton")
    Option1.Parent = DialogFrame
    Option1.Size = UDim2.new(0.9, 0, 0, 30)
    Option1.Position = UDim2.new(0.05, 0, 0.48, 0)
    Option1.BackgroundColor3 = Color3.fromRGB(40, 70, 40)
    Option1.Text = "1. อะก็ได้ๆสงสาร (ไม่ทำต่อ)"
    Option1.TextColor3 = Color3.fromRGB(150, 255, 150)
    Option1.Font = Enum.Font.SourceSansBold
    Option1.TextSize = 12
    Option1.ZIndex = 11

    local Option1Corner = Instance.new("UICorner")
    Option1Corner.CornerRadius = UDim.new(0, 5)
    Option1Corner.Parent = Option1

    local Option2 = Instance.new("TextButton")
    Option2.Parent = DialogFrame
    Option2.Size = UDim2.new(0.9, 0, 0, 30)
    Option2.Position = UDim2.new(0.05, 0, 0.72, 0)
    Option2.BackgroundColor3 = Color3.fromRGB(90, 30, 30)
    Option2.Text = "2. ไม่อะกูแค้น (ลุยเลย)"
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

-- ==================== ระบบ Fling ====================
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
        FlingHistory[targetPlayer.UserId] = true

        if hum then
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end

        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end

        local bV = Instance.new("BodyVelocity")
        bV.MaxForce = Vector3.new( math.huge, math.huge, math.huge )
        bV.Velocity = Vector3.new(999999, 999999, 999999)
        bV.Parent = hrp

        local bA = Instance.new("BodyAngularVelocity")
        bA.MaxTorque = Vector3.new( math.huge, math.huge, math.huge )
        bA.AngularVelocity = Vector3.new(999999, 999999, 999999)
        bA.Parent = hrp

        local startTime = tick()
        while tick() - startTime < 0.8 do
            if not targetHRP or not targetHRP.Parent or not hrp then break end
            hrp.CFrame = targetHRP.CFrame * CFrame.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1))
            Services.RunService.RenderStepped:Wait()
        end

        bV:Destroy()
        bA:Destroy()

        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.RotVelocity = Vector3.new(0, 0, 0)
        hrp.CFrame = oldCFrame

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

local function isLocalPlayerMurderer()
    local char = LocalPlayer.Character
    if not char then return false end
    return (char:FindFirstChild("Knife") ~= nil) or (LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChild("Knife") ~= nil)
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

local function bringAllAndKillWithKnife()
    pcall(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end

        local knife = char:FindFirstChild("Knife") or (LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChild("Knife"))
        if not knife then return end

        if knife.Parent == LocalPlayer.Backpack then
            char.Humanoid:EquipTool(knife)
            task.wait(0.1)
        end

        local hrp = char.HumanoidRootPart
        local killPoint = hrp.CFrame * CFrame.new(0, 0, -2.5)

        for _, p in pairs(Services.Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local targetHRP = p.Character.HumanoidRootPart
                targetHRP.CFrame = killPoint
            end
        end

        task.wait(0.05)

        if knife:FindFirstChild("Stab") then knife.Stab:FireServer()
        elseif knife:FindFirstChild("Slash") then knife.Slash:FireServer()
        else knife:Activate() end
    end)
end

-- ==================== ฟังก์ชันสำหรับ Blue Lock Rivals ====================
local function getFootball()
    for _, obj in pairs(Services.Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("ball") or obj.Name:lower():find("football")) then
            return obj
        end
    end
    return nil
end

-- ==================== แท็บ 1: ฟังชั่นเกมทั่วไป ====================
local isFlying = false
local flyBodyVel, flyBodyGyro
createButton(Tab1Page, "บิน (Fly) : ปิด ❌", function(btn)
    isFlying = not isFlying
    btn.Text = "บิน (Fly) : " .. (isFlying and "เปิด ✅" or "ปิด ❌")
    btn.TextColor3 = isFlying and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = isFlying and Color3.fromRGB(0, 60, 90) or Color3.fromRGB(20, 42, 70)

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    if isFlying then
        flyBodyVel = Instance.new("BodyVelocity")
        flyBodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBodyVel.Velocity = Vector3.new(0, 0, 0)
        flyBodyVel.Parent = hrp

        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBodyGyro.Parent = hrp

        task.spawn(function()
            while isFlying and char and hum and char:FindFirstChild("HumanoidRootPart") do
                local cam = Services.Workspace.CurrentCamera
                flyBodyGyro.CFrame = cam.CFrame

                if hum.MoveDirection.Magnitude > 0 then
                    flyBodyVel.Velocity = hum.MoveDirection * 50
                else
                    flyBodyVel.Velocity = Vector3.new(0, 0, 0)
                end
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
    btn.BackgroundColor3 = isNoclip and Color3.fromRGB(0, 60, 90) or Color3.fromRGB(20, 42, 70)
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
    btn.BackgroundColor3 = isInfJump and Color3.fromRGB(0, 60, 90) or Color3.fromRGB(20, 42, 70)
end)

-- ==================== แท็บ 2: ระบบปั่น & ฆ่าทุกคน ====================
createButton(Tab2Page, "🔪 ดึงทุกคนมาโดนฟันทีเดียวตายหมด", function()
    if not isLocalPlayerMurderer() then
        showWarningDialog("ทุกคน (คุณไม่ใช่ฆาตกร / ไม่มีมีด!)", function() end)
        return
    end
    bringAllAndKillWithKnife()
end)

createButton(Tab2Page, "💀 Fling ฆ่าทุกคน (วนทีละคน)", function()
    if not isLocalPlayerMurderer() then
        showWarningDialog("ทุกคน (คุณไม่ใช่ฆาตกร / ไม่มีมีด!)", function() end)
        return
    end

    task.spawn(function()
        for _, p in pairs(Services.Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                flingTarget(p)
                task.wait(1.0)
            end
        end
    end)
end)

createButton(Tab2Page, "Fling ฆาตกร (ผลักตกแมพ)", function()
    local target = getTargetByRole("Murderer")
    if target then flingTarget(target) end
end)

createButton(Tab2Page, "Fling นายอำเภอ (ผลักตกแมพ)", function()
    local target = getTargetByRole("Sheriff")
    if target then flingTarget(target) end
end)

-- ==================== แท็บ 3: Blue Lock Rivals ====================
local isMagnetBall = false
task.spawn(function()
    while task.wait(0.05) do
        if isMagnetBall then
            pcall(function()
                local ball = getFootball()
                local char = LocalPlayer.Character
                if ball and char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    ball.CFrame = hrp.CFrame * CFrame.new(0, -1, -3) -- ดูดบอลมาวางไว้หน้าเท้า
                    ball.Velocity = Vector3.new(0, 0, 0)
                end
            end)
        end
    end
end)

createButton(Tab3Page, "🧲 ดูดบอลเข้าหาตัว : ปิด ❌", function(btn)
    isMagnetBall = not isMagnetBall
    btn.Text = "🧲 ดูดบอลเข้าหาตัว : " .. (isMagnetBall and "เปิด ✅" or "ปิด ❌")
    btn.TextColor3 = isMagnetBall and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = isMagnetBall and Color3.fromRGB(0, 60, 90) or Color3.fromRGB(20, 42, 70)
end)

local isAutoControl = false
Services.RunService.Heartbeat:Connect(function()
    if isAutoControl then
        pcall(function()
            local ball = getFootball()
            local char = LocalPlayer.Character
            if ball and char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                ball.CFrame = hrp.CFrame * CFrame.new(0, -1.5, -2)
                ball.AssemblyLinearVelocity = hrp.Velocity
            end
        end)
    end
end)

createButton(Tab3Page, "⚽ ควบคุมบอลตลอดเวลา : ปิด ❌", function(btn)
    isAutoControl = not isAutoControl
    btn.Text = "⚽ ควบคุมบอลตลอดเวลา : " .. (isAutoControl and "เปิด ✅" or "ปิด ❌")
    btn.TextColor3 = isAutoControl and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = isAutoControl and Color3.fromRGB(0, 60, 90) or Color3.fromRGB(20, 42, 70)
end)

createButton(Tab3Page, "🥅 วาร์ปบอลไปจ่อหน้าประตู", function()
    pcall(function()
        local ball = getFootball()
        if ball then
            local goal = Services.Workspace:FindFirstChild("Goal") or Services.Workspace:FindFirstChild("Goal2")
            if goal then
                ball.CFrame = goal.CFrame * CFrame.new(0, 2, 0)
            end
        end
    end)
end)
