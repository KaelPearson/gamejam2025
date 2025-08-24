extends CharacterBody2D
class_name Player

var heat := 0.0
var air := 100.0
var previous_in_air := true
var in_air := true

@onready var board := $Board
@onready var body := $Body
@onready var head := %Head

@onready var debug := $debug


var head_appearance := {
	'default': preload("res://Assets/dog/Dog_Head_Default.png"),
	'air_1': preload("res://Assets/dog/Dog_Head_Air_1.png"),
	'air_2': preload("res://Assets/dog/Dog_Head_Air_2.png"),
	'hot_1': preload("res://Assets/dog/Dog_Head_Hot_1.png"),
	'hot_2': preload("res://Assets/dog/Dog_Head_Hot_2.png"),
}

var body_appearance := {
	'stand': preload("res://Assets/dog/Dog_Body_1.png"),
	'transition': preload("res://Assets/dog/Dog_Body_2.png"),
	'crouch': preload("res://Assets/dog/Dog_Body_3.png"),
	'up': preload("res://Assets/dog/Dog_Body_Up.webp"),
	'down': preload("res://Assets/dog/Dog_Body_Down.webp"),
}

var board_appearance := {
	'default': preload("res://Assets/board/Board.png"),
	'effects_1': preload("res://Assets/board/Board_Effects_1.png"),
	'effects_2': preload("res://Assets/board/Board_Effects_2.png"),
}

## switch to "Air"/"Water"
signal switch(type: String)

func _ready() -> void:
	var parent := get_parent()
	if parent.in_air_area:
		parent.in_air_area.area_entered.connect(_on_air_area_entered)
		parent.in_air_area.area_exited.connect(_on_air_area_exited)

func _process(delta: float) -> void:
	debug.text = "%.0f %.0f" % [global_position.y, velocity.y]
	if in_air:
		check_heat()
	else:
		check_air()
	
	check_velocity()


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

func check_velocity() -> void:
	if velocity.y > 250:
		if in_air:
			body.texture = body_appearance["down"]
		else:
			body.rotation = deg_to_rad(15.0)
		board.rotation = deg_to_rad(15.0)
		
	elif velocity.y < -250:
		if in_air:
			body.texture = body_appearance["up"]
		else:
			body.rotation = deg_to_rad(-15.0)
		board.rotation = deg_to_rad(-15.0)
	else:
		if in_air:
			body.texture = body_appearance["stand"]
		else:
			body.rotation = deg_to_rad(0.0)
		board.rotation = deg_to_rad(0.0)

func change_zone() -> void:
	var transition_time := 0.50
	var effects_1_offset := 64
	var effects_2_offset := 22
	if in_air:
		# coming down from the air
		board.texture = board_appearance["effects_1"]
		board.position.x += effects_1_offset
	else: 
		# coming up from the water
		board.texture = board_appearance["effects_2"]
		board.position.x += effects_2_offset
	transition()
	await get_tree().create_timer(transition_time).timeout
	# this state should now be the opposite of what it was before
	board.texture = board_appearance["default"]
	if in_air:
		board.position.x -= effects_1_offset
		stand()
	else:
		board.position.x -= effects_2_offset
		crouch()

func transition() -> void:
	body.texture = body_appearance["transition"]
	head.position = Vector2(13.0, -85.0)
	body.rotation = deg_to_rad(30.0)
	body.position = Vector2(-36.0, -74)
	board.position = Vector2(-28.0, -10.5)

func stand() -> void:
	body.texture = body_appearance["stand"]
	head.position = Vector2(13.0, -88.5)
	body.position = Vector2(-21.0, -67.5)
	body.rotation = 0.0
	board.position = Vector2(-28.0, -10.5)


func crouch() -> void:
	body.texture = body_appearance["crouch"]
	head.position = Vector2(70.0, -70.5)
	body.position = Vector2(-42.0, -39.0)
	body.rotation = 0.0
	board.position = Vector2(-28.0, -10.5)


func _on_air_area_entered(body):
	if body.get_parent() is Player:
		switch.emit("Air")
		in_air = true
		change_zone()

func _on_air_area_exited(body):
	if body.get_parent() is Player:
		switch.emit("Water")
		in_air = false
		change_zone()

func add_air(air_amt : int) -> void :
	air = clamp(air + air_amt, 0, 100);

func add_heat(heat_amt : int) -> void :
	heat = clamp(heat + heat_amt, 0, 100);
