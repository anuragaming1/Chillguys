--==============================
-- Meow Hub | Kaitun Blox Fruit
-- Shadow Text Effect Version
--==============================

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

pcall(function()
	if playerGui:FindFirstChild("meowhubui") then
		playerGui.meowhubui:Destroy()
	end
end)

--==============================
-- SCREEN GUI (MAX PRIORITY)
--==============================
local gui = Instance.new("ScreenGui")
gui.Name = "meowhubui"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = playerGui

--==============================
-- MAIN
--==============================
local main = Instance.new("Frame")
main.AnchorPoint = Vector2.new(0.5,0.5)
main.Position = UDim2.new(0.5,0,0.5,0)
main.Size = UDim2.new(0,420,0,310)
main.BackgroundTransparency = 1
main.ZIndex = 100
main.Parent = gui

--==============================
-- ICON
--==============================
local icon = Instance.new("ImageLabel")
icon.AnchorPoint = Vector2.new(0.5,0)
icon.Position = UDim2.new(0.5,0,0,0)
icon.Size = UDim2.new(0,90,0,90)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://91605464077108"
icon.ZIndex = 200
icon.Parent = main

task.spawn(function()
	while true do
		TweenService:Create(icon,TweenInfo.new(0.8),{ImageTransparency=0.15}):Play()
		task.wait(0.8)
		TweenService:Create(icon,TweenInfo.new(0.8),{ImageTransparency=0}):Play()
		task.wait(0.8)
	end
end)

--==============================
-- TITLE SHADOW (MEOW HUB)
--==============================
local titleShadow = Instance.new("TextLabel")
titleShadow.AnchorPoint = Vector2.new(0.5,0)
titleShadow.Position = UDim2.new(0.5,2,0.34,2)
titleShadow.Size = UDim2.new(0,320,0,50)
titleShadow.BackgroundTransparency = 1
titleShadow.Text = "Meow Hub"
titleShadow.Font = Enum.Font.GothamBold
titleShadow.TextScaled = true
titleShadow.TextColor3 = Color3.fromRGB(160,70,130)
titleShadow.TextTransparency = 0.35
titleShadow.ZIndex = 199
titleShadow.Parent = main

local title = Instance.new("TextLabel")
title.AnchorPoint = Vector2.new(0.5,0)
title.Position = UDim2.new(0.5,0,0.34,0)
title.Size = UDim2.new(0,320,0,50)
title.BackgroundTransparency = 1
title.Text = "Meow Hub"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,150,220)
title.ZIndex = 200
title.Parent = main

--==============================
-- SUBTITLE SHADOW (KAITUN)
--==============================
local subShadow = Instance.new("TextLabel")
subShadow.AnchorPoint = Vector2.new(0.5,0)
subShadow.Position = UDim2.new(0.5,2,0.51,2)
subShadow.Size = UDim2.new(0,280,0,30)
subShadow.BackgroundTransparency = 1
subShadow.Text = "Kaitun Blox fruit"
subShadow.Font = Enum.Font.GothamSemibold
subShadow.TextScaled = true
subShadow.TextColor3 = Color3.fromRGB(60,100,160)
subShadow.TextTransparency = 0.35
subShadow.ZIndex = 199
subShadow.Parent = main

local sub = Instance.new("TextLabel")
sub.AnchorPoint = Vector2.new(0.5,0)
sub.Position = UDim2.new(0.5,0,0.51,0)
sub.Size = UDim2.new(0,280,0,30)
sub.BackgroundTransparency = 1
sub.Text = "Kaitun Blox fruit"
sub.Font = Enum.Font.GothamSemibold
sub.TextScaled = true
sub.TextColor3 = Color3.fromRGB(150,200,255)
sub.ZIndex = 200
sub.Parent = main

--==============================
-- INFO
--==============================
local info = Instance.new("TextLabel")
info.AnchorPoint = Vector2.new(0.5,0)
info.Position = UDim2.new(0.5,0,0.65,0)
info.Size = UDim2.new(0,400,0,40)
info.BackgroundTransparency = 1
info.Font = Enum.Font.GothamSemibold
info.TextScaled = true
info.TextColor3 = Color3.new(1,1,1)
info.ZIndex = 200
info.Parent = main

--==============================
-- COPY BUTTON
--==============================
local btn = Instance.new("TextButton")
btn.AnchorPoint = Vector2.new(0.5,0)
btn.Position = UDim2.new(0.5,0,0.83,0)
btn.Size = UDim2.new(0,260,0,38)
btn.BackgroundColor3 = Color3.fromRGB(255,120,200)
btn.Text = "COPY DISCORD"
btn.Font = Enum.Font.GothamBold
btn.TextScaled = true
btn.TextColor3 = Color3.new(1,1,1)
btn.ZIndex = 300
btn.Parent = main
Instance.new("UICorner",btn).CornerRadius = UDim.new(0,12)

btn.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/sWtCuDf6zw")
	btn.Text = "COPIED ✔"
	task.wait(1)
	btn.Text = "COPY DISCORD"
end)

--==============================
-- STATS (ACCURATE)
--==============================
local data = player:WaitForChild("Data")
local level = data:WaitForChild("Level")
local beli = data:WaitForChild("Beli")
local fragments = data:WaitForChild("Fragments")
local race = data:WaitForChild("Race")

task.spawn(function()
	while task.wait(0.2) do
		info.Text = string.format(
			"Level: %d | Race: %s | Beli: %d | Fragments: %d",
			level.Value,
			race.Value,
			beli.Value,
			fragments.Value
		)
	end
end)
