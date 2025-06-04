## Creating Input
```luau
local Input = Tab:Input({
    Title = "Input Element",
    Callback = function(input)
        print(input)
    end
})
```

## Option
| Tag         | Type        | Default    |
| ----------- | ----------- |------------|
| Title       | String      | Input      |
| Callback    | function    | nil        |

## Set Title
```lua
Input:SetTitle('New Title')
```
## Set Input Value
```lua
Input:SetValue('New Value')
```
## Destroy Element
```lua
Input:Close()
```
