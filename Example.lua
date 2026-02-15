local LumeUI = loadstring(game:HttpGet("https://github.com/SSHRKs/LumeUI/releases/latest/download/main.lua"))()

function gradient(text, startColor, endColor)
    local result = ""
    local length = #text

    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)

        local char = text:sub(i, i)
        result = result .. "<font color=\"rgb(" .. r ..", " .. g .. ", " .. b .. ")\">" .. char .. "</font>"
    end
    return result
end

local Window = LumeUI:CreateWindow({
    Name = "Example",
	Author = "Hi"
    Icon = "hexagon",
    SideBarWidth = 139,
    ToggleKey = Enum.KeyCode.F,
    Size = UDim2.fromOffset(480, 320),
    Elements = {
        Minimized = true,
        Close = true
    },
})

Window:EditOpenButton({
    Title = "Open",
    Icon = "alarm-clock",
    Transparency = 0.2,
    StrokeThickness = 1,
    Rotation = 0,
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 90, 255))
    },
    AutoRotation = true,
    Speed = 15,
    CornerRadius = UDim.new(0,16),
})

local ParagraphTab = Window:Tab({Title = "Display Elements", Icon = "picture-in-picture"})
local ManagementTab = Window:Tab({Title = "Management", Icon = "chart-no-axes-gantt"})
local InputTab = Window:Tab({Title = "Input Elements", Icon = "file-input"})
local NotificationTab = Window:Tab({Title = "Notification", Icon = "message-square-dot"})
Window:Devider()
local SettingsTab = Window:Tab({Title = "Settings", Icon = "cog"})
Window:Devider()
local LockedElementsTab = Window:Tab({Title = "Locked Elements", Icon = "square-dashed-mouse-pointer"})
local OtherTab = Window:Tab({Title = "Other", Icon = "hash"})

ParagraphTab:Section({Title = "Traffic", Icon = "chart-no-axes-combined"})
local bebebe = ParagraphTab:Traffic({Title = "Traffic Title"})

ParagraphTab:Slider({
    Title = "Set Traffic",
	Step = 1,
	Value = {
		Min = 1,
		Max = 1000,
		Default = 5,
	},
	Callback = function(value)
        bebebe:SetValue(value)
	end
})

ParagraphTab:Traffic({Title = "Traffic Title", Value = 25})

ParagraphTab:SmallElement({
    Button = {
        {
            Title = "Reset Traffic",
            Callback = function()
                bebebe:Reset()
            end,
        },
    },
})

ParagraphTab:Section({Title = "Paragraph", Icon = "a-large-small"})
ParagraphTab:Paragraph({
    Title = "Paragraph Example",
    Desc = "Description Paragraph"
})

ParagraphTab:Paragraph({
    Title = "Paragraph Icon",
    Icon = "bird"
})

ParagraphTab:SmallParagraph({Title = "Paragraph"})
ParagraphTab:SmallParagraph({Title = "Paragraph",TextXAlignment = "Left"})
ParagraphTab:SmallParagraph({Title = "Paragraph",TextXAlignment = "Right"})

ParagraphTab:Section({Title = "Color Paragraph", Icon = "paintbrush"})

local Colors = {"Default","Red","Orange","Yellow","Green","Ocyan","Blue","Purple", "Pink"}
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
    Desc = "Description Button",
    Callback = function()
        print('Click!')
end})

ManagementTab:Button({
    Title = "Button Icon",
    Icon = "bird",
    Callback = function()
        print('Click!')
end})

