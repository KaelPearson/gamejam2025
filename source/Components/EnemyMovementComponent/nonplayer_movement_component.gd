extends Node
class_name NonPlayerMovementComponent;

## Speed enemy moves at (sub x val)
@export var speed : float = 100.0;

## Obst enemy etc
@export var node : Node2D;

func _ready() -> void:
	# Add the speed of speed
	speed += GameSettings.curr_speed

func _process(delta: float) -> void:
	node.global_position.x -= speed * Globals.difficulty * delta;
