-- UI REMOVER - BLACKLIST MODE - XOÁ TỨC THÌ KHI XUẤT HIỆN

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- BLACKLIST TÊN GUI / OBJECT
local NameBlacklist = {
    "notification",
}

-- BLACKLIST TEXT
local TextBlacklist = {
    "fps",
    "ping",
    "ms",
    "x:",
    "y:",
    "z:",
    "on top",
    "script loaded"
}

-- Check blacklist
local function isBlacklisted(obj)
    local name = string.lower(obj.Name)
    
    for _, word in ipairs(NameBlacklist) do  
        if string.find(name, word) then  
            return true  
        end  
    end  
    
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then  
        local text = string.lower(obj.Text or "")  
        for _, word in ipairs(TextBlacklist) do  
            if string.find(text, word) then  
                return true  
            end  
        end  
    end  
    
    return false
end

-- Xoá UI và tất cả con cháu của nó
local function destroyBlacklisted(obj)
    pcall(function()
        obj:Destroy()
    end)
end

-- Xử lý khi có object mới xuất hiện (XOÁ TỨC THÌ)
local function handleNewObject(obj)
    -- Kiểm tra ngay lập tức
    if isBlacklisted(obj) then
        destroyBlacklisted(obj)
        return
    end
    
    -- Nếu là container, kiểm tra các con
    if obj:IsA("Frame") or obj:IsA("ScreenGui") or obj:IsA("ScrollingFrame") then
        task.defer(function()
            for _, child in ipairs(obj:GetDescendants()) do
                if isBlacklisted(child) then
                    destroyBlacklisted(child)
                end
            end
        end)
    end
end

-- Xoá tất cả UI hiện có
local function clearExistingUI()
    for _, container in ipairs({PlayerGui, CoreGui}) do
        for _, obj in ipairs(container:GetDescendants()) do
            if isBlacklisted(obj) then
                destroyBlacklisted(obj)
            end
        end
    end
end

-- THIẾT LẬP XOÁ TỨC THÌ KHI UI XUẤT HIỆN

-- 1. Xoá UI hiện có trước
clearExistingUI()

-- 2. Thiết lập listener để xoá ngay khi UI xuất hiện
for _, container in ipairs({PlayerGui, CoreGui}) do
    container.DescendantAdded:Connect(function(obj)
        -- Xử lý ngay không chờ
        task.spawn(function()
            handleNewObject(obj)
        end)
    end)
end

-- 3. Bắt cả sự kiện thay đổi text (để xoá khi text thay đổi thành blacklist)
local function setupTextChangeListener(obj)
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        local connection
        connection = obj:GetPropertyChangedSignal("Text"):Connect(function()
            if isBlacklisted(obj) then
                destroyBlacklisted(obj)
                if connection then
                    connection:Disconnect()
                end
            end
        end)
    end
end

-- Áp dụng listener text change cho tất cả UI hiện có và mới
for _, container in ipairs({PlayerGui, CoreGui}) do
    for _, obj in ipairs(container:GetDescendants()) do
        setupTextChangeListener(obj)
    end
    
    container.DescendantAdded:Connect(function(obj)
        setupTextChangeListener(obj)
    end)
end

print("⚡ UI BLACKLIST ACTIVE - Xoá tức thì khi xuất hiện")

-- 4. Chạy script Kaitun TRƯỚC
local kaitunSuccess, kaitunError = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AnDepZaiHub/AnDepZaiHubBeta/refs/heads/main/adzKaitun.lua"))()
end)

if kaitunSuccess then
    print("✅ Script Kaitun đã chạy xong")
    
    -- Chờ 1 giây để đảm bảo script Kaitun đã khởi tạo xong
    task.wait(1)
    
    -- 5. Sau đó chạy script thứ 2
    print("🔄 Đang chạy script thứ 2...")
    
    local cakSuccess, cakError = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MEOW-HUB-DEV/UI-hub/refs/heads/main/Cak.lua"))()
    end)
    
    if cakSuccess then
        print("✅ Script Cak đã chạy thành công")
    else
        warn("❌ Lỗi khi chạy script Cak:", cakError)
    end
else
    warn("❌ Lỗi khi chạy script Kaitun:", kaitunError)
    
    -- Thử chạy script thứ 2 ngay cả khi script Kaitun lỗi
    print("🔄 Thử chạy script thứ 2...")
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MEOW-HUB-DEV/UI-hub/refs/heads/main/Cak.lua"))()
    end)
end
