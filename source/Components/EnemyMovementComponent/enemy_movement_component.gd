extends Node
class_name EnemyMovementComponent;

## Speed enemy moves at (sub x val)
@export var enemy_speed : float = 100.0;

## Obst enemy etc
@export var enemy : Node2D;

func _process(delta: float) -> void:
	enemy.position.x -= enemy_speed * delta;
