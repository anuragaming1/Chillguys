-- DcusUI Series
-- by iksuwu
-- Morten UI
-- Premium Edition v3.0

--[[
[+] Premium Features:
    • Smooth Blur Open/Close Animation
    • Slide + Fade Tab Transition
    • Hover Effects + Ripple Touch
    • Elastic Sidebar Indicator
    • Theme Manager (Dark/Neon/Glass)
    • Floating Mini Button
    • Particle Glow Accent
    • Save/Load Config System
    • Animated Loading Screen
    • Sound Feedback
    • Search Bar
    • Collapsible Sections
]]

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = game:GetService("Players").LocalPlayer
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

-- Utility Functions
local function Create(class, props, children)
    local obj = Instance.new(class)
    for k,v in pairs(props or {}) do obj[k] = v end
    for _,c in pairs(children or {}) do c.Parent = obj end
    return obj
end

local function CreateRipple(parent, x, y, color)
    color = color or Color3.fromRGB(255, 255, 255)
    local ripple = Create("Frame", {
        Size = UDim2.fromOffset(0, 0),
        Position = UDim2.fromOffset(x, y),
        BackgroundColor3 = color,
        BackgroundTransparency = 0.7,
        Parent = parent,
        ZIndex = 10
    }, {
        Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    local expand = TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(parent.AbsoluteSize.X * 2, parent.AbsoluteSize.X * 2),
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(x - parent.AbsoluteSize.X, y - parent.AbsoluteSize.X)
    })
    
    expand:Play()
    expand.Completed:Connect(function()
        ripple:Destroy()
    end)
end

local function PlaySound(soundType)
    local sounds = {
        Click = "rbxassetid://9120386860",
        Toggle = "rbxassetid://9120387968",
        Hover = "rbxassetid://9120385543",
        Tab = "rbxassetid://9120389165"
    }
    
    local sound = Instance.new("Sound")
    sound.SoundId = sounds[soundType] or sounds.Click
    sound.Volume = 0.3
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 1)
end

local function CreateGlow(parent, color)
    color = color or Color3.fromRGB(80, 150, 255)
    local glow = Create("Frame", {
        Size = UDim2.fromScale(1.2, 1.2),
        Position = UDim2.fromScale(-0.1, -0.1),
        BackgroundColor3 = color,
        BackgroundTransparency = 0.7,
        Parent = parent,
        ZIndex = parent.ZIndex - 1
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 8)})
    })
    
    local tween = TweenService:Create(glow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1), {
        BackgroundTransparency = 0.9,
        Size = UDim2.fromScale(1.3, 1.3)
    })
    tween:Play()
    
    return glow
end

-- Library Setup
local Library = {}
Library.__index = Library

