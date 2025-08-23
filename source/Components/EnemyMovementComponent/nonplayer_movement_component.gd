extends Node
class_name NonPlayerMovementComponent;

## Speed enemy moves at (sub x val)
@export var speed : float = 100.0;

## Obst enemy etc
@export var node : Node2D;

func _process(delta: float) -> void:
	node.position.x -= speed * delta;
