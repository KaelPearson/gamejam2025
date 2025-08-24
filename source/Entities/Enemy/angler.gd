extends Node2D

@onready var reg = $EnemySprite;
@onready var um = $um;

func _ready() -> void:
	reg.visible = true;
	um.visible = false;

# just get it wokring
func _process(delta: float) -> void:
	if global_position.x < 1200 :
		um.visible = true;
		reg.visible = false;
		$EnemyMovementComponent.speed = $EnemyMovementComponent.speed * 1.02;