-- Theme System
Library.Themes = {
    Dark = {
        Main = Color3.fromRGB(15, 15, 20),
        Top = Color3.fromRGB(20, 20, 28),
        Sidebar = Color3.fromRGB(20, 20, 28),
        Element = Color3.fromRGB(22, 22, 30),
        ElementHover = Color3.fromRGB(28, 32, 42),
        Accent = Color3.fromRGB(80, 150, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(150, 150, 170),
        Stroke = Color3.fromRGB(45, 45, 60),
        StrokeAccent = Color3.fromRGB(80, 150, 255)
    },
    Neon = {
        Main = Color3.fromRGB(10, 10, 15),
        Top = Color3.fromRGB(15, 15, 25),
        Sidebar = Color3.fromRGB(15, 15, 25),
        Element = Color3.fromRGB(20, 20, 35),
        ElementHover = Color3.fromRGB(30, 30, 50),
        Accent = Color3.fromRGB(0, 255, 200),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(150, 200, 255),
        Stroke = Color3.fromRGB(0, 200, 255),
        StrokeAccent = Color3.fromRGB(0, 255, 200)
    },
    Glass = {
        Main = Color3.fromRGB(20, 20, 30),
        Top = Color3.fromRGB(25, 25, 35),
        Sidebar = Color3.fromRGB(25, 25, 35),
        Element = Color3.fromRGB(30, 30, 40),
        ElementHover = Color3.fromRGB(35, 35, 50),
        Accent = Color3.fromRGB(150, 200, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 210),
        Stroke = Color3.fromRGB(80, 100, 150),
        StrokeAccent = Color3.fromRGB(100, 150, 255)
    }
}

-- Setting Manager
function Library.SettingManager()
    local Manager = {}
    function Manager:AddToTab(tab)
        tab:Paragraph({
            Title = "UI Settings",
            Content = "Manage the interface settings and keybindings here."
        })

        tab:Dropdown({
            Name = "Theme",
            List = {"Dark", "Neon", "Glass"},
            Default = "Dark",
            Callback = function(theme)
                Library:SetTheme(theme)
            end
        })

        tab:Keybind({
            Name = "UI Toggle Key",
            Default = Library.ToggleKey,
            OnChange = function(New)
                Library.ToggleKey = New
            end
        })

        tab:Toggle({
            Name = "Sound Effects",
            Default = true,
            Callback = function(state)
                Library.SoundEnabled = state
            end
        })

        tab:Toggle({
            Name = "Particle Effects",
            Default = true,
            Callback = function(state)
                Library.ParticlesEnabled = state
            end
        })

        tab:Button({
            Name = "Save Config",
            Callback = function()
                Library:SaveConfig("DcusConfig")
                Library:Notify({
                    Title = "Success",
                    Content = "Configuration saved!",
                    Type = "Success",
                    Time = 3
                })
            end
        })

        tab:Button({
            Name = "Load Config",
            Callback = function()
                Library:LoadConfig("DcusConfig")
                Library:Notify({
                    Title = "Success",
                    Content = "Configuration loaded!",
                    Type = "Success",
                    Time = 3
                })
            end
        })

        tab:Button({
            Name = "Unload UI",
            Callback = function()
                Library:Unload()
            end
        })
    end
    return Manager
end

-- Main Library Constructor
function Library:New(config)
    local self = setmetatable({}, Library)
    
    -- Configuration
    self.Title = config.Title or "Dcus Hub"
    self.Footer = config.Footer or "Premium Interface • v3.0"
    self.ToggleKey = config.ToggleKey or Enum.KeyCode.RightShift
    self.CurrentTheme = "Dark"
    self.SoundEnabled = true
    self.ParticlesEnabled = true
    self.Sections = {}
    
    -- Create GUI
    self.Gui = Create("ScreenGui", {
        Name = "DcusHub_v3.0 UI",
        ResetOnSpawn = false,
        Parent = (gethui and gethui()) or Player:WaitForChild("PlayerGui"),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Create Blur Effect
    self.Blur = Instance.new("BlurEffect")
    self.Blur.Size = 0
    self.Blur.Parent = Lighting
    
    -- Create Loading Screen
    self.LoadingScreen = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(10, 10, 15),
        BackgroundTransparency = 0,
        Parent = self.Gui,
        ZIndex = 1000
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 0)}),
        Create("ImageLabel", {
            Name = "Logo",
            Size = UDim2.fromOffset(100, 100),
            Position = UDim2.fromScale(0.5, 0.45),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = "rbxassetid://3926305904",
            ImageColor3 = Color3.fromRGB(80, 150, 255),
            ZIndex = 1001
        }),
        Create("TextLabel", {
            Name = "LoadingText",
            Text = "LOADING...",
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextColor3 = Color3.fromRGB(150, 150, 170),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0.5, 0.55),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ZIndex = 1001
        }),
        Create("Frame", {
            Name = "LoadingBar",
            Size = UDim2.fromOffset(200, 4),
            Position = UDim2.fromScale(0.5, 0.6),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(30, 30, 40),
            ZIndex = 1001
        }, {
            Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
            Create("Frame", {
                Name = "Fill",
                Size = UDim2.fromScale(0, 1),
                BackgroundColor3 = Color3.fromRGB(80, 150, 255),
                ZIndex = 1002
            }, {
                Create("UICorner", {CornerRadius = UDim.new(1, 0)})
            })
        })
    })
    
    -- Animate Loading Screen
    local loadingBar = self.LoadingScreen.LoadingBar.Fill
    local loadingText = self.LoadingScreen.LoadingText
    local logo = self.LoadingScreen.Logo
    
    TweenService:Create(loadingBar, TweenInfo.new(1.5, Enum.EasingStyle.Quart), {
        Size = UDim2.fromScale(1, 1)
    }):Play()
    
    task.spawn(function()
        local dots = 0
        while task.wait(0.3) do
            dots = (dots + 1) % 4
            loadingText.Text = "LOADING" .. string.rep(".", dots)
        end
    end)
    
    task.wait(1.8)
    
    -- Create Main UI
    self.Main = Create("Frame", {
        Name = "Main",
        Size = UDim2.fromScale(0.95, 0.95),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Library.Themes.Dark.Main,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = self.Gui,
        Visible = false,
        ZIndex = 1
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 16)}),
        Create("UIStroke", {
            Color = Library.Themes.Dark.Stroke,
            Thickness = 1.5,
            Transparency = 0.5
        })
    })
    
    -- Top Bar
    self.Top = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = Library.Themes.Dark.Top,
        BackgroundTransparency = 1,
        Parent = self.Main,
        ZIndex = 2
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 16)}),
        Create("Frame", {
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, 1, -1),
            BackgroundColor3 = Library.Themes.Dark.Stroke,
            BorderSizePixel = 0,
            BackgroundTransparency = 0.5
        })
    })
    
    -- Title
    Create("TextLabel", {
        Text = self.Title,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = Library.Themes.Dark.Text,
        TextXAlignment = "Left",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(20, 10),
        Size = UDim2.new(0, 200, 0, 25),
        Parent = self.Top,
        ZIndex = 3
    })
    
    -- Subtitle
    Create("TextLabel", {
        Text = self.Footer,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = Library.Themes.Dark.TextSecondary,
        TextXAlignment = "Left",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 200, 0, 20),
        Position = UDim2.fromOffset(20, 32),
        Parent = self.Top,
        ZIndex = 3
    })
    
    -- Toggle Button
    self.ToggleBtn = Create("TextButton", {
        Name = "ToggleBtn",
        Text = "≡",
        Font = Enum.Font.GothamBold,
        TextSize = 24,
        TextColor3 = Library.Themes.Dark.Text,
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(40, 40),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(1, -50, 0, 30),
        ZIndex = 50,
        Parent = self.Main
    })
    
    Create("Frame", {
        Name = "BtnBg",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Library.Themes.Dark.Element,
        ZIndex = 49,
        Parent = self.ToggleBtn
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
        Create("UIStroke", {
            Color = Library.Themes.Dark.Stroke,
            Thickness = 1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })
    })
    
    -- Container
    self.Container = Create("Frame", {
        Size = UDim2.new(1, 0, 1, -60),
        Position = UDim2.fromOffset(0, 60),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Visible = true,
        ZIndex = 1,
        Parent = self.Main
    })
    
    -- Sidebar
    self.Sidebar = Create("Frame", {
        Size = UDim2.new(0, 160, 1, -20),
        Position = UDim2.fromOffset(10, 10),
        BackgroundColor3 = Library.Themes.Dark.Sidebar,
        BackgroundTransparency = 1,
        Parent = self.Container,
        ZIndex = 2
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 12)}),
        Create("UIStroke", {
            Color = Library.Themes.Dark.Stroke,
            Thickness = 1,
            Transparency = 0.5
        })
    })
    
    -- Tab Highlight
    self.TabHighlight = Create("Frame", {
        Size = UDim2.new(1, -16, 0, 38),
        Position = UDim2.fromOffset(8, 8),
        BackgroundColor3 = Library.Themes.Dark.Accent,
        BackgroundTransparency = 0.9,
        Visible = false,
        ZIndex = 3,
        Parent = self.Sidebar
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
        Create("UIStroke", {
            Color = Library.Themes.Dark.Accent,
            Thickness = 1,
            Transparency = 0.6
        })
    })
    
    -- Tab Holder
    self.TabHolder = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 4,
        Parent = self.Sidebar
    }, {
        Create("UIListLayout", {Padding = UDim.new(0, 6)}),
        Create("UIPadding", {
            PaddingTop = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8)
        })
    })
    
    -- Pages Container
    self.Pages = Create("Frame", {
        Size = UDim2.new(1, -190, 1, -20),
        Position = UDim2.fromOffset(180, 10),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = self.Container,
        ZIndex = 1
    })
    
    -- Search Bar
    self.SearchBar = Create("Frame", {
        Size = UDim2.new(1, -190, 0, 35),
        Position = UDim2.fromOffset(180, 10),
        BackgroundColor3 = Library.Themes.Dark.Element,
        BackgroundTransparency = 1,
        Visible = false,
        Parent = self.Container,
        ZIndex = 5
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
        Create("UIStroke", {
            Color = Library.Themes.Dark.Stroke,
            Thickness = 1,
            Transparency = 0.5
        }),
        Create("TextBox", {
            Name = "Input",
            PlaceholderText = "🔍 Search scripts...",
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextColor3 = Library.Themes.Dark.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.fromOffset(10, 0),
            ClearTextOnFocus = false,
            ZIndex = 6
        })
    })
    
    -- Floating Mini Button
    self.MiniButton = Create("Frame", {
        Size = UDim2.fromOffset(55, 55),
        Position = UDim2.fromScale(0.95, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Library.Themes.Dark.Accent,
        BackgroundTransparency = 1,
        Visible = false,
        Parent = self.Gui,
        ZIndex = 100
    }, {
        Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
        Create("UIStroke", {
            Color = Library.Themes.Dark.Accent,
            Thickness = 2,
            Transparency = 0.3
        }),
        Create("ImageLabel", {
            Image = "rbxassetid://3926305904",
            Size = UDim2.fromOffset(30, 30),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            ZIndex = 101
        }),
        Create("TextButton", {
            Text = "",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ZIndex = 102
        })
    })
    
    -- Mini Button Drag
    do
        local dragging, dragInput, dragStart, startPos
        
        self.MiniButton.TextButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = self.MiniButton.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        UIS.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                self.MiniButton.Position = UDim2.new(
                    startPos.X.Scale, 
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
        
        self.MiniButton.TextButton.MouseButton1Click:Connect(function()
            self:ToggleUI()
        end)
    end
    
    -- Drag Functionality
    do
        local dragging, dragInput, dragStart, startPos
        
        local function update(input)
            local delta = input.Position - dragStart
            self.Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
        
        self.Top.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = self.Main.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        UIS.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                update(input)
            end
        end)
    end
    
    -- Toggle Function
    self.Open = true
    self.ToggleBtn.MouseButton1Click:Connect(function()
        self:ToggleUI()
    end)
    
    -- Keybind Toggle
    UIS.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == self.ToggleKey then
            self:ToggleUI()
        end
    end)
    
    -- Animate Loading Screen Out
    TweenService:Create(self.LoadingScreen, TweenInfo.new(0.5), {
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(self.LoadingScreen.Logo, TweenInfo.new(0.5), {
        ImageTransparency = 1
    }):Play()
    
    TweenService:Create(self.LoadingScreen.LoadingText, TweenInfo.new(0.5), {
        TextTransparency = 1
    }):Play()
    
    TweenService:Create(self.LoadingScreen.LoadingBar, TweenInfo.new(0.5), {
        BackgroundTransparency = 1
    }):Play()
    
    task.wait(0.5)
    self.LoadingScreen:Destroy()
    
    -- Show Main UI
    self.Main.Visible = true
    
    -- Open Animation
    TweenService:Create(self.Blur, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
        Size = 15
    }):Play()
    
    TweenService:Create(self.Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 0
    }):Play()
    
    TweenService:Create(self.Top, TweenInfo.new(0.4), {
        BackgroundTransparency = 0
    }):Play()
    
    TweenService:Create(self.Sidebar, TweenInfo.new(0.4), {
        BackgroundTransparency = 0
    }):Play()
    
    for _, child in pairs(self.Container:GetDescendants()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            TweenService:Create(child, TweenInfo.new(0.3), {
                TextTransparency = 0
            }):Play()
        end
    end
    
    return self
end

-- Toggle UI Function
function Library:ToggleUI()
    self.Open = not self.Open
    
    if self.SoundEnabled then
        PlaySound("Click")
    end
    
    if self.Open then
        self.Main.Visible = true
        self.MiniButton.Visible = false
        
        TweenService:Create(self.Blur, TweenInfo.new(0.4), {Size = 15}):Play()
        
        TweenService:Create(self.Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 0
        }):Play()
        
        TweenService:Create(self.Top, TweenInfo.new(0.4), {
            BackgroundTransparency = 0
        }):Play()
        
        TweenService:Create(self.Sidebar, TweenInfo.new(0.4), {
            BackgroundTransparency = 0
        }):Play()
    else
        TweenService:Create(self.Blur, TweenInfo.new(0.4), {Size = 0}):Play()
        
        TweenService:Create(self.Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
            Size = UDim2.fromScale(0.95, 0.95),
            BackgroundTransparency = 1
        }):Play()
        
        TweenService:Create(self.Top, TweenInfo.new(0.4), {
            BackgroundTransparency = 1
        }):Play()
        
        TweenService:Create(self.Sidebar, TweenInfo.new(0.4), {
            BackgroundTransparency = 1
        }):Play()
        
        task.wait(0.4)
        self.Main.Visible = false
        self.MiniButton.Visible = true
        
        TweenService:Create(self.MiniButton, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            BackgroundTransparency = 0,
            Size = UDim2.fromOffset(60, 60)
        }):Play()
        
        task.wait(0.1)
        TweenService:Create(self.MiniButton, TweenInfo.new(0.2), {
            Size = UDim2.fromOffset(55, 55)
        }):Play()
    end
