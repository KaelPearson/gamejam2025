extends Area2D

@export var coin_amt : int = 0;
@export var heat_amt : float = 0.0;
@export var air_amt : float = 0.0;



func area_entered(_area: Area2D) -> void :
	print("entered");
