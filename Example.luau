local SlimUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/SSHRKs/SlimUI/refs/heads/main/main.lua"))()

local Window = SlimUI:CreateWindow({
    Name = "Example UI",
    Icon = "hexagon",
    SideBarWidth = 136,
    Size = UDim2.fromOffset(460, 290),
    Elements = {
        Minimized = true,
        Close = true
    },
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
	Step = 1,
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
    Title = "Input Element",
    Value = "Input",
    Callback = function(input)
        print(input)
end})

InputTab:SmallElement({
    Button = {
        {
            Title = "Destroy Input Element",
            Callback = function()
                Input:Close()
            end,
        },
    },
})

SettingsTab:Section({Title = "Window", Icon = "grid-2x2"})
SettingsTab:Toggle({
    Title = "Transparency",
    Default = true,
    Callback = function(state)
        SlimUI:SetTransparency(state)
end})

SettingsTab:Section({Title = "Misc"})
SettingsTab:Keybind({
    Title = "Toggle Key Window",
    Callback = function(key)
        SlimUI:SetToggleKey(key)
end})

SettingsTab:Button({
    Title = "Destroy Window",
    Icon = "trash-2",
    Callback = function()
        SlimUI:Close()
end})