local DestroyButton = ManagementTab:Button({
    Title = "Destroy Button",
    Icon = "trash-2",
    Callback = function()
        DestroyButton:Close()
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

ManagementTab:SmallElement({
    Toggle = {
        {
            Title = "Toggle",
            Default = false,
            Callback = function(Value)
                print(Value)
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

local Pisun = ManagementTab:Toggle({
    Title = "Active Toggle",
    Desc = "Desc",
    Default = true,
    Callback = function(Value)
        print(Value)
end})

ManagementTab:SmallElement({
    Button = {
        {
            Title = "Destroy Active Button",
            Callback = function()
                Pisun:Close()
            end,
        },
    },
    Toggle = {
        {
            Title = "Set Status",
            Default = true,
            Callback = function(Value)
                Pisun:SetValue(Value)
            end,
        },
    },
})

ManagementTab:Section({Title = "Slider"})
local Slider = ManagementTab:Slider({
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

local ExampleSlider = ManagementTab:Slider({
	Title = "Slider Example",
	Step = 10,
	Value = {
		Min = 1,
		Max = 120,
		Default = 1,
	},
	Callback = function(value)
	end
})

ManagementTab:SmallElement({
    Button = {
        {
            Title = "Destroy Slider Example",
            Callback = function()
                ExampleSlider:Close()
            end,
        },
    },
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

ManagementTab:SmallElement({
    Button = {
        {
            Title = "Destroy DropDown Example",
            Callback = function()
                DropDown:Close()
            end,
        },
    },
})

ManagementTab:Section({Title = "Keybind"})
local Keybind = ManagementTab:Keybind({
    Title = "Keybind Element",
    Callback = function(key)
        print(key)
end})
ManagementTab:SmallElement({
    Button = {
        {
            Title = "Destroy Keybind Element",
            Callback = function()
                Keybind:Close()
            end,
        },
    },
})

InputTab:Section({Title = "Input"})
InputTab:Input({
    Title = "Input Element",
    Callback = function(input)
        print(input)
end})

local Input = InputTab:Input({
    Title = "Input Limit",
    Desc = "Desc",
    Value = "Input",
    MaxSymbols = 25,
    Callback = function(input)
        print(input)
end})

local InputSlider = InputTab:Slider({
	Title = "Set Limit",
	Step = 1,
	Value = {
		Min = 5,
		Max = 30,
		Default = 5,
	},
	Callback = function(value)
        Input:SetMaxSymbols(value)
	end
})

InputTab:SmallElement({
    Button = {
        {
            Title = "Destroy Input Limit",
            Callback = function()
                Input:Close()
                InputSlider:Close()
            end,
        },
    },
})

NotificationTab:Button({
    Title = "Get Notification",
    Callback = function()
        UI:Notification({
            Delay = 3
        })
    end
})

NotificationTab:Button({
    Title = "Get Icon Notification",
    Callback = function()
        UI:Notification({
            Icon = "bird",
            Delay = 3
        })
    end
})

NotificationTab:Button({
    Title = "Get Background Notification",
    Callback = function()
        UI:Notification({
            Icon = "bird",
            Background = "http://www.roblox.com/asset/?id=2878190399",
            Delay = 3
        })
    end
})

SettingsTab:Section({Title = "Window", Icon = "grid-2x2"})
SettingsTab:DropDown({
    Title = "Theme",
    Value = "--",
    Option = {'Dark', 'Darked', 'Light', 'Amethyst', 'Emerald', 'Ocean', 'Midnight', 'Crimson', 'GreenApple', 'Lavender', 'Peach', 'Blueberry','Coffee'},
    Callback = function(option)
        Window:SetTheme(option)
    end
})

SettingsTab:Toggle({
    Title = "Transparency",
    Default = true,
    Callback = function(state)
        Window:SetTransparency(state)
end})

SettingsTab:Section({Title = "Misc"})
SettingsTab:Keybind({
    Title = "Toggle Key Window",
    Callback = function(key)
        Window:SetToggleKey(Enum.KeyCode[key])
end})

SettingsTab:Button({
    Title = "Destroy Window",
    Icon = "trash-2",
    Callback = function()
        Window:Close()
end})

local SelectedIcon = 'bird'
OtherTab:Section({Title = "Set Icon"})
OtherTab:DropDown({
    Title = "Icon",
    Value = "bird",
    Option = {'bird', 'fish', 'folder', 'pen'},
    Callback = function(option)
        SelectedIcon = option
    end
})

local ParagraphIcon = OtherTab:Paragraph({
    Title = "Paragraph",
})

local RefreshIcon
RefreshIcon = OtherTab:Button({
    Title = "Refresh",
    Icon = "refresh-ccw",
    Callback = function()
        ParagraphIcon:SetIcon(SelectedIcon)
        ButtonIcon:SetIcon(SelectedIcon)
end})

local TrashIcon
TrashIcon = OtherTab:Button({
    Title = "Remove Icon",
    Icon = "trash-2",
    Callback = function()
        ParagraphIcon:RemoveIcon()
end})

OtherTab:Toggle({
    Title = "Left Alignment",
    Alignment = "Left",
    Default = false,
    Callback = function(Value)
        print(Value)
end})

local LockedButton = LockedElementsTab:Button({
    Title = "Button",
    Locked = true,
    Callback = function()
end})

local LockedToggle = LockedElementsTab:Toggle({
    Title = "Toggle",
    Locked = true,
    Callback = function(value)
end})

local LockedSlider = LockedElementsTab:Slider({
	Title = "Slider",
    Locked = true,
	Step = 1,
	Value = {
		Min = 5,
		Max = 30,
		Default = 5,
	},
	Callback = function(value)
        Input:SetMaxSymbols(value)
	end
})

local LockedDropdown = LockedElementsTab:DropDown({
    Title = "Dropdown",
    Locked = true,
    Value = "le",
    Option = {'le', 'lele', 'lelele'},
    Callback = function(option)
        SelectedIcon = option
    end
})

local LockedInput = LockedElementsTab:Input({
    Title = "Input",
    Locked = true,
    Value = "Input",
    Callback = function(input)
        print(input)
end})

LockedElementsTab:SmallElement({
    Toggle = {
        {
            Title = "Lock / Unlock",
            Default = true,
            Callback = function(Value)
                if Value then
                    LockedButton:Lock()
                    LockedToggle:Lock()
                    LockedSlider:Lock()
                    LockedDropdown:Lock()
                    LockedInput:Lock()
                else
                    LockedButton:UnLock()
                    LockedToggle:UnLock()
                    LockedSlider:UnLock()
                    LockedDropdown:UnLock()
                    LockedInput:UnLock()
                end
            end,
        },
    },
})
