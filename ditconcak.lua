-- 🔥 ULTRA FAST UI KILLER (SAFE WHITELIST)

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

------------------------------------------------
-- ✅ WHITELIST
------------------------------------------------
local Whitelist = {
    robloxgui = true,
    robloxpromptgui = true,
    experiencechat = true,
    screenshotscarousel = true,
    capturemanager = true,
    captureoverlay = true,
    robloxnetworkpausenotification = true,
    _fullscreentestgui = true,
    _devicetestgui = true,
    playerlist = true,
    inexperienceinterventionapp = true,
    purchasepromptapp = true,
    teleporteffectgui = true,
    rewardedvideoadplayer = true,
    systemscrim = true,
    calldialogscreen = true,
    playermenuscreen = true,
    contactlist = true,
    headsetdisconnecteddialog = true,
    screengui = false,
    touchgui = true,
    backpack = true,
    consumablestats = true,
    craft = true,
    customcursor = true,
    fishindex = true,
    viewportoverlay = true,
    hudnoinset = true,
    hiddenabilities = true,
    main = true,
    mobilecontextbuttons = true,
    scale = true,
    twittercodes = true,
    mobilemouselock = true,
    prompt = true,
    serverbrowser = true,
    servermodeinfo = true,
    playerprofile = true,
    spirittree = true,
    subclassmenu = true,
    templegui = true,
    titlesmenu = true,
    topbar = true,
    transformationhud = true,
    universalcontextbuttons = true,
    halloweenbundlemenuroot = true,
    fruitshopanddealer = true,
    inventory = true,
    accessorymerge = true,
    accessorytrasher = true,
    kyukonbundlemenuroot = true,
    meowhubui = true,
}

------------------------------------------------
-- 🔍 CHECK WHITELIST
------------------------------------------------
local function isWhitelisted(gui)
    local n = string.lower(gui.Name)
    return Whitelist[n] == true
end

------------------------------------------------
-- ❌ XOÁ TEXT 3TN
------------------------------------------------
local function purgeText(obj)
    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
        local t = obj.Text
        if t and string.find(string.lower(t), "3tn") then
            pcall(function() obj:Destroy() end)
        end
    end
end

------------------------------------------------
-- 💀 KILL UI
------------------------------------------------
local function kill(gui)
    if not gui:IsA("ScreenGui") then return end
    if isWhitelisted(gui) then return end

    pcall(function()
        gui.Enabled = false
        for _, d in ipairs(gui:GetDescendants()) do
            purgeText(d)
        end
        gui:Destroy()
    end)
end

------------------------------------------------
-- ⚡ CHẶN NGAY KHI UI SPAWN
------------------------------------------------
CoreGui.ChildAdded:Connect(kill)
PlayerGui.ChildAdded:Connect(kill)

------------------------------------------------
-- 🔄 QUÉT LIÊN TỤC (ANTI RENAME / ANTI RESPAWN)
------------------------------------------------
RunService.Heartbeat:Connect(function()
    for _, g in ipairs(CoreGui:GetChildren()) do
        kill(g)
    end
    for _, g in ipairs(PlayerGui:GetChildren()) do
        kill(g)
    end
end)

------------------------------------------------
-- 🚀 LOAD SCRIPT (SẼ BỊ DỌN UI NGAY)
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
-- Melees
AutoFullyMelees = true,
-- Swords
Saber = true,
CursedDualKatana = true,
-- Guns
SoulGuitar = true,
-- Upgrades
RaceV2 = true
},
Settings = {
StayInSea2UntilHaveDarkFragments = true
}
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/hhl29042008-ops/script/refs/heads/main/cac"))()
