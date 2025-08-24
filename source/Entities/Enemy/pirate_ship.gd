extends Node2D

var cannon_ball_scene = preload("res://Entities/Enemy/cannon_ball.tscn")

func _ready() -> void:
	$PlayerDetector.area_entered.connect(_on_area_entered)

func _on_area_entered(body) -> void:
	# Do enemy special
	if body.get_parent() is Player:
		var cannon_ball = cannon_ball_scene.instantiate()
		get_parent().add_child(cannon_ball)
		cannon_ball.global_position = $Marker2D.global_position
		$PlayerDetector.queue_free()