end

-- Set Theme Function
function Library:SetTheme(themeName)
    local theme = self.Themes[themeName]
    if not theme then return end
    
    self.CurrentTheme = themeName
    
    -- Tween Main Elements
    TweenService:Create(self.Main, TweenInfo.new(0.5), {
        BackgroundColor3 = theme.Main
    }):Play()
    
    TweenService:Create(self.Top, TweenInfo.new(0.5), {
        BackgroundColor3 = theme.Top
    }):Play()
    
    TweenService:Create(self.Sidebar, TweenInfo.new(0.5), {
        BackgroundColor3 = theme.Sidebar
    }):Play()
    
    -- Update Strokes
    for _, stroke in pairs(self.Main:GetDescendants()) do
        if stroke:IsA("UIStroke") then
            TweenService:Create(stroke, TweenInfo.new(0.5), {
                Color = theme.Stroke
            }):Play()
        end
    end
    
    -- Update Tab Highlight
    TweenService:Create(self.TabHighlight, TweenInfo.new(0.5), {
        BackgroundColor3 = theme.Accent
    }):Play()
    
    TweenService:Create(self.TabHighlight:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.5), {
        Color = theme.Accent
    }):Play()
end

-- Save/Load Config
function Library:SaveConfig(name)
    local config = {
        Theme = self.CurrentTheme,
        ToggleKey = self.ToggleKey.Name,
        Elements = {}
    }
    
    local json = HttpService:JSONEncode(config)
    
    if writefile then
        writefile(name .. ".json", json)
    else
        self:Notify({
            Title = "Warning",
            Content = "Save system not available in this environment",
            Type = "Warning",
            Time = 3
        })
    end
end

function Library:LoadConfig(name)
    if not readfile then return end
    
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(name .. ".json"))
    end)
    
    if success then
        self:SetTheme(data.Theme)
        self.ToggleKey = Enum.KeyCode[data.ToggleKey]
        
        self:Notify({
            Title = "Success",
            Content = "Configuration loaded!",
            Type = "Success",
            Time = 3
        })
    end
end

-- Unload UI
function Library:Unload()
    TweenService:Create(self.Blur, TweenInfo.new(0.4), {Size = 0}):Play()
    
    TweenService:Create(self.Main, TweenInfo.new(0.4), {
        Size = UDim2.fromScale(0.9, 0.9),
        BackgroundTransparency = 1
    }):Play()
    
    task.wait(0.4)
    self.Gui:Destroy()
    self.Blur:Destroy()
end

