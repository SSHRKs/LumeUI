# ⚠️ - EXPERIMENTAL UI

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
UI:Notification({
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
