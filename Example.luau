local SlimeUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/SSHRKs/SlimUI/refs/heads/main/main.lua"))()

local Window = SlimeUI:CreateWindow({
    Name = "Example UI",
    Size = UDim2.fromOffset(290, 240)
})

local ParagraphTab = Window:Tab({Title = "Display Elements", Icon = "type"})
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

ManagementTab:Button({
    Title = "Destroy Button",
    Icon = "trash-2",
    Callback = function()
        print('Click!')
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
	Callback = function(Value)
		game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
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
	Callback = function(Value)
		game:GetService'Workspace'.Camera.FieldOfView = Value
	end
})

ManagementTab:Section({Title = "DropDown"})
ManagementTab:Section({Title = "Keybind"})

ManagementTab:Keybind({
    Title = "Keybind Element",
    Callback = function(Value)
        print(Value)
end})

InputTab:Section({Title = "Input"})
InputTab:Input({
    Title = "Input Element",
    Callback = function(Value)
        print(Value)
end})
