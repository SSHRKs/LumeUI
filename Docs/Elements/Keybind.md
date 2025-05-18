## Creating Keybind
```luau
local Keybind = Tab:Keybind({
    Title = "Keybind Element",
    Callback = function(Key)
        print(Key)
    end
})
```

## Option
| Tag         | Type        | Default    |
| ----------- | ----------- |------------|
| Title       | String      | Keybind    |
| Callback    | function    | nil        |
