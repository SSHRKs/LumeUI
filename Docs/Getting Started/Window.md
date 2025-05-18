## Creating a Window
```luau
local Window = UI:UI({
    Name = "Example UI",
    Size = UDim2.fromOffset(420, 280),
    Transparent = false,
    Elements = {
      Minimized = true,
      Maximized = true,
      Close = true
    },
})
```
