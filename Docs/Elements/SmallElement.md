## Creating SmallElement
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

![SmallElement](https://github.com/SSHRKs/LumeUI/blob/main/Images/SmallElements.png)
