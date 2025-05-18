## Creating Slider
```luau
Tab:Slider({
	Title = "Slider Example",
	Step = 1,
	Value = {
		Min = 50,
		Max = 220,
		Default = 50,
	},
	Callback = function(Value)
		game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
	end
})
```

## Option
| Tag         | Type        | Default    |
| ----------- | ----------- |------------|
| Title       | String      | Slider     |
| Step        | Number      | 1          |
| Callback    | function    | nil        |

## Value Options
| Tag         | Type        | Default    |
| ----------- | ----------- |------------|
| Min         | Number      | 0          |
| Max         | Number      | 1          |
| Default     | Number      | 1          |
