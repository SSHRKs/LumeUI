## Creating Button
```luau
Tab:Toggle({
    Title = "Toggle Example",
    Default = false,
    Callback = function(State)
        print(State)
end})
```

| Tag         | Type        | Default  |
| ----------- | ----------- |----------|
| Title       | String      | Toggle   |
| Default     | bool        | false    |
| Callback    | function    | nil      |
