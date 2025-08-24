extends Node

## Determines how fast projectiles should be speeding up per sec
var increase_speed_amt : float = 20;
var curr_speed = 0.0;

func _process(delta: float) -> void:
	curr_speed += increase_speed_amt * delta;
