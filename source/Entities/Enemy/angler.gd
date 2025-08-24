extends Node2D

@onready var reg = $EnemySprite;
@onready var um = $um;

func _ready() -> void:
	reg.visible = true;
	um.visible = false;
	$PlayerDetector.area_entered.connect(_on_area_entered)

func _on_area_entered(body) -> void:
	# Do enemy special
	if body.get_parent() is Player:
		um.visible = true;
		reg.visible = false;
		$EvilMeow.play()
		var tween = create_tween()
		tween.tween_property($EnemyMovementComponent, "speed", $EnemyMovementComponent.speed * 5, 1)
		$PlayerDetector.queue_free()
