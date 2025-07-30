## Creating Button
```luau
local Toggle = Tab:Toggle({
    Title = "Toggle Example",
    Alignment = "Right",
    Default = false,
    Callback = function(state)
        print(state)
end})
```

| Tag         | Type        | Default  |
| ----------- | ----------- |----------|
| Title       | String      | Toggle   |
| Alignment   | String      | Right    |
| Locked      | Bool        | false    |
| Default     | bool        | false    |
| Callback    | function    | nil      |
