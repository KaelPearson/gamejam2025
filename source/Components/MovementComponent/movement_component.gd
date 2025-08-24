extends Node

@export var player : Player
var max_gravity := 30.0
var gravity := max_gravity
var vertical_force := -100.0

var max_velocity := 1500.00

var max_height := 2400.00
var min_height := 200.00

var space_held := false

func _ready() -> void:
	player.switch.connect(transition_gravity)

func _physics_process(delta: float) -> void:
	var neg = 1;
	if player.in_air :
		neg = 1;
	else :
		neg = -1;
	if space_held:
		player.velocity.y += vertical_force * .75 * neg;
	if player.global_position.y < min_height or player.global_position.y > max_height:
		player.velocity.y -= vertical_force * neg;
	
	player.velocity.y += gravity;
	player.velocity.y = clampf(player.velocity.y, max_velocity * -1, max_velocity)
	player.move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			space_held = true
		if event.is_released() and event.keycode == KEY_SPACE:
			space_held = false


func transition_gravity(zone: String) -> void:
	var tween = create_tween()
	if (zone == "Air"):
		tween.tween_property(self, "gravity", max_gravity, 0.25)
	if (zone == "Water"):
		tween.tween_property(self, "gravity", max_gravity * -1, 0.25)

func switch_zone(zone: String) -> void :
	if (zone == "Air"):
		player.velocity.y -= 100;
	if (zone == "Water"):
		player.velocity.y += 100;
	
