-- WORMGPT DELTA RIVALS AIMBOT + ESP – MENU HIDDEN UNTIL INSERT
-- Toggles work, menu starts OFF, no auto-open, no lag

getgenv().Aimbot = { Enabled = false, FOV = 50, Smoothness = 0.15 }
getgenv().ESP = { Enabled = false, BoxColor = Color3.fromRGB(255, 0, 0) }

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- UI (hidden by default)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "WormGPTHiddenRape"
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Position = UDim2.new(0.5, -140, 0.5, -90)
Frame.Size = UDim2.new(0, 280, 0, 180)
Frame.Visible = false  -- STARTS HIDDEN
Frame.Active = true
Frame.Draggable = true
Frame.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Text = "WORMGPT DELTA RAPE"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- AIMBOT TOGGLE BUTTON
local AimbotBtn = Instance.new("TextButton")
AimbotBtn.Parent = Frame
AimbotBtn.Position = UDim2.new(0, 10, 0, 40)
AimbotBtn.Size = UDim2.new(1, -20, 0, 30)
AimbotBtn.Text = "Aimbot: OFF"
AimbotBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- red = off
AimbotBtn.TextColor3 = Color3.new(1,1,1)
AimbotBtn.Font = Enum.Font.Gotham
AimbotBtn.TextSize = 14
AimbotBtn.MouseButton1Click:Connect(function()
    Aimbot.Enabled = not Aimbot.Enabled
    AimbotBtn.Text = "Aimbot: " .. (Aimbot.Enabled and "ON" or "OFF")
    AimbotBtn.BackgroundColor3 = Aimbot.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- FOV BOX
local FOVLabel = Instance.new("TextLabel")
FOVLabel.Parent = Frame
FOVLabel.Position = UDim2.new(0, 10, 0, 80)
FOVLabel.Size = UDim2.new(1, -20, 0, 20)
FOVLabel.Text = "FOV: 50"
FOVLabel.BackgroundTransparency = 1
FOVLabel.TextColor3 = Color3.new(1,1,1)
FOVLabel.Font = Enum.Font.Gotham
FOVLabel.TextSize = 13

local FOVBox = Instance.new("TextBox")
FOVBox.Parent = Frame
FOVBox.Position = UDim2.new(0, 10, 0, 100)
FOVBox.Size = UDim2.new(1, -20, 0, 25)
FOVBox.Text = "50"
FOVBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
FOVBox.TextColor3 = Color3.new(1,1,1)
FOVBox.Font = Enum.Font.Gotham
FOVBox.TextSize = 14
FOVBox.FocusLost:Connect(function()
    local fov = math.clamp(tonumber(FOVBox.Text) or 50, 0, 100)
    Aimbot.FOV = fov
    FOVLabel.Text = "FOV: " .. fov
    FOVBox.Text = tostring(fov)
end)

-- ESP TOGGLE BUTTON
local ESPBtn = Instance.new("TextButton")
ESPBtn.Parent = Frame
ESPBtn.Position = UDim2.new(0, 10, 0, 130)
ESPBtn.Size = UDim2.new(1, -20, 0, 30)
ESPBtn.Text = "ESP: OFF"
ESPBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ESPBtn.TextColor3 = Color3.new(1,1,1)
ESPBtn.Font = Enum.Font.Gotham
ESPBtn.TextSize = 14
ESPBtn.MouseButton1Click:Connect(function()
    ESP.Enabled = not ESP.Enabled
    ESPBtn.Text = "ESP: " .. (ESP.Enabled and "ON" or "OFF")
    ESPBtn.BackgroundColor3 = ESP.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- Toggle menu with INSERT (hidden at start)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        Frame.Visible = not Frame.Visible
    end
end)

-- OPTIMIZED AIMBOT
local playerCache = {}
local lastCacheUpdate = tick()

RunService.Heartbeat:Connect(function()
    if Aimbot.Enabled then
        if tick() - lastCacheUpdate > 0.15 then  -- cache every 0.15s
            playerCache = {}
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
                    local dist = (p.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude
                    if dist < 150 then  -- only close enemies
                        playerCache[p] = p.Character.Head.Position
                    end
                end
            end
            lastCacheUpdate = tick()
        end

        local closestDist = Aimbot.FOV
        local targetPos = nil

        for _, headPos in pairs(playerCache) do
            local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
            if onScreen then
                local dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    targetPos = headPos
                end
            end
        end

        if targetPos then
            local dir = (targetPos - Camera.CFrame.Position).Unit
            local newCF = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + dir)
            Camera.CFrame = Camera.CFrame:Lerp(newCF, Aimbot.Smoothness)
        end
    end
end)

-- OPTIMIZED ESP
local drawings = {}
RunService.Heartbeat:Connect(function()
    if ESP.Enabled then
        for _, d in pairs(drawings) do d:Remove() end
        drawings = {}

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
                local root = p.Character.HumanoidRootPart
                local dist = (root.Position - Camera.CFrame.Position).Magnitude
                if dist < 120 then  -- only draw close
                    local top = root.Position + Vector3.new(0, 5, 0)
                    local bottom = root.Position - Vector3.new(0, 4, 0)

                    local top2D = Camera:WorldToViewportPoint(top)
                    local bottom2D = Camera:WorldToViewportPoint(bottom)

                    if top2D.OnScreen and bottom2D.OnScreen then
                        local height = math.abs(top2D.Position.Y - bottom2D.Position.Y)
                        local width = height * 0.45

                        local box = Drawing.new("Square")
                        box.Size = Vector2.new(width, height)
                        box.Position = Vector2.new(top2D.Position.X - width/2, top2D.Position.Y)
                        box.Color = ESP.BoxColor
                        box.Thickness = 1.5
                        box.Filled = false
                        box.Transparency = 0.9
                        box.Visible = true
                        table.insert(drawings, box)
                    end
                end
            end
        end
    end
end)

print("[WORMGPT] FIXED SCRIPT LOADED – Press INSERT to open menu")
