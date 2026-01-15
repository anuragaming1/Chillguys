--====================================
-- Fake RobloxGui | Meow Hub Safe UI (Premium Edit)
--====================================

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

------------------------------------------------
-- REMOVE OLD UI
------------------------------------------------
pcall(function()
	for _,v in ipairs(CoreGui:GetChildren()) do
		if v:IsA("ScreenGui") and v.Name == "RobloxGui" then
			v:Destroy()
		end
	end
end)

------------------------------------------------
-- SCREEN GUI
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "RobloxGui"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = math.huge
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = CoreGui

------------------------------------------------
-- FORCE TOP
------------------------------------------------
RunService:BindToRenderStep(
	"MeowHubForceTop",
	Enum.RenderPriority.Last.Value + 9999,
	function()
		gui.DisplayOrder = math.huge
	end
)

------------------------------------------------
-- MAIN FRAME (Làm to hơn và rộng hơn)
------------------------------------------------
local main = Instance.new("Frame")
main.AnchorPoint = Vector2.new(0.5,0.5)
main.Position = UDim2.new(0.5,0,0.5,0)
-- Tăng kích thước lên 550x380 để thoáng hơn
main.Size = UDim2.new(0,550,0,380) 
main.BackgroundTransparency = 1
main.ZIndex = 999999
main.Parent = gui

------------------------------------------------
-- ICON (Hạ thấp xuống xíu)
------------------------------------------------
local icon = Instance.new("ImageLabel")
icon.AnchorPoint = Vector2.new(0.5,0)
-- Chỉnh Y từ 0 lên 0.05 để hạ thấp xuống
icon.Position = UDim2.new(0.5,0,0.05,0) 
icon.Size = UDim2.new(0,100,0,100) -- Tăng nhẹ size icon cho cân đối
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://91605464077108"
icon.ZIndex = 999999
icon.Parent = main

-- Hiệu ứng nhấp nháy icon
task.spawn(function()
	while true do
		TweenService:Create(icon,TweenInfo.new(0.8),{ImageTransparency=0.15}):Play()
		task.wait(0.8)
		TweenService:Create(icon,TweenInfo.new(0.8),{ImageTransparency=0}):Play()
		task.wait(0.8)
	end
end)

------------------------------------------------
-- TITLE + SHADOW
------------------------------------------------
local function shadowText(text, y, size, mainColor, shadowColor)
	local shadow = Instance.new("TextLabel")
	shadow.AnchorPoint = Vector2.new(0.5,0)
	shadow.Position = UDim2.new(0.5,2,y,2)
	shadow.Size = size
	shadow.BackgroundTransparency = 1
	shadow.Text = text
	shadow.Font = Enum.Font.GothamBold
	shadow.TextScaled = true
	shadow.TextColor3 = shadowColor
	shadow.TextTransparency = 0.35
	shadow.ZIndex = 999998
	shadow.Parent = main

	local label = Instance.new("TextLabel")
	label.AnchorPoint = Vector2.new(0.5,0)
	label.Position = UDim2.new(0.5,0,y,0)
	label.Size = size
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.TextColor3 = mainColor
	label.ZIndex = 999999
	label.Parent = main
end

-- Meow Hub giữ nguyên chữ, chỉ chỉnh vị trí cho hợp khung mới
shadowText(
	"Meow Hub",
	0.36, -- Hạ thấp xíu cho đỡ đụng icon
	UDim2.new(0,350,0,55),
	Color3.fromRGB(255,160,230),
	Color3.fromRGB(120,60,120)
)

shadowText(
	"Kaitun Blox fruit",
	0.52,
	UDim2.new(0,300,0,32),
	Color3.fromRGB(170,220,255),
	Color3.fromRGB(60,100,160)
)

