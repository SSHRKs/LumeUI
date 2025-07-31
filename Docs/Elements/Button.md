## Creating Button
```luau
local Button = Tab:Button({
    Title = "Button Example",
    Callback = function()
        print('Click!')
end})
```
[![]([Images/Button.png](https://github.com/SSHRKs/LumeUI/blob/main/Images/Button.png))](https://github.com/SSHRKs/LumeUI/blob/main/Images/Button.png)

| Tag         | Type        | Default  |
| ----------- | ----------- |----------|
| Title       | String      | Button   |
| Locked      | Bool        | false    |
| Desc        | String      | nil      |
| Icon        | String      | mouse-pointer-click      |
| Callback    | function    | nil      |

## Set Title
```lua
Button:SetTitle('New Title')
```
## Set Desc
```lua
Button:SetDesc('New Desc')
```
## Set Icon
```lua
Button:SetIcon('bird')
```
## Destroy Element
```lua
Button:Close()
```
