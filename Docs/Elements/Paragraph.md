## Creating Paragraph
```luau
local Paragraph = Tab:Paragraph({
    Title = "Paragraph Example",
    Desc = "Description Paragraph"
})
```

| Tag         | Type        | Default    |
| ----------- | ----------- |------------|
| Title       | String      | Paragraph  |
| Desc        | String      | nil        |
| Icon        | String      | nil        |

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
