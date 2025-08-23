extends CharacterBody2D

var heat := 0.0
var air := 100.0

@onready var board = $Board
@onready var body = $Body
@onready var head = $Head

## if not in_air then dog is in water.
var in_air = false

var head_appearance = {
	'default': preload("res://Assets/dog/Dog_Head_Default.png"),
	'air_1': preload("res://Assets/dog/Dog_Head_Air_1.png"),
	'air_2': preload("res://Assets/dog/Dog_Head_Air_2.png"),
	'hot_1': preload("res://Assets/dog/Dog_Head_Hot_1.png"),
	'hot_2': preload("res://Assets/dog/Dog_Head_Hot_2.png"),
}

var body_appearance = {
	'stand': preload("res://Assets/dog/Dog_Body_1.png"),
	'transition': preload("res://Assets/dog/Dog_Body_2.png"),
	'crouch': preload("res://Assets/dog/Dog_Body_3.png"),
}

var board_appearance = {
	'default': preload("res://Assets/board/Board.png"),
	'effects_1': preload("res://Assets/board/Board_Effects_1.png"),
	'effects_2': preload("res://Assets/board/Board_Effects_2.png"),
}

func _process(delta: float) -> void:
	if in_air:
		check_heat()
	else:
		check_air()


func check_heat() -> void:
		if heat > 80:
			head.texture = head_appearance['hot_2']
		elif heat > 50:
			head.texture = head_appearance['hot_1']
		else:
			head.texture = head_appearance['default']

func check_air() -> void:
		if air < 20:
			head.texture = head_appearance['air_2']
		elif air < 50:
			head.texture = head_appearance['air_1']
		else:
			head.texture = head_appearance['default']
