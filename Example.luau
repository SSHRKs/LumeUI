local UI = {}
local ElementList = {}
local Objects = {}

local ThemeID = {}

local UserInputService = game:GetService("UserInputService")
local InputObject = game:GetService("InputObject")

local function enableDragging(frameToDrag, frameToMove)
    local dragging = false
    local dragInput, mousePos, framePos

    local function update(input)
        local delta = input.Position - mousePos
        frameToMove.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end

    frameToDrag.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = frameToMove.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frameToDrag.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            update(input)
        end
    end)
end

local Icons = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Footagesus/Icons/main/Main.lua"))()
local Utility = {}
local TweenService = game:GetService("TweenService")

local UITheme = {
    Dark = {
        Background = Color3.fromRGB(20, 20, 20),
        SideBar = Color3.fromRGB(30, 30, 30),
        Text = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(43, 43, 43),
        Placeholder = Color3.fromRGB(20, 20, 20),
        IconColor = Color3.fromRGB(255, 255, 255)
    },
   Light = {
        Background = Color3.fromRGB(230, 230, 230),
        SideBar = Color3.fromRGB(236, 236, 236),
        Text = Color3.fromRGB(30, 30, 30),
        ElementColor = Color3.fromRGB(210, 210, 210),
        Placeholder = Color3.fromRGB(170, 170, 170),
        IconColor = Color3.fromRGB(30, 30, 30)
    },
   Ocean = {
        Background = Color3.fromRGB(0, 86, 80),
        SideBar = Color3.fromRGB(0, 108, 99),
        Text = Color3.fromRGB(255,255,255),
        ElementColor = Color3.fromRGB(0, 127, 116),
        Placeholder = Color3.fromRGB(0, 87, 76),
        IconColor = Color3.fromRGB(255, 255, 255)
    }
}

local CurrentTheme = UITheme.Dark

function UI:Create(class, properties, children)
    local inst = Instance.new(class)

    self:ApplyTheme(inst, properties)

    for property, value in pairs(properties) do
        inst[property] = value
    end

    if children then
        for _, child in ipairs(children) do
            child.Parent = inst
        end
    end

    return inst
end

function UI:ApplyTheme(instance, properties)
    if properties.ThemeID then
        for property, themeKey in pairs(properties.ThemeID) do
            local value = CurrentTheme[themeKey]
            if value then
                instance[property] = value
            else
                --warn(("Theme key '%s' for property '%s' not found in theme"):format(themeKey, property))
            end
        end
        properties.ThemeID = nil
    end
end

Icons.SetIconsType("lucide")

function Utility:TweenObject(obj, properties, duration, ...)
    TweenService:Create(obj, TweenInfo.new(duration, ...), properties):Play() 
end

-- Пример использования
--local frameToDrag = script.Parent.FrameToDrag -- Замените на ваш Frame, который нужно зажимать
--local frameToMove = script.Parent.FrameToMove -- Замените на ваш Frame, который нужно двигать

