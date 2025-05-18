## Creating Paragraph
```luau
Tab:SmallElement({
    Button = {
        {
            Title = "Button",
            Callback = function()
                print('Click!')
            end,
        },
    },
    Toggle = {
        {
            Title = "Toggle",
            Default = false,
            Callback = function(State)
                print(State)
            end,
        },
    }
})
```
