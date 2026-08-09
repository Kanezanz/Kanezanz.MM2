-- Kanezanz MM2 Final Fix
local Services = {Players = game:GetService("Players"), RunService = game:GetService("RunService"), Workspace = game:GetService("Workspace"), UserInputService = game:GetService("UserInputService")}
local LocalPlayer = Services.Players.LocalPlayer
local ParentContainer = (gethui and gethui()) or game:GetService("CoreGui")

pcall(function() ParentContainer.KanezanzMM2UI:Destroy() end)

local ScreenGui = Instance.new("ScreenGui", ParentContainer)
ScreenGui.Name = "KanezanzMM2UI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Kanezanz MM2 - FIX"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -10, 1, -50)
Scroll.Position = UDim2.new(0, 5, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 10)

local function createBtn(text, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
end

-- ระบบบิน
local isFlying = false
local bv, bg
createBtn("บินอิสระ (Toggle)", function(btn)
    isFlying = not isFlying
    btn.Text = isFlying and "บิน: เปิด ✅" or "บิน: ปิด ❌"
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if isFlying and hrp then
        bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            while isFlying and hrp do
                local cam = workspace.CurrentCamera
                bg.CFrame = cam.CFrame
                bv.Velocity = (Services.UserInputService:IsKeyDown(Enum.KeyCode.W) and cam.CFrame.LookVector or Vector3.new()) * 60
                Services.RunService.RenderStepped:Wait()
            end
        end)
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

-- ระบบกระโดดไม่จำกัด
local isInfJump = false
createBtn("กระโดดไม่จำกัด (Toggle)", function(btn)
    isInfJump = not isInfJump
    btn.Text = isInfJump and "กระโดด: เปิด ✅" or "กระโดด: ปิด ❌"
end)

Services.UserInputService.JumpRequest:Connect(function()
    if isInfJump then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

createBtn("เดินทะลุ (Noclip)", function(btn)
    Services.RunService.Stepped:Connect(function()
        if LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
    btn.Text = "Noclip: เปิดตลอด"
end)
