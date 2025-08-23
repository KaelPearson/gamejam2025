extends Node

@export var player : CharacterBody2D
var gravity := 20.0
var vertical_force := -40.0

var space_held := false

func _physics_process(delta: float) -> void:
	if space_held:
		player.velocity.y += vertical_force
	player.velocity.y += gravity
	player.move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			space_held = true
		if event.is_released() and event.keycode == KEY_SPACE:
			space_held = false
