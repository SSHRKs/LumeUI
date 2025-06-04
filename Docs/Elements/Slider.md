## Creating Slider
```luau
local Slider = Tab:Slider({
	Title = "Slider Example",
	Step = 1,
	Value = {
		Min = 70,
		Max = 220,
		Default = 70,
	},
	Callback = function(Value)
		game:GetService'Workspace'.Camera.FieldOfView = Value
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

## Set Title
```lua
Slider:SetTitle('New Title')
```
## Set Slider Value
```lua
Slider:SetValue(220)
```
## Destroy Element
```lua
Slider:Close()
```
