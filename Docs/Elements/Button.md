## Creating Button
```luau
local Button = Tab:Button({
    Title = "Button Example",
    Callback = function()
        print('Click!')
end})
```

| Tag         | Type        | Default  |
| ----------- | ----------- |----------|
| Title       | String      | Button   |
| Icon        | String      | nil      |
| Callback    | function    | nil      |

## Set Title
```lua
Button:SetTitle('New Title')
```