function UI:CreateWindow(Config)
    local Window = {
        Name = Config.Name or "UI Library",
        Icon = Config.Icon or nil,
        ToggleKey = Config.ToggleKey or Enum.KeyCode.F,
        Elements = Config.Elements or {},
        Transparent = Config.Transparent or false,
        Theme = Config.Theme or "Dark",
        Default = Config.Default or "Default", --Default, Maximize, Minimize
        Size = Config.Size and UDim2.new(
                        0, math.clamp(Config.Size.X.Offset, 420, 480),
                        0, math.clamp(Config.Size.Y.Offset, 280, 680)) or UDim2.new(0, 420, 0, 280),
        SideBarWidth = Config.SideBarWidth or 134,
        BackpackHotbar = Config.BackpackHotbar or game:GetService("CoreGui"):WaitForChild("RobloxGui"):WaitForChild("Backpack"):WaitForChild("Hotbar"),
    }

    print(Window.Size.X.Offset, Window.Size.Y.Offset)
    Utility:TweenObject(Window.BackpackHotbar, {Position = UDim2.new(0.5, -100, 1, -70)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    for _, v in next, game.Players.LocalPlayer:WaitForChild("PlayerGui"):GetChildren() do
        if v.Name == Config.Name then
          v:Destroy()
        end
    end
    --local UIScreen = Instance.new("ScreenGui")
    --local MainFrame = Instance.new("Frame")
    local MainFrameC = Instance.new("UICorner")
    local Frame = Instance.new("Frame")
    local UIName = Instance.new("TextLabel")
    local WindElement = Instance.new("Frame")
    local WindElementC = Instance.new("UICorner")
    local Minimize = Instance.new("ImageButton")
    local Maximize = Instance.new("ImageButton")
    local Destroy = Instance.new("ImageButton")
    local WindElementULL = Instance.new("UIListLayout")
    local WindElementUP = Instance.new("UIPadding")
    local ElementFolder = Instance.new("Folder")
    local ElementFrame = Instance.new("Frame")

    local UIScreen = UI:Create("ScreenGui", {
        Name = Window.Name,
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })

    local MainFrame = UI:Create("Frame", {Parent = UIScreen,
        AutomaticSize = "XY",
        Active = true,
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        Transparency = Window.Transparent and 0.1 or 0,
        Position = UDim2.new(0.375444829, 0, 0.324120611, 0),
        Size = UDim2.new(0, 420, 0, 280),
        ThemeID = {
            BackgroundColor3 = "Background"
        }
    }, {
        UI:Create("UICorner", {
            CornerRadius = UDim.new(0, 11)
        })
    })

    --[[local DragUI = Instance.new("Frame")
    local DragUI_2 = Instance.new("Frame")
    local DragUIC = Instance.new("UICorner")

    DragUI.Name = "DragUI"
    DragUI.Parent = MainFrame
    DragUI.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DragUI.BackgroundTransparency = 0.850
    DragUI.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DragUI.BorderSizePixel = 0
    DragUI.Position = UDim2.new(0.26000002, 0, 0, Window.Size.Y.Offset)
    DragUI.Size = UDim2.new(0, 100, 0, -4)

    DragUI_2.Name = "DragUI"
    DragUI_2.Parent = DragUI
    DragUI_2.Active = true
    DragUI_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DragUI_2.BackgroundTransparency = 0.350
    DragUI_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DragUI_2.BorderSizePixel = 0
    DragUI_2.Position = UDim2.new(0.259523809, 0, 1.01699996, 0)
    DragUI_2.Size = UDim2.new(0, 201, 0, 4)

    DragUIC.CornerRadius = UDim.new(0, 100)
    DragUIC.Name = "DragUIC"
    DragUIC.Parent = DragUI_2

    enableDragging(DragUI_2, MainFrame)--]]
    enableDragging(MainFrame, MainFrame)

    --local TabLib = Instance.new("Frame")
    --local MainFrameC_2 = Instance.new("UICorner")
    --local ScrollingFrame = Instance.new("ScrollingFrame")
    local UIPadding = Instance.new("UIPadding")

    local TabLib = UI:Create("Frame", {Parent = MainFrame,
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        Transparency = Window.Transparent and 1 or 0,
        Size = UDim2.new(0, Window.SideBarWidth, 0, Window.Size.Y.Offset),
        ThemeID = {
            BackgroundColor3 = "SideBar"
        }
    }, {
        UI:Create("UICorner", {
            CornerRadius = UDim.new(0, 11)
        })
    })

    local ScrollingFrame = UI:Create("ScrollingFrame", {Parent = TabLib,
        Active = true,
        BackgroundColor3 = Color3.fromRGB(1,1,1,1),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.new(0, 0, 0.0928571448, 0),
        Size = UDim2.new(0, TabLib.Size.X.Offset, 0, Window.Size.Y.Offset - 20),
        ScrollBarThickness = 0,
    }, {
        UI:Create("UIListLayout", {
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })
    })

    ScrollingFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollingFrame.CanvasSize = UDim2.new(0, ScrollingFrame.UIListLayout.AbsoluteContentSize.X, 0, ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
    end)
    --UIPadding.Parent = ScrollingFrame
    --UIPadding.PaddingTop = UDim.new(0, 5)

    local Frame = UI:Create("Frame", {Parent = TabLib,
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = "Y",
        Transparency = Window.Transparent and 1 or 0,
        Position = UDim2.new(0, TabLib.Size.X.Offset-5, 0, 0),
        Size = UDim2.new(0, 7, 0, Window.Size.Y.Offset),
        ThemeID = {
            BackgroundColor3 = "SideBar"
        }
    })

    local UIName = UI:Create("TextLabel", {Parent = MainFrame,
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0.0166666675, 0, 0.0270000007, 0),
        Size = UDim2.new(0, 105, 0, 14),
        FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Bold, Enum.FontStyle.Normal),
        Text = Window.Name,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        ThemeID = {
            TextColor3 = "Text"
        }
    })

    --local MinimizedFrame = Instance.new("Frame")
    local UIMinName = Instance.new("TextLabel")
    --local UIMinNameUP = Instance.new("UIPadding")
    --local MinimizedFrameC = Instance.new("UICorner")
    local UIIcon = Instance.new("ImageLabel")
    local UIArrow = Instance.new("ImageLabel")

    local MinimizedFrame = UI:Create("Frame", {Parent = UIScreen,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Visible = false,
        Size = UDim2.new(0, 149, 0, 29),
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, 0),
        ThemeID = {
            BackgroundColor3 = "Background"
        }
    }, {
        UI:Create("UICorner", {
            CornerRadius = UDim.new(0, 11)
        }),
        UI:Create("UIStroke", {
            Color = Color3.fromRGB(255, 255, 255),
            LineJoinMode = "Round"
        })
    })


    local MinimizedTRG = UI:Create("TextButton", {Parent = MinimizedFrame,
        Parent = MinimizedFrame,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, -0.672413766, 0),
        Size = UDim2.new(0, 193, 0, 48),
        Font = Enum.Font.SourceSans,
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 14.000,
        TextTransparency = 1.000,
    })

    local UIMinName = UI:Create("TextLabel", {Parent = MinimizedFrame,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 148, 0, 29),
        FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.Bold, Enum.FontStyle.Normal),
        Text = Window.Name,
        TextSize = 14.000,
        TextStrokeColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        ThemeID = {
            TextColor3 = "Text"
        }
    },{
        UI:Create("UIPadding", {
            PaddingLeft = UDim.new(0, Window.Icon and 35 or 5)
        })
    })

        if Window.Icon and Icons.Icon(Window.Icon) then
            local UIIcon = UI:Create("ImageLabel", {Parent = MinimizedFrame,
                BackgroundTransparency = 1.000,
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2.new(0.0399999991, 3, 0.206896558, 0),
                Size = UDim2.new(0, 17, 0, 17),
                Image = Icons.Icon(Window.Icon)[1],
                ImageRectSize = Icons.Icon(Window.Icon)[2].ImageRectSize,
                ImageRectOffset = Icons.Icon(Window.Icon)[2].ImageRectPosition,
                ThemeID = {
                    ImageColor3 = "IconColor"
                }
            })
        elseif Window.Icon and string.find(Window.Icon, "rbxassetid://") then
            local UIIcon = UI:Create("ImageLabel", {Parent = MinimizedFrame,
                BackgroundTransparency = 1.000,
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2.new(0.0399999991, 3, 0.206896558, 0),
                Size = UDim2.new(0, 17, 0, 17),
                Image = Window.Icon,
                ThemeID = {
                    ImageColor3 = "IconColor"
                }
            })
        end

    local UIArrow = UI:Create("ImageLabel", {Parent = MinimizedFrame,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0.409395963, 0, -0.672413766, 0),
        Size = UDim2.new(0, 26, 0, 19),
        Image = Icons.Icon("chevron-up")[1],
        ImageRectSize = Icons.Icon("chevron-up")[2].ImageRectSize,
        ImageRectOffset = Icons.Icon("chevron-up")[2].ImageRectPosition,
        ThemeID = {
            ImageColor3 = "IconColor"
        }
    })

    --Wind ELEMENT's
    local WindElement = UI:Create("Frame", {
        Parent = MainFrame,
        BackgroundColor3 = Color3.new(0.113725, 0.113725, 0.113725),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0, Window.Size.X.Offset - Window.SideBarWidth + 53, 0.0285714287, 0),
        Size = UDim2.new(0, 78, 0, 12),
    }, {
        UI:Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 5),
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
        }),
        UI:Create("UIPadding", {
            PaddingLeft = UDim.new(0, 10),
        }),
    })

    if Window.Elements.Minimize or true then
        local Minimize = UI:Create("ImageLabel", {Parent = WindElement,
            BackgroundTransparency = 1,
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(-1.11764705, 0, 1.125, 0),
            Size = UDim2.new(0, 21, 0, 21),
            Image = "rbxassetid://97170161699384",
            ThemeID = {
                ImageColor3 = "ImageColor"
            }
        })
    end

    --[[if Window.Elements.Maximize then
        Maximize.Name = "Maximize"
        Maximize.Parent = WindElement
        Maximize.BackgroundColor3 = Color3.new(1, 1, 1)
        Maximize.BackgroundTransparency = 1
        Maximize.BorderColor3 = Color3.new(0, 0, 0)
        Maximize.BorderSizePixel = 0
        Maximize.Position = UDim2.new(0.134328365, 0, -0.505928755, 0)
        Maximize.Size = UDim2.new(0, 21, 0, 21)
        Maximize.Image = "rbxassetid://104146031032977"
    end--]]

    if Window.Elements.Close or true  then
        local Destroy = UI:Create("ImageLabel", {Parent = WindElement,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0.134328365, 0, -0.505928755, 0),
            Size = UDim2.new(0, 21, 0, 21),
            Image = "rbxassetid://126853728595543",
            ThemeID = {
                ImageColor3 = "ImageColor"
            }
        })
    end

    Destroy.MouseButton1Click:Connect(function()
        UIScreen:Destroy()
    end)

    --Minimize.Visible = Window.Elements.Minimize or true
    --Maximize.Visible = Window.Elements.Maximize or true
    --Destroy.Visible = Window.Elements.Close or true

    local ElementFolder = UI:Create("Folder", {Parent = MainFrame,
        Name = "ElementFolder"
    })

    local ElementFrame = UI:Create("Frame", {Parent = ElementFolder,
        BackgroundColor3 = Color3.new(1, 1, 1),
        AutomaticSize = "XY",
        BackgroundTransparency = 1,
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0, Window.SideBarWidth, 0.118749999, 0),
        Size = UDim2.new(0, 286, 0, 246),
    })

    function UI:Close()
        UIScreen:Destroy()
    end

    function UI:SetToggleKey(Value)
        Window.ToggleKey = Value
    end

    function UI:SetTransparency(Value)
        MainFrame.Transparency = Value and 0.1 or 0
        TabLib.Transparency = Value and 1 or 0
        Frame.Transparency = Value and 1 or 0
    end
    
    local TogValue = true
    UserInputService.InputBegan:Connect(function(input, Progress)
        if Progress then return end

        if input.KeyCode == Window.ToggleKey then
            TogValue = not TogValue
            MainFrame.Visible = TogValue
        end 
    end)

    function UI:Devider()
        local Divider = UI:Create("ImageLabel", {Parent = ScrollingFrame,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.12396694, 0),
            Size = UDim2.new(0, Window.SideBarWidth - 5, 0, 8),
            Image = "http://www.roblox.com/asset/?id=76083478049007",
            ThemeID = {
                ImageColor3 = "ImageColor"
            }
        })
    end

    local TabModule = {}
    local TabCounter = 0
    local Tabs = true

    function TabModule:Tab(Config)
        TabCounter = TabCounter + 1
        local Tab = {
            Title = Config.Title or "Tab " .. TabCounter,
            Icon = Config.Icon
        }

        local TabBackground = Instance.new("Frame")
        local TabImage = Instance.new("ImageLabel")
        local TabLabel = Instance.new("TextLabel")
        local UIPadding_2 = Instance.new("UIPadding")

        local TabBackground = UI:Create("Frame", {Parent = ScrollingFrame,
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
            AutomaticSize = "Y",
            Size = UDim2.new(0, Window.SideBarWidth - 5, 0, 25),
            Transparency = 1,
        })

        local TabLabel = UI:Create("TextLabel", {Parent = TabBackground,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.209999993, 0),
            Size = UDim2.new(0, Window.SideBarWidth - 5, 0, 14),
            AutomaticSize = "Y",
            FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
            Text = Config.Title,
            TextSize = 14,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            ThemeID = {
                TextColor3 = "TextColor"
            },
        },{
            UI:Create("UIPadding", {
                PaddingLeft = UDim.new(0, 33)
            })
        })

        local TabButton = UI:Create("TextButton", {Parent = TabBackground,
            Parent = TabBackground,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(-2.72478388e-07, 0, 0, 0),
            Size = UDim2.new(0, Window.SideBarWidth - 5, 0, 25),
            Font = Enum.Font.SourceSans,
            Transparency = 1,
            TextTransparency = 1,
            AutomaticSize = "Y",
            TextColor3 = Color3.new(0, 0, 0),
            TextSize = 14,
        })

        if Tab.Icon and Icons.Icon(Tab.Icon) then
            local TabImage = UI:Create("ImageLabel", {Parent = TabBackground,
                BackgroundTransparency = 1.000,
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2.new(0.0399999991, 3, 0.206896558, 0),
                Size = UDim2.new(0, 17, 0, 17),
                Image = Icons.Icon(Tab.Icon)[1],
                ImageRectSize = Icons.Icon(Tab.Icon)[2].ImageRectSize,
                ImageRectOffset = Icons.Icon(Tab.Icon)[2].ImageRectPosition,
                ThemeID = {
                    ImageColor3 = "IconColor"
                }
            })
        elseif Window.Icon and string.find(Window.Icon, "rbxassetid://") then
            local TabImage = UI:Create("ImageLabel", {Parent = TabBackground,
                BackgroundTransparency = 1.000,
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2.new(0.0399999991, 3, 0.206896558, 0),
                Size = UDim2.new(0, 17, 0, 17),
                Image = Window.Icon,
                ThemeID = {
                    ImageColor3 = "IconColor"
                }
            })
        end

        local ScrollElement = UI:Create("ScrollingFrame", {Parent = ElementFrame,
            Active = true,
            BackgroundColor3 = Color3.new(1, 1, 1),
            ClipsDescendants = true,
            BackgroundTransparency = 1,
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(0, Window.Size.X.Offset - 134, 0, Window.Size.Y.Offset - 30),
            ScrollBarThickness = 2
        },{
            UI:Create("UIListLayout", {Parent = ScrollElement,
                Padding = UDim.new(0, 5),
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            UI:Create("UIPadding", {Parent = ScrollElement,
                PaddingLeft = UDim.new(0, 8),
                PaddingTop = UDim.new(0, 3),
                PaddingBottom = UDim.new(0, 7),
            })
        })

        table.insert(ElementList, ScrollElement)
        
        ScrollElement.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ScrollElement.CanvasSize = UDim2.new(0, ScrollElement.UIListLayout.AbsoluteContentSize.X, 0, ScrollElement.UIListLayout.AbsoluteContentSize.Y)
        end)

            if Tabs then
                ScrollElement.Visible = true
                TabLabel.TextColor3 = Color3.fromRGB(UITheme[Window.Theme].Text.R * 255, UITheme[Window.Theme].Text.G * 255, UITheme[Window.Theme].Text.B * 255)
                --TabBackground.BackgroundTransparency = true
                --Utility:TweenObject(TabBackground, {Transparency = 0.8}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                Tabs = false
            else
                Utility:TweenObject(TabImage, {ImageColor3 = Color3.fromRGB(UITheme[Window.Theme].Text.R * 255-90, UITheme[Window.Theme].Text.G * 255-90, UITheme[Window.Theme].Text.B * 255-90)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                TabLabel.TextColor3 = Color3.fromRGB(UITheme[Window.Theme].Text.R * 255-90, UITheme[Window.Theme].Text.G * 255-90, UITheme[Window.Theme].Text.B * 255-90)
                ScrollElement.Visible = false
            end
        
            TabButton.MouseButton1Click:Connect(function()
                for _, v in next, ElementFrame:GetChildren() do
                    if v:IsA("GuiObject") then
                        v.Visible = false
                    end
                end
                ScrollElement.Visible = true
                for i,v in next, ScrollingFrame:GetChildren() do
                    if v:IsA("Frame") then
                        for i,v in next, v:GetChildren() do
                            if v:IsA("TextLabel") then
                                Utility:TweenObject(v, {TextColor3 = Color3.fromRGB(UITheme[Window.Theme].Text.R * 255-90, UITheme[Window.Theme].Text.G * 255-90, UITheme[Window.Theme].Text.B * 255-90)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                            end
                            if v:IsA("ImageLabel") then
                                Utility:TweenObject(v, {ImageColor3 = Color3.fromRGB(UITheme[Window.Theme].Text.R * 255-90, UITheme[Window.Theme].Text.G * 255-90, UITheme[Window.Theme].Text.B * 255-90)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                            end
                        end
                    end
                end
                    Utility:TweenObject(TabLabel, {TextColor3 = Color3.fromRGB(UITheme[Window.Theme].Text.R * 255, UITheme[Window.Theme].Text.G * 255, UITheme[Window.Theme].Text.B * 255)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                    Utility:TweenObject(TabImage, {ImageColor3 = Color3.fromRGB(UITheme[Window.Theme].Text.R * 255, UITheme[Window.Theme].Text.G * 255, UITheme[Window.Theme].Text.B * 255)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            end)

        
        --[[local DoubleElemente = {}
        local isDoubleElementsCreated = false

        function DoubleElemente:DoubleFrame(Config)
            local Double = {
                Title = Config.Title or "Section 1"
            }
            if isDoubleElementsCreated then
                return DoubleElement
            end

            isDoubleElementsCreated = true

            local DoubleElements = Instance.new("Frame")
            local DoubleOCFrame = Instance.new("Frame")
            local DoubleFrame = Instance.new("Frame")
            local DoubleFrameC = Instance.new("UICorner")
            local SectionElements = Instance.new("TextLabel")

            DoubleElements.Name = "DoubleElements"
            DoubleElements.Parent = ScrollElement
            DoubleElements.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            DoubleElements.BackgroundTransparency = 1.000
            DoubleElements.BorderColor3 = Color3.fromRGB(0, 0, 0)
            DoubleElements.BorderSizePixel = 0
            DoubleElements.Position = UDim2.new(0, 0, 0.282700419, 0)
            DoubleElements.Size = UDim2.new(0, 265, 0, 25)

            DoubleOCFrame.Name = "DoubleOCFrame"
            DoubleOCFrame.Parent = DoubleElements
            DoubleOCFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            DoubleOCFrame.BackgroundTransparency = 1.000
            DoubleOCFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            DoubleOCFrame.BorderSizePixel = 0
            DoubleOCFrame.Position = UDim2.new(0, 0, -0.308016866, 0)
            DoubleOCFrame.Size = UDim2.new(0, 265, 0, 135)

            DoubleFrame.Name = "DoubleFrame"
            DoubleFrame.Parent = DoubleOCFrame
            DoubleFrame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
            DoubleFrame.BackgroundTransparency = 0.300
            DoubleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            DoubleFrame.BorderSizePixel = 0
            DoubleFrame.Size = UDim2.new(0, 130, 0, 135)

            DoubleFrameC.CornerRadius = UDim.new(0, 5)
            DoubleFrameC.Name = "DoubleFrameC"
            DoubleFrameC.Parent = DoubleFrame

            SectionElements.Name = "SectionElements"
            SectionElements.Parent = DoubleElements
            SectionElements.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SectionElements.BackgroundTransparency = 1.000
            SectionElements.BorderColor3 = Color3.fromRGB(0, 0, 0)
            SectionElements.BorderSizePixel = 0
            SectionElements.Size = UDim2.new(0, 130, 0, -25)
            SectionElements.Font = Enum.Font.Unknown
            SectionElements.Text = "Section"
            SectionElements.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionElements.TextSize = 18.000
            SectionElements.TextXAlignment = Enum.TextXAlignment.Left

            local UIPadding_3 = Instance.new("UIPadding")
            UIPadding_3.Parent = DoubleElements
            UIPadding_3.PaddingTop = UDim.new(0, 25)

            local DoubleFrame = Instance.new("Frame")
            local DoubleFrameC = Instance.new("UICorner")
            local UIListLayout = Instance.new("UIListLayout")
            local UIPadding = Instance.new("UIPadding")

            DoubleFrame.Name = "DoubleFrame"
            DoubleFrame.Parent = DoubleOCFrame
            DoubleFrame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
            DoubleFrame.BackgroundTransparency = 0.300
            DoubleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            DoubleFrame.BorderSizePixel = 0
            DoubleFrame.Size = UDim2.new(0, 130, 0, 135)

            DoubleFrameC.CornerRadius = UDim.new(0, 5)
            DoubleFrameC.Name = "DoubleFrameC"
            DoubleFrameC.Parent = DoubleFrame

            UIListLayout.Parent = DoubleFrame
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 5)

            UIPadding.Parent = DoubleFrame
            UIPadding.PaddingLeft = UDim.new(0, 5)
            UIPadding.PaddingTop = UDim.new(0, 5)

            --local DElements = {}
            --function DElements:Paragraph(Config)
                -- Логика для добавления параграфа
            --end
            return DoubleElemente, Double
        end--]]

        local Elements = {}
        local ButtonCount = 0
        function Elements:Button(Config)
            ButtonCount = ButtonCount + 1
            local Button = {
                Title = Config.Title or "Button " .. ButtonCount,
                Icon = Config.Icon or "mouse-pointer-click",
                Callback = Config.Callback or function() end
            }

            local ButtonModule = Instance.new("Frame")
            local ButtonModuleC = Instance.new("UICorner")
            local BTNLabel = Instance.new("TextLabel")
            local BTNLabelUP = Instance.new("UIPadding")
            local BTNImage = Instance.new("ImageLabel")
            local BTNTRG = Instance.new("TextButton")

            local ButtonModule = UI:Create("Frame", {Parent = ScrollElement,
                Name = Button.Title,
                BackgroundTransparency = 0.2,
                BorderColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                Size = UDim2.new(0, Window.Size.X.Offset - 17 - 134, 0, 35),
                ThemeID = {
                    BackgroundColor3 = "ElementColor"
                }
            },{
                UI:Create("UICorner", {
                    CornerRadius = UDim.new(0, 5)
                }),
                UI:Create("UIStroke", {
                    Color = Color3.fromRGB(255,255,255),
                    LineJoinMode = "Round",
                    Thickness = 0.6
                },{
                    UI:Create("UIGradient", {
                        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(ButtonModule.BackgroundColor3.R,ButtonModule.BackgroundColor3.G,ButtonModule.BackgroundColor3.B)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(ButtonModule.BackgroundColor3.R+20,ButtonModule.BackgroundColor3.G+20,ButtonModule.BackgroundColor3.B+20))},
                        Rotation = -90
                    }),
                }),
            })

            local BTNLabel = UI:Create("TextLabel", {Parent = ScrollElement,
                Parent = ButtonModule,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(0, ButtonModule.Size.X.Offset - 30, 0, 35),
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
                Text = Button.Title,
                AutomaticSize = "Y",
                TextSize = 13,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                ThemeID = {
                    TextColor3 = "Text"
                }
            },{
                UI:Create("UIPadding", {
                    PaddingLeft = UDim.new(0, 5)
                })
            })

            if Button.Icon and Icons.Icon(Button.Icon) then
                local BTNImage = UI:Create("ImageLabel", {Parent = ButtonModule,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.new(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, ButtonModule.Size.X.Offset - 25, 0, 8.5),
                    Size = UDim2.new(0, 17, 0, 17),
                    ImageColor3 = Color3.fromRGB(UITheme[Window.Theme].IconColor.R * 255, UITheme[Window.Theme].IconColor.G * 255, UITheme[Window.Theme].IconColor.B * 255),
                    Image = Icons.Icon(Button.Icon)[1],
                    ImageRectSize = Icons.Icon(Button.Icon)[2].ImageRectSize,
                    ImageRectOffset = Icons.Icon(Button.Icon)[2].ImageRectPosition,
                    --ThemeID = {
                        --ImageColor3 = "IconColor"
                    --}
                })
            elseif Button.Icon and string.find(Button.Icon, "rbxassetid://") then
                local BTNImage = UI:Create("ImageLabel", {Parent = ButtonModule,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.new(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, ButtonModule.Size.X.Offset - 25, 0, 8.5),
                    Size = UDim2.new(0, 17, 0, 17),
                    ImageColor3 = Color3.fromRGB(UITheme[Window.Theme].IconColor.R * 255, UITheme[Window.Theme].IconColor.G * 255, UITheme[Window.Theme].IconColor.B * 255),
                    Image = Button.Icon,
                    --ThemeID = {
                        --ImageColor3 = "IconColor"
                    --}
                })
            end

            local BTNTextButton = UI:Create("TextButton", {Parent = ButtonModule,
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                BorderColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                Size = UDim2.new(0, ButtonModule.Size.X.Offset, 0, 35),
                ZIndex = 5,
                TextColor3 = Color3.new(0, 0, 0),
                TextSize = 14,
                TextTransparency = 1,
            })

            BTNTextButton.MouseButton1Click:Connect(function()
                spawn(function()
                    pcall(Button.Callback)
                end)
                Utility:TweenObject(ButtonModule, {BackgroundColor3 = Color3.fromRGB(ButtonModule.BackgroundColor3.R+30,ButtonModule.BackgroundColor3.G+30,ButtonModule.BackgroundColor3.B+30)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                wait(0.15)
                Utility:TweenObject(ButtonModule, {BackgroundColor3 = Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255, UITheme[Window.Theme].ElementColor.G * 255, UITheme[Window.Theme].ElementColor.B * 255)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            end)

            function Button:Close()
                ButtonModule:Destroy()
                return Button, ButtonModule
            end

            function Button:SetTitle(Value)
                BTNLabel.Text = Value
                return Button, BTNLabel
            end
            return Button
        end

        local ToggleCount = 0
        function Elements:Toggle(Config)
            ToggleCount = ToggleCount + 1
            local Toggle = {
                Title = Config.Title or "Toggle " .. ToggleCount,
                Default = Config.Default or false,
                Callback = Config.Callback or function() end
            }

            local ToggleModule = UI:Create("Frame", {
                Name = Toggle.Title,
                Parent = ScrollElement,
                BackgroundTransparency = 0.2,
                BackgroundColor3 = Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255, UITheme[Window.Theme].ElementColor.G * 255, UITheme[Window.Theme].ElementColor.B * 255),
                BorderColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                Size = UDim2.new(0, Window.Size.X.Offset - 17 - 134, 0, 35),
                ThemeID = {
                    BackgroundColor3 = "ElementColor"
                }
            })

            local UIStroke = UI:Create("UIStroke", {
                Parent = ToggleModule,
                Color = Color3.fromRGB(255, 255, 255),
                LineJoinMode = "Round",
                Thickness = 0.6,
            })

            local UIGradient = UI:Create("UIGradient", {
                Parent = UIStroke,
                Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255, UITheme[Window.Theme].ElementColor.G * 255, UITheme[Window.Theme].ElementColor.B * 255 + 20)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255 + 20, UITheme[Window.Theme].ElementColor.G * 255 + 20, UITheme[Window.Theme].ElementColor.B * 255 + 20))
                },
            })

            local ToggleModuleC = UI:Create("UICorner", {
                Parent = ToggleModule,
                CornerRadius = UDim.new(0, 5),
            })

            local TRGLabel = UI:Create("TextLabel", {
                Parent = ToggleModule,
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                BorderColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                Size = UDim2.new(0, Window.Size.X.Offset - 17, 0, 35),
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
                Text = Toggle.Title,
                TextColor3 = Color3.fromRGB(UITheme[Window.Theme].Text.R * 255, UITheme[Window.Theme].Text.G * 255, UITheme[Window.Theme].Text.B * 255),
                TextSize = 13,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                ThemeID = {
                    TextColor3 = "Text"
                }
            })

            local TRGLabelUP = UI:Create("UIPadding", {
                Parent = TRGLabel,
                PaddingLeft = UDim.new(0, 5),
            })

            local ToggleTRG = UI:Create("TextButton", {
                Parent = ToggleModule,
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                BorderColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                Size = UDim2.new(0, Window.Size.X.Offset - 17, 0, 35),
                ZIndex = 5,
                Font = Enum.Font.SourceSans,
                TextColor3 = Color3.new(0, 0, 0),
                TextSize = 14,
                TextTransparency = 1,
            })

            local ValFrame = UI:Create("Frame", {
                Parent = ToggleModule,
                BackgroundColor3 = Color3.fromRGB(UITheme[Window.Theme].Placeholder.R * 255, UITheme[Window.Theme].Placeholder.G * 255, UITheme[Window.Theme].Placeholder.B * 255),
                BorderColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2.new(0, ToggleModule.Size.X.Offset - 35, 0, 8.5),
                Size = UDim2.new(0, 30, 0, 17),
                ThemeID = {
                    BackgroundColor3 = "Placeholder"
                }
            })

            local ValFrameC = UI:Create("UICorner", {
                Parent = ValFrame,
            })

            local ToggleVal = UI:Create("Frame", {
                Parent = ValFrame,
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                BorderColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 2, 0, 2),
                Size = UDim2.new(0, 13, 0, 13),
            })

            local ToggleValC = UI:Create("UICorner", {
                Parent = ToggleVal,
            })
            function Toggle:SetValue(Val)
                ToggleModule:Destroy()
            end

            local Val = Toggle.Default
            function TSvipe(Val)
                if Val then
                    Utility:TweenObject(ToggleVal, {Position = UDim2.new(0, 15,0, 2)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                    Utility:TweenObject(ToggleVal, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                else
                    Utility:TweenObject(ToggleVal, {Position = UDim2.new(0, 2, 0, 2)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                    Utility:TweenObject(ToggleVal, {BackgroundColor3 = Color3.fromRGB(UITheme[Window.Theme].Placeholder.R * 255 + 20, UITheme[Window.Theme].Placeholder.G * 255 + 20, UITheme[Window.Theme].Placeholder.B * 255 + 20)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                end
            end

            function Toggle:SetValue(Val)
                TSvipe(Val)
            end
            TSvipe(Val)

                spawn(function()
                    pcall(Toggle.Callback, Val)
                end)

                ToggleTRG.MouseButton1Click:Connect(function()
                    Val = not Val
                    spawn(function()
                        pcall(Toggle.Callback, Val)
                    end)

                    if Val then
                        Utility:TweenObject(ToggleVal, {Position = UDim2.new(0, 15,0, 2)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                        Utility:TweenObject(ToggleVal, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                    else
                        Utility:TweenObject(ToggleVal, {Position = UDim2.new(0, 2, 0, 2)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                        Utility:TweenObject(ToggleVal, {BackgroundColor3 = Color3.fromRGB(UITheme[Window.Theme].Placeholder.R * 255 + 20, UITheme[Window.Theme].Placeholder.G * 255 + 20, UITheme[Window.Theme].Placeholder.B * 255 + 20)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                    end
                end)

                function Toggle:Close()
                    ToggleModule:Destroy()
                end

                function Toggle:SetTitle(Value)
                    TRGLabel.Text = Value
                end
            return Toggle
        end

        local ParagraphCount = 0
        function Elements:Paragraph(Config)
            ParagraphCount = ParagraphCount + 1
            local Paragraph = {
                Title = Config.Title or "Paragraph" .. ParagraphCount,
                Icon = Config.Icon,
                Color = Config.Color or "Default",
                Brightness = Config.Brightness or 28,
                TextSize = Config.TextSize or 13
            }

        local function createColor(r, g, b)
            return Color3.fromRGB(r + Paragraph.Brightness - 28, g + Paragraph.Brightness - 28, b + Paragraph.Brightness - 28)
        end

        local Colors = {
            Default = createColor(UITheme[Window.Theme].ElementColor.R * 255, UITheme[Window.Theme].ElementColor.G * 255, UITheme[Window.Theme].ElementColor.B * 255),
            Red = createColor(154, 0, 5),
            Green = createColor(41, 154, 0),
            Blue = createColor(0, 41, 154),
            Pink = createColor(154, 0, 154),
            Orange = createColor(154, 95, 0),
            Yellow = createColor(154, 141, 0),
            Ocyan = createColor(0, 133, 154),
            Purple = createColor(95, 0, 154),
        }

        local ParagraphElement = UI:Create("Frame", {
            Name = Paragraph.Title,
            Parent = ScrollElement,
            BackgroundTransparency = 0.2,
            BorderColor3 = Color3.new(0, 0, 0),
            AutomaticSize = "Y",
            BorderSizePixel = 0,
            Size = UDim2.new(0, Window.Size.X.Offset - 17 - 134, 0, 35),
            ThemeID = {
                BackgroundColor3 = "BackgroundColor"
            },
            BackgroundColor3 = Colors[Paragraph.Color] or Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255, UITheme[Window.Theme].ElementColor.G * 255, UITheme[Window.Theme].ElementColor.B * 255),
        })

        local ParagraphElementC = UI:Create("UICorner", {
            Parent = ParagraphElement,
            CornerRadius = UDim.new(0, 5),
        })

        local ParagraphLabel = UI:Create("TextLabel", {
            Parent = ParagraphElement,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
            Size = UDim2.new(0, Window.Size.X.Offset - 17, 0, 35),
            FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
            Text = Paragraph.Title,
            AutomaticSize = "Y",
            TextColor3 = Color3.fromRGB(UITheme[Window.Theme].Text.R * 255, UITheme[Window.Theme].Text.G * 255, UITheme[Window.Theme].Text.B * 255),
            TextSize = Paragraph.TextSize,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            ThemeID = {
                TextColor3 = "Text"
            }
        })

        local ParagraphLabelUP = UI:Create("UIPadding", {
            Parent = ParagraphLabel,
            PaddingLeft = UDim.new(0, 5),
        })

        local ParagraphIcon = Instance.new("ImageLabel")
            if Paragraph.Icon then
                ParagraphIcon.Parent = ParagraphElement
                ParagraphIcon.BackgroundColor3 = Color3.new(1, 1, 1)
                ParagraphIcon.BackgroundTransparency = 1
                ParagraphIcon.BorderColor3 = Color3.new(0, 0, 0)
                ParagraphIcon.BorderSizePixel = 0
                ParagraphIcon.Position = UDim2.new(0.025, 0,0.249, 0)
                ParagraphIcon.Size = UDim2.new(0, 17, 0, 17)
                ParagraphIcon.ImageColor3 = Color3.fromRGB(UITheme[Window.Theme].IconColor.R * 255, UITheme[Window.Theme].IconColor.G * 255, UITheme[Window.Theme].IconColor.B * 255)
                if Paragraph.Icon and Icons.Icon(Paragraph.Icon) then
                    ParagraphIcon.Image = Icons.Icon(Paragraph.Icon)[1]
                    ParagraphIcon.ImageRectSize = Icons.Icon(Paragraph.Icon)[2].ImageRectSize
                    ParagraphIcon.ImageRectOffset = Icons.Icon(Paragraph.Icon)[2].ImageRectPosition
                elseif Paragraph.Icon and string.find(Paragraph.Icon, "rbxassetid://") then
                    ParagraphIcon.Image = Paragraph.Icon
                end
                ParagraphLabelUP.PaddingLeft = UDim.new(0, 28)
            end
                function Paragraph:Close()
                    ParagraphElement:Destroy()
                end

                function Paragraph:SetTitle(Value)
                    ParagraphLabel.Text = Value
                end
            return Paragraph
        end
        local SectionCount = 0
        function Elements:Section(Config)
            SectionCount = SectionCount + 1
            local Section = {
                Title = Config.Title or "Section" .. SectionCount,
                Icon = Config.Icon,
                TextSize = Config.TextSize or 18,
                UIPadding = Config.UIPadding or UDim.new(0, 0),
            }
            local SectionElement = UI:Create("Frame", {
                Name = Section.Title,
                Parent = ScrollElement,
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                BorderColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0.3038, 0),
                Size = UDim2.new(0, Window.Size.X.Offset - 17 - 134, 0, 20),
                ThemeID = {
                    BackgroundColor3 = "ElementColor"
                }
            })

            local SectionLabel = UI:Create("TextLabel", {
                Name = "SectionLabel",
                Parent = SectionElement,
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                BorderColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(0, Window.Size.X.Offset - 17, 0, 20),
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
                Text = Section.Title,
                TextColor3 = Color3.fromRGB(UITheme[Window.Theme].Text.R * 255, UITheme[Window.Theme].Text.G * 255, UITheme[Window.Theme].Text.B * 255),
                TextSize = Section.TextSize,
                TextXAlignment = Enum.TextXAlignment.Left,
                ThemeID = {
                    TextColor3 = "Text"
                }
            })

            local SectionLabelUP = UI:Create("UIPadding", {
                Name = "SectionLabelUP",
                Parent = SectionLabel,
                PaddingLeft = UDim.new(0, 22),
            })

            local SectionIcon = Instance.new("ImageLabel")
            if Section.Icon then
                SectionIcon.Name = "SectionIcon"
                SectionIcon.Parent = SectionElement
                SectionIcon.BackgroundColor3 = Color3.new(1, 1, 1)
                SectionIcon.BackgroundTransparency = 1
                SectionIcon.BorderColor3 = Color3.new(0, 0, 0)
                SectionIcon.BorderSizePixel = 0
                SectionIcon.Position = UDim2.new(0, 0, 0, 1)
                SectionIcon.Size = UDim2.new(0, 20, 0, 20)
                SectionIcon.ImageColor3 = Color3.fromRGB(UITheme[Window.Theme].IconColor.R * 255, UITheme[Window.Theme].IconColor.G * 255, UITheme[Window.Theme].IconColor.B * 255)
                if Section.Icon and Icons.Icon(Section.Icon) then
                    SectionIcon.Image = Icons.Icon(Section.Icon)[1]
                    SectionIcon.ImageRectSize = Icons.Icon(Section.Icon)[2].ImageRectSize
                    SectionIcon.ImageRectOffset = Icons.Icon(Section.Icon)[2].ImageRectPosition
                elseif Paragraph.Icon and string.find(Section.Icon, "rbxassetid://") then
                    SectionIcon.Image = Section.Icon
                end
            end

            if Section.Icon then
                SectionLabelUP.PaddingLeft = Section.UIPadding + UDim.new(0, 22)
            else
                SectionLabelUP.PaddingLeft = Section.UIPadding
            end
            function Section:Close()
                SectionElement:Destroy()
            end

            function Section:SetTitle(Value)
                SectionLabel.Text = Value
            end
            return Section
        end

        local SmallParagraphcount = 0
        function Elements:SmallParagraph(Config)
            SmallParagraphcount = SmallParagraphcount + 1
            local SmallParagraph = {
                Title = Config.Title or "Paragraph" .. SmallParagraphcount,
                Icon = Config.Icon,
                Color = Config.Color or "Default",
                Brightness = Config.Brightness or 28,
                TextSize = Config.TextSize or 11,
                TextXAlignment = Config.TextXAlignment or "Center"
            }

            local function createColor(r, g, b)
                return Color3.fromRGB(r + SmallParagraph.Brightness - 28, g + SmallParagraph.Brightness - 28, b + SmallParagraph.Brightness - 28)
            end

            local Colors = {
                Default = createColor(UITheme[Window.Theme].ElementColor.R * 255, UITheme[Window.Theme].ElementColor.G * 255, UITheme[Window.Theme].ElementColor.B * 255),
                Red = createColor(154, 0, 5),
                Green = createColor(41, 154, 0),
                Blue = createColor(0, 41, 154),
                Pink = createColor(154, 0, 154),
                Orange = createColor(154, 95, 0),
                Yellow = createColor(154, 141, 0),
                Ocyan = createColor(0, 133, 154),
                Purple = createColor(95, 0, 154),
            }

            local SmallParagraphElement = UI:Create("Frame", {
                Name = SmallParagraph.Title,
                Parent = ScrollElement,
                BackgroundColor3 = Colors[SmallParagraph.Color] or Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255, UITheme[Window.Theme].ElementColor.G * 255, UITheme[Window.Theme].ElementColor.B * 255),
                BackgroundTransparency = 0.2,
                BorderColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0.6203, 0),
                Size = UDim2.new(0, Window.Size.X.Offset - 17 - 134, 0, 20),
                ThemeID = {
                    BackgroundColor3 = "ElementColor"
                }
            })

            --local UIStroke = UI:Create("UIStroke", {
                --Parent = SmallParagraphElement,
                --Color = Color3.fromRGB(255, 255, 255),
                --LineJoinMode = "Round",
                --Thickness = 0.6,
            --})

            --local UIGradient = UI:Create("UIGradient", {
                --Parent = UIStroke,
                --Color = ColorSequence.new{
                    --ColorSequenceKeypoint.new(0.00, Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255, UITheme[Window.Theme].ElementColor.G * 255, UITheme[Window.Theme].ElementColor.B * 255 + 20)),
                    --ColorSequenceKeypoint.new(1.00, Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255 + 20, UITheme[Window.Theme].ElementColor.G * 255 + 20, UITheme[Window.Theme].ElementColor.B * 255 + 20))
                --},
                --Rotation = -90,
            --})

            if Colors[SmallParagraph.Color] then
                SmallParagraphElement.BackgroundColor3 = Colors[SmallParagraph.Color]
            end

            local SmallParagraphElementC = UI:Create("UICorner", {
                Parent = SmallParagraphElement,
                CornerRadius = UDim.new(0, 5),
            })

            local SmallParagraphLabel = UI:Create("TextLabel", {
                Name = "SmallParagraphLabel",
                Parent = SmallParagraphElement,
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                BorderColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                Size = UDim2.new(0, Window.Size.X.Offset - 17 - 134, 0, 20),
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
                Text = SmallParagraph.Title,
                TextColor3 = Color3.fromRGB(UITheme[Window.Theme].Text.R * 255, UITheme[Window.Theme].Text.G * 255, UITheme[Window.Theme].Text.B * 255),
                TextSize = SmallParagraph.TextSize,
                TextWrapped = true,
                TextXAlignment = SmallParagraph.TextXAlignment,
                ThemeID = {
                    TextColor3 = "Text"
                }
            })

            local SmallParagraphLabelUP = UI:Create("UIPadding", {
                Parent = SmallParagraphLabel,
                PaddingLeft = UDim.new(0, 5),
            })

            if SmallParagraph.Icon then
                local SmallParagraphLabelUP = Instance.new("UIPadding")
                SmallParagraphIcon.Name = "SmallParagraphIcon"
                SmallParagraphIcon.Parent = SmallParagraphElement
                SmallParagraphIcon.BackgroundColor3 = Color3.new(1, 1, 1)
                SmallParagraphIcon.BackgroundTransparency = 1
                SmallParagraphIcon.BorderColor3 = Color3.new(0, 0, 0)
                SmallParagraphIcon.BorderSizePixel = 0
                SmallParagraphIcon.Position = UDim2.new(0.024, 0,0.099, 0)
                SmallParagraphIcon.Size = UDim2.new(0, 15, 0, 15)
                SmallParagraphIcon.ImageColor3 = Color3.fromRGB(UITheme[Window.Theme].IconColor.R * 255, UITheme[Window.Theme].IconColor.G * 255, UITheme[Window.Theme].IconColor.B * 255)
                if SmallParagraph.Icon and Icons.Icon(SmallParagraph.Icon) then
                    SmallParagraphIcon.Image = Icons.Icon(SmallParagraph.Icon)[1]
                    SmallParagraphIcon.ImageRectSize = Icons.Icon(SmallParagraph.Icon)[2].ImageRectSize
                    SmallParagraphIcon.ImageRectOffset = Icons.Icon(SmallParagraph.Icon)[2].ImageRectPosition
                    SmallParagraphLabelUP.PaddingLeft = UDim.new(0, 25)
                elseif SmallParagraph.Icon and string.find(SmallParagraph.Icon, "rbxassetid://") then
                    SmallParagraphIcon.Image = SmallParagraph.Icon
                end

                if SmallParagraph.TextXAlignment == "Left" then
                    SmallParagraphLabelUP.PaddingLeft = UDim.new(0, 25)
                    SmallParagraphIcon.Position = UDim2.new(0.024, 0,0.125, 0)
                elseif SmallParagraph.TextXAlignment == "Right" then
                    SmallParagraphLabelUP.PaddingRight = UDim.new(0, 25)
                    SmallParagraphIcon.Position = UDim2.new(0.922, 0,0.125, 0)
                elseif SmallParagraph.TextXAlignment == "Center" then
                    SmallParagraphLabelUP.PaddingRight = UDim.new(0, 0)
                    SmallParagraphLabelUP.PaddingLeft = UDim.new(0, 0)
                    SmallParagraphIcon.Visible = false
                end
            else
                if SmallParagraph.TextXAlignment == "Left" then
                    SmallParagraphLabelUP.PaddingLeft = UDim.new(0, 5)
                elseif SmallParagraph.TextXAlignment == "Right" then
                    SmallParagraphLabelUP.PaddingRight = UDim.new(0, 5)
                elseif SmallParagraph.TextXAlignment == "Center" then
                    SmallParagraphLabelUP.PaddingRight = UDim.new(0, 0)
                end
            end

            function SmallParagraph:Close()
                SmallParagraphElement:Destroy()
            end

            function SmallParagraph:SetTitle(Value)
                SmallParagraphLabel.Text = Value
            end
            return SmallParagraph
        end

        local SliderCount = 0
        local HoldingSlider = false

        function Elements:Slider(Config)
            SliderCount = SliderCount + 1
            local Slider = {
                Title = Config.Title or "Slider " .. SliderCount,
                Step = Config.Step,
                Value = Config.Value or {},
                Callback = Config.Callback or function() end
            }
                        
            local SliderElement = UI:Create("Frame", {
                Name = Slider.Title,
                Parent = ScrollElement,
                BackgroundColor3 = Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255, UITheme[Window.Theme].ElementColor.G * 255, UITheme[Window.Theme].ElementColor.B * 255),
                BackgroundTransparency = 0.2,
                BorderColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                Size = UDim2.new(0, Window.Size.X.Offset - 17 - 134, 0, 35),
                ThemeID = {
                    BackgroundColor3 = "ElementColor"
                }
            })

            local UIStroke = UI:Create("UIStroke", {
                Parent = SliderElement,
                Color = Color3.fromRGB(255, 255, 255),
                LineJoinMode = "Round",
                Thickness = 0.6,
            })

            local UIGradient = UI:Create("UIGradient", {
                Parent = UIStroke,
                Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255, UITheme[Window.Theme].ElementColor.G * 255, UITheme[Window.Theme].ElementColor.B * 255 + 20)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255 + 20, UITheme[Window.Theme].ElementColor.G * 255 + 20, UITheme[Window.Theme].ElementColor.B * 255 + 20))
                },
                Rotation = -90,
            })

            local SliderElementC = UI:Create("UICorner", {
                Parent = SliderElement,
                CornerRadius = UDim.new(0, 5),
            })

            local ParagraphLabel = UI:Create("TextLabel", {
                Name = "ParagraphLabel",
                Parent = SliderElement,
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                BorderColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                Size = UDim2.new(0, Window.Size.X.Offset - 17 - 134, 0, 35),
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
                Text = Slider.Title,
                TextColor3 = Color3.fromRGB(UITheme[Window.Theme].Text.R * 255, UITheme[Window.Theme].Text.G * 255, UITheme[Window.Theme].Text.B * 255),
                TextSize = 13,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                ThemeID = {
                    TextColor3 = "Text"
                }
            })

            table.insert(TextColor, ParagraphLabel)

            local ParagraphLabelUP = UI:Create("UIPadding", {
                Parent = ParagraphLabel,
                PaddingLeft = UDim.new(0, 5),
            })

            local SliderBar = UI:Create("Frame", {
                Name = "SliderBar",
                Parent = SliderElement,
                BackgroundColor3 = Color3.fromRGB(UITheme[Window.Theme].Placeholder.R * 255, UITheme[Window.Theme].Placeholder.G * 255, UITheme[Window.Theme].Placeholder.B * 255),
                BorderColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2.new(0, SliderElement.Size.X.Offset - 135, 0, 10),
                Size = UDim2.new(0, 91, 0, 13),
                ThemeID = {
                    BackgroundColor3 = "Placeholder"
                }
            })

            local SliderBarC = UI:Create("UICorner", {
                Parent = SliderBar,
            })

            local SliderBarPart = UI:Create("Frame", {
                Name = "SliderBarPart",
                Parent = SliderBar,
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                Size = UDim2.new(0, 40, 0, 13),
            })

            local SliderBarPartC = UI:Create("UICorner", {
                Parent = SliderBarPart,
            })

            local SliderBarTRG = UI:Create("TextButton", {
                Name = "SliderBarTRG",
                Parent = SliderBar,
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                BorderColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                Size = UDim2.new(0, 91, 0, 13),
                Font = Enum.Font.SourceSans,
                TextColor3 = Color3.new(0, 0, 0),
                TextSize = 14,
                TextTransparency = 1,
            })

            local SliderValBG = UI:Create("TextButton", {
                Name = "SliderValBG",
                Parent = SliderElement,
                BackgroundColor3 = Color3.fromRGB(UITheme[Window.Theme].Placeholder.R * 255, UITheme[Window.Theme].Placeholder.G * 255, UITheme[Window.Theme].Placeholder.B * 255),
                BorderColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2.new(0, SliderElement.Size.X.Offset - 35, 0, 8.5),
                Size = UDim2.new(0, 28, 0, 17),
                ZIndex = 3,
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
                Text = "",
                TextColor3 = Color3.new(0, 0, 0),
                TextSize = 10,
                ThemeID = {
                    TextColor3 = "Text",
                    BackgroundColor3 = "Placeholder"
                }
            })

            local SliderValBGC = UI:Create("UICorner", {
                Parent = SliderValBG,
                CornerRadius = UDim.new(0, 6),
            })

            local SliderValBG_2 = UI:Create("TextBox", {
                Name = "SliderValBG",
                Parent = SliderValBG,
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                BorderColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 1, 0),
                FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
                PlaceholderColor3 = Color3.new(1, 1, 1),
                Text = "",
                TextColor3 = Color3.new(1, 1, 1),
                TextSize = 10,
                TextStrokeColor3 = Color3.new(1, 1, 1),
                TextWrapped = true,
                ThemeID = {
                    TextColor3 = "Text",
                    BackgroundColor3 = "Placeholder"
                }
            })

            local Value
			local moveconnection
			local releaseconnection
			local isTouch = false
			local isFocusing = false

			SliderValBG_2.Focused:Connect(function()
				isFocusing = true
			end)

			SliderValBG_2.FocusLost:Connect(function(enterPressed)
				isFocusing = false
				if tonumber(SliderValBG_2.Text) then
					local inputValue = tonumber(SliderValBG_2.Text)
					local clampedValue = math.clamp(inputValue, Slider.Value.Min, Slider.Value.Max)
					Value = clampedValue
					SliderValBG_2.Text = Value
					SliderBarPart.Size = UDim2.new((clampedValue - Slider.Value.Min) / (Slider.Value.Max - Slider.Value.Min), 0, 1, 0)
					task.spawn(Slider.Callback, clampedValue)
				end
			end)
			
			local clampedDefault = math.clamp(Slider.Value.Default, Slider.Value.Min, Slider.Value.Max)
			Value = clampedDefault
			SliderBarPart.Size = UDim2.new((clampedDefault - Slider.Value.Min) / (Slider.Value.Max - Slider.Value.Min), 0, 1, 0)
			SliderValBG_2.Text = tostring(clampedDefault)
			task.spawn(Slider.Callback, clampedDefault)
			
			SliderValBG_2:GetPropertyChangedSignal("Text"):Connect(function()
				if tonumber(SliderValBG_2.Text) then
					local inputValue = tonumber(SliderValBG_2.Text)
					local clampedValue = math.clamp(inputValue, Slider.Value.Min, Slider.Value.Max)
					Value = clampedValue
					SliderBarPart.Size = UDim2.new((clampedValue - Slider.Value.Min) / (Slider.Value.Max - Slider.Value.Min), 0, 1, 0)
					task.spawn(Slider.Callback, clampedValue)
				end
			end)
					
			SliderBarTRG.InputBegan:Connect(function(input)
				if not isFocusing and not HoldingSlider and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
					isTouch = (input.UserInputType == Enum.UserInputType.Touch)
					HoldingSlider = true
					moveconnection = game:GetService("RunService").RenderStepped:Connect(function()
						local inputPosition
						if isTouch then
							inputPosition = input.Position.X
						else
							inputPosition = game:GetService("UserInputService"):GetMouseLocation().X
						end
						local delta = math.clamp((inputPosition - SliderBarPart.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
						Value = math.floor((Slider.Value.Min + delta * (Slider.Value.Max - Slider.Value.Min)) / Slider.Step + 0.5) * Slider.Step
						SliderBarPart.Size = UDim2.new(delta, 0, 1, 0)
						SliderValBG_2.Text = tostring(Value)
						task.spawn(Slider.Callback, Value)
					end)
					
					releaseconnection = game:GetService("UserInputService").InputEnded:Connect(function(endInput)
						if (endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch) and input == endInput then
							moveconnection:Disconnect()
							releaseconnection:Disconnect()
							HoldingSlider = false
						end
					end)
				end
			end)

            function Slider:Close()
                SliderElement:Destroy()
            end

            function Slider:SetTitle(Value)
                ParagraphLabel.Text = Value
            end
            return Slider
        end

        local DropDownCount = 0
        function Elements:DropDown(Config)
            local Dropdown = {
                Title = Config.Title or "DropDown" .. DropDownCount,
                Value = Config.Value or "",
                Option = Config.Option or {},
                Callback = Config.Callback or function() end
            }

            local DropDownElement = Instance.new("Frame")
            local DropDownLabel = Instance.new("TextLabel")
            local DropDownLabelUPP = Instance.new("UIPadding")
            local DropDownTRG = Instance.new("TextButton")
            local DropElementFrame = Instance.new("Frame")
            local UIPadding = Instance.new("UIPadding")
            local DropElementFrameULL = Instance.new("UIListLayout")
            local DropDownOptionElm = Instance.new("Frame")
            local DropDownOptionElmC = Instance.new("UICorner")
            local DropIcon = Instance.new("ImageLabel")
            local DropOptionBox = Instance.new("TextBox")
            local DropOptionBoxUPP = Instance.new("UIPadding")
            local ParagraphElementC = Instance.new("UICorner")

            DropDownElement.Name = Dropdown.Title
            DropDownElement.Parent = ScrollElement
            DropDownElement.BackgroundColor3 = Color3.fromRGB(0, 30, 53)
            DropDownElement.BackgroundTransparency = 0.9
            DropDownElement.BorderColor3 = Color3.new(0, 0, 0)
            DropDownElement.BorderSizePixel = 0
            DropDownElement.Position = UDim2.new(-0.00719424477, 0, 0.527426183, 0)
            DropDownElement.AutomaticSize = "Y"
            DropDownElement.Size = UDim2.new(0, Window.Size.X.Offset - 17 - 134, 0, 0)

            --[[DropDownModule.Name = "DropDownModule"
            DropDownModule.Parent = ScrollElement
            DropDownModule.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
            DropDownModule.BackgroundTransparency = 1
            DropDownModule.BorderColor3 = Color3.fromRGB(0, 0, 0)
            DropDownModule.BorderSizePixel = 0
            DropDownModule.AutomaticSize = "Y"
            DropDownModule.Position = UDim2.new(0, 0, 0.496284127, 35)
            DropDownModule.Size = UDim2.new(0, Window.Size.X.Offset - 17 - 134, 0, 0)--]]

            local UIListLayout = Instance.new("UIListLayout")
            UIListLayout.Parent = DropDownElement
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 4)

            --[[local CDropDownModule = Instance.new("Frame")
            CDropDownModule.Name = "DropDownModule"
            CDropDownModule.Parent = ScrollElement
            CDropDownModule.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
            CDropDownModule.BackgroundTransparency = 0.200
            CDropDownModule.BorderColor3 = Color3.fromRGB(0, 0, 0)
            CDropDownModule.BorderSizePixel = 0
            CDropDownModule.Position = UDim2.new(0, 0, 0.496284127, 0)
            CDropDownModule.Size = UDim2.new(0, Window.Size.X.Offset - 17 - 134, 0, 35)--]]

            local DropFrame = Instance.new("Frame")
            DropFrame.Parent = DropDownElement
            DropFrame.BackgroundColor3 = Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255, UITheme[Window.Theme].ElementColor.G * 255, UITheme[Window.Theme].ElementColor.B * 255)
            DropFrame.BackgroundTransparency = 0
            DropFrame.BorderColor3 = Color3.new(0, 0, 0)
            DropFrame.BorderSizePixel = 0
            DropFrame.Size = UDim2.new(0, Window.Size.X.Offset - 17 - 134, 0, 35)

            local UIStroke = Instance.new("UIStroke", DropFrame)
            UIStroke.Color = Color3.fromRGB(255, 255, 255)
            UIStroke.LineJoinMode = "Round"
            UIStroke.Thickness = 0.6

            local UIGradient = Instance.new("UIGradient", UIStroke)
            UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255, UITheme[Window.Theme].ElementColor.G * 255, UITheme[Window.Theme].ElementColor.B * 255 + 20)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255 + 20, UITheme[Window.Theme].ElementColor.G * 255 + 20, UITheme[Window.Theme].ElementColor.B * 255 + 20))}
            UIGradient.Rotation = -90

            DropDownLabel.Name = "DropDownLabel"
            DropDownLabel.Parent = DropFrame
            DropDownLabel.BackgroundColor3 = Color3.new(1, 1, 1)
            DropDownLabel.BackgroundTransparency = 1
            DropDownLabel.BorderColor3 = Color3.new(0, 0, 0)
            DropDownLabel.BorderSizePixel = 0
            DropDownLabel.Size = UDim2.new(0, Window.Size.X.Offset - 17, 0, 35)
            DropDownLabel.FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            DropDownLabel.Text = Dropdown.Title
            DropDownLabel.TextColor3 = Color3.fromRGB(UITheme[Window.Theme].Text.R * 255, UITheme[Window.Theme].Text.G * 255, UITheme[Window.Theme].Text.B * 255)
            DropDownLabel.TextSize = 13
            DropDownLabel.TextWrapped = true
            DropDownLabel.TextXAlignment = Enum.TextXAlignment.Left


            DropDownLabelUPP.Name = "DropDownLabelUPP"
            DropDownLabelUPP.Parent = DropDownLabel
            DropDownLabelUPP.PaddingLeft = UDim.new(0, 5)

            DropDownTRG.Name = "DropDownTRG"
            DropDownTRG.Parent = DropFrame
            DropDownTRG.BackgroundColor3 = Color3.new(1, 1, 1)
            DropDownTRG.BackgroundTransparency = 1
            DropDownTRG.BorderColor3 = Color3.new(0, 0, 0)
            DropDownTRG.BorderSizePixel = 0
            DropDownTRG.Size = UDim2.new(0, Window.Size.X.Offset - 17, 0, 35)
            DropDownTRG.FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            DropDownTRG.TextColor3 = Color3.new(0, 0, 0)
            DropDownTRG.TextSize = 14
            DropDownTRG.TextTransparency = 1

            DropElementFrame.Name = "DropElementFrame"
            DropElementFrame.Parent = DropDownElement
            DropElementFrame.BackgroundColor3 = Color3.new(1, 1, 1)
            DropElementFrame.BackgroundTransparency = 1
            DropElementFrame.BorderColor3 = Color3.new(0, 0, 0)
            DropElementFrame.BorderSizePixel = 0
            DropElementFrame.ClipsDescendants = true
            DropElementFrame.AutomaticSize = "Y"
            --DropElementFrame.ClipsDescendants = true
            DropElementFrame.Position = UDim2.new(0, 0, 0)
            DropElementFrame.Size = UDim2.new(0, Window.Size.X.Offset - 17, 0, 0)

            local ScrollingFrame = Instance.new("ScrollingFrame")
            ScrollingFrame.Name = "DropElementFrame"
            ScrollingFrame.Parent = DropElementFrame
            ScrollingFrame.BackgroundColor3 = Color3.new(1, 1, 1)
            ScrollingFrame.BackgroundTransparency = 1
            ScrollingFrame.BorderColor3 = Color3.new(0, 0, 0)
            ScrollingFrame.BorderSizePixel = 0
            --ScrollingFrame.AutomaticSize = "XY"
            ScrollingFrame.AutomaticCanvasSize = "Y"
            ScrollingFrame.ScrollingDirection = "Y"
            ScrollingFrame.ClipsDescendants = false
            ScrollingFrame.Size = UDim2.new(0, Window.Size.X.Offset - 17, 0, 0)

            UIPadding.Parent = ScrollingFrame
            --UIPadding.PaddingTop = UDim.new(0, 3)
            UIPadding.PaddingTop = UDim.new(0,0)
            UIPadding.PaddingLeft = UDim.new(0,0)
            UIPadding.PaddingRight = UDim.new(0.6)
            UIPadding.PaddingBottom = UDim.new(0,0)

            DropElementFrameULL.Name = "DropElementFrameULL"
            DropElementFrameULL.Parent = ScrollingFrame
            DropElementFrameULL.SortOrder = Enum.SortOrder.LayoutOrder
            DropElementFrameULL.Padding = UDim.new(0, 5)

            DropDownOptionElm.Name = "DropDownOptionElm"
            DropDownOptionElm.Parent = DropFrame
            DropDownOptionElm.BackgroundColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392)
            DropDownOptionElm.BorderColor3 = Color3.new(0, 0, 0)
            DropDownOptionElm.BorderSizePixel = 0
            --DropDownOptionElm.ClipsDescendants = true
            DropDownOptionElm.Position = UDim2.new(0, DropFrame.Size.X.Offset - 103, 0.22857143, 0)
            DropDownOptionElm.Size = UDim2.new(0, 96, 0, 18)

            DropDownOptionElmC.Name = "DropDownOptionElmC"
            DropDownOptionElmC.Parent = DropDownOptionElm

            DropIcon.Name = "DropIcon"
            DropIcon.Parent = DropDownOptionElm
            DropIcon.BackgroundColor3 = Color3.new(1, 1, 1)
            DropIcon.BackgroundTransparency = 1
            DropIcon.BorderColor3 = Color3.new(0, 0, 0)
            DropIcon.BorderSizePixel = 0
            DropIcon.Position = UDim2.new(0, DropDownOptionElm.Size.X.Offset - 23, 0, 1)
            DropIcon.Size = UDim2.new(0, 17, 0, 17)
            DropIcon.Rotation = 180
            DropIcon.ImageColor3 = Color3.fromRGB(UITheme[Window.Theme].IconColor.R * 255, UITheme[Window.Theme].IconColor.G * 255, UITheme[Window.Theme].IconColor.B * 255)
            DropIcon.Image = "rbxassetid://92757382869764"
            DropIcon.ZIndex = 6

            DropOptionBox.Name = "DropOptionBox"
            DropOptionBox.Parent = DropDownOptionElm
            DropOptionBox.BackgroundColor3 = Color3.new(1, 1, 1)
            DropOptionBox.BackgroundTransparency = 1
            DropOptionBox.BorderColor3 = Color3.new(0, 0, 0)
            DropOptionBox.BorderSizePixel = 0
            DropOptionBox.Position = UDim2.new(0.0140501661, 0, 0.055555556, 0)
            DropOptionBox.Size = UDim2.new(0, 59, 0, 17)
            DropOptionBox.ZIndex = 5
            DropOptionBox.FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            DropOptionBox.Text = "Option 1"
            DropOptionBox.TextColor3 = Color3.new(0.764706, 0.764706, 0.764706)
            DropOptionBox.TextSize = 10
            DropOptionBox.TextStrokeColor3 = Color3.new(1, 1, 1)
            DropOptionBox.TextWrapped = true
            DropOptionBox.TextXAlignment = Enum.TextXAlignment.Left
            DropOptionBox.TextEditable = false

            DropOptionBoxUPP.Name = "DropOptionBoxUPP"
            DropOptionBoxUPP.Parent = DropOptionBox
            DropOptionBoxUPP.PaddingLeft = UDim.new(0, 4)

            ParagraphElementC.Name = "ParagraphElementC"
            ParagraphElementC.Parent = DropFrame
            ParagraphElementC.CornerRadius = UDim.new(0, 5)

            local DropdownUISize = Instance.new("UISizeConstraint")
            DropdownUISize.MinSize = Vector2.new(Window.Size.X.Offset - 17 - 134,0) 
            DropdownUISize.MaxSize = Vector2.new(Window.Size.X.Offset - 17 - 134,10000) -- X, Y
            DropdownUISize.Parent = DropElementFrame

            --[[DropOptionBox:GetPropertyChangedSignal("Text"):Connect(function()
                local query = DropOptionBox.Text
                if query ~= "" and query ~= "Search . . ." then
                    DropOptionBox.TextColor3 = Color3.fromRGB(UITheme[Window.Theme].Text.R * 255, UITheme[Window.Theme].Text.G * 255, UITheme[Window.Theme].Text.B * 255)
                    updateResults(query)
                else
                    DropOptionBox.TextColor3 = Color3.fromRGB(117, 117, 117)
                    for _, v in pairs(ScrollingFrame:GetChildren()) do
                        if v:IsA("Frame") then
                            v.Visible = true
                        end
                    end
                end
            end)

            function updateResults(query)
                local lowerQuery = string.lower(query)
                for _, v in pairs(ScrollingFrame:GetChildren()) do
                    if v:IsA("Frame") then
                        if string.lower(v.Name):find(lowerQuery) then
                            v.Visible = true
                        else
                            v.Visible = false
                        end
                    end
                end
            end

            DropOptionBox:GetPropertyChangedSignal("Text"):Connect(function()
                updateResults(DropOptionBox.Text)
            end)--]]

                local DropOption = false
                
                DropDownTRG.MouseButton1Click:Connect(function()
                    if DropOption then
                        Utility:TweenObject(DropElementFrame, {Size = UDim2.new(0,DropElementFrameULL.AbsoluteContentSize.X,0,0)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                        Utility:TweenObject(UIPadding, {PaddingTop = UDim.new(0,0), PaddingBottom = UDim.new(0,0)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                        Utility:TweenObject(DropElementFrame, {Position = UDim2.new(0,0,0,35)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)--38
                        Utility:TweenObject(DropIcon, {Rotation = 180}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                    else
                        Utility:TweenObject(DropElementFrame, {Size = UDim2.new(0,DropElementFrameULL.AbsoluteContentSize.X,0,DropElementFrameULL.AbsoluteContentSize.Y+12)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                        Utility:TweenObject(UIPadding, {PaddingTop = UDim.new(0,6), PaddingBottom = UDim.new(0,6)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                        Utility:TweenObject(DropElementFrame, {Position = UDim2.new(0,0,0,0)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)--40
                        Utility:TweenObject(DropIcon, {Rotation = 0}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                    end
                    DropOption = not DropOption
                end)

                local Items = {}
                local ClickedItems = {}
                local ItemsIndex = 0
                
                for _, Item in ipairs(Dropdown.Option) do
                    ItemsIndex = ItemsIndex + 1
                    
                    local CurrentCount = ItemsIndex
                    
                    local ItemButton = Instance.new("TextButton")
                    Items[ItemsIndex] = {
                        ItemButton = ItemButton,
                        Selected = false
                    }
                    local DropElement = Instance.new("Frame")
                    local DropElementC = Instance.new("UICorner")
                    local DropElementTRG = Instance.new("TextButton")

                    DropElement.Name = Item
                    DropElement.Parent = ScrollingFrame
                    DropElement.BackgroundColor3 = Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255, UITheme[Window.Theme].ElementColor.G * 255, UITheme[Window.Theme].ElementColor.B * 255)
                    DropElement.BorderColor3 = Color3.new(0, 0, 0)
                    DropElement.BorderSizePixel = 0
                    DropElement.AutomaticSize = "Y"
                    DropElement.Size = UDim2.new(0, Window.Size.X.Offset - 17 - 134, 0, 20)
                    --DropElement.Visible = false

                    DropElementC.Name = "DropElementC"
                    DropElementC.Parent = DropElement
                    DropElementC.CornerRadius = UDim.new(0, 5)

                    DropElementTRG.Name = "DropElementTRG"
                    DropElementTRG.Parent = DropElement
                    DropElementTRG.BackgroundColor3 = Color3.new(1, 1, 1)
                    DropElementTRG.BackgroundTransparency = 1
                    DropElementTRG.BorderColor3 = Color3.new(0, 0, 0)
                    DropElementTRG.BorderSizePixel = 0
                    DropElementTRG.Text = Item
                    DropElementTRG.AutomaticSize = "Y"
                    DropElementTRG.TextWrapped = true
                    DropElementTRG.Position = UDim2.new(0, 0, 0, 0)
                    DropElementTRG.Size = UDim2.new(0, Window.Size.X.Offset - 17 - 134, 0, 20)
                    DropElementTRG.FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                    DropElementTRG.TextColor3 = Color3.new(1, 1, 1)
                    DropElementTRG.TextSize = 11

                    DropElementTRG.MouseButton1Click:Connect(function()
                        DropOptionBox.Text = Item
                        task.spawn(Dropdown.Callback, Item)
                        Utility:TweenObject(DropElement, {BackgroundColor3 = Color3.fromRGB(DropElement.BackgroundColor3.R+30,DropElement.BackgroundColor3.G+30,DropElement.BackgroundColor3.B+30)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                        wait(0.15)
                        Utility:TweenObject(DropElement, {BackgroundColor3 = Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255, UITheme[Window.Theme].ElementColor.G * 255, UITheme[Window.Theme].ElementColor.B * 255)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                    end)
                end

                function Dropdown:Refresh(Val)
                    for _, ItemButton in ipairs(Items) do
                        if ItemButton then
                            ItemButton:Destroy()
                        end
                    end
                    Items = {}
                    ClickedItems = {}
                    ItemsIndex = 0

                    for _, Item in ipairs(Val) do
                        ItemsIndex = ItemsIndex + 1
                        
                        local CurrentCount = ItemsIndex
                        
                        local ItemButton = Instance.new("TextButton")
                        Items[ItemsIndex] = {
                            ItemButton = ItemButton,
                            Selected = false
                        }
                        local DropElement = Instance.new("Frame")
                        local DropElementC = Instance.new("UICorner")
                        local DropElementTRG = Instance.new("TextButton")

                        DropElement.Name = Item
                        DropElement.Parent = ScrollingFrame
                        DropElement.BackgroundColor3 = Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255, UITheme[Window.Theme].ElementColor.G * 255, UITheme[Window.Theme].ElementColor.B * 255)
                        DropElement.BorderColor3 = Color3.new(0, 0, 0)
                        DropElement.BorderSizePixel = 0
                        DropElement.AutomaticSize = "Y"
                        DropElement.Size = UDim2.new(0, Window.Size.X.Offset - 17 - 134, 0, 20)
                        --DropElement.Visible = false

                        DropElementC.Name = "DropElementC"
                        DropElementC.Parent = DropElement
                        DropElementC.CornerRadius = UDim.new(0, 5)

                        DropElementTRG.Name = "DropElementTRG"
                        DropElementTRG.Parent = DropElement
                        DropElementTRG.BackgroundColor3 = Color3.new(1, 1, 1)
                        DropElementTRG.BackgroundTransparency = 1
                        DropElementTRG.BorderColor3 = Color3.new(0, 0, 0)
                        DropElementTRG.BorderSizePixel = 0
                        DropElementTRG.Text = Item
                        DropElementTRG.AutomaticSize = "Y"
                        DropElementTRG.TextWrapped = true
                        DropElementTRG.Position = UDim2.new(0, 0, 0, 0)
                        DropElementTRG.Size = UDim2.new(0, Window.Size.X.Offset - 17 - 134, 0, 20)
                        DropElementTRG.FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                        DropElementTRG.TextColor3 = Color3.new(1, 1, 1)
                        DropElementTRG.TextSize = 11

                        DropElementTRG.MouseButton1Click:Connect(function()
                            DropOptionBox.Text = Item
                            task.spawn(Dropdown.Callback, Item)
                            Utility:TweenObject(DropElement, {BackgroundColor3 = Color3.fromRGB(DropElement.BackgroundColor3.R+30,DropElement.BackgroundColor3.G+30,DropElement.BackgroundColor3.B+30)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                            wait(0.15)
                            Utility:TweenObject(DropElement, {BackgroundColor3 = Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255, UITheme[Window.Theme].ElementColor.G * 255, UITheme[Window.Theme].ElementColor.B * 255)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                        end)
                    end
                    return Dropdown, Items
                end

                DropElementFrame.Size = UDim2.new(0,DropElementFrameULL.AbsoluteContentSize.X,0,0)
                    function Dropdown:Close()
                        DropDownElement:Destroy()
                    end

                    function Dropdown:SetTitle(Value)
                        DropDownLabel.Text = Value
                    end
            return Dropdown
        end
        local InputCount = 0
        function Elements:Input(Config)
            InputCount = InputCount + 1
            local Input = {
                Title = Config.Title or "Input " .. InputCount,
                Value = Config.Value or "",
                Callback = Config.Callback or function() end
            }
            local InputElement = Instance.new("Frame")
            local InputElementC = Instance.new("UICorner")
            local InputLabel = Instance.new("TextLabel")
            local ParagraphLabelUP = Instance.new("UIPadding")
            local Point = Instance.new("TextButton")
            local PointC = Instance.new("UICorner")
            local InputBox = Instance.new("TextBox")
            local InputBoxUP = Instance.new("UIPadding")
            local PointUP = Instance.new("UIPadding")

            InputElement.Name = Input.Title
            InputElement.Parent = ScrollElement
            InputElement.BackgroundColor3 = Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255, UITheme[Window.Theme].ElementColor.G * 255, UITheme[Window.Theme].ElementColor.B * 255)
            InputElement.BorderColor3 = Color3.new(0, 0, 0)
            InputElement.BorderSizePixel = 0
            InputElement.Position = UDim2.new(0.0179856122, 0, 0.708860755, 0)
            InputElement.Size = UDim2.new(0, Window.Size.X.Offset - 17 - 134, 0, 35)

            local UIStroke = Instance.new("UIStroke", InputElement)
            UIStroke.Color = Color3.fromRGB(255, 255, 255)
            UIStroke.LineJoinMode = "Round"
            UIStroke.Thickness = 0.6

            local UIGradient = Instance.new("UIGradient", UIStroke)
            UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255, UITheme[Window.Theme].ElementColor.G * 255, UITheme[Window.Theme].ElementColor.B * 255 + 20)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255 + 20, UITheme[Window.Theme].ElementColor.G * 255 + 20, UITheme[Window.Theme].ElementColor.B * 255 + 20))}
            UIGradient.Rotation = -90

            InputElementC.Name = "InputElementC"
            InputElementC.Parent = InputElement
            InputElementC.CornerRadius = UDim.new(0, 5)

            InputLabel.Name = "InputLabel"
            InputLabel.Parent = InputElement
            InputLabel.BackgroundColor3 = Color3.new(1, 1, 1)
            InputLabel.BackgroundTransparency = 1
            InputLabel.BorderColor3 = Color3.new(0, 0, 0)
            InputLabel.BorderSizePixel = 0
            InputLabel.Size = UDim2.new(0, Window.Size.X.Offset - 17, 0, 35)
            InputLabel.FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            InputLabel.Text = Input.Title
            InputLabel.TextColor3 = Color3.fromRGB(UITheme[Window.Theme].Text.R * 255, UITheme[Window.Theme].Text.G * 255, UITheme[Window.Theme].Text.B * 255)
            InputLabel.TextSize = 13
            InputLabel.TextWrapped = true
            InputLabel.TextXAlignment = Enum.TextXAlignment.Left

            table.insert(TextColor, InputLabel)

            ParagraphLabelUP.Name = "ParagraphLabelUP"
            ParagraphLabelUP.Parent = InputLabel
            ParagraphLabelUP.PaddingLeft = UDim.new(0, 5)

            Point.Name = "Point"
            Point.Parent = InputElement
            Point.BackgroundColor3 = Color3.fromRGB(UITheme[Window.Theme].Placeholder.R * 255, UITheme[Window.Theme].Placeholder.G * 255, UITheme[Window.Theme].Placeholder.B * 255)
            Point.BorderColor3 = Color3.new(0, 0, 0)
            Point.BorderSizePixel = 0
            Point.AutoButtonColor = false
            Point.TextTransparency = 1
            Point.ClipsDescendants = true
            Point.Position = UDim2.new(0, InputElement.Size.X.Offset - 100, 0, 8.5)
            Point.Size = UDim2.new(0, 89, 0, 17)

            PointC.Name = "PointC"
            PointC.Parent = Point

            InputBox.Name = "InputBox"
            InputBox.Parent = Point
            InputBox.BackgroundColor3 = Color3.new(1, 1, 1)
            InputBox.BackgroundTransparency = 1
            InputBox.BorderColor3 = Color3.new(0, 0, 0)
            InputBox.BorderSizePixel = 0
            InputBox.ClipsDescendants = true
            InputBox.Size = UDim2.new(0, 89, 0, 17)
            InputBox.FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            InputBox.Text = Input.Value
            InputBox.TextColor3 = Color3.new(1, 1, 1)
            InputBox.TextSize = 11
            InputBox.TextStrokeColor3 = Color3.new(1, 1, 1)
            InputBox.TextXAlignment = Enum.TextXAlignment.Left

            InputBoxUP.Name = "InputBoxUP"
            InputBoxUP.Parent = InputBox
            InputBoxUP.PaddingLeft = UDim.new(0, 4)
            InputBoxUP.PaddingRight = UDim.new(0, 4)

            PointUP.Name = "PointUP"
            PointUP.Parent = Point

            InputBox.FocusLost:Connect(function(EnterPressed)
                if not EnterPressed then return end
                    spawn(function()
                        pcall(Input.Callback, InputBox.Text)
                    end)
                    --InputBox.Text = ""  
                end)

                function Input:Close()
                    InputElement:Destroy()
                end

                function Input:SetValue(Val)
                    InputBox.Text = Val
                    task.spawn(Input.Callback, Val)
                end

                function Input:SetTitle(Value)
                    InputLabel.Text = Value
                end
            return Input
        end
        local KeybindCount = 0
        function Elements:Keybind(Config)
            KeybindCount = KeybindCount + 1
            local Keybind = {
                Title = Config.Title or "Keybind " .. KeybindCount,
                Value = Config.Value or "F",
                Callback = Config.Callback or function() end
            }

            local oldKey = Keybind.Value

            local KeybindElement = Instance.new("Frame")
            local ElementC = Instance.new("UICorner")
            local KeybindLabel = Instance.new("TextLabel")
            local LabelUP = Instance.new("UIPadding")
            local Point = Instance.new("TextButton")
            local PointC = Instance.new("UICorner")
            local PointUP = Instance.new("UIPadding")

            KeybindElement.Name = Keybind.Title
            KeybindElement.Parent = ScrollElement
            KeybindElement.BackgroundColor3 = Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255, UITheme[Window.Theme].ElementColor.G * 255, UITheme[Window.Theme].ElementColor.B * 255)
            KeybindElement.BorderColor3 = Color3.new(0, 0, 0)
            KeybindElement.BorderSizePixel = 0
            KeybindElement.Position = UDim2.new(0.0179856122, 0, 0.708860755, 0)
            KeybindElement.Size = UDim2.new(0, Window.Size.X.Offset - 17 - 134, 0, 35)

            local UIStroke = Instance.new("UIStroke", KeybindElement)
            UIStroke.Color = Color3.fromRGB(255, 255, 255)
            UIStroke.LineJoinMode = "Round"
            UIStroke.Thickness = 0.6

            local UIGradient = Instance.new("UIGradient", UIStroke)
            UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255, UITheme[Window.Theme].ElementColor.G * 255, UITheme[Window.Theme].ElementColor.B * 255 + 20)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255 + 20, UITheme[Window.Theme].ElementColor.G * 255 + 20, UITheme[Window.Theme].ElementColor.B * 255 + 20))}
            UIGradient.Rotation = -90

            ElementC.Name = "ElementC"
            ElementC.Parent = KeybindElement
            ElementC.CornerRadius = UDim.new(0, 5)

            KeybindLabel.Name = "KeybindLabel"
            KeybindLabel.Parent = KeybindElement
            KeybindLabel.BackgroundColor3 = Color3.new(1, 1, 1)
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.BorderColor3 = Color3.new(0, 0, 0)
            KeybindLabel.BorderSizePixel = 0
            KeybindLabel.Size = UDim2.new(0, Window.Size.X.Offset - 17 - 134, 0, 35)
            KeybindLabel.FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            KeybindLabel.Text = Keybind.Title
            KeybindLabel.TextColor3 = Color3.fromRGB(UITheme[Window.Theme].Text.R * 255, UITheme[Window.Theme].Text.G * 255, UITheme[Window.Theme].Text.B * 255)
            KeybindLabel.TextSize = 13
            KeybindLabel.TextWrapped = true
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left

            table.insert(TextColor, KeybindLabel)

            LabelUP.Name = "LabelUP"
            LabelUP.Parent = KeybindLabel
            LabelUP.PaddingLeft = UDim.new(0, 5)

            Point.Name = "Point"
            Point.Parent = KeybindElement
            Point.BackgroundColor3 = Color3.fromRGB(UITheme[Window.Theme].Placeholder.R * 255, UITheme[Window.Theme].Placeholder.G * 255, UITheme[Window.Theme].Placeholder.B * 255)
            Point.BorderColor3 = Color3.new(0, 0, 0)
            Point.BorderSizePixel = 0
            Point.ClipsDescendants = true
            Point.FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            Point.TextColor3 = Color3.fromRGB(255, 255, 255)
            Point.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            Point.Position = UDim2.new(0, KeybindElement.Size.X.Offset - 35, 0, 8.5)
            Point.TextSize = 11
            Point.Size = UDim2.new(0, 28, 0, 17)
            Point.Text = Keybind.Value

            PointC.Name = "PointC"
            PointC.Parent = Point

            PointUP.Name = "PointUP"
            PointUP.Parent = Point

            spawn(function()
                pcall(Keybind.Callback, Keybind.Value)
            end)
                Point.MouseButton1Click:connect(function(e) 
                    Point.Text = ". . ."
                    local a, b = game:GetService('UserInputService').InputBegan:wait();
                    if a.KeyCode.Name ~= "Unknown" then
                        keybindFrame:TweenSize(UDim2.new(0, 365,0, 36), "InOut", "Quint", 0.18, true)
                        Point.Text = a.KeyCode.Name
                        oldKey = a.KeyCode.Name
                        spawn(function()
                            pcall(Keybind.Callback, a.KeyCode.Name)
                        end)
                    end
                end)

                function Keybind:Close()
                    KeybindElement:Destroy()
                end

                function Keybind:SetValue(Val)
                    Point.Text = Val
                    task.spawn(Keybind.Callback, Val)
                end

                function Keybind:SetTitle(Value)
                    KeybindLabel.Text = Value
                end
            return Keybind
        end
        function Elements:SmallElement(Config)
            local MiniElement = Instance.new("Frame")
            local MiniElementC = Instance.new("UICorner")
            local UIListLayout = Instance.new("UIListLayout")

            MiniElement.Name = "MiniElement"
            MiniElement.Parent = ScrollElement
            MiniElement.BackgroundColor3 = Color3.new(0.133333, 0.133333, 0.133333)
            MiniElement.BackgroundTransparency = 1
            MiniElement.BorderColor3 = Color3.new(0, 0, 0)
            MiniElement.BorderSizePixel = 0
            MiniElement.AutomaticSize = "Y"
            MiniElement.Position = UDim2.new(0, 0, 0.160337552, 0)
            MiniElement.Size = UDim2.new(0, Window.Size.X.Offset - 17 - 134, 0, 22)

            MiniElementC.Name = "MiniElementC"
            MiniElementC.Parent = MiniElement
            MiniElementC.CornerRadius = UDim.new(0, 5)

            UIListLayout.Parent = MiniElement
            UIListLayout.FillDirection = Enum.FillDirection.Horizontal
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 5)

            local totalLimit = 10
            local totalCount = 0

            -- Считаем общее количество элементов (кнопки + переключатели), ограничено totalLimit
            local buttonCount = 0
            if Config.Button then
                for _ in pairs(Config.Button) do
                    buttonCount = buttonCount + 1
                    if buttonCount >= totalLimit then
                        buttonCount = totalLimit
                        break
                    end
                end
            else
                buttonCount = 0
            end

            local toggleCount = 0
            if Config.Toggle then
                for _ in pairs(Config.Toggle) do
                    toggleCount = toggleCount + 1
                    if (buttonCount + toggleCount) >= totalLimit then
                        toggleCount = totalLimit - buttonCount
                        break
                    end
                end
            else
                toggleCount = 0
            end

            local totalElements = buttonCount + toggleCount
            if totalElements > totalLimit then
                totalElements = totalLimit
            end

            -- Параметры
            local totalWidth = Window.Size.X.Offset - 17 - 134
            local padding = 5 -- отступ между элементами
            local totalPadding = (totalElements > 1) and (totalElements - 1) * padding or 0
            local elementWidth = 0

            if totalElements > 0 then
                elementWidth = (totalWidth - totalPadding) / totalElements
            else
                elementWidth = 0
            end

            -- Создаем кнопки
            if Config.Button then
                for _, ButtonElement in pairs(Config.Button) do
                    if totalCount >= totalLimit then break end

                    local MiniBTNElement = Instance.new("Frame")
                    local MiniBTNElementC = Instance.new("UICorner")
                    local MiniBTNLabel = Instance.new("TextLabel")
                    local BTNTrigger = Instance.new("TextButton")

                    MiniBTNElement.Name = ButtonElement.Title
                    MiniBTNElement.Parent = MiniElement
                    MiniBTNElement.BackgroundColor3 = Color3.fromRGB(
                        UITheme[Window.Theme].ElementColor.R * 255,
                        UITheme[Window.Theme].ElementColor.G * 255,
                        UITheme[Window.Theme].ElementColor.B * 255
                    )
                    MiniBTNElement.BorderColor3 = Color3.new(0, 0, 0)
                    MiniBTNElement.BorderSizePixel = 0
                    MiniBTNElement.AutomaticSize = "Y"
                    MiniBTNElement.Size = UDim2.new(0, elementWidth, 0, 20) -- динамическая ширина

                    MiniBTNElementC.Parent = MiniBTNElement

                    MiniBTNLabel.Parent = MiniBTNElement
                    MiniBTNLabel.BackgroundColor3 = MiniBTNElement.BackgroundColor3
                    MiniBTNLabel.BackgroundTransparency = 1
                    MiniBTNLabel.BorderColor3 = Color3.new(0, 0, 0)
                    MiniBTNLabel.BorderSizePixel = 0
                    MiniBTNLabel.Position = UDim2.new(0.08, 0, 0, 0)
                    MiniBTNLabel.Size = UDim2.new(0, elementWidth - 30, 0, 20) -- с учётом иконки
                    MiniBTNLabel.FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                    MiniBTNLabel.Text = ButtonElement.Title
                    MiniBTNLabel.TextColor3 = Color3.fromRGB(
                        UITheme[Window.Theme].Text.R * 255,
                        UITheme[Window.Theme].Text.G * 255,
                        UITheme[Window.Theme].Text.B * 255
                    )
                    MiniBTNLabel.TextSize = 11
                    MiniBTNLabel.TextWrapped = true
                    MiniBTNLabel.AutomaticSize = "Y"
                    MiniBTNLabel.TextXAlignment = Enum.TextXAlignment.Left

                    local BTNIcon = Instance.new("ImageLabel")
                    BTNIcon.Name = "BTNIcon"
                    BTNIcon.Parent = MiniBTNElement
                    BTNIcon.BackgroundColor3 = Color3.new(1, 1, 1)
                    BTNIcon.BackgroundTransparency = 1
                    BTNIcon.BorderColor3 = Color3.new(0, 0, 0)
                    BTNIcon.BorderSizePixel = 0
                    BTNIcon.Position = UDim2.new(0, MiniBTNElement.Size.X.Offset - 20, 0.17, 0)
                    BTNIcon.Size = UDim2.new(0, 11, 0, 11)
                    BTNIcon.ImageColor3 = Color3.fromRGB(
                        UITheme[Window.Theme].IconColor.R * 255,
                        UITheme[Window.Theme].IconColor.G * 255,
                        UITheme[Window.Theme].IconColor.B * 255
                    )
                    BTNIcon.Image = "rbxassetid://105887588913897"

                    BTNTrigger.Parent = MiniBTNElement
                    BTNTrigger.BackgroundColor3 = Color3.new(1, 1, 1)
                    BTNTrigger.BackgroundTransparency = 1
                    BTNTrigger.BorderColor3 = Color3.new(0, 0, 0)
                    BTNTrigger.BorderSizePixel = 0
                    BTNTrigger.Size = UDim2.new(0, elementWidth, 0, 20)
                    BTNTrigger.Font = Enum.Font.SourceSans
                    BTNTrigger.AutomaticSize = "Y"
                    BTNTrigger.TextColor3 = Color3.new(0, 0, 0)
                    BTNTrigger.TextSize = 14
                    BTNTrigger.ZIndex = 4
                    BTNTrigger.TextTransparency = 1

                    BTNTrigger.MouseButton1Click:Connect(function()
                        spawn(function()
                            pcall(ButtonElement.Callback)
                        end)
                        TweenService:Create(MiniBTNElement, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255 + 30,
                                                            UITheme[Window.Theme].ElementColor.G * 255 + 30,
                                                            UITheme[Window.Theme].ElementColor.B * 255 + 30)
                        }):Play()
                        wait(0.2)
                        TweenService:Create(MiniBTNElement, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(UITheme[Window.Theme].ElementColor.R * 255,
                                                            UITheme[Window.Theme].ElementColor.G * 255,
                                                            UITheme[Window.Theme].ElementColor.B * 255)
                        }):Play()
                    end)

                    totalCount = totalCount + 1
                end
            end

            -- Создаем переключатели (Toggle)
            if Config.Toggle then
                for _, ToggleElement in pairs(Config.Toggle) do
                    if totalCount >= totalLimit then break end

                    local MiniToggleFrame = Instance.new("Frame")
                    local MiniToggleElementC = Instance.new("UICorner")
                    local MiniToggleLabel = Instance.new("TextLabel")
                    local ToggleVal = Instance.new("Frame")
                    local ToggleValC = Instance.new("UICorner")
                    local TGLTrigger = Instance.new("TextButton")

                    MiniToggleFrame.Name = ToggleElement.Title
                    MiniToggleFrame.Parent = MiniElement
                    MiniToggleFrame.BackgroundColor3 = Color3.fromRGB(
                        UITheme[Window.Theme].ElementColor.R * 255,
                        UITheme[Window.Theme].ElementColor.G * 255,
                        UITheme[Window.Theme].ElementColor.B * 255
                    )
                    MiniToggleFrame.BorderColor3 = Color3.new(0, 0, 0)
                    MiniToggleFrame.BorderSizePixel = 0
                    MiniToggleFrame.AutomaticSize = "Y"
                    MiniToggleFrame.Size = UDim2.new(0, elementWidth, 0, 20) -- динамическая ширина

                    MiniToggleElementC.Parent = MiniToggleFrame

                    MiniToggleLabel.Parent = MiniToggleFrame
                    MiniToggleLabel.BackgroundColor3 = Color3.new(1, 1, 1)
                    MiniToggleLabel.BackgroundTransparency = 1
                    MiniToggleLabel.BorderColor3 = Color3.new(0, 0, 0)
                    MiniToggleLabel.BorderSizePixel = 0
                    MiniToggleLabel.AutomaticSize = "Y"
                    MiniToggleLabel.Position = UDim2.new(0.08, 0, 0, 0)
                    MiniToggleLabel.Size = UDim2.new(0, elementWidth - 30, 0, 20)
                    MiniToggleLabel.FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                    MiniToggleLabel.Text = ToggleElement.Title
                    MiniToggleLabel.TextColor3 = Color3.fromRGB(
                        UITheme[Window.Theme].Text.R * 255,
                        UITheme[Window.Theme].Text.G * 255,
                        UITheme[Window.Theme].Text.B * 255
                    )
                    MiniToggleLabel.TextSize = 11
                    MiniToggleLabel.TextWrapped = true
                    MiniToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

                    ToggleVal.Parent = MiniToggleFrame
                    ToggleVal.BackgroundColor3 = Color3.fromRGB(
                        UITheme[Window.Theme].ElementColor.R * 255 - 70,
                        UITheme[Window.Theme].ElementColor.G * 255 - 70,
                        UITheme[Window.Theme].ElementColor.B * 255 - 70
                    )
                    ToggleVal.BackgroundTransparency = 1
                    ToggleVal.BorderColor3 = Color3.new(0, 0, 0)
                    ToggleVal.BorderSizePixel = 0
                    ToggleVal.Position = UDim2.new(0, MiniToggleFrame.Size.X.Offset - 20, 0.17, 0)
                    ToggleVal.Size = UDim2.new(0, 13, 0, 13)

                    local ToggleValUS = Instance.new("UIStroke", ToggleVal)
                    ToggleValUS.Color = Color3.fromRGB(62, 62, 62)
                    ToggleValUS.Thickness = 1.5
                    ToggleValUS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

                    ToggleValC.Parent = ToggleVal
                    ToggleValC.CornerRadius = UDim.new(0, 4)

                    TGLTrigger.Parent = MiniToggleFrame
                    TGLTrigger.BackgroundColor3 = Color3.new(1, 1, 1)
                    TGLTrigger.BackgroundTransparency = 1
                    TGLTrigger.BorderColor3 = Color3.new(0, 0, 0)
                    TGLTrigger.BorderSizePixel = 0
                    TGLTrigger.Size = UDim2.new(0, elementWidth, 0, 20)
                    TGLTrigger.Font = Enum.Font.SourceSans
                    TGLTrigger.AutomaticSize = "Y"
                    TGLTrigger.TextColor3 = Color3.new(0, 0, 0)
                    TGLTrigger.TextSize = 14
                    TGLTrigger.ZIndex = 4
                    TGLTrigger.TextTransparency = 1

                    local Val = ToggleElement.Default
                    if Val then
                        TweenService:Create(ToggleVal, TweenInfo.new(0.2), {Transparency = 0}):Play()
                    else
                        TweenService:Create(ToggleVal, TweenInfo.new(0.2), {Transparency = 1}):Play()
                    end

                    spawn(function()
                        pcall(ToggleElement.Callback, Val)
                    end)

                    TGLTrigger.MouseButton1Click:Connect(function()
                        Val = not Val
                        spawn(function()
                            pcall(ToggleElement.Callback, Val)
                        end)
                        if Val then
                            TweenService:Create(ToggleVal, TweenInfo.new(0.2), {Transparency = 0}):Play()
                        else
                            TweenService:Create(ToggleVal, TweenInfo.new(0.2), {Transparency = 1}):Play()
                        end
                    end)

                    totalCount = totalCount + 1
                end
            end
            return Button
        end
        return Elements, Tab
    end

        local FrameNotifiFrame = UI:Create("Frame", {
            Name = "FrameNotifiFrame",
            Parent = UIScreen,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1.000,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.new(0, 284, 0, 795),
            AnchorPoint = Vector2.new(1, 0.5),
        })

        local FrameNotifiFrameULL = UI:Create("UIListLayout", {
            Name = "FrameNotifiFrameULL",
            Parent = FrameNotifiFrame,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 10),
        })

        local FrameNotifiFrameUP = UI:Create("UIPadding", {
            Name = "FrameNotifiFrameUP",
            Parent = FrameNotifiFrame,
            PaddingBottom = UDim.new(0, 170),
        })

    function UI:Notification(Config)
        local Notification = {
            Title = Config.Title or "Hello World!",
            Icon = Config.Icon,
            Delay = Config.Delay or 3
        }

        local NotifiElement = UI:Create("Frame", {
            Name = "NotifiElement",
            Parent = FrameNotifiFrame,
            BackgroundColor3 = Color3.fromRGB(27, 27, 27),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.921599984, 0),
            Size = UDim2.new(0, 284, 0, 43),
        })

        local NotifiElementC = UI:Create("UICorner", {
            Name = "NotifiElementC",
            Parent = NotifiElement,
            CornerRadius = UDim.new(0, 7),
        })

        local DecorativeFrameNotf = UI:Create("Frame", {
            Name = "DecorativeFrameNotf",
            Parent = NotifiElement,
            BackgroundColor3 = Color3.fromRGB(48, 48, 48),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Size = UDim2.new(0, 15, 0, 43),
        })

        local DecorativeFrameNotfC = UI:Create("UICorner", {
            Name = "DecorativeFrameNotfC",
            Parent = DecorativeFrameNotf,
            CornerRadius = UDim.new(0, 7),
        })

        local DecorativeFrameNotf_2 = UI:Create("Frame", {
            Name = "DecorativeFrameNotf_2",
            Parent = DecorativeFrameNotf,
            BackgroundColor3 = Color3.fromRGB(48, 48, 48),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0.600000024, 0, 0, 0),
            Size = UDim2.new(0, 6, 0, 43),
        })

        local DelayFrame = UI:Create("Frame", {
            Name = "DelayFrame",
            Parent = NotifiElement,
            BackgroundColor3 = Color3.fromRGB(65, 65, 65),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0.0845070407, 0, 0, 0),
            Size = UDim2.new(0, 248, 0, 2),
        })

        local DelayFrameC = UI:Create("UICorner", {
            Name = "DelayFrameC",
            Parent = DelayFrame,
            CornerRadius = UDim.new(0, 100),
        })

        local NotifiIcon = UI:Create("ImageLabel", {
            Name = "NotifiIcon",
            Parent = NotifiElement,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1.000,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0.0845070407, 0, 0.143814445, 0),
            Size = UDim2.new(0, 30, 0, 30),
            Image = "rbxassetid://84892336431975",
        })

        local NotifiLAbel = UI:Create("TextLabel", {
            Name = "NotifiLAbel",
            Parent = NotifiElement,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1.000,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0.0528169014, 0, 0, 0),
            Size = UDim2.new(0, 263, 0, 43),
            ZIndex = 2,
            FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
            Text = Notification.Title,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14.000,
            TextStrokeColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        local NotifiLAbelUP = UI:Create("UIPadding", {
            Name = "NotifiLAbelUP",
            Parent = NotifiLAbel,
            PaddingLeft = UDim.new(0, 45),
        })

        local Frame = UI:Create("Frame", {
            Parent = NotifiElement,
            BackgroundColor3 = Color3.fromRGB(27, 27, 27),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0.978873253, 0, 0, 0),
            Size = UDim2.new(0, 6, 0, 43),
        })

        local UIGradient = UI:Create("UIGradient", {
            Parent = NotifiElement,
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(72, 72, 72)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255)),
            },
        })

        Utility:TweenObject(DelayFrame, {Size = UDim.new(0,0,0,2)}, Notification.Delay, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        wait(Notification.Delay)
        NotifiElement:Destroy()
        return Notification
    end

        --[[local SearchScroll = Instance.new("ScrollingFrame")
        local SearuiListLayout = Instance.new("UIListLayout")
        local UIPadding_5 = Instance.new("UIPadding")

        SearchScroll.Name = "SearchScroll"
        SearchScroll.Parent = ElementFrame
        SearchScroll.Active = true
        SearchScroll.BackgroundColor3 = Color3.new(1, 1, 1)
        SearchScroll.ClipsDescendants = true
        SearchScroll.BackgroundTransparency = 1
        SearchScroll.BorderColor3 = Color3.new(0, 0, 0)
        SearchScroll.BorderSizePixel = 0
        SearchScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        SearchScroll.Size = UDim2.new(0, Window.Size.X.Offset - 134, 0, Window.Size.Y.Offset - 30)
        SearchScroll.ScrollBarThickness = 2

        SearuiListLayout.Parent = SearchScroll
        SearuiListLayout.Padding = UDim.new(0, 5)
        SearuiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

        UIPadding_5.Parent = SearchScroll
        UIPadding_5.PaddingLeft = UDim.new(0, 8)
        UIPadding_5.PaddingTop = UDim.new(0, 3)
        UIPadding_5.PaddingBottom = UDim.new(0, 7)--]]


        --[[local SearchFrame = Instance.new("Frame")
        local SearchFrameC = Instance.new("UICorner")
        local SearchBox = Instance.new("TextBox")
        local SearchLabel = Instance.new("ImageLabel")

        SearchFrame.Name = "SearchFrame"
        SearchFrame.Parent = MainFrame
        SearchFrame.BackgroundColor3 = Color3.fromRGB(UITheme[Window.Theme].Background.R * 255 + 10, UITheme[Window.Theme].Background.G * 255 + 10, UITheme[Window.Theme].Background.B * 255 + 10)
        SearchFrame.BorderColor3 = Color3.new(0, 0, 0)
        SearchFrame.BorderSizePixel = 0
        SearchFrame.Position = UDim2.new(0, TabLib.Size.X.Offset + 10, 0.0140000004, 0)
        SearchFrame.Size = UDim2.new(0, 146,0, 25)

        local SearchFrameUIStroke = Instance.new("UIStroke", SearchFrame)
        SearchFrameUIStroke.Color = Color3.fromRGB(UITheme[Window.Theme].Background.R * 255 + 20, UITheme[Window.Theme].Background.G * 255 + 20, UITheme[Window.Theme].Background.B * 255 + 20)
        SearchFrameUIStroke.LineJoinMode = "Round"
        SearchFrameUIStroke.Thickness = 0.6

        SearchFrameC.Parent = SearchFrame
        SearchFrameC.CornerRadius = UDim.new(0, 11)

        SearchBox.Parent = SearchFrame
        SearchBox.BackgroundColor3 = Color3.new(1, 1, 1)
        SearchBox.BackgroundTransparency = 1
        SearchBox.BorderColor3 = Color3.new(0, 0, 0)
        SearchBox.BorderSizePixel = 0
        SearchBox.Position = UDim2.new(0.217, 0,0.14, 0)
        SearchBox.Size = UDim2.new(0, 105,0, 17)--]]
        --SearchBox.FontFace = Font.new([[rbxassetid://12187365364]], Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        --[[SearchBox.Text = "Search . . ."
        SearchBox.TextColor3 = Color3.fromRGB(117, 117, 117)
        SearchBox.TextSize = 11
        SearchBox.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        SearchBox.TextWrapped = true
        SearchBox.TextXAlignment = Enum.TextXAlignment.Left

        SearchLabel.Parent = SearchFrame
        SearchLabel.BackgroundColor3 = Color3.new(1, 1, 1)
        SearchLabel.BackgroundTransparency = 1
        SearchLabel.BorderColor3 = Color3.new(0, 0, 0)
        SearchLabel.BorderSizePixel = 0
        SearchLabel.Position = UDim2.new(0.054, 0,0.22, 0)
        SearchLabel.Size = UDim2.new(0, 14, 0, 14)
        SearchLabel.Image = Icons.Icon("search")[1]
        SearchLabel.ImageRectSize = Icons.Icon("search")[2].ImageRectSize
        SearchLabel.ImageRectOffset = Icons.Icon("search")[2].ImageRectPosition

    SearchBox.FocusLost:Connect(function(enterPressed)
        if not enterPressed then
            SearchBox.Text = "Search . . ."
            SearchBox.TextColor3 = Color3.fromRGB(117, 117, 117)
            for _, v in pairs(ElementFolder.ElementFrame.ScrollingFrame:GetChildren()) do
                if v:IsA("Frame") then
                    v.Visible = true
                end
            end
        end
    end)

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = SearchBox.Text
        if query ~= "" and query ~= "Search . . ." then
            SearchBox.TextColor3 = Color3.fromRGB(UITheme[Window.Theme].Text.R * 255, UITheme[Window.Theme].Text.G * 255, UITheme[Window.Theme].Text.B * 255)
            updateResults(query)
        else
            SearchBox.TextColor3 = Color3.fromRGB(117, 117, 117)
            for _, v in pairs(ElementFolder.ElementFrame.ScrollingFrame:GetChildren()) do
                if v:IsA("Frame") then
                    v.Visible = true
                end
            end
        end
    end)

    function updateResults(query)
        local lowerQuery = string.lower(query)
        for _, v in pairs(ElementFolder.ElementFrame.ScrollingFrame:GetChildren()) do
            if v:IsA("Frame") then
                if string.lower(v.Name):find(lowerQuery) then
                    v.Visible = true
                else
                    v.Visible = false
                end
            end
        end
    end

        SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            updateResults(SearchBox.Text)
        end)--]]

        Minimize.MouseButton1Click:Connect(function()
            local viewportSize = workspace.CurrentCamera.ViewportSize
            --AnchorPoint = Vector2.new(0.5,1)
            Utility:TweenObject(MainFrame, {AnchorPoint = Vector2.new(0.5,0.5)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            Utility:TweenObject(MainFrame, {Position = UDim2.new(0.5,0,0.5,0)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            wait(0.21)
            Utility:TweenObject(Window.BackpackHotbar, {Position = UDim2.new(Window.BackpackHotbar.Position.X.Scale, Window.BackpackHotbar.Position.X.Offset-190, Window.BackpackHotbar.Position.Y.Scale, Window.BackpackHotbar.Position.Y.Offset)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            for _, tab in ipairs(ElementList) do
                Utility:TweenObject(tab, {Size = UDim2.new(0, tab.Size.X.Offset, 0, 0)}, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            end
            WindElement.Visible = false
            Utility:TweenObject(TabLib, {Size = UDim2.new(0, TabLib.Size.X.Offset, 0, 0)}, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            Utility:TweenObject(Frame, {Size = UDim2.new(0, Frame.Size.X.Offset, 0, 0)}, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            Utility:TweenObject(ScrollingFrame, {Size = UDim2.new(0, ScrollingFrame.Size.X.Offset, 0, 0)}, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            ScrollingFrame.Visible = false
            MainFrame.AutomaticSize = "None"
            Utility:TweenObject(MainFrame, {Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 30)}, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            Utility:TweenObject(UIName, {Position = UDim2.new(0, MainFrame.Size.X.Offset - MainFrame.Size.X.Offset + 5, 0, 7)}, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            --Utility:TweenObject(SearchFrame, {Transparency = 1}, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            --SearchBox.Visible = false
            --Utility:TweenObject(SearchLabel, {ImageTransparency = 1}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            --Utility:TweenObject(MainFrame.MainFrameFUIStroke, {Transparency = 0}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            wait(0.3)
            Utility:TweenObject(MainFrame, {Size = UDim2.new(0, MainFrame.Size.X.Offset / 2, 0, 30)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            Utility:TweenObject(MainFrame, {Position = UDim2.new(0.5,0,1,35)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            Utility:TweenObject(UIName, {Position = UDim2.new(0, MainFrame.Size.X.Offset - MainFrame.Size.X.Offset + 5, 0, 7)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            Utility:TweenObject(MinimizedFrame, {AnchorPoint = Vector2.new(0.5,1)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            MinimizedFrame.Position = UDim2.new(0.5,0,1,45)
            MinimizedFrame.Visible = true
            wait(0.3)
            Utility:TweenObject(MinimizedFrame, {Position = UDim2.new(0.5,0,1,0-5)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            --Utility:TweenObject(MainFrame, {Position = UDim2.new(0, MinimizedFrame.Position.X.Offset, 0, MinimizedFrame.Position.Y.Offset)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            --Utility:TweenObject(BackpackHotbar, {Position = UDim2.new(BackpackHotbar.Position.X.Scale, BackpackHotbar.Position.X.Offset-200, BackpackHotbar.Position.Y.Scale, BackpackHotbar.Position.Y.Offset)}, 0.7, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        end)

        MinimizedTRG.MouseButton1Click:Connect(function()
            Utility:TweenObject(MainFrame, {AnchorPoint = Vector2.new(0.5,0.5)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            Utility:TweenObject(MainFrame, {Position = UDim2.new(0.5,0,0.5,0)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                
            Utility:TweenObject(MinimizedFrame, {Position = UDim2.new(0.5,0,1,45)}, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            wait(0.3)
            MinimizedFrame.Visible = false
            Utility:TweenObject(MinimizedFrame, {AnchorPoint = Vector2.new(0.5,1)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            Utility:TweenObject(UIName, {Position = UDim2.new(0, MainFrame.Size.X.Offset - MainFrame.Size.X.Offset + 5, 0, 7)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            Utility:TweenObject(MainFrame, {AnchorPoint = Vector2.new(0.5,0.5)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            Utility:TweenObject(MainFrame, {Position = UDim2.new(0.5,0,0.5,0)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            Utility:TweenObject(MainFrame, {Size = UDim2.new(0, Window.Size.X.Offset, 0, 30)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            wait(0.3)
            --Utility:TweenObject(MainFrame.MainFrameFUIStroke, {Transparency = 1}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            --Utility:TweenObject(SearchLabel, {ImageTransparency = 0}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            --SearchBox.Visible = true
            --Utility:TweenObject(SearchFrame, {Transparency = 0}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            Utility:TweenObject(UIName, {Position = UDim2.new(0, MainFrame.Size.X.Offset - MainFrame.Size.X.Offset + 5, 0, 7)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            Utility:TweenObject(MainFrame, {Size = UDim2.new(0, Window.Size.X.Offset, 0, 30)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            MainFrame.AutomaticSize = "XY"
            ScrollingFrame.Visible = true
            Utility:TweenObject(ScrollingFrame, {Size = UDim2.new(0, ScrollingFrame.Size.X.Offset, 0, Window.Size.Y.Offset)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            Utility:TweenObject(TabLib, {Size = UDim2.new(0, TabLib.Size.X.Offset, 0, Window.Size.Y.Offset)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            Utility:TweenObject(Frame, {Size = UDim2.new(0, Frame.Size.X.Offset, 0, Window.Size.Y.Offset)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            WindElement.Visible = true
            for _, tab in ipairs(ElementList) do
                Utility:TweenObject(tab, {Size = UDim2.new(0, Window.Size.Y.Offset, 0, Window.Size.Y.Offset - 35)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            end
            Utility:TweenObject(Window.BackpackHotbar, {Position = UDim2.new(0.5, -100, 1, -70)}, 0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        end)
    return TabModule, Window, UI
end

local Window = UI:CreateWindow({
    Name = "Example UI",
    Icon = "hexagon",
    SideBarWidth = 136,
    Size = UDim2.fromOffset(460, 290)
})

local ParagraphTab = Window:Tab({Title = "Display Elements", Icon = "picture-in-picture"})
local ManagementTab = Window:Tab({Title = "Management", Icon = "chart-no-axes-gantt"})
local InputTab = Window:Tab({Title = "Input Elements", Icon = "file-input"})
UI:Devider()
local SettingsTab = Window:Tab({Title = "Settings", Icon = "cog"})
local Colors = {"Default","Red","Orange","Yellow","Green","Ocyan","Blue","Purple", "Pink"}

ParagraphTab:Section({Title = "Paragraph", Icon = "a-large-small"})
ParagraphTab:Paragraph({
    Title = "Paragraph Example",
})

ParagraphTab:Paragraph({
    Title = "Paragraph Icon",
    Icon = "bird"
})

ParagraphTab:SmallParagraph({Title = "Paragraph"})
ParagraphTab:SmallParagraph({Title = "Paragraph",TextXAlignment = "Left"})
ParagraphTab:SmallParagraph({Title = "Paragraph",TextXAlignment = "Right"})

ParagraphTab:Section({Title = "Color Paragraph", Icon = "paintbrush"})
local ColorCount = 0
for i = 1, 9 do
    ColorCount = ColorCount + 1
    ParagraphTab:Paragraph({
        Title = Colors[ColorCount],
        Color = Colors[ColorCount]
    })

    ParagraphTab:SmallParagraph({
        Title = Colors[ColorCount],
        Color = Colors[ColorCount],
        TextXAlignment = "Left"
    })
end
ColorCount = 0

ParagraphTab:Section({Title = "Brightness Color", Icon = "sun"})
for i = 1, 9 do
    ColorCount = ColorCount + 1
    ParagraphTab:Paragraph({
        Title = Colors[ColorCount],
        Color = Colors[ColorCount],
        Brightness = 100
    })

    ParagraphTab:SmallParagraph({
        Title = Colors[ColorCount],
        Color = Colors[ColorCount],
        Brightness = 100,
        TextXAlignment = "Left"
    })
end

ManagementTab:Section({Title = "Button Element"})
ManagementTab:Button({
    Title = "Button Example",
    Callback = function()
        print('Click!')
end})

ManagementTab:Button({
    Title = "Button Icon",
    Icon = "bird",
    Callback = function()
        print('Click!')
end})

local Button = ManagementTab:Button({
    Title = "Destroy Button",
    Icon = "trash-2",
    Callback = function()
        Button:Close()
end})

ManagementTab:SmallElement({
    Button = {
        {
            Title = "Button",
            Callback = function()
                print('Click!')
            end,
        },
    },
    Toggle = {
        {
            Title = "Toggle",
            Default = false,
            Callback = function(Value)
                print(Value)
            end,
        },
        {
            Title = "Active Toggle",
            Default = true,
            Callback = function(Value)
                print(Value)
            end,
        },
    }
})

ManagementTab:SmallElement({
    Button = {
        {
            Title = "Click",
            Callback = function()
                print('Click!')
            end,
        },
        {
            Title = "Button",
            Callback = function()
                print('Click!')
            end,
        },
    },
})

ManagementTab:Section({Title = "Toggle Element"})
ManagementTab:Toggle({
    Title = "Toggle Example",
    Callback = function(Value)
        print(Value)
end})

ManagementTab:Toggle({
    Title = "Active Toggle",
    Default = true,
    Callback = function(Value)
        print(Value)
end})

ManagementTab:Section({Title = "Slider"})
ManagementTab:Slider({
	Title = "Walk Speed",
	Step = 1,
	Value = {
		Min = 16,
		Max = 220,
		Default = 16,
	},
	Callback = function(Value)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
	end
})
ManagementTab:Slider({
	Title = "Jump Power",
	Step = 1,
	Value = {
		Min = 50,
		Max = 220,
		Default = 50,
	},
	Callback = function(value)
		game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
	end
})
ManagementTab:Slider({
	Title = "FOV",
	Step = 1,
	Value = {
		Min = 1,
		Max = 120,
		Default = 70,
	},
	Callback = function(value)
		game:GetService'Workspace'.Camera.FieldOfView = value
	end
})

ManagementTab:Section({Title = "DropDown"})
local DropDown = ManagementTab:DropDown({
    Title = "DropDown Example",
    Value = "Option A",
    Option = {'Option A', 'Option B', 'Option C'},
    Callback = function(option)
        print(option)
    end
})

ManagementTab:Button({
    Title = "Refresh DropDown",
    Callback = function()
        DropDown:Refresh({"Option D","Option E","Option F",})
end})


ManagementTab:Section({Title = "Keybind"})
ManagementTab:Keybind({
    Title = "Keybind Element",
    Callback = function(key)
        print(key)
end})
InputTab:Section({Title = "Input"})
InputTab:Input({
    Title = "Input Element",
    Callback = function(input)
        print(input)
end})

InputTab:Input({
    Title = "Input Element",
    Value = "Input",
    Callback = function(input)
        print(input)
end})

SettingsTab:Section({Title = "Window", Icon = "grid-2x2"})
SettingsTab:Toggle({
    Title = "Transparency",
    Default = true,
    Callback = function(state)
        UI:SetTransparency(state)
end})

SettingsTab:Section({Title = "Misc"})
SettingsTab:Keybind({
    Title = "Toggle Key Window",
    Callback = function(key)
        UI:SetToggleKey(key)
end})
SettingsTab:Button({
    Title = "Destroy Window",
    Icon = "trash-2",
    Callback = function()
        UI:Close()
end})
