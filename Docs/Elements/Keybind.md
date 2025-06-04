## Creating Keybind
```luau
local Keybind = Tab:Keybind({
    Title = "Keybind Element",
    Callback = function(key)
        print(key)
    end
})
```

## Option
| Tag         | Type        | Default    |
| ----------- | ----------- |------------|
| Title       | String      | Keybind    |
| Callback    | function    | nil        |
