-- 🧹 ULTRA FAST UI DESTROYER + SCRIPT LOADER
-- ❌ UI không whitelist sẽ KHÔNG BAO GIỜ KỊP HIỆN

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

-- ✅ WHITELIST UI ĐƯỢC PHÉP TỒN TẠI
local Whitelist = {
    ["robloxgui"] = true,
    ["robloxpromptgui"] = true,
    ["experiencechat"] = true,
    ["screenshotscarousel"] = true,
    ["capturemanager"] = true,
    ["captureoverlay"] = true,
    ["robloxnetworkpausenotification"] = true,
    ["_fullscreentestgui"] = true,
    ["_devicetestgui"] = true,
    ["playerlist"] = true,
    ["inexperienceinterventionapp"] = true,
    ["purchasepromptapp"] = true,
    ["teleporteffectgui"] = true,
    ["rewardedvideoadplayer"] = true,
    ["systemscrim"] = true,
    ["calldialogscreen"] = true,
    ["playermenuscreen"] = true,
    ["contactlist"] = true,
    ["headsetdisconnecteddialog"] = true,
    ["screengui"] = false,
    ["touchgui"] = true,
    ["backpack"] = true,
    ["consumablestats"] = true,
    ["craft"] = true,
    ["customcursor"] = true,
    ["fishindex"] = true,
    ["viewportoverlay"] = true,
    ["hudnoinset"] = true,
    ["hiddenabilities"] = true,
    ["main"] = true,
    ["mobilecontextbuttons"] = true,
    ["scale"] = true,
    ["twittercodes"] = true,
    ["mobilemouselock"] = true,
    ["prompt"] = true,
    ["serverbrowser"] = true,
    ["servermodeinfo"] = true,
    ["playerprofile"] = true,
    ["spirittree"] = true,
    ["subclassmenu"] = true,
    ["templegui"] = true,
    ["titlesmenu"] = true,
    ["topbar"] = true,
    ["transformationhud"] = true,
    ["universalcontextbuttons"] = true,
    ["halloweenbundlemenuroot"] = true,
    ["fruitshopanddealer"] = true,
    ["inventory"] = true,
    ["accessorymerge"] = true,
    ["accessorytrasher"] = true,
    ["kyukonbundlemenuroot"] = true,
    ["meowhubui"] = true,
}

-- 🧠 xoá ngay lập tức (KHÔNG WAIT)
local function instantDestroy(gui)
    if not gui:IsA("ScreenGui") then return end
    local name = string.lower(gui.Name)
    if not Whitelist[name] then
        pcall(function()
            gui:Destroy()
        end)
    end
end

-- 🚀 quét ngay lập tức
for _, v in ipairs(CoreGui:GetChildren()) do
    instantDestroy(v)
end
for _, v in ipairs(PlayerGui:GetChildren()) do
    instantDestroy(v)
end

-- ⚡ BẮT UI NGAY KHI GẮN PARENT (CHƯA KỊP RENDER)
CoreGui.ChildAdded:Connect(instantDestroy)
PlayerGui.ChildAdded:Connect(instantDestroy)

-- ⚡ BẮT CẢ DESCENDANT (UI lồng trong folder)
CoreGui.DescendantAdded:Connect(instantDestroy)
PlayerGui.DescendantAdded:Connect(instantDestroy)

-- 🔥 QUÉT CỰC NHANH TRONG VÀI FRAME ĐẦU (ANTI FLASH)
local frames = 0
RunService.Stepped:Connect(function()
    frames += 1
    for _, v in ipairs(CoreGui:GetChildren()) do
        instantDestroy(v)
    end
    for _, v in ipairs(PlayerGui:GetChildren()) do
        instantDestroy(v)
    end
    if frames >= 10 then
        -- sau ~10 frame thì ngừng quét frame (đỡ tốn tài nguyên)
        script:Destroy()
    end
end)

------------------------------------------------
-- 🔥 LOAD SCRIPT (UI KHÔNG CÓ CƠ HỘI HIỆN)
------------------------------------------------

Config = {
    Team = "Pirates",
    Configuration = {
        HopWhenIdle = true,
        AutoHop = true,
        AutoHopDelay = 60 * 60,
        FpsBoost = false,
        BlackScreen = true
    },
    Items = {
        AutoFullyMelees = true,
        Saber = true,
        CursedDualKatana = true,
        SoulGuitar = true,
        RaceV2 = true
    },
    Settings = {
        StayInSea2UntilHaveDarkFragments = true
    }
}

loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/hhl29042008-ops/script/refs/heads/main/cac"
))()

print("⚡ skid cl chúng mày")
