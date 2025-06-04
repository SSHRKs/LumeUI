## Creating Paragraph
```luau
local SmallParagraph = Tab:SmallParagraph({
    Title = "Paragraph Example",
    Color = "Default",
    Brightness = 28,
})
```

| Tag         | Type        | Default    |
| ----------- | ----------- |------------|
| Title       | String      | "Paragraph"|
| Color       | String      | "Default"  |
| Brightness  | Number      | 28         |
## Set Title
```lua
SmallParagraph:SetTitle('New Title')
```
## Destroy Element
```lua
SmallParagraph:Close()
```
