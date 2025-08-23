extends Area2D

@export var coin_amt : int = 0;
@export var heat_amt : float = 0.0;
@export var air_amt : float = 0.0;

func _ready() -> void:
	area_entered.connect(_area_entered)

func _area_entered(_area: Area2D) -> void :
	var bodies = get_overlapping_bodies();
	for body in bodies :
		if (body is Player) :
			body.add_air(air_amt);
			body.add_heat(heat_amt);
			print("add coin too TODO");
