extends Node2D

var rise := 0.0

func _physics_process(delta: float) -> void:
	global_position.y += rise * delta
