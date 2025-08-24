extends Area2D

@export var coin_amt : int = 0;
@export var heat_amt : float = 0.0;
@export var air_amt : float = 0.0;

func _ready() -> void:
	area_entered.connect(_area_entered)

func _area_entered(_area: Area2D) -> void :
	var bodies = get_overlapping_areas();
	for body in bodies :
		if (body is HurtboxComponent) :
			body.collect_to_player(heat_amt, air_amt, coin_amt);
			queue_free();
