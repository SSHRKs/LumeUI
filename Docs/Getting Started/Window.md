## Creating a Window
```luau
local Window = LumeUI:CreateWindow({
    Name = "Example UI",
    Size = UDim2.fromOffset(520, 320),
    Transparent = false,
    Elements = {
      Minimized = true,
      Close = true
    },
})
```

## Option
| Tag           | Type        | Default     |
| ------------- | ----------- |-------------|
| Name          | String      | UI Library  |
| Transparent   | UDim2       | false       |
| Size          | UDim2       | 420, 280    |
| SideBarWidth  | function    | 134         |

## Elements Option
| Tag         | Type        | Default     |
| ----------- | ----------- |-------------|
| Minimized   | Bool        | true        |
| Close       | Bool        | true        |

## Creating Notification
```lua
LumeUI:Notification({
    Title = "Title",
    Desc = "Desc",
    Icon = "bird", --Lucide / rbxassetid
    Delay = 3,
})
```

| Tag         | Type        | Default     |
| ----------- | ----------- |-------------|
| Title       | String      | nil         |
| Desc        | String      | nil         |
| Icon        | String      | nil         |
| Background  | String      | nil         |
| Delay       | Number      | 3           |

## Edit `OpenButton`
```lua
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
```

## Setting Library
## Set Theme
```lua
Window:SetTheme('Dark') --Dark, Light
```
## Set Transparency
```lua
Window:SetTransparency(false) --true / false
```
## Set ToggleKey
```lua
Window:SetToggleKey(Enum.KeyCode.F)
```

