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
| MaxSymbols  | Number     | nil         |
| Callback    | function    | nil        |

## Set Title
```lua
Input:SetTitle('New Title')
```
## Set Input Value
```lua
Input:SetValue('New Value')
```
## Set MaxSymbols
```lua
Input:SetMaxSymbols(999)
```
## Destroy Element
```lua
Input:Close()
```
