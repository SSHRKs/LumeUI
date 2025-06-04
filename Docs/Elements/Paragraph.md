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
| Color       | String      | Default    |
| Brightness  | Number      | 28         |

## Set Title
```lua
Paragraph:SetTitle('New Title')
```
## Set Desc
```lua
Paragraph:SetDesc('New Desc')
```
## Destroy Element
```lua
Paragraph:Close()
```