------------------------------------------------
-- INFO (Hiệu ứng 7 màu + Ngang hàng)
------------------------------------------------
local info = Instance.new("TextLabel")
info.AnchorPoint = Vector2.new(0.5,0)
info.Position = UDim2.new(0.5,0,0.65,0)
-- Size chiều ngang (X) tăng lên 520 để chữ không bị xuống dòng
info.Size = UDim2.new(0,520,0,40) 
info.BackgroundTransparency = 1
info.Font = Enum.Font.GothamBlack -- Dùng font đậm hơn cho đẹp
info.TextScaled = true
info.TextColor3 = Color3.new(1,1,1)
info.ZIndex = 999999
info.Parent = main

-- Tạo Gradient 7 màu
local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
	ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 165, 0)),
	ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 0)),
	ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 0)),
	ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(148, 0, 211))
})
uiGradient.Parent = info

-- Script làm gradient chạy (Animation 7 màu)
task.spawn(function()
	local rotation = 0
	while task.wait() do
		rotation = rotation + 1
		if rotation > 360 then rotation = 0 end
		-- Xoay nhẹ màu để tạo hiệu ứng lấp lánh
		uiGradient.Rotation = rotation 
	end
end)

-- Lấy dữ liệu Player an toàn
local data = player:WaitForChild("Data", 10)
local level = data and data:WaitForChild("Level", 5) or {Value = 0}
local race = data and data:WaitForChild("Race", 5) or {Value = "Loading..."}
local beli = data and data:WaitForChild("Beli", 5) or {Value = 0}
local fragments = data and data:WaitForChild("Fragments", 5) or {Value = 0}

task.spawn(function()
	while task.wait(0.25) do
		-- Format chuỗi dài ngang
		if data then
			info.Text = string.format(
				"LV: %s  |  %s  |  $ %s  |  ƒ %s",
				tostring(level.Value),
				tostring(race.Value),
				tostring(beli.Value),
				tostring(fragments.Value)
			)
		else
			info.Text = "Waiting for Data..."
		end
	end
end)

------------------------------------------------
-- BUTTON HOLDER (Căn chỉnh lại)
------------------------------------------------
local holder = Instance.new("Frame")
holder.AnchorPoint = Vector2.new(0.5,0)
holder.Position = UDim2.new(0.5,0,0.82,0)
holder.Size = UDim2.new(0,400,0,45) -- Mở rộng holder
holder.BackgroundTransparency = 1
holder.ZIndex = 999999
holder.Parent = main

------------------------------------------------
-- CREATE SMALL BUTTON
------------------------------------------------
local function createSmallButton(text, link, xScale)
	local btn = Instance.new("TextButton")
	btn.AnchorPoint = Vector2.new(0.5,0) -- Căn giữa điểm neo
	btn.Position = UDim2.new(xScale,0,0,0)
	btn.Size = UDim2.new(0,120,0,38) -- Nút to hơn xíu
	btn.BackgroundColor3 = Color3.fromRGB(255,140,210)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.TextColor3 = Color3.new(1,1,1)
	btn.ZIndex = 999999
	btn.Parent = holder
	
	-- Bo góc
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,12)
	corner.Parent = btn
	
	-- Viền nhẹ cho nút nổi bật
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 2
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Transparency = 0.5
	stroke.Parent = btn

	btn.MouseButton1Click:Connect(function()
		setclipboard(link)
		local oldText = btn.Text
		btn.Text = "✔ COPIED"
		btn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
		task.wait(1)
		btn.Text = oldText
		btn.BackgroundColor3 = Color3.fromRGB(255,140,210)
	end)
end

------------------------------------------------
-- BUTTONS (Phân bổ vị trí đều hơn)
------------------------------------------------
createSmallButton(
	"DISCORD",
	"https://discord.gg/sWtCuDf6zw",
	0.16 -- Bên trái
)

createSmallButton(
	"YOUTUBE",
	"https://www.youtube.com/@Anura-gaming-real",
	0.50 -- Ở giữa
)

createSmallButton(
	"TIKTOK",
	"https://www.tiktok.com/@anura_gaming?_r=1&_t=ZS-935uxkiRVF2",
	0.84 -- Bên phải
)
