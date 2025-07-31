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
Dropdown:SetTitle('New Title')
```
## Refresh Option
```lua
Dropdown:Refresh({'1', '2', '3'})
```
## Destroy Element
```luau
Dropdown:Close()
```
