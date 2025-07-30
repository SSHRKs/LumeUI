## Creating Paragraph
```luau
local Dropdown = Tab:DropDown({
    Title = "Dropdown",
    Locked = false,
    Value = "--",
    Option = {'le', 'lele', 'lelele'},
    Callback = function(option)
        print(option)
    end
})
```

| Tag         | Type        | Default    |
| ----------- | ----------- |------------|
| Title       | String      | Dropdown   |
| Locked      | Bool        | false      |
| Value       | String      | nil        |
| Option      | Table       | {}         |
| Callback    | function    | nil        |

## Set Title
```lua
Paragraph:SetTitle('New Title')
```
## Set Desc
```lua
Paragraph:SetDesc('New Desc')
```
## Set Icon
```lua
Paragraph:SetIcon('bird')
```
## Remove Icon
```lua
Paragraph:RemoveIcon()
```
## Destroy Element
```lua
Paragraph:Close()
```
