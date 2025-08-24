extends Node
class_name NonPlayerMovementComponent;

## Speed enemy moves at (sub x val)
@export var speed : float = 100.0;

## Obst enemy etc
@export var node : Node2D;

func _ready() -> void:
	speed = randf_range(speed, speed * 1.25)

func _process(delta: float) -> void:
	node.global_position.x -= ((speed * Globals.difficulty) + (5 * pow(Globals.difficulty, 2))) * delta;