-- Notification System
function Library:Notify(config)
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local notifType = config.Type or "Info"
    local duration = config.Time or 5
    
    local colors = {
        Success = Color3.fromRGB(80, 200, 120),
        Warning = Color3.fromRGB(255, 180, 60),
        Error = Color3.fromRGB(255, 80, 80),
        Info = Color3.fromRGB(80, 150, 255)
    }
    
    local icons = {
        Success = "✓",
        Warning = "⚠",
        Error = "✗",
        Info = "ℹ"
    }
    
    local notifColor = colors[notifType] or colors.Info
    
    local NotifGui = self.Gui:FindFirstChild("Notifications") or Create("Frame", {
        Name = "Notifications",
        Size = UDim2.new(0, 300, 1, -20),
        Position = UDim2.new(1, -310, 0, 10),
        BackgroundTransparency = 1,
        Parent = self.Gui,
        ZIndex = 200
    }, {
        Create("UIListLayout", {
            VerticalAlignment = "Bottom",
            HorizontalAlignment = "Right",
            Padding = UDim.new(0, 10)
        })
    })
    
    local Notif = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(20, 20, 28),
        BackgroundTransparency = 1,
        Parent = NotifGui,
        ZIndex = 201
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 12)}),
        Create("UIStroke", {
            Color = notifColor,
            Thickness = 1.5,
            Transparency = 1
        })
    })
    
    local IconLabel = Create("TextLabel", {
        Text = icons[notifType],
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = notifColor,
        BackgroundTransparency = 1,
        TextTransparency = 1,
        Position = UDim2.fromOffset(12, 12),
        Size = UDim2.fromOffset(24, 24),
        Parent = Notif
    })
    
    local TitleLabel = Create("TextLabel", {
        Text = title:upper(),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = notifColor,
        BackgroundTransparency = 1,
        TextTransparency = 1,
        Position = UDim2.fromOffset(44, 12),
        Size = UDim2.new(1, -56, 0, 15),
        TextXAlignment = "Left",
        Parent = Notif
    })
    
    local ContentLabel = Create("TextLabel", {
        Text = content,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(180, 180, 200),
        BackgroundTransparency = 1,
        TextTransparency = 1,
        Position = UDim2.fromOffset(44, 30),
        Size = UDim2.new(1, -56, 0, 0),
        TextXAlignment = "Left",
        TextYAlignment = "Top",
        TextWrapped = true,
        Parent = Notif
    })
    
    local ProgressBar = Create("Frame", {
        Size = UDim2.new(1, -24, 0, 2),
        Position = UDim2.fromOffset(12, 0),
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = notifColor,
        BackgroundTransparency = 1,
        Parent = Notif
    }, {
        Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    local ts = game:GetService("TextService"):GetTextSize(content, 12, Enum.Font.GothamMedium, Vector2.new(220, 10000))
    local targetSizeY = ts.Y + 50
    
    Notif.Size = UDim2.new(1, 0, 0, targetSizeY)
    Notif.Position = UDim2.new(1, 50, 0, 0)
    ProgressBar.Position = UDim2.fromOffset(12, targetSizeY - 6)
    
    -- Animate In
    TweenService:Create(Notif, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
        BackgroundTransparency = 0,
        Position = UDim2.new(1, -10, 0, 0)
    }):Play()
    
    TweenService:Create(Notif.UIStroke, TweenInfo.new(0.5), {Transparency = 0.5}):Play()
    TweenService:Create(IconLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(TitleLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(ContentLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(ProgressBar, TweenInfo.new(0.5), {BackgroundTransparency = 0.5}):Play()
    
    -- Progress Bar Animation
    TweenService:Create(ProgressBar, TweenInfo.new(duration), {
        Size = UDim2.new(0, 0, 0, 2)
    }):Play()
    
    -- Auto Close
    task.delay(duration, function()
        TweenService:Create(Notif, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
            BackgroundTransparency = 1,
            Position = UDim2.new(1, 50, 0, 0)
        }):Play()
        
        TweenService:Create(Notif.UIStroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
        TweenService:Create(IconLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(TitleLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(ContentLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(ProgressBar, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        
        task.wait(0.5)
        Notif:Destroy()
    end)
end

-- New Tab Function
function Library:NewTab(name)
    local Tab = {}
    
    -- Tab Button Background
    local TabBg = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Library.Themes.Dark.Element,
        Parent = self.TabHolder,
        ZIndex = 5
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
        Create("UIStroke", {
            Color = Library.Themes.Dark.Stroke,
            Thickness = 1,
            Transparency = 0.5
        })
    })
    
    -- Tab Dot
    local Dot = Create("Frame", {
        Size = UDim2.fromOffset(6, 6),
        Position = UDim2.new(0, 12, 0.5, -3),
        BackgroundColor3 = Library.Themes.Dark.TextSecondary,
        Parent = TabBg,
        ZIndex = 6
    }, {
        Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    })
    
    -- Tab Button
    local TabBtn = Create("TextButton", {
        Text = name,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = Library.Themes.Dark.TextSecondary,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Parent = TabBg,
        ZIndex = 6
    })
    
    -- Tab Page
    local Page = Create("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = false,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Library.Themes.Dark.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = self.Pages,
        ZIndex = 2,
        Position = UDim2.fromOffset(500, 0)
    }, {
        Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        }),
        Create("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 10)
        })
    })
    
    -- Search Box for this tab
    local SearchBox = Create("Frame", {
        Size = UDim2.new(1, -5, 0, 35),
        BackgroundColor3 = Library.Themes.Dark.Element,
        BackgroundTransparency = 0,
        Parent = Page,
        LayoutOrder = -1,
        Visible = false,
        ZIndex = 7
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Create("UIStroke", {
            Color = Library.Themes.Dark.Stroke,
            Thickness = 1
        }),
        Create("TextBox", {
            Name = "Input",
            PlaceholderText = "🔍 Search...",
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextColor3 = Library.Themes.Dark.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -30, 1, 0),
            Position = UDim2.fromOffset(15, 0),
            ClearTextOnFocus = false,
            ZIndex = 8
        })
    })
    
    Page.SearchBox = SearchBox
    
    -- Canvas Size Update
    local UIListLayout = Page:FindFirstChildOfClass("UIListLayout")
    
    local function UpdateCanvasSize()
        Page.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
    end
    
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvasSize)
    task.spawn(UpdateCanvasSize)
    
    -- Tab Click Animation
    TabBtn.MouseButton1Click:Connect(function()
        if self.SoundEnabled then
            PlaySound("Tab")
        end
        
        -- Animate current tab out
        for _, page in pairs(self.Pages:GetChildren()) do
            if page:IsA("ScrollingFrame") and page.Visible then
                TweenService:Create(page, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                    Position = UDim2.fromOffset(-500, 0),
                    BackgroundTransparency = 1
                }):Play()
                
                for _, child in pairs(page:GetDescendants()) do
                    if child:IsA("TextLabel") or child:IsA("TextButton") then
                        TweenService:Create(child, TweenInfo.new(0.2), {
                            TextTransparency = 1
                        }):Play()
                    end
                end
                
                task.wait(0.25)
                page.Visible = false
                page.Position = UDim2.fromOffset(0, 0)
            end
        end
        
        -- Prepare new page
        Page.Visible = true
        Page.Position = UDim2.fromOffset(500, 0)
        Page.BackgroundTransparency = 1
        
        for _, child in pairs(Page:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") then
                child.TextTransparency = 1
            end
        end
        
        -- Animate new page in
        TweenService:Create(Page, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
            Position = UDim2.fromOffset(0, 0),
            BackgroundTransparency = 0
        }):Play()
        
        for _, child in pairs(Page:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") then
                TweenService:Create(child, TweenInfo.new(0.3), {
                    TextTransparency = 0
                }):Play()
            end
        end
        
        -- Animate Tab Highlight
        self.TabHighlight.Visible = true
        local yPos = TabBg.AbsolutePosition.Y - self.Sidebar.AbsolutePosition.Y
        
        -- Elastic Animation
        TweenService:Create(self.TabHighlight, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
            Size = UDim2.new(1, -16, 0, 45),
            Position = UDim2.fromOffset(8, yPos - 3)
        }):Play()
        
        task.wait(0.15)
        TweenService:Create(self.TabHighlight, TweenInfo.new(0.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, -16, 0, 38),
            Position = UDim2.fromOffset(8, yPos)
        }):Play()
        
        -- Reset other tabs
        for _, bg in pairs(self.TabHolder:GetChildren()) do
            if bg:IsA("Frame") then
                local btn = bg:FindFirstChildOfClass("TextButton")
                local dot = bg:FindFirstChild("Frame")
                local stroke = bg:FindFirstChildOfClass("UIStroke")
                
                if btn and btn ~= TabBtn then
                    TweenService:Create(btn, TweenInfo.new(0.2), {
                        TextColor3 = Library.Themes[self.CurrentTheme].TextSecondary
                    }):Play()
                end
                
                if dot and dot ~= Dot then
                    TweenService:Create(dot, TweenInfo.new(0.2), {
                        BackgroundColor3 = Library.Themes[self.CurrentTheme].TextSecondary
                    }):Play()
                end
            end
        end
        
        -- Highlight current tab
        TweenService:Create(TabBtn, TweenInfo.new(0.2), {
            TextColor3 = Library.Themes[self.CurrentTheme].Text
        }):Play()
        
        TweenService:Create(Dot, TweenInfo.new(0.2), {
            BackgroundColor3 = Library.Themes[self.CurrentTheme].Accent
        }):Play()
    end)
    
    -- Hover Effects
    TabBtn.MouseEnter:Connect(function()
        if self.SoundEnabled then
            PlaySound("Hover")
        end
        
        TweenService:Create(TabBg, TweenInfo.new(0.2), {
            BackgroundColor3 = Library.Themes[self.CurrentTheme].ElementHover
        }):Play()
    end)
    
    TabBtn.MouseLeave:Connect(function()
        TweenService:Create(TabBg, TweenInfo.new(0.3), {
            BackgroundColor3 = Library.Themes[self.CurrentTheme].Element
        }):Play()
    end)
    
    -- UI Elements Functions
    function Tab:Button(config)
        local text = config.Name or config.Text or "Button"
        local callback = config.Callback or function() end
        
        local BtnBg = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Element,
            Parent = Page,
            ZIndex = 3
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
            Create("UIStroke", {
                Color = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Stroke,
                Thickness = 1,
                Transparency = 0.5
            })
        })
        
        Create("TextLabel", {
            Text = text,
            Font = Enum.Font.GothamMedium,
            TextSize = 14,
            TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Text,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(15, 0),
            Size = UDim2.new(1, -100, 1, 0),
            TextXAlignment = "Left",
            Parent = BtnBg,
            ZIndex = 4
        })
        
        local RunBadge = Create("Frame", {
            Size = UDim2.fromOffset(50, 26),
            Position = UDim2.new(1, -60, 0.5, -13),
            BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].ElementHover,
            Parent = BtnBg,
            ZIndex = 4
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            Create("UIStroke", {
                Color = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent,
                Thickness = 1
            }),
            Create("TextLabel", {
                Text = "▶ RUN",
                Font = Enum.Font.GothamBold,
                TextSize = 10,
                TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                ZIndex = 5
            })
        })
        
        local Hit = Create("TextButton", {
            Text = "",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ZIndex = 10,
            Parent = BtnBg
        })
        
        -- Hover
        Hit.MouseEnter:Connect(function()
            TweenService:Create(BtnBg, TweenInfo.new(0.2), {
                BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].ElementHover
            }):Play()
            
            TweenService:Create(RunBadge, TweenInfo.new(0.2), {
                BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent
            }):Play()
            
            TweenService:Create(RunBadge.TextLabel, TweenInfo.new(0.2), {
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        end)
        
        Hit.MouseLeave:Connect(function()
            TweenService:Create(BtnBg, TweenInfo.new(0.3), {
                BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Element
            }):Play()
            
            TweenService:Create(RunBadge, TweenInfo.new(0.3), {
                BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].ElementHover
            }):Play()
            
            TweenService:Create(RunBadge.TextLabel, TweenInfo.new(0.3), {
                TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent
            }):Play()
        end)
        
        -- Click
        Hit.MouseButton1Click:Connect(function(input)
            if self.Main.Parent.Parent.SoundEnabled then
                PlaySound("Click")
            end
            
            if self.Main.Parent.Parent.ParticlesEnabled then
                local mousePos = UIS:GetMouseLocation()
                local absPos = BtnBg.AbsolutePosition
                local x = mousePos.X - absPos.X
                local y = mousePos.Y - absPos.Y
                CreateRipple(BtnBg, x, y, Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent)
            end
            
            TweenService:Create(BtnBg, TweenInfo.new(0.1), {
                BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent
            }):Play()
            
            task.wait(0.1)
            
            TweenService:Create(BtnBg, TweenInfo.new(0.2), {
                BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Element
            }):Play()
            
            callback()
        end)
    end
    
    function Tab:Toggle(config)
        local text = config.Name or "Toggle"
        local callback = config.Callback or function() end
        local state = config.Default or false
        
        local TglBg = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Element,
            Parent = Page,
            ZIndex = 3
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
            Create("UIStroke", {
                Color = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Stroke,
                Thickness = 1,
                Transparency = 0.5
            })
        })
        
        Create("TextLabel", {
            Text = text,
            Font = Enum.Font.GothamMedium,
            TextSize = 14,
            TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Text,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(15, 0),
            Size = UDim2.new(1, -80, 1, 0),
            TextXAlignment = "Left",
            Parent = TglBg,
            ZIndex = 4
        })
        
        local Switch = Create("Frame", {
            Size = UDim2.fromOffset(45, 24),
            Position = UDim2.new(1, -60, 0.5, -12),
            BackgroundColor3 = state and Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent or Library.Themes[self.Main.Parent.Parent.CurrentTheme].ElementHover,
            Parent = TglBg,
            ZIndex = 4
        }, {
            Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
            Create("UIStroke", {
                Color = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent,
                Thickness = 1,
                Transparency = state and 0.3 or 0.7
            })
        })
        
        local Knob = Create("Frame", {
            Size = UDim2.fromOffset(20, 20),
            Position = state and UDim2.fromOffset(23, 2) or UDim2.fromOffset(2, 2),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Switch,
            ZIndex = 5
        }, {
            Create("UICorner", {CornerRadius = UDim.new(1, 0)})
        })
        
        if self.Main.Parent.Parent.ParticlesEnabled and state then
            CreateGlow(Switch, Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent)
        end
        
        local function updateView(val)
            TweenService:Create(Switch, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
                BackgroundColor3 = val and Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent or Library.Themes[self.Main.Parent.Parent.CurrentTheme].ElementHover
            }):Play()
            
            TweenService:Create(Switch.UIStroke, TweenInfo.new(0.2), {
                Transparency = val and 0.3 or 0.7
            }):Play()
            
            TweenService:Create(Knob, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
                Position = val and UDim2.fromOffset(23, 2) or UDim2.fromOffset(2, 2)
            }):Play()
        end
        
        local Hit = Create("TextButton", {
            Text = "",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ZIndex = 10,
            Parent = TglBg
        })
        
        Hit.MouseButton1Click:Connect(function(input)
            if self.Main.Parent.Parent.SoundEnabled then
                PlaySound("Toggle")
            end
            
            if self.Main.Parent.Parent.ParticlesEnabled then
                local mousePos = UIS:GetMouseLocation()
                local absPos = TglBg.AbsolutePosition
                local x = mousePos.X - absPos.X
                local y = mousePos.Y - absPos.Y
                CreateRipple(TglBg, x, y, Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent)
            end
            
            state = not state
            updateView(state)
            
            if state and self.Main.Parent.Parent.ParticlesEnabled then
                CreateGlow(Switch, Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent)
            end
            
            callback(state)
        end)
        
        local ToggleFunctions = {}
        function ToggleFunctions:SetValue(val)
            state = val
            updateView(state)
            callback(state)
        end
        
        return ToggleFunctions
    end
    
    function Tab:Slider(config)
        local text = config.Name or "Slider"
        local min = config.Min or 0
        local max = config.Max or 100
        local default = config.Default or min
        local rounding = config.Rounding or 0
        local callback = config.Callback or function() end
        local suffix = config.Suffix or ""
        
        local SliderBg = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 60),
            BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Element,
            Parent = Page,
            ZIndex = 3
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
            Create("UIStroke", {
                Color = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Stroke,
                Thickness = 1,
                Transparency = 0.5
            })
        })
        
        local Label = Create("TextLabel", {
            Text = text,
            Font = Enum.Font.GothamMedium,
            TextSize = 14,
            TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Text,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(15, 8),
            Size = UDim2.new(1, -100, 0, 20),
            TextXAlignment = "Left",
            Parent = SliderBg,
            ZIndex = 4
        })
        
        local ValueLabel = Create("TextLabel", {
            Text = tostring(default) .. suffix,
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -80, 0, 8),
            Size = UDim2.new(0, 65, 0, 20),
            TextXAlignment = "Right",
            Parent = SliderBg,
            ZIndex = 4
        })
        
        local Tray = Create("Frame", {
            Size = UDim2.new(1, -30, 0, 5),
            Position = UDim2.new(0, 15, 1, -15),
            BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].ElementHover,
            Parent = SliderBg,
            ZIndex = 4
        }, {
            Create("UICorner", {CornerRadius = UDim.new(1, 0)})
        })
        
        local Fill = Create("Frame", {
            Size = UDim2.fromScale((default - min) / (max - min), 1),
            BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent,
            Parent = Tray,
            ZIndex = 5
        }, {
            Create("UICorner", {CornerRadius = UDim.new(1, 0)})
        })
        
        local Knob = Create("Frame", {
            Size = UDim2.fromOffset(12, 12),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale((default - min) / (max - min), 0.5),
            BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Element,
            Parent = Tray,
            ZIndex = 6
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
            Create("UIStroke", {
                Color = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent,
                Thickness = 2
            })
        })
        
        local function Update(input)
            local pos = math.clamp((input.Position.X - Tray.AbsolutePosition.X) / Tray.AbsoluteSize.X, 0, 1)
            local rawVal = min + (max - min) * pos
            local val = rounding == 1 and (math.floor(rawVal * 10) / 10) or math.floor(rawVal)
            
            ValueLabel.Text = tostring(val) .. suffix
            
            TweenService:Create(Fill, TweenInfo.new(0.1), {
                Size = UDim2.fromScale(pos, 1)
            }):Play()
            
            TweenService:Create(Knob, TweenInfo.new(0.1), {
                Position = UDim2.fromScale(pos, 0.5)
            }):Play()
            
            callback(val)
        end
        
        local dragging = false
        
        SliderBg.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                Update(i)
                
                if self.Main.Parent.Parent.SoundEnabled then
                    PlaySound("Click")
                end
            end
        end)
        
        UIS.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                Update(i)
            end
        end)
        
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end
    
    function Tab:Dropdown(config)
        local text = config.Name or "Dropdown"
        local list = config.List or {}
        local default = config.Default
        local callback = config.Callback or function() end
        
        local expanded = false
        
        local DropdownBg = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Element,
            ClipsDescendants = true,
            Parent = Page,
            ZIndex = 3
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
            Create("UIStroke", {
                Color = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Stroke,
                Thickness = 1,
                Transparency = 0.5
            })
        })
        
        local Header = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundTransparency = 1,
            Text = "",
            Parent = DropdownBg,
            ZIndex = 10
        })
        
        local TitleLabel = Create("TextLabel", {
            Text = text,
            Font = Enum.Font.GothamMedium,
            TextSize = 14,
            TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Text,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(15, 0),
            Size = UDim2.new(1, -50, 1, 0),
            TextXAlignment = "Left",
            Parent = Header,
            ZIndex = 5
        })
        
        local Arrow = Create("TextLabel", {
            Text = "▼",
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].TextSecondary,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -35, 0, 0),
            Size = UDim2.new(0, 25, 1, 0),
            Parent = Header,
            ZIndex = 5
        })
        
        local Content = Create("Frame", {
            Size = UDim2.new(1, -20, 0, #list * 35),
            Position = UDim2.fromOffset(10, 50),
            BackgroundTransparency = 1,
            Parent = DropdownBg,
            ZIndex = 4
        })
        
        local DropHighlight = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent,
            BackgroundTransparency = 0.85,
            Visible = false,
            ZIndex = 4,
            Parent = Content
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            Create("UIStroke", {
                Color = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent,
                Thickness = 1,
                Transparency = 0.5
            })
        })
        
        local OptionHolder = Create("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            ZIndex = 5,
            Parent = Content
        })
        
        local ListLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 3),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = OptionHolder
        })
        
        local function Select(v, btn)
            DropHighlight.Visible = true
            
            local targetY = btn.AbsolutePosition.Y - Content.AbsolutePosition.Y + OptionHolder.AbsolutePosition.Y
            
            TweenService:Create(DropHighlight, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                Position = UDim2.fromOffset(0, targetY)
            }):Play()
            
            for _, o in pairs(OptionHolder:GetChildren()) do
                if o:IsA("TextButton") then
                    TweenService:Create(o, TweenInfo.new(0.2), {
                        TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].TextSecondary
                    }):Play()
                end
            end
            
            TweenService:Create(btn, TweenInfo.new(0.2), {
                TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Text
            }):Play()
            
            TitleLabel.Text = text .. " : " .. v
            callback(v)
        end
        
        for i, v in pairs(list) do
            local Opt = Create("TextButton", {
                Text = v,
                Font = Enum.Font.GothamMedium,
                TextSize = 13,
                TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].TextSecondary,
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                LayoutOrder = i,
                Parent = OptionHolder,
                ZIndex = 6
            })
            
            Opt.MouseButton1Click:Connect(function()
                Select(v, Opt)
                
                if self.Main.Parent.Parent.SoundEnabled then
                    PlaySound("Click")
                end
            end)
            
            -- Hover
            Opt.MouseEnter:Connect(function()
                TweenService:Create(Opt, TweenInfo.new(0.2), {
                    TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Text
                }):Play()
            end)
            
            Opt.MouseLeave:Connect(function()
                TweenService:Create(Opt, TweenInfo.new(0.3), {
                    TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].TextSecondary
                }):Play()
            end)
            
            if default and v == default then
                task.spawn(function()
                    repeat task.wait() until Opt.AbsolutePosition.Y > 0
                    Select(v, Opt)
                end)
            end
        end
        
        Header.MouseButton1Click:Connect(function()
            expanded = not expanded
            
            TweenService:Create(Arrow, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
                Rotation = expanded and 180 or 0
            }):Play()
            
            TweenService:Create(DropdownBg, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
                Size = UDim2.new(1, 0, 0, expanded and (50 + #list * 35 + 15) or 50)
            }):Play()
            
            if self.Main.Parent.Parent.SoundEnabled then
                PlaySound("Click")
            end
        end)
    end
    
    function Tab:Label(config)
        local text = config.Text or "Label"
        
        local LabelBg = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Element,
            BackgroundTransparency = 0.3,
            Parent = Page,
            ZIndex = 3
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            Create("UIStroke", {
                Color = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Stroke,
                Thickness = 1,
                Transparency = 0.5
            })
        })
        
        local Text = Create("TextLabel", {
            Text = text,
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].TextSecondary,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(12, 8),
            Size = UDim2.new(1, -24, 0, 0),
            TextXAlignment = "Left",
            TextYAlignment = "Center",
            TextWrapped = true,
            Parent = LabelBg,
            ZIndex = 4
        })
        
        local function Resize()
            local ts = game:GetService("TextService"):GetTextSize(
                Text.Text, Text.TextSize, Text.Font, Vector2.new(Text.AbsoluteSize.X, 10000)
            )
            LabelBg.Size = UDim2.new(1, 0, 0, ts.Y + 16)
            Text.Size = UDim2.new(1, -24, 0, ts.Y)
        end
        
        Text:GetPropertyChangedSignal("AbsoluteSize"):Connect(Resize)
        task.spawn(Resize)
    end
    
    function Tab:Paragraph(config)
        local title = config.Title or "Paragraph"
        local content = config.Content or ""
        
        local SectionBg = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 60),
            BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Element,
            Parent = Page,
            ZIndex = 3
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
            Create("UIStroke", {
                Color = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Stroke,
                Thickness = 1,
                Transparency = 0.5
            })
        })
        
        local Title = Create("TextLabel", {
            Text = title:upper(),
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(15, 8),
            Size = UDim2.new(1, -30, 0, 20),
            TextXAlignment = "Left",
            Parent = SectionBg,
            ZIndex = 4
        })
        
        local Divider = Create("Frame", {
            Size = UDim2.new(1, -30, 0, 1),
            Position = UDim2.fromOffset(15, 30),
            BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Stroke,
            BorderSizePixel = 0,
            BackgroundTransparency = 0.5,
            Parent = SectionBg,
            ZIndex = 4
        })
        
        local Desc = Create("TextLabel", {
            Text = content,
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].TextSecondary,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(15, 38),
            Size = UDim2.new(1, -30, 0, 0),
            TextXAlignment = "Left",
            TextYAlignment = "Top",
            TextWrapped = true,
            Parent = SectionBg,
            ZIndex = 4
        })
        
        local function Resize()
            local ts = game:GetService("TextService"):GetTextSize(
                Desc.Text, Desc.TextSize, Desc.Font, Vector2.new(Desc.AbsoluteSize.X, 10000)
            )
            SectionBg.Size = UDim2.new(1, 0, 0, ts.Y + 50)
            Desc.Size = UDim2.new(1, -30, 0, ts.Y)
        end
        
        Desc:GetPropertyChangedSignal("AbsoluteSize"):Connect(Resize)
        task.spawn(Resize)
    end
    
    function Tab:Keybind(config)
        local text = config.Name or "Keybind"
        local default = config.Default or Enum.KeyCode.E
        local callback = config.Callback or function() end
        local onChange = config.OnChange or function() end
        local listening = false
        
        local BindBg = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Element,
            Parent = Page,
            ZIndex = 3
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
            Create("UIStroke", {
                Color = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Stroke,
                Thickness = 1,
                Transparency = 0.5
            })
        })
        
        local Label = Create("TextLabel", {
            Text = text,
            Font = Enum.Font.GothamMedium,
            TextSize = 14,
            TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Text,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(15, 0),
            Size = UDim2.new(1, -100, 1, 0),
            TextXAlignment = "Left",
            Parent = BindBg,
            ZIndex = 4
        })
        
        local BindDisplay = Create("Frame", {
            Size = UDim2.fromOffset(80, 30),
            Position = UDim2.new(1, -95, 0.5, -15),
            BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].ElementHover,
            Parent = BindBg,
            ZIndex = 4
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            Create("UIStroke", {
                Color = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent,
                Thickness = 1,
                Transparency = 0.5
            })
        })
        
        local BindText = Create("TextLabel", {
            Text = default.Name,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Text,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Parent = BindDisplay,
            ZIndex = 5
        })
        
        local Hit = Create("TextButton", {
            Text = "",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ZIndex = 10,
            Parent = BindBg
        })
        
        Hit.MouseButton1Click:Connect(function()
            listening = true
            BindText.Text = "..."
            
            TweenService:Create(BindDisplay.UIStroke, TweenInfo.new(0.2), {
                Color = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent,
                Transparency = 0
            }):Play()
            
            if self.Main.Parent.Parent.SoundEnabled then
                PlaySound("Click")
            end
        end)
        
        UIS.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            
            if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                listening = false
                default = input.KeyCode
                BindText.Text = input.KeyCode.Name
                
                TweenService:Create(BindDisplay.UIStroke, TweenInfo.new(0.2), {
                    Transparency = 0.5
                }):Play()
                
                onChange(input.KeyCode)
                
                if self.Main.Parent.Parent.SoundEnabled then
                    PlaySound("Toggle")
                end
                
            elseif not listening and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == default then
                -- Visual feedback
                TweenService:Create(BindDisplay, TweenInfo.new(0.1), {
                    BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent
                }):Play()
                
                TweenService:Create(BindText, TweenInfo.new(0.1), {
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                }):Play()
                
                task.wait(0.1)
                
                TweenService:Create(BindDisplay, TweenInfo.new(0.2), {
                    BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].ElementHover
                }):Play()
                
                TweenService:Create(BindText, TweenInfo.new(0.2), {
                    TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Text
                }):Play()
                
                callback()
            end
        end)
    end
    
    function Tab:Textbox(config)
        local text = config.Name or "Textbox"
        local placeholder = config.Placeholder or "Enter..."
        local callback = config.Callback or function() end
        
        local BoxBg = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Element,
            Parent = Page,
            ZIndex = 3
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
            Create("UIStroke", {
                Color = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Stroke,
                Thickness = 1,
                Transparency = 0.5
            })
        })
        
        local Label = Create("TextLabel", {
            Text = text,
            Font = Enum.Font.GothamMedium,
            TextSize = 14,
            TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Text,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(15, 0),
            Size = UDim2.new(1, -120, 1, 0),
            TextXAlignment = "Left",
            Parent = BoxBg,
            ZIndex = 4
        })
        
        local InputHolder = Create("Frame", {
            Size = UDim2.new(0, 100, 0, 32),
            Position = UDim2.new(1, -115, 0.5, -16),
            BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].ElementHover,
            ClipsDescendants = true,
            Parent = BoxBg,
            ZIndex = 4
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            Create("UIStroke", {
                Color = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Stroke,
                Thickness = 1
            })
        })
        
        local Input = Create("TextBox", {
            Text = "",
            PlaceholderText = placeholder,
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -10, 1, 0),
            Position = UDim2.fromOffset(5, 0),
            TextXAlignment = "Center",
            Parent = InputHolder,
            ZIndex = 5
        })
        
        Input.Focused:Connect(function()
            TweenService:Create(InputHolder, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
                Size = UDim2.new(0, 150, 0, 32),
                Position = UDim2.new(1, -165, 0.5, -16)
            }):Play()
            
            TweenService:Create(InputHolder.UIStroke, TweenInfo.new(0.4), {
                Color = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent,
                Transparency = 0
            }):Play()
            
            TweenService:Create(Label, TweenInfo.new(0.4), {
                TextTransparency = 0.5
            }):Play()
        end)
        
        Input.FocusLost:Connect(function(enterPressed)
            TweenService:Create(InputHolder, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
                Size = UDim2.new(0, 100, 0, 32),
                Position = UDim2.new(1, -115, 0.5, -16)
            }):Play()
            
            TweenService:Create(InputHolder.UIStroke, TweenInfo.new(0.4), {
                Color = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Stroke,
                Transparency = 0
            }):Play()
            
            TweenService:Create(Label, TweenInfo.new(0.4), {
                TextTransparency = 0
            }):Play()
            
            callback(Input.Text, enterPressed)
        end)
    end
    
    function Tab:Section(config)
        local name = config.Name or "Section"
        local collapsible = config.Collapsible or false
        local defaultOpen = config.DefaultOpen or true
        
        local SectionBg = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Element,
            Parent = Page,
            ZIndex = 3
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
            Create("UIStroke", {
                Color = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Stroke,
                Thickness = 1,
                Transparency = 0.5
            })
        })
        
        local Header = Create("TextButton", {
            Text = "",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 40),
            Parent = SectionBg,
            ZIndex = 10
        })
        
        local Title = Create("TextLabel", {
            Text = name:upper(),
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].Accent,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(15, 0),
            Size = UDim2.new(1, -50, 1, 0),
            TextXAlignment = "Left",
            Parent = Header,
            ZIndex = 5
        })
        
        local Arrow = Create("TextLabel", {
            Text = collapsible and (defaultOpen and "▼" or "▶") or "",
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextColor3 = Library.Themes[self.Main.Parent.Parent.CurrentTheme].TextSecondary,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -35, 0, 0),
            Size = UDim2.new(0, 25, 1, 0),
            Visible = collapsible,
            Parent = Header,
            ZIndex = 5
        })
        
        local Content = Create("Frame", {
            Size = UDim2.new(1, -20, 0, 0),
            Position = UDim2.fromOffset(10, 40),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Parent = SectionBg,
            ZIndex = 4,
            Visible = defaultOpen
        })
        
        local Layout = Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = Content
        })
        
        local Padding = Create("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 5),
            Parent = Content
        })
        
        local sectionOpen = defaultOpen
        
        if collapsible then
            Header.MouseButton1Click:Connect(function()
                sectionOpen = not sectionOpen
                
                TweenService:Create(Arrow, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                    Rotation = sectionOpen and 0 or -90,
                    Text = sectionOpen and "▼" or "▶"
                }):Play()
                
                TweenService:Create(Content, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                    Size = UDim2.new(1, -20, 0, sectionOpen and Layout.AbsoluteContentSize.Y + 10 or 0)
                }):Play()
                
                task.wait(0.15)
                Content.Visible = sectionOpen
            end)
        end
        
        local Section = {}
        
        function Section:Button(cfg)
            cfg.Parent = Content
            return Tab:Button(cfg)
        end
        
        function Section:Toggle(cfg)
            cfg.Parent = Content
            return Tab:Toggle(cfg)
        end
        
        function Section:Slider(cfg)
            cfg.Parent = Content
            return Tab:Slider(cfg)
        end
        
        function Section:Dropdown(cfg)
            cfg.Parent = Content
            return Tab:Dropdown(cfg)
        end
        
        function Section:Label(cfg)
            cfg.Parent = Content
            return Tab:Label(cfg)
        end
        
        function Section:Paragraph(cfg)
            cfg.Parent = Content
            return Tab:Paragraph(cfg)
        end
        
        function Section:Keybind(cfg)
            cfg.Parent = Content
            return Tab:Keybind(cfg)
        end
        
        function Section:Textbox(cfg)
            cfg.Parent = Content
            return Tab:Textbox(cfg)
        end
        
        -- Update section size when content changes
        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if sectionOpen then
                Content.Size = UDim2.new(1, -20, 0, Layout.AbsoluteContentSize.Y + 10)
                SectionBg.Size = UDim2.new(1, 0, 0, 40 + Content.Size.Y.Offset + 10)
            end
        end)
        
        return Section
    end
    
    return Tab
end

return Library
