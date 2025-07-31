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

## Destroy Dropdown
```luau
Dropdown:Close()
```
