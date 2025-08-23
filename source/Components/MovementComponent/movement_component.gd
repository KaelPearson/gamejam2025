extends Node

@export var player : Player
var max_gravity := 30.0
var gravity := max_gravity
var vertical_force := -100.0

var max_velocity := 750.00

var space_held := false

func _ready() -> void:
	player.switch.connect(transition_gravity)

func _physics_process(delta: float) -> void:
	if space_held:
		player.velocity.y += vertical_force
	player.velocity.y += gravity
	player.velocity.y = clampf(player.velocity.y, max_velocity * -1, max_velocity)
	player.move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			space_held = true
		if event.is_released() and event.keycode == KEY_SPACE:
			space_held = false


func transition_gravity(zone: String) -> void:
	#var tween = create_tween()
	if (zone == "Air" and gravity < 0):
		gravity = max_gravity
		#tween.tween_property(self, "gravity", max_gravity, 3)
	if (zone == "Water" and gravity > 0):
		#tween.tween_property(self, "gravity", max_gravity * -1, 3)
		gravity = max_gravity * -1
