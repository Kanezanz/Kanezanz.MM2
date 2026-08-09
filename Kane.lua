-- Kanezanz Script (Final Version: All Features Included)
local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    Workspace = game:GetService("Workspace"),
    UserInputService = game:GetService("UserInputService")
}

local LocalPlayer = Services.Players.LocalPlayer
local FlingHistory = {}

-- [ฟังก์ชันพื้นฐานสำหรับ UI]
local function getUIContainer()
    return gethui and gethui() or game:GetService("CoreGui")
end

local ParentContainer = getUIContainer()
if ParentContainer:FindFirstChild("KanezanzDualTabUI") then ParentContainer.KanezanzDualTabUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KanezanzDualTabUI"
ScreenGui.Parent = ParentContainer

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 370, 0, 330)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 22, 38)
MainFrame.Draggable = true
MainFrame.Visible = true

local TabBar = Instance.new("Frame")
TabBar.Parent = MainFrame
TabBar.Size = UDim2.new(0, 115, 1, -45)
TabBar.Position = UDim2.new(0, 8, 0, 38)
TabBar.BackgroundColor3 = Color3.fromRGB(18, 32, 54)

local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainFrame
ContentArea.Size = UDim2.new(1, -137, 1, -45)
ContentArea.Position = UDim2.new(0, 129, 0, 38)
ContentArea.BackgroundTransparency = 1

-- [ฟังก์ชันสร้างปุ่ม]
local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(0.95, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(20, 42, 70)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 13
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

-- [ฟังก์ชันบินอิสระ]
local isFlying = false
local flySpeed = 50
local flyBodyVel, flyBodyGyro

local function toggleFly(btn)
    isFlying = not isFlying
    btn.Text = "บินอิสระ : " .. (isFlying and "เปิด ✅" or "ปิด ❌")
    
    if isFlying then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        flyBodyVel = Instance.new("BodyVelocity", hrp)
        flyBodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBodyGyro = Instance.new("BodyGyro", hrp)
        flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        
        task.spawn(function()
            while isFlying and LocalPlayer.Character and hrp do
                local cam = workspace.CurrentCamera
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
        end)
    else
        if flyBodyVel then flyBodyVel:Destroy() end
        if flyBodyGyro then flyBodyGyro:Destroy() end
    end
end

-- [สร้างแท็บ]
local Tab3Page = Instance.new("ScrollingFrame", ContentArea)
Tab3Page.Size = UDim2.new(1, 0, 1, 0)
Tab3Page.BackgroundTransparency = 1
Instance.new("UIListLayout", Tab3Page).Padding = UDim.new(0, 5)

-- [ฟังก์ชัน Blue Lock]
local function getFootball()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("ball")) then return obj end
    end
end

local isMagnet = false
local isAutoControl = false

Services.RunService.Heartbeat:Connect(function()
    local ball = getFootball()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if ball and hrp then
        if isMagnet then
            ball.CFrame = hrp.CFrame * CFrame.new(0, -1, -3)
        elseif isAutoControl then
            ball.CFrame = hrp.CFrame * CFrame.new(0, -1.5, -2)
            ball.AssemblyLinearVelocity = hrp.Velocity
        end
    end
end)

createButton(Tab3Page, "🧲 ดูดบอลเข้าหาตัว : ปิด ❌", function(btn)
    isMagnet = not isMagnet
    btn.Text = "🧲 ดูดบอลเข้าหาตัว : " .. (isMagnet and "เปิด ✅" or "ปิด ❌")
end)

createButton(Tab3Page, "⚽ ควบคุมบอลตลอดเวลา : ปิด ❌", function(btn)
    isAutoControl = not isAutoControl
    btn.Text = "⚽ ควบคุมบอลตลอดเวลา : " .. (isAutoControl and "เปิด ✅" or "ปิด ❌")
end)

createButton(Tab3Page, "🥅 วาร์ปบอลเข้าโกล", function()
    local ball = getFootball()
    if ball then ball.CFrame = CFrame.new(0, 2, 0) end -- ปรับตำแหน่งโกลตามแมพ
end)

-- (เพิ่มปุ่มบินในแท็บที่เกี่ยวข้อง)
createButton(Tab3Page, "บินอิสระ : ปิด ❌", toggleFly)
