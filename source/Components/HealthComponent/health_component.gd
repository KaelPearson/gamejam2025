extends Node
class_name HealthComponent;

var max_health := 3
var current_health := max_health

## Emits health_changed positive or negative.
## Negative numbers are damage, positive numbers are healing.
signal health_changed(amount)

## Emits when player died
signal death();

@onready var i_frame_timer = Timer.new();
var i_frames = false;

func _ready() -> void:
	add_child(i_frame_timer);
	i_frame_timer.wait_time = 1.0;
	i_frame_timer.one_shot = true;
	i_frame_timer.timeout.connect(_can_be_hit);

func _can_be_hit() -> void :
	i_frames = false;

func heal(amount: int) -> void:
	change_health(amount)

func damage(amount: int) -> void:
	if (i_frames) : return;
	change_health(-amount)
	i_frame_timer.start();
	i_frames = true;

func change_health(amount: int) -> void:
	current_health = clampi(current_health + amount, 0, max_health)
	emit_signal("health_changed", current_health)
	if (current_health <= 0) :
		death.emit();
