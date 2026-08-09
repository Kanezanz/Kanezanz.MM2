-- Kanezanz Script (Fixed UI & Full Features)
local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    Workspace = game:GetService("Workspace"),
    UserInputService = game:GetService("UserInputService")
}

local LocalPlayer = Services.Players.LocalPlayer
local FlingHistory = {}

-- ล้าง UI เก่า
pcall(function()
    local container = gethui and gethui() or game:GetService("CoreGui")
    if container:FindFirstChild("KanezanzDualTabUI") then
        container.KanezanzDualTabUI:Destroy()
    end
end)

local ParentContainer = gethui and gethui() or game:GetService("CoreGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KanezanzDualTabUI"
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

-- หน้าต่างหลัก (ขยายกว้างขึ้นเพื่อให้ปุ่มและแท็บไม่เบียดกัน)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 420, 0, 320)
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
Title.Text = "Kanezanz Script 🇹🇭"
Title.TextColor3 = Color3.fromRGB(0, 210, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- แถบเลือกแท็บฝั่งซ้าย (ปรับสีให้สว่างขึ้น มองเห็นชัดเจน)
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

-- สร้างหน้าแท็บทั้ง 3
local function createPage()
    local page = Instance.new("ScrollingFrame", ContentArea)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 0, 280)
    page.ScrollBarThickness = 4
    page.Visible = false
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    return page
end

local Tab1Page = createPage()
local Tab2Page = createPage()
local Tab3Page = createPage()
Tab1Page.Visible = true -- เปิดแท็บแรกไว้เป็นค่าเริ่มต้น

-- ปุ่มสลับแท็บ
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
        Tab3Page.Visible = false
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

local Tab1Btn = createTabButton("🎮 เกมทั่วไป", Tab1Page)
Tab1Btn.TextColor3 = Color3.fromRGB(0, 220, 255)
Tab1Btn.BackgroundColor3 = Color3.fromRGB(35, 70, 110)

createTabButton("🌀 ปั่น/ฆ่า MM2", Tab2Page)
createTabButton("⚽ Blue Lock", Tab3Page)

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(22, 45, 75)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(0, 120, 200)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

-- ==================== แท็บ 1: เกมทั่วไป + บินอิสระ ====================
local isFlying = false
local flySpeed = 50
local flyBodyVel, flyBodyGyro

createButton(Tab1Page, "บินอิสระ (Fly) : ปิด ❌", function(btn)
    isFlying = not isFlying
    btn.Text = "บินอิสระ : " .. (isFlying and "เปิด ✅" or "ปิด ❌")
    btn.TextColor3 = isFlying and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 255, 255)

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if isFlying and hrp then
        flyBodyVel = Instance.new("BodyVelocity", hrp)
        flyBodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBodyGyro = Instance.new("BodyGyro", hrp)
        flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        
        task.spawn(function()
            while isFlying and LocalPlayer.Character and hrp do
                local cam = Services.Workspace.CurrentCamera
                flyBodyGyro.CFrame = cam.CFrame
                local moveDir = Vector3.new()
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.new(0, 1, 0) end
                flyBodyVel.Velocity = moveDir * flySpeed
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
end)

-- ==================== แท็บ 2: MM2 ====================
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

-- ==================== แท็บ 3: Blue Lock Rivals ====================
local function getFootball()
    for _, obj in pairs(Services.Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("ball")) then return obj end
    end
end

local isMagnet = false
local isAutoControl = false

Services.RunService.Heartbeat:Connect(function()
    pcall(function()
        local ball = getFootball()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if ball and hrp then
            if isMagnet then
                ball.CFrame = hrp.CFrame * CFrame.new(0, -1, -3)
                ball.Velocity = Vector3.new(0, 0, 0)
            elseif isAutoControl then
                ball.CFrame = hrp.CFrame * CFrame.new(0, -1.5, -2)
                ball.AssemblyLinearVelocity = hrp.Velocity
            end
        end
    end)
end)

createButton(Tab3Page, "🧲 ดูดบอลเข้าหาตัว : ปิด ❌", function(btn)
    isMagnet = not isMagnet
    btn.Text = "🧲 ดูดบอลเข้าหาตัว : " .. (isMagnet and "เปิด ✅" or "ปิด ❌")
end)

createButton(Tab3Page, "⚽ ควบคุมบอลตลอดเวลา : ปิด ❌", function(btn)
    isAutoControl = not isAutoControl
    btn.Text = "⚽ ควบคุมบอลตลอดเวลา : " .. (isAutoControl and "เปิด ✅" or "ปิด ❌")
end)

createButton(Tab3Page, "🥅 วาร์ปบอลไปโกล", function()
    local ball = getFootball()
    if ball then ball.CFrame = CFrame.new(0, 2, 0) end
end)
