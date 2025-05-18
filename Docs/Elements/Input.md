## Creating Input
```luau
local Input = Tab:Input({
    Title = "Input Element",
    Callback = function(Value)
        print(Value)
    end
})
```

## Option
| Tag         | Type        | Default    |
| ----------- | ----------- |------------|
| Title       | String      | Input      |
| Callback    | function    | nil        |
