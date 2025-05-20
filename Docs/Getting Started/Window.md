# ⚠️ - EXPERIMENTAL UI

## Creating a Window
```luau
local Window = UI:UI({
    Name = "Example UI",
    Size = UDim2.fromOffset(420, 280),
    Transparent = false,
    Elements = {
      Minimized = true,
      Close = true
    },
})
```

## Option
| Tag          | Type        | Default     |
| -------------| ----------- |-------------|
| Name         | String      | UI Library  |
| Transparent  | UDim2       | false       |
| Size         | UDim2       | 420, 280    |
| SideBarWidth | function    | 134         |

## Elements Option
| Tag         | Type        | Default     |
| ----------- | ----------- |-------------|
| Minimized   | Bool        | true        |
| Close       | Bool        | true        |
