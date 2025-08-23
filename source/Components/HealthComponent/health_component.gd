extends Node

var max_health := 3
var current_health := max_health

## Emits health_changed positive or negative.
## Negative numbers are damage, positive numbers are healing.
signal health_changed(amount)

func heal(amount: int) -> void:
	change_health(amount)

func damage(amount: int) -> void:
	change_health(-amount)

func change_health(amount: int) -> void:
	current_health = clampi(current_health + amount, 0, max_health)
	emit_signal("health_changed", amount)
