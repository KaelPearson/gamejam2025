extends Node2D

func _ready() -> void:
	$PlayerDetector.area_entered.connect(_on_area_entered)

func _on_area_entered(body) -> void:
	# Do enemy special
	if body.get_parent() is Player:
		var tween = create_tween()
		tween.tween_property(self, "global_position:y", body.global_position.y, 1)
		tween = create_tween()
		tween.tween_property(self, "rotation", deg_to_rad(-30), 0.5)
		tween.tween_property(self, "rotation", deg_to_rad(0), 0.5)
		$PlayerDetector.queue_free()
